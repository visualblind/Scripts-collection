<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//ALARMS
//---------------------------------------------

    //hard-coded alarm state IDs
    define ("ALARM_DOWN",1);
    define ("ALARM_UP",2);
    define ("ALARM_ALERT",3);
    define ("ALARM_TESTING",4);

    function insert_alarm($date_start,$date_stop,$interface,$type,$active,$referer_start,$referer_stop) {
	    if ($date_stop=="") unset($date_stop);
	    if ($referer_stop=="") unset($referer_stop);

	    $data = compact("date_start","date_stop","interface","type","active","referer_start","referer_stop");
	    $id = db_insert("alarms",$data);
	    logger( "New Alarm: $id := $date_start - $date_stop - $interface - $type - $active - $referer_start - $referer_stop\n");
	    
	    trigger_analize("alarm",current(alarms_list(NULL,array("alarm_id"=>$id)))); //analize alarm triggers

	    return $id;
    }

    function alarms_update($id,$data) {
        if (is_array($data))
	    $result = db_update("alarms",$id,$data);

	trigger_analize("alarm",current(alarms_list(NULL,array("alarm_id"=>$id)))); //analize alarm triggers
	
	return $result;
    }

    function alarms_delete($id) {
	return db_delete("alarms",$id);
    }

    function have_other_alarm ($interface,$event_type,$alarm_states) {
	$query ="
	    SELECT alarms.id as start_id, alarms.referer_start, alarms.date_start as start_date, alarm_states.state  as alarm_state
	    FROM alarms, alarm_states 
	    WHERE alarms.interface = '$interface' and alarms.type = '$event_type' and alarms.active = alarm_states.id and
	    (alarm_states.state = '".$alarm_states[0]."' or alarm_states.state = '".$alarm_states[1]."')";
	$result = db_query ($query) or die ("Query failed - have_other_alarm() - ".db_error());
	$cant = db_num_rows ($result);
	
	$data = array();
	if ($cant > 0) $data = db_fetch_array($result);
	
	return array("result"=>$result,"cant"=>$cant,"alarm"=>$data);
    }

    function alarm_lookup ($alarm_description) {
	$query = "SELECT state FROM alarm_states where description = '$alarm_description'";    
	$result = db_query ($query) or die ("Query Failed - alarm_lookup($alarm_description) - ".db_error());
	if (db_num_rows($result) == 1) return current(db_fetch_array($result));
	return NULL;
    }

    function alarms_list ($ids,$filters = NULL,$init = 0,$span = 100, $where_special = NULL) {

	if (!is_array($where_special)) $where_special = array();

	//round span values (no decimals in SQL LIMIT)
	$span = round($span);
	$init = round($init);
		       		
	if (is_array($filters))
		foreach ($filters as $filter_key=>$filter_value) 
		    if ( isset($filter_value) )
			switch ($filter_key) {
				case "type"     :       $where_special[]=array("types.id","=",$filter_value);
							break;
				
				case "state"    :       $where_special[]=array("alarm_states.id","=",$filter_value);
							break;

				case "alarm_id" :       $where_special[]=array("alarms.id","=",$filter_value);
							break;

				case "triggered" :      $where_special[]=array("alarms.triggered","=",$filter_value);
							break;

				case "alarm_state":     $where_special[]=array("alarm_states.state","=",$filter_value);
							break;

				case "host":     	$where_special[]=array("interfaces.host","=",$filter_value);
							break;

			}
	
	$result = get_db_list(
		array("interfaces","alarms","types","alarm_states","clients"),
		$ids,
		array(
		    "alarms.*",
		    "duration"=>"(alarms.date_stop - alarms.date_start)",
		    "interface_host"=>"interfaces.host",
		    "interface_interface"=>"interfaces.interface",
		    "interface_client"=>"clients.name",
		    "interface_client_id"=>"interfaces.client",	//Needed for triggers by Customer
		    "interface_type"=>"interfaces.type",	//needed for triggers by interface type
		    "type_description"=>"types.description",
		    "alarm_state"=>"alarm_states.state",
		    "state_description"=>"alarm_states.description"),
		array_merge(
		    array(
			array("alarms.interface","=","interfaces.id"),
			array("interfaces.client","=","clients.id"),
			array("alarms.type","=","types.id"),
			array("alarms.active","=","alarm_states.id"),
			array("alarms.id",">","1")),
		    $where_special),
		array (
		    array("alarms.id","desc")),
		"",NULL,$init,$span);
	
	foreach ($result as $key=>$data) {
	    $result[$key]["interface_description"] = 
		$data["interface_client"]." ".$data["interface_interface"]; 
	
	    if ($result[$key]["alarm_state"]==ALARM_DOWN) //Alarm still Active
		$result[$key]["duration"] = time() - strtotime($result[$key]["date_start"]); //calculate the ongoing duration
	}	
	return $result;
    }

