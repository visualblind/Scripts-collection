<?php
/* Alteon Switch Load Balancing Virt Servers. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// switch is .1.3.6.1.4.1.1872.2.1
// stats is 8
// info is 9
// .1.3.6.1.4.1.1872.2.1.5.2.1 is cfgreal
define(CfgVirtServerIndex, '.1.3.6.1.4.1.1872.2.1.5.5.1.1');
define(CfgVirtServerIpAddress, '.1.3.6.1.4.1.1872.2.1.5.5.1.2');
define(CfgVirtServerState, '.1.3.6.1.4.1.1872.2.1.5.5.1.4');
define(CfgVirtServerDname, '.1.3.6.1.4.1.1872.2.1.5.5.1.5');
define(CfgVirtServiceHname, '.1.3.6.1.4.1.1872.2.1.5.7.1.8');


function discovery_alteon_virtualservers($ip, $community, $hostid, $param) {
    $server_type=$param;

	$interfaces = array();

	if ($ip && $community && $hostid) {
        $indexes = snmp_walk($ip, $community, CfgVirtServerIndex);
        // Die Quickly if no index
        if ($indexes === FALSE) return FALSE;
        $ipaddrs = snmp_walk($ip, $community, CfgVirtServerIpAddress);
        $adminstates = snmp_walk($ip, $community, CfgVirtServerState);
        $serverdnames = snmp_walk($ip, $community, CfgVirtServerDname);
        if ($indexes !== FALSE) {
            foreach($indexes as $key => $index) {
                if (!isset($ipaddrs["$key"])) 
                    $ipaddress="";
                else
                    list($dummy, $ipaddress) = explode(':', $ipaddrs["$key"]);
                $ipaddress = trim($ipaddress);
                if (empty($serverdnames["$key"])) {
                    $servername = 'unknown';
                } else {
                    $service_hnames = snmp_walk($ip, $community,CfgVirtServiceHname.".$index" );
                    if (!empty($service_hnames[0])) {
                        $servername = "$service_hnames[0].$serverdnames[$key]";
                    } else {
                        $servername = $serverdnames["$key"];
                    }
                }
                if (isset($adminstates["$key"]) && $adminstates["$key"] == '2') {
                    $admin = 'up';
                } else {
                    $admin = 'down';
                }
                $interfaces["$index"] = array (
                    'interface' => $ipaddress,
                    'hostname' => $servername,
                    'address' => $ipaddress,
                    'admin' => $admin,
                    'oper' => 'up', //Always up if switch is alive
                );
            }
        }
    }

	//var_dump($interfaces);
	return $interfaces;
}
// vim:et:sw=4:ts=4:
?>
