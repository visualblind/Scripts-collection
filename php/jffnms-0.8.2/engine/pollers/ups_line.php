<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function poller_ups_line ($options) {
	
    	$UPSMIB = ".1.3.6.1.2.1.33"; //SNMPv2-SMI::mib-2.33

	$upsInputs  = $UPSMIB.".1.3.3.1"; //UPS-MIB::upsInputEntry
	$upsOutputs = $UPSMIB.".1.4.4.1"; //UPS-MIB::upsOutputEntry
    
	$upsInputsIndex = $upsInputs.".1";   //UPS-MIB::upsInputLineIndex
	$upsOutputsIndex = $upsOutputs.".1"; //UPS-MIB::upsOutputLineIndex

	$upsInputVoltage  = $upsInputs.".3";  //UPS-MIB::upsInputVoltage
	$upsOutputVoltage = $upsOutputs.".2"; //UPS-MIB::upsOutputVoltage

	$upsInputCurrent  = $upsInputs.".4";  //UPS-MIB::upsInputCurrent
	$upsOutputCurrent = $upsOutputs.".3"; //UPS-MIB::upsOutputCurrent

	$upsOutputLoad = $upsOutputs.".5"; //UPS-MIB::upsOutputLoad

	$input = ($options["line_type"]=="INPUT")?true:false;
	
        switch ($options["poller_name"]) {
	    case "voltage":  $oid = ($input)?$upsInputVoltage:$upsOutputVoltage; break;
	    case "current":  $oid = ($input)?$upsInputCurrent:$upsOutputCurrent; break;
	    case "load"   :  $oid = ($input)?false:$upsOutputLoad; break;
	}
	
	if (!empty($oid)) { 
	    $oid .= ".".$options["line_index"];
	    
	    $value = snmp_get($options["host_ip"], $options["ro_community"], $oid);
	} 
	
	return $value;
}

?>
