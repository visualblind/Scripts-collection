<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_saagent_forwardjitter($options) {

    if ( !is_array($GLOBALS["cisco_saagent_forwardjitter"][$options["host_id"]])) {
	$i=0;
        while ( !is_array($sumpossd) and $i++ <= 2 ) {
	    $sumpossd=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.9",1);
    	    $sumnegsd=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.14",1);
            $nrpossd =snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.8",1);
            $nrnegsd =snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.13",1);
	}

	if ( is_array($sumpossd) )
	foreach ( $sumpossd as $key=>$entry ) { 
	    $key=explode(".",$key);
            $key=$key[count($key)-1];
            
	    $sum_pos_sd[$key]=$entry;
        }

	if ( is_array($sumnegsd) )
	foreach ( $sumnegsd as $key=>$entry ) {
	    $key=explode(".",$key);
            $key=$key[count($key)-1];

	    $sum_neg_sd[$key]=$entry;
        }

	if ( is_array($nrpossd) )
	foreach ( $nrpossd as $key=>$entry ) { 
	    $key=explode(".",$key);
            $key=$key[count($key)-1];

	    $nr_pos_sd[$key]=$entry;
        }

	if ( is_array($nrnegsd) ) 
	foreach ( $nrnegsd as $key=>$entry ) {
	    $key=explode(".",$key);
            $key=$key[count($key)-1];

	    $nr_neg_sd[$key]=$entry;
        }

	if ( is_array($sum_pos_sd) )
	foreach ( $sum_pos_sd as $key=>$entry ) {
	    $sum=$sum_pos_sd[$key]+$sum_neg_sd[$key];
            $nr=$nr_pos_sd[$key]+$nr_neg_sd[$key];
        
	    $forward_jitter[$key]=0;
	    if ( $nr > 0 )
		$forward_jitter[$key]=($sum/$nr);
	    
	    $GLOBALS["cisco_saagent_forwardjitter"][$options["host_id"]][$key]=$forward_jitter[$key]; 
        }
    }

    $value=0;
    if ( isset($GLOBALS["cisco_saagent_forwardjitter"][$options["host_id"]][$options["index"]]) )
	$value=$GLOBALS["cisco_saagent_forwardjitter"][$options["host_id"]][$options["index"]];

    return round($value,2);
}
?>
