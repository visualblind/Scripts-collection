<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_snmp_counter ($options) {
	extract($options);

	$oid = $poller_parameters;

	if ($ro_community) { //dont do anything if we dont have the community
	    $value =  trim(get_snmp_counter($host_ip,$ro_community,$oid));
	    if ($value=="") $value =  trim(get_snmp_counter($host_ip,$ro_community,$oid));
	
	    if (strpos($value," ")!==FALSE) $value = substr($value,0,strpos($value," "));
	    $value = str_replace("(","", str_replace(")","",$value));
	}

	return $value;
}
?>
