<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //CISCO-CONFIG-COPY-MIB Configuration Downloader Implementation
    //from: http://www.cisco.com/warp/public/477/SNMP/copy_configs_snmp.shtml
    //	waiting(1), running(2), successful(3), failed(4)

    function config_cisco_cc_get ($ip, $rwcommunity, $server, $filename) {

	if ($ip && $rwcommunity && $server && $filename) {
	    $oid = ".1.3.6.1.4.1.9.9.96.1.1.1.1";
	    $result = snmp_set($ip,$rwcommunity,"$oid.14.999","i",6); //destroy

	    if ($result==true) {
		snmp_set($ip,$rwcommunity,"$oid.14.999","i","5"); //create and wait
		snmp_set($ip,$rwcommunity,"$oid.2.999","i","1"); //tftp
		snmp_set($ip,$rwcommunity,"$oid.3.999","i","4"); //running
		snmp_set($ip,$rwcommunity,"$oid.4.999","i","1"); //network
		snmp_set($ip,$rwcommunity,"$oid.5.999","a",$server); //server
		snmp_set($ip,$rwcommunity,"$oid.6.999","s",$filename); //filename
		snmp_set($ip,$rwcommunity,"$oid.14.999","i","1"); //activate
	    
		sleep (2);
	    
		$result = snmp_get($ip,$rwcommunity,"$oid.10.999");
		if ($result != 4) return true;
	    }
	}
	return false;
    }

    function config_cisco_cc_wait ($ip, $rwcommunity, $server, $filename) {
        $i = 1;
        $result = 1;
	$oid = ".1.3.6.1.4.1.9.9.96.1.1.1.1";
        while ((($result == 1) or ($result == 2)) and ($i++ < 30)) { 
	    $result = snmp_get($ip,$rwcommunity,"$oid.10.999");
	    sleep(2); 
	}
	if ($result == 3) return true; 
	return false;
    }
?>
