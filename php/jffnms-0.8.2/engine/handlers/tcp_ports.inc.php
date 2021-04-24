<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Data comes as a reference to real data
    function handler_tcp_ports ($id, $data, $old_data) {
	
	$port = (!empty($data["port"])?$data["port"]:$old_data["port"]);
	
	$aux_interface_name = "Port $port";
	$data["port"]=$port;
	
	//Duplicate avoidance Logic (because of manual add)
	if ($old_data["port"]!=$port) { //if the user is trying to change the port number
	
	    if ($id!==false) {
		$aux = current(interfaces_list($id)); //Get the Host ID of the interface
	        $host_id = $aux["host"];
		unset ($aux);
	    } else
		$host_id = 1;

	    $exists = 1;
	    while ($exists > 0) {
		$ids = interfaces_list(NULL,array("host"=>$host_id,"interface"=>$aux_interface_name));
		unset ($ids[$id]); //remove my id from the list
		$exists = count($ids);
	    
	        if ($exists > 0) { //if we've any record with this interface name already, then add an identifier
		    $data["port"] = $port." ".$i++; //changes the record
	    	    $aux_interface_name = "Port ".$data["port"];
		}
	    }
	}
	
	$data["interface"] = $aux_interface_name;
    }

?>
