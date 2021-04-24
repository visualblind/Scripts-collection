<?
/* Host Information Discovery. This file is part of JFFNMS.
 * Copyright (C) <2002> Robert Bogdon 
 * Copyright (C) <2002-2005> Modifications by Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_host_information ($ip,$rocommunity,$hostid,$param) { 

	$systemMIB_oid   = ".1.3.6.1.2.1.1";
	$sysDescr_oid    = $systemMIB_oid.".1.0";
	$sysObjectID_oid = $systemMIB_oid.".2.0";
	$sysContact_oid  = $systemMIB_oid.".4.0";
	$sysName_oid  	 = $systemMIB_oid.".5.0";
	$sysLocation_oid = $systemMIB_oid.".6.0";
	
	$hrDeviceType_oid = ".1.3.6.1.2.1.25.3.2.1.2";

        $cpu_info = array();

	if ($ip && !empty($rocommunity)) {

	    // Fetch the ObjectID
	    $system_oid = snmp_get($ip, $rocommunity, $sysObjectID_oid);
	    $system_oid = str_replace (".1.3.6.1.4.1","enterprises",$system_oid); //replace OID for enterprises

	    // Check if the ObjectID is in our parameters
	    $found = false;
	    $systems = explode(",",$param);

	    foreach ($systems as $data)
		if (strpos($system_oid,trim($data)) > 1)
		    $found = true;
    
	    // If it was, get all the other information and return an interface
    	    if ($found==true) {
    		
		$description 	= snmp_get ($ip, $rocommunity, $sysDescr_oid);
		$name 		= snmp_get ($ip, $rocommunity, $sysName_oid);
		$contact 	= snmp_get ($ip, $rocommunity, $sysContact_oid);
		$location 	= snmp_get ($ip, $rocommunity, $sysLocation_oid);
		
		// Try to discover the number of CPUs
		$cpus = 0;
		
		$devices = snmp_walk ($ip, $rocommunity, $hrDeviceType_oid);

		if (is_array($devices))
		    foreach ($devices as $device)
			if ((strpos($device, "Processor")!==false) || (strpos($device, "25.3.1.3")!==false))
			    $cpus++;

		if ($cpus==0) 	// if it didn't have any, or it didn't have support for that OID.
		    $cpus = 1;  // we assume it has at least 1 CPU.

		$cpu_info[1] = array(
		    "interface" => "CPU",
		    "oper" 	=> "up",
	    	    "cpu_num" 	=> $cpus,
		    "name" 	=> $name,
		    "location" 	=> $location,
		    "contact" 	=> $contact,
		    "description" => $description,
		);
    	    }
	}
	
        return $cpu_info; 
    }
?>
