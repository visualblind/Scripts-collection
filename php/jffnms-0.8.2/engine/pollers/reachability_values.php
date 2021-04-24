<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_reachability_values ($options) {

    $fping_pattern = "/\S+ : xmt\/rcv\/%loss = (\S+)\/(\S+)\/\S+%(, min\/avg\/max = \S+\/(\S+)\/\S+|)/";
    $temp = get_config_option ("engine_temp_path");
    $buffer = $GLOBALS["session_vars"]["poller_buffer"];
    $uniq = $buffer["ping-".$options["interface_id"]]; //get file id from reachability_start
    
    $filename = "$temp/$uniq.log";

    unset ($temp);
    unset ($buffer);
    unset ($uniq);

    $which_value = $options["poller_parameters"]; //Poller Parameter specifies which value to return
    $value = 0;
        
    if (file_exists($filename)) {

	$data = trim(end(file($filename))); //get last trimmed line of the fping result
	if (preg_match($fping_pattern,$data,$parts))
	    switch ($which_value) {
		case "rtt":	if (!empty($parts[3])) $value = $parts[4]; // RTT Average
				break;

		case "pl":	$value = $parts[1] - $parts[2]; // Lost Packets = Sent Packets - Recv Packets 
				break;
	    }
    }
    unset ($data);
    unset ($parts);
    unset ($which_value);
    unset ($fping_pattern);
    
    return $value;
}
?>
