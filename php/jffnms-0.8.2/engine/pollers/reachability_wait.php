<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_reachability_wait ($options) {

    $temp = get_config_option ("engine_temp_path");
    $buffer = $GLOBALS["session_vars"]["poller_buffer"];
    $uniq = $buffer["ping-".$options["interface_id"]]; //get file id from reachability_start

    $filename = "$temp/$uniq.log";

    unset ($temp);
    unset ($buffer);
    unset ($uniq);

    if (file_exists($filename)) {
	$i = 0;        
	while (($i++ < 100) && (strpos(trim(end(file($filename))),":") === false)) //wait 100 seconds or untuil the last line of filename have :
	    sleep(1); 
	
	return "ok";
    }
    return "error";
}
?>
