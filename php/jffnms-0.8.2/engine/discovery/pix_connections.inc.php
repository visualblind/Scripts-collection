<?
/* Cisco PIX Connection Stats MIB implementation as part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_pix_connections ($ip,$community, $host_id, $param) {
         
	$cnx_stats = array();
	
        $cfwConnectionStatEntry = ".1.3.6.1.4.1.9.9.147.1.2.2.2.1";

	$cfwConnectionStatValue = $cfwConnectionStatEntry.".5";
	$cfwConnectionStatDescription = $cfwConnectionStatEntry.".3";

	if ($ip && $community && $host_id) { //check for required values

	    $cnx_values = snmp_walk ($ip, $community, $cfwConnectionStatValue, INCLUDE_OID_2);

	    if (is_array($cnx_values)) {

        	$cnx_descr = snmp_walk ($ip, $community, $cfwConnectionStatDescription, INCLUDE_OID_2);
            
		while (list ($key) = each ($cnx_values))
		    $cnx_stats[$key] = array (
			"interface" => "FW Stat ".$key,
		        "description" => $cnx_descr[$key],
		        "oper" => "up"
		    );
	    }
	}
	return $cnx_stats;
    }
?>