//EVENTS
//---------------------------------------------

    function insert_event($date,$type,$host,$interface,$state,$username,$info,$referer,$log_it = 1) {
	$info = substr($info,0,149);
	if (empty($referer)) unset ($referer);
	
    	$data = compact("date","type","host","interface","state","username","info","referer");
	$id = db_insert("events",$data);
	
	if ($log_it == 1)
	    logger("New Event ($id): $date - $type - $host - $interface - $state - $username - $info - $referer\n");

        trigger_analize("event",current(events_list($id)),$log_it); //analize event triggers
    
	return $id;
    }

    function events_analized($id,$analized = 1) {	
	return db_update("events",$id, array(analized=>$analized));
    }
    
    function events_ack($id,$ack = 1) {
	if ($ack == 1) 
	    $result = db_query ("update events set ack='$ack' where ack = 0 and id = '$id'"); //dont overwrite the journal
	else 
	    $result = db_update("events",$id,array("ack"=>$ack)); //if it's journal, overerite

	return $result;
    }
    

    function make_events_latest($max = 0) { //for performance reasons, this must be db-specific
	if ($max == 0) $max = get_config_option("events_latest_max");
	
	return db_copy_table("events","events_latest",$max);
    }

    function events_list ($event_id = NULL, $map_id = 1, $have_filter = 1, $filter = NULL, $init = 0, $span = 20, $order_type = "desc" ,$view_all = 0, $show_all = 0, $journal = 0, $client_id = 0) { 
	$params = func_get_args();
	$params = current($params);
	
	$latest_mode = 2; //FIXME make this an option
	$use_latest = 1;
	$time_latest = get_config_option("events_latest_max")*(60);
	
	$query_select = 
	    "select /* SQL_BUFFER_RESULT HIGH_PRIORITY SQL_BIG_RESULT */ ".
	    "<events_table>.id, <events_table>.date, hosts.name as host_name, <events_table>.host as host_id, ".
	    "hosts.ip as host_ip, zones.shortname as zone, zones.image as zone_image, types.description as type_description, ". 
	    "<events_table>.type as type_id, severity.severity, zones.id as zone_id, zones.zone as zone_name, ".
	    "severity.level as severity_level, severity.fgcolor, severity.bgcolor, <events_table>.interface, ".
	    "<events_table>.username as user, <events_table>.state, <events_table>.info, types.text, types.show_host, ".
	    "<events_table>.ack, clients.name as interface_customer, interfaces.id as interface_id, interfaces.client as interface_client_id ";
	
	$query_from  = "hosts, types, severity, zones, <events_table> ";

	$query_joins = " LEFT OUTER JOIN interfaces on (<events_table>.host = interfaces.host) and (<events_table>.interface = interfaces.interface) \n".
		       " LEFT OUTER JOIN clients on (interfaces.client = clients.id) ";

	$query_where = "where <events_table>.host = hosts.id and <events_table>.type = types.id and hosts.zone = zones.id and 
			types.severity = severity.id $filter ";
	
	$query_order = "order by <events_table>.date $order_type, <events_table>.id $order_type ";
    
	if ($event_id > 1) $query_where.= " and <events_table>.id = $event_id ";

	if (($map_id) && ($map_id !=1 )) { //Map Selected and Not RootMap
	    $query_from = "maps_interfaces, $query_from";
	    $query_where .= 
		" and interfaces.interface = <events_table>.interface and interfaces.host = hosts.id and ". 
		"maps_interfaces.interface = interfaces.id and maps_interfaces.map = $map_id";
	    
	    if ($have_filter==0) $query_where .=" and date >= '".date("Y-m-d",time()-(60*60*24*3))." 00:00:00'"; 

	    $use_latest = 0;
	}
	
	if (is_numeric($client_id) && ($client_id > 0)) //Filter by Client ID
	    $query_where .= " and interfaces.client = $client_id ";
    
	if (($init+$span) > get_config_option("events_latest_max")) $use_latest = 0; 

	if ($have_filter==1) {
	    $show_all = 1;
	    $use_latest = 0;
	    $query_where .= " and types.show_default > 0"; //if its filtered show types 1 and 2 (show and 'only in filter')
	}

	if ($show_all==0) $query_where .= " and types.show_default = 1"; //only show the normal (don't hidden) types
	
	if ($journal > 1) $query_where .= " and <events_table>.ack = $journal";
	    
	//round span values (no decimals in SQL LIMIT)
	$span = round($span);
	$init = round($init);
	
	if (($view_all==1) && ($have_filter==1)) $query_limit = "";
	    else $query_limit = " LIMIT $init,$span";

	if ($latest_mode == 1) {
	    if ($use_latest==1) $events_table = "events_latest";
		else $events_table = "events";
	}

	if ($latest_mode == 2) {
	    //filter by lastest hours on events table
	    if ($use_latest==1) $query_where .= " and <events_table>.date > '".date("Y-m-d H:i:s",time()-$time_latest)."' ";
	    $events_table = "events";
	}
	
	$query = "$query_select \nfrom $query_from \n$query_joins \n$query_where \n$query_order $query_limit;";
	$query = str_replace("<events_table>",$events_table,$query);        
	//debug ($query);

	$res = db_query($query) or die ("Query Failed - events_list(".join(",",$params).") - ".db_error());
	$info = array();
	
	while ($reg = db_fetch_array($res)) {
	    $reg["text"] = events_replace_vars($reg,$reg["text"]); //replace the variables in < >
	    $info[]=$reg;	
	}
	//debug ($info);

	return $info;
    }


    function events_replace_vars($event,$text_aux) {
	$replacer = array ();
	
	$int_id = $event["interface_id"];
	
	if (is_numeric($int_id)) { //if the event matched an interface
	    $int_data = interface_values($int_id); //get values
	
	    foreach (current($int_data["fields"]) as $fname=>$fdata)
		switch ($fdata["type"]) {
		    case 7 : 	if (!isset($event["interface_description"])) $event["interface_description"]="";
				$event["interface_description"].= " ".$int_data["values"][$int_id][$fname];
				$event[$fname]=$int_data["values"][$int_id][$fname];
				break;
		    case 8: 
				$event[$fname]=$int_data["values"][$int_id][$fname];
				break;
		}
	    unset ($int_data);
	}


	foreach (array_keys($event) as $key) {
	    $replacer[$key] = $key;
	    if (strpos($key,"_") > 1) $replacer[str_replace("_","-",$key)]=$key;
	}

	//exceptions
	$replacer["journal"]="ack";
	$replacer["client"]="interface_customer";
	$replacer["customer"]="interface_customer";

        //debug ($event);
	//debug ($replacer);

	foreach ($replacer as $match=>$field)
	    $text_aux = str_replace("<$match>",htmlspecialchars(trim($event[$field])),$text_aux);

	// this replaces not mached < > variables
	$text_aux = preg_replace("(<\S+>)","",$text_aux);

	return $text_aux;
    } //replace vars



