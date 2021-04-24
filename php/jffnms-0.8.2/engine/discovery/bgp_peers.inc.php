<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function discovery_bgp_peers ($ip,$rocommunity,$hostid,$param) {

	    $bgp_interfaces = array();

	    if ($ip && $hostid && $rocommunity)  
		$ifIndex = snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.15.3.1.1"); //bgp.bgpPeerTable.bgpPeerEntry.bgpPeerIdentifier
	    
	    if (count($ifIndex) > 0) {
		$ifLocal = snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.15.3.1.5");
		$ifRemote = snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.15.3.1.7");
		$ifOperStatus = snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.15.3.1.2");
		$ifRemoteAS = snmp_walk($ip,$rocommunity,".1.3.6.1.2.1.15.3.1.9");

		for ($i=0; $i < count($ifIndex) ; $i++) if ($ifIndex[$i]) {
		    list($ifOperStatus[$i]) = explode("(",$ifOperStatus[$i]);
		
		    switch ($ifOperStatus[$i]) {
			case 1: $OperStatus[$i] = "down"; break;
			case 3: $OperStatus[$i] = "down"; break; //active
			case 6: $OperStatus[$i] = "up"; break;
		    }
		    
		    $ifRemote[$i] = trim($ifRemote[$i]); 
    
		    $bgp_interfaces[$ifRemote[$i]]= array(
			"local"=>trim($ifLocal[$i]),
			"asn"=>"AS ".$ifRemoteAS[$i],
			"interface"=>$ifRemote[$i],
			"oper"=> $OperStatus[$i]
		    );
		}
	    }

	    return $bgp_interfaces;
    }
?>
