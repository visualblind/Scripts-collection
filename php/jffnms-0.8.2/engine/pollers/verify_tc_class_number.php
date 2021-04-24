<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_verify_tc_class_number ($options) {

    $linux_tc_oid = $options["autodiscovery_parameters"];
    
    $index_actual = -1;
    if (!is_array($GLOBALS["verify_tc_class_number_data"]) && !empty($options["ro_community"])) 
        $GLOBALS["verify_tc_class_number_data"] = snmp_walk($options["host_ip"],$options["ro_community"],
	    "$linux_tc_oid.1.2",1);

    if (is_array($GLOBALS["verify_tc_class_number_data"])) {
	$class_name = substr($options["interface"],strpos($options["interface"],"/")+1,strlen($options["interface"]));
	$oid_key = array_search($class_name,$GLOBALS["verify_tc_class_number_data"]);
	$index_actual = current(array_reverse(explode (".",$oid_key)));
    }

    return $index_actual;		    
}
?>
