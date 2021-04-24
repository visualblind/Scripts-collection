<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Temp store the results so other backend or poller can use them (probably the rrd backend)

    function backend_multi_buffer($options,$result){

	$buffer = &$GLOBALS["session_vars"]["poller_buffer"];
	
	$var_names = explode (",",$options["poller_name"]);
	$values = explode ("|",$result);
	
	foreach ($var_names as $key=>$name) {
	    $buffer_name = $name."-".$options["interface_id"];
    
    	    if (empty($buffer[$buffer_name]) && ($values[$key]!==""))  		//if its not already set
    		$buffer[$buffer_name]=$values[$key]; 	//save the data on a buffer, 
    	    						//this has to support satellite session operation
	}
	return count($buffer);
    }

?>