//SYSLOG/TACACS/TRAPS
//-------------------------

    function syslog_analized($id,$analized = 1) {	
	return db_update("syslog",$id, array(analized=>$analized));
    }

    function tacacs_analized($id,$analized = 1) {	
	return db_update("acct",$id, array(analized=>$analized));
    }

    function traps_analized($id,$analized = 1) {	
	return db_update("traps",$id, array(analized=>$analized));
    }



//FILTERS
//--------------

function filters_generate_sql($filter_id = 1) {
    $query_filter_aux = "
	    select filters_cond.pos, filters_fields.field, filters_cond.op, filters_cond.value
	    from filters_cond, filters_fields
	    where filters_cond.filter_id = $filter_id and filters_cond.field_id = filters_fields.id
	    order by filters_cond.pos";
    $result_filter_aux = db_query($query_filter_aux) or die ("Query failed - FS1 - ".db_error());
    while ($registro_filter_aux = db_fetch_array($result_filter_aux)) {
	extract($registro_filter_aux);
	
	if ($field) {
	    if (($field=="AND") or ($field=="OR"))  //for special fields
		$sql .= " $field ";
	    else if (strpos($value,"(") > 0 ) $sql .="($field $op $value)"; //this is for SQL functions like NOW()
		    else $sql .="($field $op '$value')"; //for other values
	}
    }		
    $sql = trim($sql);
    if ($sql!="") $sql_aux ="($sql)";
    return $sql_aux;
}

