<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Get Values fomr the Buffer Temp storage

    function poller_buffer ($options) {
        
	$buffer_names = explode (",",$options["poller_name"]);
	
	$buffer = &$GLOBALS["session_vars"]["poller_buffer"];
	
	$values = array();
	
	foreach ($buffer_names as $buffer_name)
	    if (isset($buffer[$buffer_name."-".$options["interface_id"]]))
		$values[] = $buffer[$buffer_name."-".$options["interface_id"]];    
    
	$value = join("|",$values);
	
	return $value;
    }

?>
