<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_reachability_end ($options) {

    $temp = get_config_option ("engine_temp_path");
    $buffer = $GLOBALS["session_vars"]["poller_buffer"];
    $uniq = $buffer["ping-".$options["interface_id"]]; //get file id from reachability_start
    $filename = "$temp/$uniq.log";

    unset ($temp);
    unset ($buffer);
    unset ($uniq);

    $result = -1;
    if (file_exists($filename))
	$result = unlink ($filename);

    return $result;
}
?>
