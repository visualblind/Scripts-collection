<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function discovery_tcp_ports($ip,$community, $host_id, $param) {

	$nmap = get_config_option ("nmap_executable");
	$temp = get_config_option ("engine_temp_path");

	$ports = array();
	list($ip) = explode(":",$ip); //remove :port from IP
	$ip = gethostbyname ($ip);

	if ((ip2long($ip)!==-1) && $host_id && (file_exists($nmap)===TRUE)) { 
	    $filename = "$temp/".uniqid("").".log";
	    $command = "$nmap $param -n -oG $filename $ip";
	    exec($command,$a,$b);

	    if (file_exists($filename)==true) {
	        $data = file($filename);
		unlink($filename);
	    }

	    if (count($data)==3) { 	
		$pos1 = strpos($data[1],"Ports")+6;
		if ($pos1 > 6) {
		    $pos2 = strpos($data[1],"Ignored");
		    $data_line = substr($data[1],$pos1,$pos2-$pos1);
		    $data_ports = explode(",",$data_line);
		}
	    }

	    if (is_array($data_ports) && (count($data_ports) > 0))
	    foreach ($data_ports as $port) { 
		$aux1 = array();

		$port_data = explode("/",trim($port));

		$status = $port_data[1];
		$aux1["interface"] = "Port ".$port_data[0];
		$aux1["description"] = $port_data[4]; 
		$aux1["admin"] = $status;	//to show
		$aux1["oper"] = $status;	//to be added by the AD

		if ($status=="open") //only return ports with open state, not filtered, or closed
		    $ports[$port_data[0]]= $aux1;
	    }
	}
	return $ports;
    }
?>
