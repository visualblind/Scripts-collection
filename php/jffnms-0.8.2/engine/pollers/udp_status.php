<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function poller_udp_status ($options) {
	
	$host_ip = gethostbyname ($options["host_ip"]);
	$nmap = get_config_option ("nmap_executable");
	$temp = get_config_option ("engine_temp_path");
    
        //Get the Port using only the first numeric characters.
        $i = 0;
	$port = "";
	while (is_numeric(substr($options["port"],$i,1))) 
	    $port .= substr($options["port"],$i++,1);

	if ((ip2long($host_ip)!==-1) && (file_exists($nmap)===true)) { 
	    $filename = "$temp/".uniqid("").".log";
	    $command = "$nmap -sU -p$port -n -oG $filename $host_ip";
	    exec($command,$a,$b);

	    if (file_exists($filename)==true) {
	        $data = file($filename);
		unlink($filename);
	    }

	    if (count($data)==3) { 	
		$pos1 = strpos($data[1],"Ports")+6;

		if ($pos1 > 6) {
		    $data_line = substr($data[1],$pos1,strlen($data[1])-$pos1);
		    $data_ports = explode(",",$data_line);
		}
		$time = current(array_slice(explode(" ",$data[2]),-2));
	    }

	    if (is_array($data_ports) && (count($data_ports) > 0))
		foreach ($data_ports as $port) 
		    list ($udp_port, $status) = explode("/",trim($port));

	}	
	return "$status|$time";
    }
?>
