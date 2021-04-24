<? 
/* This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_ups_lines ($ip,$rocommunity,$hostid,$param) { 
	
	$ups_lines = array();
	$UPSMIB = ".1.3.6.1.2.1.33"; //SNMPv2-SMI::mib-2.33

	$upsInputs  = $UPSMIB.".1.3.3.1"; //UPS-MIB::upsInputEntry
	$upsOutputs = $UPSMIB.".1.4.4.1"; //UPS-MIB::upsOutputEntry
    
	$upsInputsIndex = $upsInputs.".1"; //UPS-MIB::upsInputLineIndex
	$upsOutputsIndex = $upsOutputs.".1"; //UPS-MIB::upsOutputLineIndex
	
	if (!empty($ip) && !empty($rocommunity)) {
	    
    	    $upsInputLines  = snmp_walk($ip, $rocommunity, $upsInputsIndex);
    	    $upsOutputLines = snmp_walk($ip, $rocommunity, $upsOutputsIndex);

	    if (is_array($upsInputLines) && is_array($upsOutputLines)) {
		
		foreach ($upsInputLines as $index) 
		    $ups_lines[10+$index] = array(
			"interface"=>"Input Line ".$index,
			"line_type"=>"INPUT",
			"line_index"=>$index,
			"admin"=>"up", "oper"=>"up"
		    );

		foreach ($upsOutputLines as $index) 
		    $ups_lines[20+$index] = array(
			"interface"=>"Output Line ".$index,
			"line_type"=>"OUTPUT",
			"line_index"=>$index,
			"admin"=>"up", "oper"=>"up"
		    );
	    }
	}

        return $ups_lines;
    } 
?>
