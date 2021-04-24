<?
/* Simple Discovery script. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_simple ($ip, $rocommunity, $hostid, $param) {
	
	$simple = array();	
    
	if (!empty($rocommunity) && !empty($ip)) {
	    
	    list ($test_oid, $interface_name) = explode (",", $param);

	    $test = snmp_get($ip, $rocommunity, $test_oid);	// query the Test OID

	    if ($test!==false)					// if the OID exists
		$simple[1] = array(				// return a new interface 
		    "interface" => $interface_name,		// with the specified name
		    "oper" => "up"
		);
	}
	
	return $simple;
    }
?>
