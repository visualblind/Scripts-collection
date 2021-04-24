<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_saagent_verify($options) {
        
        if (!is_array($GLOBALS["verify_saagent_operation"][$options["host_id"]]) && $options["ro_community"]) {
    	    $i=0;
    	    while (!is_array($rets) and $i++ <=2 ) 
		$rets=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.1",1);
            
	    if ( is_array($rets) )
	    foreach ( $rets as $key=>$entry ) {
		$key=explode(".",$key);
                $key=$key[count($key)-1];
		$GLOBALS["verify_saagent_operation"][$options["host_id"]][$key]=$entry;
            }
	}

        //$value="down"; //don't assume DOWN let that job to the alarm backend

        if ( isset($GLOBALS["verify_saagent_operation"][$options["host_id"]][$options["index"]]) )
            $check_val=$GLOBALS["verify_saagent_operation"][$options["host_id"]][$options["index"]];

        if (isset($check_val))
             $value="up"; 
	
	return "$value|$value";
}
?>
