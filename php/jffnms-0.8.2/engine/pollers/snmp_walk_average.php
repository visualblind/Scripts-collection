<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function poller_snmp_walk_average ($options) {
	$oid = $options["poller_parameters"];

	if ($options["ro_community"]) { //dont do anything if we dont have the community
	    $values = snmp_walk ($options["host_ip"],$options["ro_community"],$oid);

	    if (is_array($values) && count($values) > 0)
		$average = array_sum($values)/count($values);
	}

	return $average;
    }
?>
