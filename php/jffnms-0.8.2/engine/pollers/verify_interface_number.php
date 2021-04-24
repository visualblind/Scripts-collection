<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function poller_verify_interface_number ($options) {
    
    $buffer = &$GLOBALS["verify_interface_number_data"];
    
    $current_ifindex = $options["interfacenumber"];

    //Search by Interface Name (ie. Switches or not IP interfaces)
    if (($options["address"]=="") && ($options["interfacenumber"]!="")) { // if IP is empty and it has a interfacenumber in the DB

	if (!is_array($buffer["ifIndex"]) && $options["ro_community"]) {	//Get the Tables via SNMP only once
	
	    $ifIndex_oid = ".1.3.6.1.2.1.2.2.1.1";

	    include_once(jffnms_shared("catos"));				//Load CatOS code
	    if (is_catos($options["host_ip"], $options["ro_community"]))	//If this host is CatOS
		list($ifDescr_oid) = catos_info(); 				//Get the OID for it
	    else
		$ifDescr_oid = ".1.3.6.1.2.1.2.2.1.2";				//Use the Standard IF-MIB OID
	    	
	    $buffer["ifIndex"] = snmp_walk($options["host_ip"],$options["ro_community"],$ifIndex_oid);
	    $buffer["ifDescr"] = snmp_walk($options["host_ip"],$options["ro_community"],$ifDescr_oid);
	}
	
	if (is_array($buffer["ifDescr"])) {				 	//If ifDescr is an array
	    $pos = array_search($options["interface"],$buffer["ifDescr"]);	//Find the DB interface name and return the index

	    if (is_numeric($pos))						//if we found something
		$current_ifindex = $buffer["ifIndex"][$pos];			//return the ifIndex at the same position we found this
	}
	
    } else //Search by IP Address
	if (strpos($options["address"],".")==false) { 	// if the address is not an IP, use that as the IfIndex
		$current_ifindex = $options["address"];
	} else 											//If its an IP Address
	    if (!empty($options["ro_community"]))						//and has SNMP
		$current_ifindex = snmp_get($options["host_ip"],$options["ro_community"], 	//Get the interface index
		    ".1.3.6.1.2.1.4.20.1.2.".$options["address"]); 			 	//by looking up the IP
		
    return $current_ifindex;
}

?>