//JOURNAL
//---------------


function journal_list($ids = NULL,$only_active = 1) { 
    if ($only_active==1) $filter = array("journal.active","=",$only_active);

    return get_db_list(	
    	array("journal"), $ids, 
	array("journal.*"),	
	array($filter,array("journal.id",">",2)),
	array(array("journal.id","desc"))
	); 
}


function journal_update($id, $data, $comment_update = "") { //FIXME take care of ticket updating
    $journal_data = current(journal_list($journal_id));
    
    $new_comment = $journal_data[comment]."\n".$comment_update; //merge old and new comments
    if (!$data[comment]) $data[comment] = $new_comment;

    if ($journal_data[ticket]) journal_ticket ("update",$id,$comment_update);

    return db_update("journal",$id,$data); 
}


function journal_ticket($action, $journal_id, $update = "") {
    if (($action) && ($journal_id > 1)) { 
	$ticket_system = "tiba"; //FIXME
	$real_function = "ticket_".$ticket_system."_$action";
	
	$function_file = get_config_option("jffnms_real_path")."/engine/ticket/$ticket_system.inc.php";

	if (file_exists($function_file) &&  (@include_once($function_file)) ) {
	    if (function_exists($real_function)) {
		    $journal_data = current(journal_list($journal_id));

		    if ($action=="create") { //find interfaces information to create ticket
			$events = events_list (NULL,"",1,"",0,1,"",0,1, $journal_id);
			if (is_array($events) && (count ($events)==1)) {
			    $interfaces = interfaces_list(NULL,array("interface"=>$events[0]["interface"],host=>$events[0][host_id]));
			    if (is_array($interfaces) && (count ($interfaces)==1)) {
				$interface = current($interfaces);
				$journal_data["interface_description"] = $interface["host_name"]." ".$interface["zone_shortname"]." ".$interface["interface"].
							" ( ".$interface[client_name]." ".$interface[description]." )";
			    }
			}
		    }
		    $journal_data[update]=$update;
		    //debug($journal_data);
		    list($ticket_status, $ticket_number) = call_user_func_array($real_function,array($journal_data));
	    } else logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
	} else logger ("ERROR Loading file $function_file.<br>\n");

	if ($action=="create")
	    if (($ticket_status == 1) && ($ticket_number)) //OK
		db_update("journal",$journal_id,array(ticket=>$ticket_number)); //update the Journal

	if ($action=="view") return $ticket_number;
    }
}

?>
