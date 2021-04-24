<?
/* Linux TC (traffic control shapper) discovery, part of JFFNMS
 * Copyright (C) <2004> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Use with the JFFNMS tc-snmp program
    
    function discovery_linux_tc ($ip,$rocommunity,$hostid,$param) {

	    $linux_tc = array();
	    $linux_tc_oid = $param;

	    if ($ip && $hostid && $rocommunity)  
		$clIndex = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.0"); 

	    if ((is_array($clIndex)) && (count($clIndex) > 0)) {
		$ifIndex = snmp_walk($ip,$rocommunity,"$linux_tc_oid.0.0");
		$ifNames = snmp_walk($ip,$rocommunity,"$linux_tc_oid.0.1");
		$clInt	 = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.1");
		$clNames = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.2");
		$clQdisc = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.3");
		$clRate  = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.4");
		$clCeil  = snmp_walk($ip,$rocommunity,"$linux_tc_oid.1.5");

		/*	
	    	debug ($ifIndex);
		debug ($ifNames);
		debug ($clIndex);
		debug ($clInt);
		debug ($clNames);
		*/

		if (is_array($ifIndex) && is_array($ifNames) && is_array($clInt) && is_array($clNames) && 
		    is_array($clQdisc) && is_array($clRate) && is_array($clCeil))
		foreach ($clIndex as $pos=>$index) { 
		    $aux1 = array();
		    
		    $aux1["interface"] = $ifNames[array_search($clInt[$pos],$ifIndex)]."/".$clNames[$pos];
		    $aux1["interface"] = str_replace ("\"","",$aux1["interface"]); //clean posible quotes, happens in windows
		    
		    $aux1["description"] = "TC ".str_replace("\"","",$clQdisc[$pos]);

		    $aux1["rate"] = $clRate[$pos];
		    $aux1["ceil"] = $clCeil[$pos];
		
		    $aux1["oper"] = "up";

		    $linux_tc[$index]= $aux1;
		    unset($aux1);
		}
	    }
	    return $linux_tc;
    }
?>
