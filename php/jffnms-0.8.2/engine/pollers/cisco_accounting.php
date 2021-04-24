<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// get Cisco IP Accounting Information 
// URL : http://www.cisco.com/en/US/tech/tk648/tk362/technologies_tech_note09186a0080094aa2.shtml
// MIB: ftp://ftp.cisco.com/pub/mibs/v1/OLD-CISCO-IP-MIB.my

function poller_cisco_accounting ($options) {

	$checkpoint_oid 	= ".1.3.6.1.4.1.9.2.4.11.0";
	$accounting_packets_oid = ".1.3.6.1.4.1.9.2.4.9.1.3";
	$accounting_bytes_oid 	= ".1.3.6.1.4.1.9.2.4.9.1.4";
	
	$total_bytes = 0;
	$total_packets = 0;
	
	if (($options["host_ip"]) && (strlen($options["rw_community"]) > 3)) {
	
	    $checkpoint_id = snmp_get($options["host_ip"],$options["rw_community"],$checkpoint_oid);

	    $get_data = snmp_set($options["host_ip"],$options["rw_community"],$checkpoint_oid,"i",$checkpoint_id); //mark checkpoint to get new data
	    //var_dump($get_data);

	    if ($get_data) { 
		
		$packets = snmp_walk($options["host_ip"],$options["rw_community"],$accounting_packets_oid);    
		if (is_array($packets)) while (list(,$aux) = each($packets)) $total_packets += $aux;
		unset($packets);

		$bytes = snmp_walk($options["host_ip"],$options["rw_community"],$accounting_bytes_oid);    
		if (is_array($bytes)) while (list(,$aux) = each($bytes)) $total_bytes += $aux;
		unset($bytes);
	    }

	    return "$total_bytes,$total_packets";  //return to buffer
	} else return -1;
}
?>
