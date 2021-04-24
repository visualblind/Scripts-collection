<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//Temp store the results so other backend or poller can use them (probably the rrd backend)

function backend_buffer($options,$result){
        
    extract($options);	
    if ($backend_parameters) $buffer_name = $backend_parameters;
	else $buffer_name="$poller_name-$interface_id";

    $buffer = &$GLOBALS["session_vars"]["poller_buffer"];
    
    if (empty($buffer[$buffer_name]))  //if its not already set
	$buffer[$buffer_name]=$result; //save the data on a buffer, 
        //this has to support satellite session operation
    
    return count($buffer);
}

?>
