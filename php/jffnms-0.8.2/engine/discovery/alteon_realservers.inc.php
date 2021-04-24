<?php
/* Alteon Switch Load Balancing Real Servers. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// switch is .1.3.6.1.4.1.1872.2.1
// stats is 8
// info is 9
// .1.3.6.1.4.1.1872.2.1.5.2.1 is cfgreal
define(CfgRealServerIndex, '.1.3.6.1.4.1.1872.2.1.5.2.1.1');
define(CfgRealServerIpAddr, '.1.3.6.1.4.1.1872.2.1.5.2.1.2');
define(CfgRealServerMaxConns, '.1.3.6.1.4.1.1872.2.1.5.2.1.4');
define(CfgRealServerState, '.1.3.6.1.4.1.1872.2.1.5.2.1.10');
define(CfgRealServerName, '.1.3.6.1.4.1.1872.2.1.5.2.1.12');

define(slbRealServerInfoState, '.1.3.6.1.4.1.1872.2.1.9.2.2.1.7');


function discovery_alteon_realservers($ip, $community, $hostid, $param) {
    $server_type=$param;

	$interfaces = array();

	if ($ip && $community && $hostid) {
        $indexes = snmp_walk($ip, $community, CfgRealServerIndex);
        // Die Quickly if no index
        if ($indexes === FALSE) return FALSE;
        $ipaddrs = snmp_walk($ip, $community, CfgRealServerIpAddr);
        $adminstates = snmp_walk($ip, $community, CfgRealServerState);
        $servernames = snmp_walk($ip, $community, CfgRealServerName);
        $operstates = snmp_walk($ip, $community, slbRealServerInfoState);
        $maxconns = snmp_walk($ip, $community, CfgRealServerMaxConns);

        if ($indexes !== FALSE) {
            foreach($indexes as $index) {
                $idx = $index-1;
                if (!isset($ipaddrs["$idx"])) 
                    $ipaddress="";
                else
                    list($dummy, $ipaddress) = explode(':', $ipaddrs["$idx"]);
                $ipaddress = trim($ipaddress);
                if (!isset($servernames["$idx"])) $servernames["$idx"] = '';
                if (!isset($maxconns["$idx"])) $maxconns["$idx"] = '20001';
                if (isset($adminstates["$idx"]) && $adminstates["$idx"] == '2') {
                    $admin = 'up';
                } else {
                    $admin = 'down';
                }
                if (isset($operstates["$idx"]) && $operstates["$idx"] == '2') {
                    $oper = 'up';
                } else {
                    $oper = 'down';
                }
                $interfaces["$index"] = array (
                    'interface' => $ipaddress,
                    'real_server' => $index,
                    'address' => $ipaddress,
                    'admin' => $admin,
                    'oper' => $oper,
                    'hostname' => $servernames["$idx"],
                    'max_connections' => $maxconns["$idx"],
                );
            }
        }
    }

	//var_dump($interfaces);
	return $interfaces;
}
// vim:et:sw=4:ts=4:
?>
