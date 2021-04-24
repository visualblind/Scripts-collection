<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function discovery_snmp_interfaces($ip,$rocommunity,$hostid,$param) {

	    $ifAux = array();
	    $snmp_interfaces = array();

	    list($host_ip) = explode(":",$ip); 		//remove :port from IP
	    $host_ip = gethostbyname ($host_ip);	//try to resolve it, this is just to check there is an IP

	    if ((ip2long($host_ip)!==-1) && !empty($hostid) && !empty($rocommunity))  
		$ifIndex 	= snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.2.2.1.1");

	    if (is_array($ifIndex) && (count($ifIndex) > 0)) {
		
		// Exceptions
		include_once(jffnms_shared("catos"));	//Load the CatOS Functions
		include_once(jffnms_shared("webos"));	//Load the WebOS Functions

		if (is_catos($ip, $rocommunity)) 	// Check if its CatOS
		    list ($ifDescr_oid, $ifAlias) = catos_info($ip, $rocommunity, $ifIndex); //Get the CatOS Information

		elseif (is_webos($ip, $rocommunity)) 	// Check if its WebOS
		    list($ifDescr,$ifAlias) = webos_info($ip, $rocommunity, $ifIndex);

		else { 					//Normal IF-MIB oids
		    $ifDescr_oid = ".1.3.6.1.2.1.2.2.1.2";
		    $ifAlias_oid = ".1.3.6.1.2.1.31.1.1.1.18";
		}

		// Get all the data via SNMP	
		if (!empty($ifDescr_oid))	$ifDescr = snmp_walk($ip,$rocommunity,$ifDescr_oid);
		if (!empty($ifAlias_oid))	$ifAlias = snmp_walk($ip,$rocommunity,$ifAlias_oid);
		
		$ifAdminStatus 	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.2.2.1.7");
		$ifOperStatus 	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.2.2.1.8");
	
		$ifSpeed 	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.2.2.1.5");
	
		$ipAddEntIP 	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.4.20.1.1");
		$ipAddifIndex	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.4.20.1.2");
		$ipAddMask 	= snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.4.20.1.3");
		
	        if (!is_array($ipAddifIndex)) $ipAddifIndex = array();

		for ($i=0; $i < count($ifIndex) ; $i++) if ($ifIndex[$i]) {

		    $ipPos = array_search($ifIndex[$i],$ipAddifIndex); //Find FIRST the pos where this ifIndex has an IP

		    if ($ipPos !== false) {		//we Found some IPs for this interface index

		        $ifAddr[$i] = $ipAddEntIP[$ipPos]; //Get the IP from that Pos

		        $ifAddrMask[$i] = $ipAddMask[$ipPos]; //Get the Mask from that Pos
	
			if (strpos($ifAddr[$i],".") > 0) { //IP Address for peer
			    $aux = explode(".",$ifAddr[$i]);
			    
			    if ($aux[3]%2) 
				$aux[3]++; //if it's even, then peer is next one
			    else 
				if ($aux[3]>0) 
				    $aux[3]--; //if its not and grater than 0 peer is previous one

			    $peerAddr[$i] = implode(".",$aux);
			}
		    }
		    $ifSpeed[$i] = round($ifSpeed[$i]/1000);

		    //Process MIB Status Values    
		    if (is_numeric($ifAdminStatus[$i]))
			switch ($ifAdminStatus[$i]) {
			    case "1": $ifAdminStatus[$i] = "up"; break;
			    case "2": $ifAdminStatus[$i] = "down"; break;
			    case "3": $ifAdminStatus[$i] = "testing"; break;
			}
		    else
			list($ifAdminStatus[$i]) = explode("(",$ifAdminStatus[$i]);
		
		    if (is_numeric($ifOperStatus[$i]))
			switch ($ifOperStatus[$i]) {
			    case "1": $ifOperStatus[$i] = "up"; break;
			    case "2": $ifOperStatus[$i] = "down"; break;
			    case "3": $ifOperStatus[$i] = "testing"; break;
			}
		    else
			list($ifOperStatus[$i]) = explode("(",$ifOperStatus[$i]);
		    
		    $aux1 = array();
		    
		    //FIXME This is only for cisco to discard Atm9/1/0.2-aal5 layer, and FastEthernet4/0/0.1-ISL vLAN s after the dash
		    if ((strpos($ifDescr[$i],"-aal5") > 0) ||
			(strpos($ifDescr[$i],"-ISL") > 0) ||
			(strpos($ifDescr[$i],"-802.1Q") > 0))
			    $ifDescr[$i] = substr($ifDescr[$i],0,strpos($ifDescr[$i],"-"));

		    if (get_config_option("os_type")=="windows") $ifDescr[$i]=str_replace("\"","",$ifDescr[$i]); //FIXME
		    
                    if (!isset($ifAddr[$i])) $ifAddr[$i]="";
	    	    $aux1["address"] = $ifAddr[$i]; 

                    if (!isset($ifAddrMask[$i])) $ifAddrMask[$i]="";
	    	    $aux1["mask"] = $ifAddrMask[$i]; 
                    
		    if (!isset($peerAddr[$i])) $peerAddr[$i]="";
		    $aux1["peer"] = $peerAddr[$i]; 
                    
		    if (!isset($ifAlias[$i])) $ifAlias[$i]="";
		    
		    $aux1["description"] = $ifAlias[$i];
		    $aux1["description"] = str_replace("\"","",$aux1["description"]);  //Strip Quotes FIXME
		    $aux1["description"] = str_replace("'","", $aux1["description"]);  //Strip Quotes FIXME
		    
		    $aux1["interface"] = substr(snmp_hex_to_string($ifDescr[$i]),0,30); 
		    $aux1["interface"] = str_replace("'","", $aux1["interface"]);  //Strip Quotes for PIX

		    if ($ifSpeed[$i] == 0) $ifSpeed[$i] = 128; //default Speed Value
		    $aux1["bandwidthin"] = $ifSpeed[$i]*1000; 
		    $aux1["bandwidthout"] = $ifSpeed[$i]*1000; 
		
		    $aux1["admin"] = $ifAdminStatus[$i]; 
		    $aux1["oper"] = $ifOperStatus[$i];

                    // Juniper Fixes
                    // Because Juniper Creates one new interface per L3 stack on each L2 interface
                    // So we have to merge them

                    //if the before-end char is . (like in t1-1/0/1:6.0) and the description is not set
                    if ((substr($aux1["interface"],-2,1)==".") && (empty($aux1["description"]))) {
                        $int = substr($aux1["interface"],0,strlen($aux1["interface"])-2); //get the real interface name before the dot

                        if (!empty($interface_names[$int])) { //if its already loaded in the list
                            $old_id = $interface_names[$int];

                            $aux2=$snmp_interfaces[$old_id];

                            $aux2["address"]=$aux1["address"];
                            $aux2["peer"]=$aux1["peer"];
                            $aux1 = $aux2;

                            unset ($aux2);
                            unset ($snmp_interfaces[$old_id]);
			    unset ($old_id);
			}
			unset ($int);

                    } else
                        $interface_names[$aux1["interface"]]=$ifIndex[$i];

		    if (!empty($aux1["interface"])) //check for the interface name, if its ok, add the interface to the list
			$snmp_interfaces[$ifIndex[$i]]= $aux1;
		}
	    }
	    unset ($interface_names);
	    unset ($aux1);

	    return $snmp_interfaces;
    }
?>
