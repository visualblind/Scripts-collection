<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//This poller stores all the table on an array and then request its contents,
//this is faster if you are monitoring a lot of same-type interface in a host

function poller_snmp_interface_status_all ($options) {
	$stored_data = "snmp_interface_status_data-".$options["poller_parameters"];

	if ($options["ro_community"]) {
	
	    if (!isset($GLOBALS[$stored_data]["number_of_interfaces"])) //Get the Number of Interfaces
		$GLOBALS[$stored_data]["number_of_interfaces"] = 
		    snmp_get($options["host_ip"],$options["ro_community"],".1.3.6.1.2.1.2.1.0");

	    if ($GLOBALS[$stored_data]["number_of_interfaces"] > 30) {
		if (count($GLOBALS[$stored_data])==1) { //only the number of interfaces is set
		    $i=0;
	    	    $rets = "";
		    while (!is_array($rets) and $i++ <= 2) //check 3 times or until we get something valid
    	    		$rets=snmp_walk($options["host_ip"],$options["ro_community"],".1.3.6.1.2.1.2.2.1.".$options["poller_parameters"],1);

		    unset ($i);
	    
	    	    if (is_array($rets))
		    foreach ($rets as $key=>$entry) {
    			$key=explode(".",$key);
		        $key=$key[count($key)-1];
		        $GLOBALS[$stored_data][$key]=$entry;
        	    }
		    unset ($entry);
	    	    unset ($key);
    		}
	    } else
		$GLOBALS[$stored_data][$options["interfacenumber"]] =
		    snmp_get($options["host_ip"],$options["ro_community"],".1.3.6.1.2.1.2.2.1.".$options["poller_parameters"].".".$options["interfacenumber"]);
	}

	$check_val=$GLOBALS[$stored_data][$options["interfacenumber"]];
	
        if ($check_val) { 
    	    list($check_val) = explode("(",$check_val);

	    if (is_numeric($check_val)) //Process MIB Values
		switch ($check_val) {
		    case "1"	:	$value = "up"; break;
		    case "2"	:	$value = "down"; break;
		    case "3"	:	$value = "testing"; break;
		    default	:	$value = "down";
		}	
	    else
	        $value=$check_val;
	}
	unset ($check_val);
	
	//exception
	if (($options["poller_parameters"]==7) && //If we're polling the Admin Status
	    ($options["fixed_admin_status"]==1))  //And the interface has specified that it does not want its admin status to be modified
	    unset ($value);			  //Unset the variable so the 'db' backend does not modify it.
	
	return $value;
}
?>
