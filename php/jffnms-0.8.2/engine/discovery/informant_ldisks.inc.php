<?
/* SNMP Informant lDisk Discovery. This file is part of JFFNMS.
 * Copyright (C) <2005> David LIMA <dlima@fr.scc.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
*/

    function discovery_informant_ldisks($ip, $community, $hostid, $param) {
	
	$interfaces = array();
	
	$SNMP_INFORMAT_MIB = ".1.3.6.1.4.1.9600.1.1";
	$lDiskEntry_oid = $SNMP_INFORMAT_MIB.".1.1.1.2";

        if ($ip && $community && $hostid) {
	
	    $DisksEntries = snmp_walk($ip, $community, $lDiskEntry_oid, true);
	    
	     if (is_array($DisksEntries))
		foreach ($DisksEntries as $oid=>$interface) {

		    $index = join(".",array_slice(explode(".",$oid),7));
		    
		    $interfaces[$index] = array (
			'interface' => $interface." Stats",
			'oper' => "up"
		    );
		}
	    else
		return false;
	}

    	return $interfaces;
    }
?>
