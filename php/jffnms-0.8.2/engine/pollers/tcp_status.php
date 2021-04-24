<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_tcp_status ($options) {
    $time_tcp_normal = time_usec();
    
    $host_ip = $options["host_ip"];
    
    //Get the Port using only the first numeric characters.
    $i = 0;
    $port = "";
    while (is_numeric(substr($options["port"],$i,1))) 
	$port .= substr($options["port"],$i++,1);

    $time_tcp_normal = time_usec_diff($time_tcp_normal); //save the normal, one instruction delay

    $time_tcp = time_usec();
    $fp = @fsockopen ($host_ip, $port, $errno, $errstr, 10); //try to connect
    
    $time_tcp = time_usec_diff($time_tcp); //save the delay of connection in milliseconds

    $time_tcp_real = ($time_tcp - $time_tcp_normal) / 1000; //time tcp less the normal delay in seconds

    if (!$fp) {
	if (!empty($errstr)) logger ("$errstr ($errno):");
	$status = "closed";
    } else {
	socket_set_blocking($fp,FALSE); //try to read for 1 second
	sleep(3);
	$data = addslashes( trim (fgets ($fp,100)));
	fclose ($fp);
	$status = "open";
    }

    return "$status|$data|$time_tcp_real";
}
?>
