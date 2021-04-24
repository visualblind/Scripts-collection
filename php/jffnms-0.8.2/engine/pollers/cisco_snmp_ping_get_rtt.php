<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_snmp_ping_get_rtt ($options) {
	extract($options);

	$oid = ".1.3.6.1.4.1.9.9.16.1.1.1";

	$poller_buffer = $GLOBALS["session_vars"]["poller_buffer"];
	$buffer_name = "cisco_snmp_ping_start-$interface_id";
	if ($poller_buffer[$buffer_name]==2) {
	    $rtt=round(snmp_get($host_ip,$rw_community,"$oid.12.$random$interface_id"));
	    return $rtt;
	}
	return 0;
}
?>
