<?
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * Copyright (C) <2002-2005> Modifications by Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_storage($ip,$rocommunity,$hostid,$param) {

	$storage_devices = array();

	if ($ip && $hostid && $rocommunity)  
	    $deviceIndex = snmp_walk("$ip","$rocommunity",".1.3.6.1.2.1.25.2.3.1.1");
    
	if (count($deviceIndex) > 0) {

	    $deviceDescription 	= snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.25.2.3.1.3");
	    $deviceType 	= snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.25.2.3.1.2");
	    $deviceBlockSize 	= snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.25.2.3.1.4");
	    $deviceBlockCount 	= snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.25.2.3.1.5");
	    
   	    for ($i=0; $i < count($deviceIndex) ; $i++) 
		if ($deviceIndex[$i]) {
		    
		    $devInfo = array();
		    $aux1 = array();
		    
		    //Device Type
		    if (isset($deviceType[$i])) {
			$device_type_ok = false;
			
			if (strpos ($deviceType[$i],".hrStorage")!==FALSE) { //UCD-SNMP
			    $aux1 = explode(".hrStorage",$deviceType[$i]);
			    if (isset($aux1[count($aux1) - 1])) $deviceType[$i] = $aux1[count($aux1) - 1];
			    $device_type_ok = true;
			}
		    
			if (strpos ($deviceType[$i],"::hrStorage")!==FALSE) { //NET-SNMP
			    $aux1 = explode ("::",$deviceType[$i]);
			    $deviceType[$i] = str_replace("hrStorage","",$aux1[count($aux1)-1]);
			    $device_type_ok = true;
			}

			if ($device_type_ok==false) { //if we didnt get the name in the OID, use the RFC/MIB Values
			    $aux1 = explode (".", $deviceType[$i]);
			    $device_type_id = current(array_reverse($aux1)); //get the last value of the OID
			    switch ($device_type_id) {
				case "1" :	$deviceType[$i]="Other"; $device_type_ok = true; break;	
				case "2" :	$deviceType[$i]="Ram"; $device_type_ok = true; break;	
				case "3" :	$deviceType[$i]="VirtualMemory"; $device_type_ok = true; break;	
				case "4" :	$deviceType[$i]="FixedDisk"; $device_type_ok = true; break;	
				case "5" :	$deviceType[$i]="RemovableDisk"; $device_type_ok = true; break;	
				case "6" :	$deviceType[$i]="FloppyDisk"; $device_type_ok = true; break;	
				case "7" :	$deviceType[$i]="CompactDisk"; $device_type_ok = true; break;	
				case "8" :	$deviceType[$i]="RamDisk"; $device_type_ok = true; break;	
			    }
			}
			
			if ($device_type_ok==false) unset ($deviceType[$i]); //if we could find a type description, don't show it

		        unset ($aux1);
			unset ($device_type_ok);
		    }

		    list($deviceBlockSize[$i], $aux) = explode(" ", $deviceBlockSize[$i]);
		    
        	    if (isset($deviceType[$i])) 
			$devInfo["storage_type"] = $deviceType[$i];
    		    
		    if (isset($deviceBlockSize[$i]) && isset($deviceBlockCount[$i])) 
			$devInfo["size"] = $deviceBlockSize[$i] * $deviceBlockCount[$i];

		    $label_hex = strpos($deviceDescription[$i],"Hex");
		    if ($label_hex!==FALSE)   //UCD-SNMP 4.2.4 fix
		        $deviceDescription[$i] = substr($deviceDescription[$i],0,$label_hex-1);
		    
		    $deviceDescription[$i]  = str_replace("\"","",$deviceDescription[$i]);  //UCD-SNMP 4.2.4 fix
		    $deviceDescription[$i]  = str_replace("\\","",$deviceDescription[$i]); //Windows Hack for C:\ breaking the DB

		    //Windows XP Disk Label Hack
		    $label_pos = strpos($deviceDescription[$i],"Label");
		    if ($label_pos!==FALSE) {  
		        $devInfo["interface"] = substr($deviceDescription[$i],0,$label_pos-1); //strip the \ and the space
		        $devInfo["description"] = substr($deviceDescription[$i],$label_pos,strlen($deviceDescription[$i])-$label_pos);
		    } else 
			$devInfo["interface"] = $deviceDescription[$i];
    	    
		    foreach ($devInfo as $key=>$value) $devInfo[$key]=trim($value);
	
        	    if($devInfo["size"] > 0) {
            		$devInfo["admin"] = "up";
            		$devInfo["oper"] = "up";
            	    } else {
			$devInfo["admin"] = "down";
            		$devInfo["oper"] = "down";
                    }
		    
		    $storage_devices[$deviceIndex[$i]] = $devInfo;
		    //debug ($devInfo);
		}
	}
        //debug($storage_devices);

	return $storage_devices;
    }
?>
