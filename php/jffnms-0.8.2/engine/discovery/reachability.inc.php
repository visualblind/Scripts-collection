<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function discovery_reachability ($ip,$community, $host_id, $param) {

	$fping = get_config_option ("fping_executable");
	
	list($ip) = explode(":",$ip); //remove :port from IP
	
	$reach = array();
	$ip = gethostbyname ($ip);
	$perms = @fileperms($fping);

	if ((ip2long($ip)!==-1) && $host_id && (file_exists($fping)===TRUE) && ($perms & 0x800)) { 
	    $reach["1"]["description"] = "Reachability to ".$ip;
	    $reach["1"]["interface"] = "Reachability Test";
	    $reach["1"]["admin"] = "Not Checked";
	    $reach["1"]["oper"] = "reachable";
	}
	
	return $reach;
    }
?>
