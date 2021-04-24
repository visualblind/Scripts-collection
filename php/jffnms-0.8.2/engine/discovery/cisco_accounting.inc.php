<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function discovery_cisco_accounting ($ip,$rocommunity,$hostid,$param) {
	    $accounting = array();
	    $mac_accounting_oid = ".1.3.6.1.4.1.9.9.84.1.2.1.1.3";
	    $netToMedia_oid = ".1.3.6.1.2.1.4.22.1.2";
	    $bgpRemote_oid = ".1.3.6.1.2.1.15.3.1.7";
	    $bgpAS_oid = ".1.3.6.1.2.1.15.3.1.9";

	    if ($ip && $hostid && $rocommunity)  
		$mac = snmp_walk($ip,$rocommunity,$mac_accounting_oid,1); 
	    
	    if (is_array($mac)) {
		$netToMedia = snmp_walk($ip,$rocommunity,$netToMedia_oid,1); 
		$bgpRemote =  snmp_walk($ip,$rocommunity,$bgpRemote_oid,1);
		
		while (list ($oid,) = each ($mac)) {

		    unset ($ip_aux);
		    unset($ip_addr);
		    unset($asn);
		    unset ($mac_hex2);
		    unset ($sum);
		    unset($mac_hex);
		    
		    $aux = explode(".",$oid);
		    $ifIndex = $aux[9];
		    $direction = $aux[10];

		    $mac_array = array_slice($aux,11,16);
		    $mac_addr_dec = join(".",$mac_array);
		    
		    foreach ($mac_array as $part) $mac_hex[] = str_pad(dechex($part),2,"0",STR_PAD_LEFT);
		    $mac_addr_hex1 = strtoupper(@join(":",$mac_hex));
		
		    foreach ($mac_array as $part) {
			$aux = dechex($part);
			$mac_hex2[] = $aux; 
			$sum += (int)$aux;
		    }
		    $mac_addr_hex2 = @join(":",$mac_hex2);
	
		    if (!$accounting[$sum]) { //if we dont already have this MAC address
			//Get  Interface Name
			$interface = substr(snmp_hex_to_string(snmp_get($ip,$rocommunity,".1.3.6.1.2.1.2.2.1.2.$ifIndex")),0,30);
		    
			//get IP Address
			$ip_aux = array_search($mac_addr_hex2,$netToMedia);
		    }

		    if ($ip_aux) { //if has an ip address;
		
			unset($netToMedia[$ip_aux]); //delete it so we have only one ip address per mac
			
			$ip_addr = join(".",array_slice(explode(".",$ip_aux),-4));
	
			//GET BGP ASN if Any
			if ($as_aux = array_search("IpAddress: $ip_addr",$bgpRemote))
			    $asn = snmp_get($ip,$rocommunity,$bgpAS_oid.".".join(".",array_slice(explode(".",$as_aux),-4)));
			else 
			    $asn = "";
		    	    
			//debug ("IfIndex $ifIndex, Interface $interface, Direction $direction, "
			//	."MAC: DEC: $mac_addr_dec HEX: $mac_addr_hex HEX1: $mac_addr_hex1 HEX2: $mac_addr_hex2, IP: $ip_addr, ASN: $asn"); 
	
			if ($asn) $asn = "AS $asn";

	    	        $aux1["address"] = $ip_addr;
			$aux1["mac"] = $mac_addr_dec;
			$aux1["ifindex"] = $ifIndex;

			$aux1["description"] = "MAC $mac_addr_hex1 $asn";
			$aux1["interface"] = $interface.":$sum";
			$aux1["oper"] = "up";
		    
			$accounting[$sum]=$aux1;
		    }
		}
	    }
	    return $accounting;
    }

?>
