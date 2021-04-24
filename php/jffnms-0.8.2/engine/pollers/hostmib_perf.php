<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //HOSTMIB Software Performance Poller
    //By: Javier Szyszlican
    //Based on the Status Poller By: Anders Karlsson <anders.x.karlsson@songnetworks.se>

    function poller_hostmib_perf ($options) {
	global $Apps;

	$hrSWRunPerfEntry_oid = ".1.3.6.1.2.1.25.5.1.1";
	$perf_oid = $hrSWRunPerfEntry_oid.".".$options["poller_parameters"];
	
	if (is_array($Apps[$options["host_id"]]["pids"][$options["interface"]])) { //if we got something

	    $pids = $Apps[$options["host_id"]]["pids"][$options["interface"]];
	    
	    foreach ($pids as $pid)
		$values[] = current(explode(" ",snmp_get($options["host_ip"], $options["ro_community"], $perf_oid.".$pid")));
	    
	    $value = array_sum($values);
	
	    return $value;
	}
    }
?>
