<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_saagent_fwpacketloss($options) {
        
    if (!is_array($GLOBALS["cisco_saagent_fwpacketloss"][$options["host_id"]]) && $options["ro_community"]) {
	$i=0;
        while ( !is_array($fwpacketloss) and $i++ <=2 ) {
	    $fwpacketloss_sd=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.26",1);
            $rtlnum=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.1",1);
	}

        if ( is_array($fwpacketloss_sd) ) 
	foreach ($fwpacketloss_sd as $key=>$entry) {
    	    $key=explode(".",$key);
            $key=$key[count($key)-1];

            $fwpacketloss_sd[$key]=$entry;
	}

	if ( is_array($rtlnum) ) 
	foreach ($rtlnum as $key=>$entry) {
    	    $key=explode(".",$key);
            $key=$key[count($key)-1];

	    $rtlnum[$key]=$entry;
        }

	if ( is_array($fwpacketloss_sd) )
        foreach ( $fwpacketloss_sd as $key=>$entry ) {
    	    $fwpacketloss[$key]=0;
            $nr=$rtlnum[$key];
            if ( $nr > 0 )
		$fwpacketloss[$key]=$fwpacketloss_sd[$key]/($fwpacketloss_sd[$key] + $rtlnum[$key])*100; 

	    $GLOBALS["cisco_saagent_fwpacketloss"][$options["host_id"]][$key]=$fwpacketloss[$key]; 
        }
    }

    $value=0;
    if ( isset($GLOBALS["cisco_saagent_fwpacketloss"][$options["host_id"]][$options["index"]]) )
	$value=$GLOBALS["cisco_saagent_fwpacketloss"][$options["host_id"]][$options["index"]];

    return $value;
}
?>
