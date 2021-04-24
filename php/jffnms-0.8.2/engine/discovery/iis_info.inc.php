<?
/* IIS Discovery. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_iis_info ($ip, $rocommunity, $hostid, $param) {
         $test = snmp_get($ip, $rocommunity, ".1.3.6.1.4.1.311.1.7.3.1.1.0");
 
	if ($test!=false) {
    	    $iis_info[1]["interface"] = "IIS Information";
    	    $iis_info[1]["admin"] = "ok";  //to show
    	    $iis_info[1]["oper"] = "up";   //to be added by the AD
	}
 
	return $iis_info;
    }
?>
