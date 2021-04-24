<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_snmp_ping_end ($options) {
	extract($options);

	if (($peer) && ($host_ip) && ($rw_community)) {
    	    $oid = ".1.3.6.1.4.1.9.9.16.1.1.1";
	    $result = snmp_set($host_ip,$rw_community,"$oid.16.$random$interface_id","i","6"); //destroy
	    return count($result);
	} else return -1;
}
?>
