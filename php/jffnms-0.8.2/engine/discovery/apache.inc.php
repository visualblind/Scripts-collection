<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Apache Discovery

    function discovery_apache ($ip, $rocommunity, $hostid, $param) {
         
	list($ip) = explode(":",$ip); //remove :port from IP

	$ip_port = $ip.":80";
	$test = @file("http://".$ip_port."/server-status?auto");
	 
	if ($test!=false) {
    	    $apache_info[$ip_port]["interface"] = "Apache Information";
    	    $apache_info[$ip_port]["admin"] = "ok";  //to show
    	    $apache_info[$ip_port]["oper"] = "up";   //to be added by the AD
	}
 
	return $apache_info;
    }
?>
