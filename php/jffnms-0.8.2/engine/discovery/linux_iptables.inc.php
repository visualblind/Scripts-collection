<?
/* Linux IPTables (firewall) discovery, part of JFFNMS. Use with the JFFNMS iptables extension.
 * Copyright (C) <2004> Hans Peter Dittler <hpdittler@braintec-consult.de>
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_linux_iptables ($ip,$rocommunity,$hostid,$param) {

	    $linux_iptables = array();
	    $IPT_MIB = $param;

	    if ($ip && $hostid && $rocommunity) 
		$tableIndex = snmp_walk($ip,$rocommunity, $IPT_MIB.".0.0", false, 5);

	    if ((is_array($tableIndex)) && (count($tableIndex) > 0)) {
		
		$tableName 	= snmp_walk ($ip,$rocommunity, $IPT_MIB.".0.1");

		$chainIndex 	= snmp_walk ($ip,$rocommunity, $IPT_MIB.".1.0");
		$chainTableIndex= snmp_walk ($ip,$rocommunity, $IPT_MIB.".1.1");
		
		$chainName 	= snmp_walk ($ip,$rocommunity, $IPT_MIB.".1.2");
		$chainPolicy 	= snmp_walk ($ip,$rocommunity, $IPT_MIB.".1.3");
		
		if (is_array($chainIndex) && is_array($tableName) && is_array($chainTableIndex) && is_array($chainName) && is_array($chainPolicy))
		    
		    foreach ($chainIndex as $pos=>$chain_id) 
			if ($chainPolicy[$pos]!="dynamic") {

			    $chain = $tableName[array_search($chainTableIndex[$pos],$tableIndex)]."/".$chainName[$pos];
			
			    $linux_iptables[$chain_id] = array(
				"interface" => "IPTables ".$chain,
				"policy" => $chainPolicy[$pos],
				"description"=>$chain." Chain",
			        "oper" => "up"
			    );
			}
		//d($linux_iptables);
	    }
	    return $linux_iptables;
    }

// iptables are transmitted in three sepearte tables
// rows in table 0
//  0 - index of table
//  1 - name of table

// rows in table 1
//  0 - index of chain
//  1 - index of table where this chain belongs to
//  2 - name of chain
//  3 - default policy of chain or keyword dynamic for dymacally defined chains

//  4 - packets worked by this chain (not counting LOG) 
//  5 - bytes worked by this chain (not counting LOG) 

//  6 - packets ACCEPTED by this chain 
//  7 - bytes ACCEPTED by this chain 

// rows in table 2
//  0 - index of rule
//  1 - index of chain which contains this rule
//  2 - target of this rule
//  3 - parameters of this rule
//  4 - packets worked by this rule
//  5 - bytes worked by this rule
?>
