<?
/* Poller Helper. This file is part of JFFNMS
 * Copyright (C) <2004> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");
    
    $poller_helper_time = time_usec();
    
    $my_sat_id = satellite_my_id();

    $jffnms_poller_command = "poller.php";

    $query_hosts="SELECT * FROM hosts WHERE id > 1 AND poll > 0 AND satellite = $my_sat_id";
    $result_hosts = db_query ($query_hosts) or die ("Query failed - R2 - ".db_error());

    while ($host = db_fetch_array($result_hosts)) {
    
	$host_id = $host["id"];

	// Poll DMIIs
        // ----------

	if ($host["dmii"]!=1) { 
	    logger(" :  H ".str_pad($host["id"],3," ",STR_PAD_LEFT)." : Polling DMIIs.\n");
	    spawn ("$php_executable -q poller.php","$host_id dmii",1);
	    sleep(2);
	}
	
	// Poll Alarmed Interfaces
        // -----------------------
    
	$alarms = alarms_list(0,array("alarm_state"=>ALARM_DOWN,"host"=>$host["id"]));

	unset ($interface_id);
	foreach ( $alarms as $alarm ) { //get all the interface ids from this host
	    $int = current(interfaces_list ($alarm["interface"]));
	    if ($int["poll"] > 0)
		$interface_id[]=$alarm["interface"];
	}
	
	if (count($interface_id) > 0) {
	    logger( " :  H ".str_pad($host["id"],3," ",STR_PAD_LEFT)." : Polling Alarmed/Down: ".count($interface_id)." Interfaces.\n");
	    
	    spawn ("$php_executable -q poller.php","$host_id ".join(",",$interface_id),1);
	    sleep(5);
	}
    }

    $poller_helper_time = time_usec_diff($poller_helper_time);
    logger(" : Poller Helper Ended, Total Time: $poller_helper_time msec.\n");
?>
