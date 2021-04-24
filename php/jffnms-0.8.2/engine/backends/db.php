<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// Allows changes to the DB based on the result,
// paramters expected like db_field,down=1|up=2,0
// so if result = down, and the actual value is not 0, db_field will be set to 1

function backend_db ($options,$poller_result){

    $db_value = "";

    $id = $options["interface_id"];
    list($field,$aux_options,$skip_value) = explode (",",$options["backend_parameters"]);

    if (!empty($aux_options)) { //if we have options
	$aux_options = explode ("|",$aux_options);
    
	foreach ($aux_options as $aux_option) {
	    list ($key,$value) = explode ("=",$aux_option);
	    if ($key==$poller_result) $db_value = $value;
	}
    } else //if we don't have options, then use the result value to modify the db
	$db_value = $poller_result;

    if (!empty($db_value) && (empty($skip_value) || ($options[$field]!=$skip_value))) { //if we have a value to use and the old value is not the skip
        if (!isset($options[$field]) || ($options[$field]!=$db_value)) //if the value is different than the old value
    	    $result = adm_interfaces_update($id,array($field=>$db_value)); //update the db
	else 
	    $result = 0; //already modified
    } else
        $result = -1; //not modified
    
    return $result;
}

?>
