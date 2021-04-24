<?
/* Interfaces Autodiscovery is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    //launcher parameters
    $launcher_function = "real_iad";
    $launcher_param_normal_handler = "iad_params";
    $launcher_param_managed_handler = "iad_params_managed";
    $launcher_item_source = "ad_hosts_list";

    $timeout = (8*60);
    $max_tries = 1;
    $refresh_items = false;
    
    $items_per_child = 1; // Old Master
    
    function ad_hosts_list() { //FIXME add Satellite

	$query_hosts="
	    SELECT hosts.id 
	    FROM hosts
	    WHERE hosts.id > 1 and hosts.poll = 1 and hosts.autodiscovery > 1
	    GROUP BY hosts.id 
	    ORDER BY hosts.id";

	$result_hosts = db_query ($query_hosts) or die ("Query failed - R2 - ".db_error());

	$hosts = array();

	while ($host = db_fetch_array($result_hosts)) 
	    $hosts[]=$host["id"];

	return $hosts;
    }

    function iad_params($params) {
	$base = array(NULL,NULL,NULL,NULL);
	$params[2] = true;
	$params[3] = ($_SERVER["argv"][3]=="nolog")?false:true; // Do not insert events

	foreach ($params as $pos=>$value)
	    $base[$pos] = $value;

	return $base;
    }

    function iad_params_managed($params) {

	$base = array(NULL,NULL,NULL,NULL);
	$params[2] = false;
	$params[3] = true;

	foreach ($params as $pos=>$value)
	    $base[$pos] = $value;
	
	return $base;
    }

    function ad_show_interface ($fields,$data) {
	$fields = array_merge(array(array("name"=>"interface", "ftype"=>1, "ftype_handler"=>"none")),$fields);	

	$text = array();   
	foreach ($fields as $fdata)
	    if (isset($fdata["ftype"]) && ($fdata["ftype"]!=3) && isset($fdata["ftype_handler"]) && ($fdata["ftype_handler"]!="bool"))
		$text[] = substr($fdata["name"],0,4).": ".(isset($data[$fdata["name"]])?$data[$fdata["name"]]:"");

	$text = join(" | ",$text);
	return $text;
    }


    function real_iad ($host_id = NULL, $type_id = NULL, $output = true, $log_events = true) {
	global $heartbeat;

	$event_type_id = get_config_option("jffnms_administrative_type");
	
        $ad_time = time_usec();
	
	if (!$output)  ob_start();

	$query_hosts="
	    SELECT  hosts.id, hosts.ip, hosts.rocommunity, hosts.autodiscovery_default_customer,
		    autodiscovery.poller_default, autodiscovery.permit_add, autodiscovery.permit_del,
		    autodiscovery.permit_mod, autodiscovery.permit_disable, autodiscovery.skip_loopback,
		    autodiscovery.check_state, autodiscovery.check_address, autodiscovery.alert_del
	    FROM    hosts, autodiscovery 
	    WHERE   hosts.id = ".$host_id." and hosts.autodiscovery = autodiscovery.id and 
		    hosts.autodiscovery > 1 and hosts.poll = 1";
	$result_hosts = db_query ($query_hosts) or die ("Query failed - autodiscovery hosts data - ".db_error());

	while ($host_info = db_fetch_array($result_hosts)) { //this should return only one host

	    $type_filter = ($type_id > 1)?" and id = ".$type_id:""; 

	    $query_ad="
		SELECT 	id, autodiscovery_validate, autodiscovery_function, autodiscovery_parameters, 
			autodiscovery_default_poller, description, sla_default
		FROM 	interface_types
		WHERE 	autodiscovery_enabled = 1 ".$type_filter."
		ORDER BY id";
	
	    $result_ad = db_query ($query_ad) or die ("Query failed - autodiscovery interface types - ".db_error());

	    while ($it = db_fetch_array($result_ad)) { //loop thru all interface_types
		unset($db);
		unset($host);
	    
		if (!$output) {
		    ob_end_clean();

		    if (($old_time + $heartbeat) > time()) 		// if $heartbeat seconds have passed since last time
			echo ".";					// Output a dot is sign of a heartbeat for the master

		    flush();
		    ob_flush();
		    ob_start();
	    	    $old_time = time();
		}
	    
		logger(	"H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
			"IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
			"Autodiscovering ".$it["description"]."\n");

		//Get All nedded data for this interface type
	    
		$db   = hosts_interfaces_from_db ($host_info["id"],$it["id"]);
	
		$host = hosts_interfaces_from_discovery ($it["autodiscovery_function"], $host_info["ip"], $host_info["rocommunity"], $host_info["id"], $it["autodiscovery_parameters"]);

		$fields = interface_types_fields_list (NULL,array("itype"=>$it["id"],"exclude_types"=>20));
	    
		//print_r($db);
	        //print_r($host);
		//print_r ($fields);
	    
		if (is_array($host)) { //merge the keys to get a single list of all interfaces on both lists
		    $interface_ids_list = array_unique(array_merge(array_keys($db),array_keys($host)));
		    asort($interface_ids_list);
		    reset($interface_ids_list);
		}
	    
		if (is_array($host) && (count($host) > 0)) //if the host aswered something  
		    foreach ($interface_ids_list as $key) if ($key >= 0) { //key is valid 
			$processed = 0;
			$now_date = date("Y-m-d H:i:s",time());
		
			if (isset($db[$key])) 	 ksort($db[$key]);
			if (isset($host[$key])) ksort($host[$key]);

			//output
		        logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
			        "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
			        "I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
			        "DB  : ".(isset($db[$key])?ad_show_interface($fields,$db[$key]):"Not Found")."\n");
			logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
			        "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
			        "I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
			        "HOST: ".(isset($host[$key])?ad_show_interface($fields,$host[$key]):"Not Found")."\n");
		
			if (!isset($db[$key]) && isset($host[$key])) {  //not found in DB and found in Host, add

			    if (    ($it["autodiscovery_validate"]==0) ||  //the interface type told us not to validate the data
				    ( //validation	    
					(//loopback test
					($host_info["skip_loopback"]==0) ||	//the policy says not to skip loopbacks
					    ( //check if the interface is loopback
					    (strpos(strtolower($host[$key]["interface"]),"loopback") === false) && //cisco
					    (strpos(strtolower($host[$key]["interface"]),"null") === false) && //cisco
					    ($host[$key]["address"] != "127.0.0.1") && //any loopback
					    (substr(strtolower($host[$key]["interface"]),0,2) != "lo") //linux
					    ) //TRUE if its not a loopback
					) && 
					( //check address
					($host_info["check_address"]==0) || 			//the policy tell us not to check if the address is valid
					(array_key_exists("address",$host[$key]) == false) || 	//or the host doesn't have an address field
					    (($host[$key]["address"]!="") && ($host[$key]["address"]!="0.0.0.0"))  //or the interface has a valid IP address 
					) &&
					( //check status
					($host_info["check_state"]==0) || //the host autodiscovery policy tell us not to check state	
					    (alarm_lookup($host[$key]["oper"])==ALARM_UP) //or the state is UP
					)
				    ) //end of validation
				) { //add the interface

			    unset ($text);
	
			    logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
				    "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
				    "I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
				    "RES : New Interface Found\n");
			
			    if ($host_info["permit_add"]==1) { //if the AD policy permits adding an interface.
			    
				if ($host_info["poller_default"]==1) //if the AD policy says use default poller
				    ad_set_default (&$host[$key]["poll"],$it["autodiscovery_default_poller"]); //use the interface type default poller for this new interface
		
				ad_set_default (&$host[$key]["client"],$host_info["autodiscovery_default_customer"]);
				ad_set_default (&$host[$key]["sla"],$it["sla_default"]);
			    
			        //Find the Index Field
				foreach ($fields as $fdata)
				    if ($fdata["ftype"]==3)
					$index_field = $fdata["name"];

				//add the index field as data to use when adding a record
				$host[$key][$index_field]=$key;

				//delete the status fields, because they will not be found in the db
				unset ($host[$key]["admin"]);
				unset ($host[$key]["oper"]);

				$interface_id = adm_interfaces_add(array("host"=>$host_info["id"],"type"=>$it["id"])); //add new record
				adm_interfaces_update($interface_id,$host[$key]); //update it with the data
				$text = "- Added";
			    } //permit add
			
			    if ($log_events==true)
				insert_event ($now_date, $event_type_id, $host_info["id"], $host[$key]["interface"], //add informative event
				    "alert","autodiscovery",trim("Found ".$text),0); 
			    $processed = 1;
			} // if allow add
		    } //add 
	
		    if ( !isset($host[$key]) && isset($db[$key]) && //found in DB but not in host
			($it["autodiscovery_validate"]==1) && ($db[$key]["poll"] > 1)){  //IT need validation, and the interface is being polled (preserve non polling)
		
			logger(	"H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
				"IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
				"I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
				"RES : Not Found in Host\n");
	
			unset ($text);
			if (($host_info["permit_del"]==1) && ($host_info["permit_disable"]==0)) { //Policy permits delete and not disable
			    adm_interfaces_del ($db[$key]["id"]); //delete it
			    $text = "- Deleted";
			}

			if (($host_info["permit_del"]==0) && ($host_info["permit_disable"]==1)) { //policy permits disable but not delete
			    adm_interfaces_update ($db[$key]["id"],array("poll"=>1,"show_rootmap"=>2)); //disable it (No Polling), and mark it disabled on the map
			    $text = "- Disabled";
			}

			if (($log_events==true) && ($host_info["alert_del"]==1))
			    insert_event($now_date,$event_type_id, $host_id, $db[$key]["interface"], //add informative event
				"alert","autodiscovery", trim("Not Found in Host ".$text),0); 
			$processed = 1;
		    } //delete
	
		    if (isset($host[$key]) && isset($db[$key]) && ($db[$key]["poll"] > 1)) { //found in both and poll enabled, check for modification

			//track field changes
		        if ($it["autodiscovery_validate"]==1) { //validate fields in this interface type?
	
			    $fields_to_modify = array();
			    $track_fields = array();
			
			    $track_fields["interface"]="Interface Name";
			
			    foreach ($fields as $fdata)
				if ($fdata["tracked"]==1) 
				    $track_fields[$fdata["name"]]=$fdata["description"];

			    foreach ($track_fields as $track_field=>$track_field_descr)			
				if ((!empty($host[$key][$track_field])) && //field from host not empty
		    		    (trim(substr($db[$key][$track_field],0,30)) != trim(substr($host[$key][$track_field],0,30))) ) {  //fields not equal

				    logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
				            "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
					    "I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
				    	    "RES : ".$track_field_descr." Changed from ".$db[$key][$track_field]." to ".$host[$key][$track_field]."\n");

				    //add field to be modified
				    $fields_to_modify[$track_field]=$host[$key][$track_field];
				}

			    if (count($fields_to_modify) > 0) { 	//there are fields to be modified
		
				$aux_changes = array();
			    
			        foreach ($fields_to_modify as $field_name=>$field_value)
			    	    $aux_changes[] = $track_fields[$field_name]." to ".$field_value." was ".$db[$key][$field_name];
				
				$aux_changes = join (" and ",$aux_changes);
			    
				if ($host_info["permit_mod"]==1) { 	//policy permits modification
			    
				    adm_interfaces_update ($db[$key]["id"],$fields_to_modify); //modify it
			    
				    if (array_key_exists("interface",$fields_to_modify)) //if we changed the interface field (key for events)
					$aux_interface_name = $host[$key]["interface"]; //use the new one
				    else
					$aux_interface_name = $db[$key]["interface"]; //if not use the old one
			
			    	    $aux_comment = "- Changed ".$aux_changes;
				} else {
			    	    $aux_interface_name = $db[$key]["interface"];
			    	    $aux_comment = "- NOT Changed ".$aux_changes;
				}

				if ($log_events==true)
				    insert_event($now_date, $event_type_id, $host_id, $aux_interface_name,
					"alert","autodiscovery", trim("detected modification ".$aux_comment),0); 
				$processed = 1;

				unset ($aux_interface_name);
			        unset ($aux_comment);
			    }
			
			    unset($track_fields);
			    unset($fields_to_modify);
			}//validate
		    
			//no customer selected 
			if ($db[$key]["client"] <= 1) { //customer not selected in DB
			    logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
				    "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
			    	    "I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
			    	    "RES : No Customer Selected\n");

			    if ($log_events==true)
				insert_event($now_date, $event_type_id, $host_id, $db[$key]["interface"],
				    "alert","autodiscovery","Incomplete Interface Setup (Customer not Selected)",0); 
			    $processed = 1;
			}
		    } //modification 
	    
		    if ($processed == 0) //interface was not touched by any posibility
			logger( "H ".str_pad($host_info["id"],3," ",STR_PAD_LEFT)." : ".
			        "IT ".str_pad($it["id"],3," ",STR_PAD_LEFT)." : ".
				"I ".str_pad($key,4," ",STR_PAD_LEFT)." : ".
			        "RES : Nothing Done.\n");
		
		} //for (interface ids)
	    } //while (interface types)
	} //while (host)

	$ad_time = round(time_usec_diff($ad_time));
	logger("H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Autodiscovery took ".$ad_time." msec.\n");

        ob_end_clean();

	return array("times"=>$ad_time);
    } //function 
    
    include ("launcher.inc.php");

?>
