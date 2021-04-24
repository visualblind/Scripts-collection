<?
/* SYSLOG Consolidator is part of JFFNMS
 * Copyright (C) <2002-2004> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Match, and parse Syslog Messages, then put them in the events table

    $query_syslog = "select id, date_logged as date, host, message from syslog where analized = 0 order by id asc";
    $result_syslog = db_query ($query_syslog) or die ("Query failed - SY2 - ".db_error());

    logger( "SYSLOG Events to Process: ".db_num_rows($result_syslog)."\n");

    $fields = array("interface","state","username","info");

    while ($syslog_record = db_fetch_array($result_syslog)) {

	    logger( "S ".$syslog_record["id"].":= ".$syslog_record["date"]." ".$syslog_record["host"]." ".$syslog_record["message"]."\n");

	    $values = array();

	    $event_type_id = 1;  // Default event, if we have no match
	    
	    //Sanitize
	    $syslog_record["message"] = trim($syslog_record["message"]);
	    $syslog_record["message"] = str_replace("\n"," ",$syslog_record["message"]);

	    $query_stypes = "SELECT id, type, interface, username, state, info, match_text FROM syslog_types WHERE id > 1 ORDER BY pos asc, id";
	    $result_stypes = db_query($query_stypes) or die ("Query failed - SY3 - ".db_error());

	    //var_dump($syslog_record[message]);

	    while ( ($stype_rows = db_fetch_array($result_stypes))) { //loop thru all syslog_types until we find a match (or dont)

		if (strpos($stype_rows["match_text"],"(")===FALSE) //take care of legacy (non-regexp) matches, that does not have a '('
		    $stype_rows["match_text"].=".+";
				
	        if (preg_match("/".$stype_rows["match_text"]."/i", $syslog_record["message"], $parts)) {
	    	    $event_type_id = $stype_rows["type"];
		    if (count($parts)==1) $parts=explode(" ",$parts[0]);
		    
		    logger( "S ".$syslog_record["id"].":= Matched ".$stype_rows["match_text"]."\n");

		    break; //stop processing regexps as this one matches
	        }
	    }
	    
	    //var_dump($parts);

	    if ($event_type_id == 1) //we didnt found a match, default (unknown) event
		$values["info"] = $syslog_record["message"]; //put complete message as the info
	    else
		foreach ($fields as $field_name) //foreach field to be completed
		    if (!empty($stype_rows[$field_name])) { //if it has something in the db
			
			unset ($value);
			switch ($stype_rows[$field_name]) {
			    
			    case "*":	//complete message
					$value = $syslog_record["message"]; //this way we get the complete message
					break;
	
			    case "D":	//only the data, not the match
					unset ($parts[0]);
					$value = join(" ",$parts); // all the parts without the 0 (complete)
					break;
	
			    default:	//No Special Case
					if (is_numeric($stype_rows[$field_name])) 	// if field has a number is refereing to a part match
		    			    $value = $parts[$stype_rows[$field_name]];	// Value is the part signaled by the field value
					else						// it was not numeric
					    $value = $stype_rows[$field_name];		// so, we take it as a literal
					break;
			}

			$values[$field_name] = $value;
		    }
	    
	    //final touchs to the values
	    foreach ($fields as $field_name)
		$values[$field_name]=addslashes(trim(str_replace(",","",$values[$field_name]))); //trim them and scape the '
	    
	    //FIXME, why? do I need to add more?
	    $values["info"] = str_replace("(","",str_replace(")","",$values["info"])); //replace ( and )
	
	    // Get the Host ID based on the IP or the Name
	    
	    unset ($host_ip);
	    if (ip2long($syslog_record["host"]) === -1) //its not an IP address
		$host_ip = gethostbyname($syslog_record["host"]); //try to resolve the IP
	    	
	    $query_router="
		SELECT hosts.id FROM hosts 
		WHERE hosts.ip = '".$syslog_record["host"]."' OR hosts.name ='".$syslog_record["host"]."'".
		(isset($host_ip)?" OR hosts.ip ='".$host_ip."'":""); 

	    $result_router = db_query ($query_router) or die ("Query failed - SY4 - ".db_error());
	    
	    if (db_num_rows ($result_router) > 0) // there is a record
		$host_id = current(db_fetch_array($result_router)); // use the first one
	    else {
		$host_id = 1; //Unknown Host
	
		//if host is unknown and event type is unknown put the host ip as the interface
	        //FIXME get a better way to include the host ip in the event when the host is unknown
	
		if ($event_type_id == 1) 
		    $values["interface"] = $syslog_record["host"];
		else 
		    $values["info"] .= $syslog_record["host"];
	    }
	    
	    $output_text = array();
	    $output_text[] = "Host: $host_id";
	    
	    foreach ($fields as $field_name)
		if (!empty($stype_rows[$field_name]))
		    $output_text[]= "$field_name(".$stype_rows[$field_name]."): ".$values[$field_name];    

	    logger( "S ".$syslog_record["id"].":= ".join(" - ",$output_text)."\n");

	    insert_event($syslog_record["date"],$event_type_id,$host_id,$values["interface"],strtolower($values["state"]),$values["username"],$values["info"],$syslog_record["id"]);
	    syslog_analized($syslog_record["id"]);
    }	

?>
