<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //OLD-CISCO-SYSTEM-MIB Configuration Downloader Implementation
    //from: http://www.cisco.com/warp/public/477/SNMP/11_7910.shtml
        
    function config_cisco_sys_get ($ip, $rwcommunity, $server, $filename) {
	if ($ip && $rwcommunity && $server && $filename) {
	    $oid = ".1.3.6.1.4.1.9.2.1.55.$server";
	    $result = snmp_set($ip,$rwcommunity,$oid,"s",$filename, 4);

	    if ($result==true) return true;
	}
	return false;
    }

    function config_cisco_sys_wait ($ip, $rwcommunity, $server, $filename) {
	return true; //we dont wait because the snmp_set returns when the tftp has been completed
    }
?>
