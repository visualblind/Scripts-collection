<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function poller_sql_status ($options) {

	$buffer = &$GLOBALS["session_vars"]["poller_buffer"];

	$record_values = array(
	    $buffer["records_counter-".$options["interface_id"]],
	    $buffer["records_absolute-".$options["interface_id"]]);
	    
	$records = is_numeric($record_values[0])?$record_values[0]:$record_values[1];

	if ($records >= 0) {
	    if (is_numeric($options["max_records"]) && ($records > $options["max_records"]))
		return "out of bounds|$records records is more than Max ".$options["max_records"];
    
	    if (is_numeric($options["min_records"]) && ($records < $options["min_records"]))
		return "out of bounds|$records records is less than Min ".$options["min_records"];
    
	    return "ok|$records records is within boundaries";

	} else {

	    switch ($records) {
		case -1: $error = "Problem connecting to the DB"; break;
		case -2: $error = "Problem in Query"; break;
		case -3: $error = "Problem in Data Retrival"; break;
	    }
	    
	    return "out of bounds|$error";
	}
    }
?>
