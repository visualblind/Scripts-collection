<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_apc ($ip,$rocommunity,$hostid,$param) { 
	
	$apc = array();
	
	list ($apc_oid) = explode(",",$param);

	if ($ip && $hostid && $rocommunity) {
    	    $system_oid = @current(snmp_walk($ip, $rocommunity, ".1.3.6.1.2.1.1.2")); // system.sysObjectID

	    if (strpos($system_oid,$apc_oid)!==false) {
		$aux = array();
		
		$apcmib = ".1.3.6.1.4.1.318.1.1.1.";
		
		$name_oid	= $apcmib."1.1.2.0";
		$model_oid 	= $apcmib."1.1.1.0";
		$status_oid 	= $apcmib."2.1.1.0";
				
		$name 		= trim(snmp_get($ip,$rocommunity,$name_oid));
		$model		= snmp_get($ip,$rocommunity,$model_oid);
		$status		= snmp_get($ip,$rocommunity,$status_oid);

		$battery_status = array (1=>"bettery unknown", 2=>"battery normal", 3=>"battery low");

		if (!empty($name) && !empty($model) && !empty($status)) {
			
		    $aux = array();
		    $aux["interface"] = $model;
		    $aux["description"] = $name;
			    
		    $aux["admin"] = "up";
    		    $aux["oper"] = $battery_status[$status];
			
		    $apc[1]=$aux;
    		}
	    }
	} 

        return $apc;
    } 
?>
