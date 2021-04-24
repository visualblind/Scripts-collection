<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_envmib_status ($options) {
	
        $val="down";

	$data = &$GLOBALS["cisco_envmib_status_data"][$options["host_ip"]][$options["poller_parameters"]];

	if (!is_array($data) && $options["ro_community"]) {
    	    $i=0;
	    $rets="";
	    while (!is_array($rets) and $i++ <=2 ) //try 2 times 
        	$rets=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.13.1.".$options["poller_parameters"],1);
	    
	    if (is_array($rets))
	    foreach ( $rets as $key=>$entry ) {
        	$key=explode(".",$key);
                $key=array_reverse($key);
                $key=$key[0];
                $data[$key]=$entry;
            }
	}

	$value=$data[$options["index"]];
    
	if ($value == "1") $val="up";
	return $val;
}
?>
