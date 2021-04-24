<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_reachability_start ($options) {
    $fping = get_config_option ("fping_executable");
    $temp = get_config_option ("engine_temp_path");
    
    $ip = gethostbyname($options["host_ip"]);

    $num_ping = $options["pings"];
    $interval = $options["interval"];

    if (($ip != -1) && file_exists($fping) && ($num_ping > 0) && ($interval > 10)) {
	$uniq = uniqid("");
	$filename = "$temp/$uniq.log";
	$command = "$fping -c $num_ping -p $interval -q $ip > $filename 2>&1 &";
	exec($command); //FIXME check if it is running
	
	unset ($command);
	unset ($filename);
    }
    unset ($fping);
    unset ($temp);
    unset ($ip);
    unset ($num_ping);
    unset ($interval);
    
    return $uniq;
}
?>
