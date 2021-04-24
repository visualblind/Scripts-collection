<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_cisco_saagent_rtl($options) {
        
    if ( !is_array($GLOBALS["cisco_saagent_rtl"][$options["host_id"]]) ) {
	$i=0;
        while ( !is_array($rtlsum) and $i++ <=2 ) {
    	    $rtlsum=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.2",1);
            $rtlnum=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.4.1.9.9.42.1.5.2.1.1",1);
	}

	if ( is_array($rtlsum) )
	foreach ( $rtlsum as $key=>$entry ) {
    	    $key=explode(".",$key);
            $key=$key[count($key)-1];

            $rtlsum[$key]=$entry;
        }

	if ( is_array($rtlnum) )
	foreach ( $rtlnum as $key=>$entry ) { 
    	    $key=explode(".",$key);
            $key=$key[count($key)-1];

            $rtlnum[$key]=$entry;
        }

	if ( is_array($rtlsum) ) 
    	foreach ( $rtlsum as $key=>$entry ) {
	    $rtl[$key]="0";
            $nr=$rtlnum[$key];
            if ( $nr > 0 )
		$rtl[$key]=$rtlsum[$key]/$rtlnum[$key];
            $GLOBALS["cisco_saagent_rtl"][$options["host_id"]][$key]=$rtl[$key]; 
        }
    }
    
    $value=0;
    if (isset($GLOBALS["cisco_saagent_rtl"][$options["host_id"]][$options["index"]]) )
        $value=$GLOBALS["cisco_saagent_rtl"][$options["host_id"]][$options["index"]];

    return $value;
}
?>
