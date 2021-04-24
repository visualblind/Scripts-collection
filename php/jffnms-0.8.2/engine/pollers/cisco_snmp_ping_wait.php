<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_snmp_ping_wait ($options) {

	extract($options);

	$cant_pings = $options["pings"];
	$oid = ".1.3.6.1.4.1.9.9.16.1.1.1";
	$cant = 1;
	
	$poller_buffer = $GLOBALS["session_vars"]["poller_buffer"];
	$buffer_name = "cisco_snmp_ping_start-$interface_id";

	if ($poller_buffer[$buffer_name]==2) {
	    //Esperar a que terminen los pings o que pasen mas de ((.25*4)*8) == 8 seg = 32 == 30
	    $timeout = 2; //sec per ping 
	    $wait = 4;
	    $max_wait = ($cant_pings*$timeout*$wait)*80/100; //cant de usleeps max
	    while (( ($cant_send = trim(get_snmp_counter($host_ip,$rw_community,"$oid.9.$random$interface_id"))) < $cant_pings ) && ($cant < $max_wait)) {
		usleep((1000000/$wait));
		$cant++;
		echo ".";
		//logger("cant=$cant cant_send=$cant_send max=$max_wait cant_pings=$cant_pings time=".(time()-$time_start)."\n"); flush();
	    }
	    echo "\n";
	    //logger("end wait\n");
	    if ($cant < $max_wait) return $cant_send;
	}
	return -1;
}
?>
