<? 
/* This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_ups ($ip,$rocommunity,$hostid,$param) { 
	
	$ups = array();
	$UPSMIB = ".1.3.6.1.2.1.33"; //SNMPv2-SMI::mib-2.33
	$upsIdentName_oid = $UPSMIB.".1.1.5.0"; //UPS-MIB::upsIdentName.0
	$upsBatteryStatus_oid = $UPSMIB.".1.2.1.0"; //UPS-MIB::upsBatteryStatus.0
	$battery_status = array (1=>"battery unknown", 2=>"battery normal", 3=>"battery low", 4=>"batter depleted");
	
	if (!empty($ip) && !empty($rocommunity)) {
	    
    	    $upsIdentName = snmp_get($ip, $rocommunity, $upsIdentName_oid);

	    if ($upsIdentName!==false) {

		$upsBatteryStatus = snmp_get($ip, $rocommunity, $upsBatteryStatus_oid);

		if (!empty($upsIdentName) && !empty($upsBatteryStatus))
		    $ups[1] = array(
			    "interface"=>"UPS",
			    "ident"=>$upsIdentName,
			    "admin"=>"ok",
			    "oper"=>$battery_status[$upsBatteryStatus]
			);
	    }
	}

        return $ups;
    } 
?>
