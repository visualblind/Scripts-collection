<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function backend_verify_interface_number($options,$result) {
    
    $aux = interface_values ($options["interface_id"],array("ftype"=>3)); //get the index field
    $index_field = key(current($aux["values"]));
    
    if (($result!=$options[$index_field]) && (!empty($result)) && ($result!="-1")) { //if valid result and result different than older value

	$data = array($index_field=>$result);
	$result = adm_interfaces_update($options["interface_id"],$data);
	
	return "$index_field changed";
    } else 
	return "$index_field not changed";
}

?>
