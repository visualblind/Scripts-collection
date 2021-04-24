<?
/* Poller 2.0 . This file is part of JFFNMS
 * Copyright (C) <2004-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $launcher_function = "real_poller";
    $launcher_param_normal_handler = "poller_params";
    $launcher_param_managed_handler = "poller_params_managed";

    $launcher_child_status ="poller_status";
    $launcher_item_source = "hosts_random_list";
    $refresh_items = true;
    $refresh_time = 20;	
    $timeout = (3*60); 

    function hosts_random_list($interval = false) { //FIXME Add Satellite

	$query_hosts="
	    SELECT hosts.id, count(interfaces.id) as cant_interfaces, hosts.last_poll_date
	    FROM hosts, interfaces
	    WHERE hosts.id > 1 and hosts.poll = 1 and interfaces.id > 1 and 
		interfaces.poll > 1 and interfaces.host = hosts.id".
		(($interval)?" and ((hosts.last_poll_date + hosts.poll_interval - (hosts.last_poll_time/2)) < ".time().")":"").
	    "\n\t GROUP BY hosts.id, hosts.last_poll_date ORDER BY hosts.last_poll_date asc";

	$result_hosts = db_query ($query_hosts) or die ("Query failed - R2 - ".db_error());

	$hosts = array();
	while ($host = db_fetch_array($result_hosts)) 
	    if ($host["cant_interfaces"] > 0) 
		$hosts[]=$host["id"];

	return $hosts;
    }	

    function poller_status ($poller, $result) {
    
	list ($status, $items_total, $items_ok, $time) = explode (" ", $result);
	
	logger (
	    "Poller ".$poller["pid"]." ".
	    (($status=="OK")
	    ?"finished working on host ".$poller["item"]." in ".time_hms(round($time/1000)).", Items $items_ok/$items_total"
	    :"failed when polling host ".$poller["item"].": $result")
	.".\n");
	
	return ($status=="OK")?true:false;
    }

    function poller_params($params) {
	$base = array(NULL,NULL,NULL,NULL,NULL,NULL);
	$params[4] = true;

	foreach ($params as $pos=>$value)
	    $base[$pos] = $value;

	return $base;
    }

    function poller_params_managed($params) {

	$base = array(NULL,NULL,NULL,NULL,NULL,NULL);
	$params[4] = false;

	foreach ($params as $pos=>$value)
	    $base[$pos] = $value;

	return $base;
    }

    function real_poller ($host_id = NULL , $interface_id = NULL, $poller_pos = NULL, $itype = NULL, $output = true) { 
	global $heartbeat;
	
	$time_start = time_usec();

	$poller_plan_filter = array("interface"=>$interface_id,"host"=>$host_id,"pos"=>$poller_pos,"type"=>$itype);
	$poller_plan_result = poller_plan ($poller_plan_filter); // Get the Poller Plan (things to poll)

	if ($output)
	    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Poller Start : ".$poller_plan_result["items"]." Items.\n"); 
	else
	    ob_start();

	$times = array();
	$included_files = array();
	$items_ok = 0;
	
	$jffnms_real_path = get_config_option ("jffnms_real_path");

	while ($poller_data = poller_plan_next($poller_plan_result)) {

	    $poller_command = $poller_data["poller_command"];
	    $backend_command = $poller_data["backend_command"];
	    $poller_filename = "$jffnms_real_path/engine/pollers/$poller_command.php";
	    $backend_filename = "$jffnms_real_path/engine/backends/$backend_command.php";

	    //unset result variables
	    unset($poller_result);
	    unset($backend_result);
	
	    $ok = true;

	    if (!isset($included_files[$poller_filename])) {
		if (file_exists($poller_filename)) {
		    include_once($poller_filename);
	    	    $included_filenames[$poller_filename]=true;
		} else 
		    $ok = false;
	    }	    

	    if (!isset($included_files[$backend_filename])) {
		if (file_exists($backend_filename)) {
		    include_once($backend_filename);
	    	    $included_filenames[$backend_filename]=true;
		} else 
		    $ok = false;
	    }	    

	    if ($ok) {
		
		$time_poller_query = time_usec();
		$poller_result = call_user_func_array("poller_$poller_command",array($poller_data));
		$time_poller_query = time_usec_diff($time_poller_query);
	
		$time_backend_query = time_usec();
    		$backend_result = call_user_func_array("backend_$backend_command",array($poller_data,$poller_result));
	        $time_backend_query = time_usec_diff($time_backend_query); 

		$items_ok++;
	    } else  //no poller files
		logger("ERROR: $poller_command or $backend_command Modules not Found...",0);

	    //debug output	
	    if ($output) {
	    
		//Cut the Poller Parameters String
		$poller_param_description = isset($poller_data["poller_parameters"])?$poller_data["poller_parameters"]:"";
		if ($aux = strlen($poller_param_description) > 10) 
		    $poller_param_description = substr($poller_param_description,0,4)."..".substr($poller_param_description,strlen($aux)-4,4); 

		logger( " :  H ".str_pad($poller_data["host_id"],3," ",STR_PAD_LEFT).
			" :  I ".str_pad($poller_data["interface_id"],3," ",STR_PAD_LEFT).
			" :  P ".str_pad($poller_data["poller_pos"],3," ",STR_PAD_LEFT).
			" : ".(($backend_command=="buffer")?"$poller_command:":"").$poller_data["poller_name"]."(".$poller_param_description."): $poller_result ".
			"-> $backend_command(".$poller_data["backend_parameters"]."): $backend_result".
			" (time P: $time_poller_query | B: $time_backend_query) ".
			"\n");
	    } else {
	        ob_end_clean();

		if (($old_time + $heartbeat) > time()) 		// if $heartbeat seconds have passed since last time
		    echo ".";					// Output a dot is sign of a heartbeat for the master

		flush();
		ob_flush();
		ob_start();
	        $old_time = time();
	    }
	} //while 

    	$time = round(time_usec_diff($time_start));
	
	if ($output)
	    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Poller End, Total Time: $time msec.\n");
	else
	    ob_end_clean();

	// Update Host(s) Last Poll Date/Time
	
	$host_ids = explode(",",$host_id); // in case we're being called to poll multiple hosts
	foreach ($host_ids as $host_id)
	    adm_hosts_update($host_id,array("last_poll_date"=>time(), "last_poll_time"=>round($time/1000))); 

	return array("items"=>$poller_plan_result["items"], "items_ok"=>$items_ok, "time"=>$time);
    }
    
    include ("launcher.inc.php");
    
?>
