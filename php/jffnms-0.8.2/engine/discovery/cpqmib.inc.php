<?php
/* Compaq Insight Discovery. This file is part of JFFNMS
 * Copyright (C) <2004> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

DEFINE( phydrv ,'.1.3.6.1.4.1.232.3.2.5.1.1.');
DEFINE( fans, '.1.3.6.1.4.1.232.6.2.6.7.1.');
DEFINE( temp, '.1.3.6.1.4.1.232.6.2.6.8.1.');
function discovery_cpqmib ($ip, $rocommunity, $hostid, $param)
{
	$disc_type = $param;
	$interfaces = array();

	if (empty($ip) || empty($rocommunity) || empty($param)) {
		return $interfaces;
	}
	
	$ifnum=1;
	switch($disc_type) {
		case 'phydrv':
			$controllers = snmp_walk($ip, $rocommunity, phydrv.'1');

			if (is_array($controllers)) {
			
			    $drvindex = snmp_walk($ip, $rocommunity, phydrv.'2');
			    $model = snmp_walk($ip, $rocommunity, phydrv.'3');
			    $status = snmp_walk($ip, $rocommunity, phydrv.'6');
			
			    foreach($controllers as $key => $ctl) {
				$interfaces[$ifnum++] = array(
					'interface' => "Disk$ctl/$drvindex[$key]",
					'controller' => $ctl,
					'drvindex' => $drvindex[$key],
					'model' => $model[$key],
					'oper' => $status[$key]==2?'up':'down',
				);
			    }
			}
			break;
		case 'fans':
			$chassis = snmp_walk($ip, $rocommunity, fans.'1');

			if (is_array($chassis)) {
			    $fanindex = snmp_walk($ip, $rocommunity, fans.'2');
			    $location = snmp_walk($ip, $rocommunity, fans.'3');
			    $present = snmp_walk($ip, $rocommunity, fans.'4');
			    $condition = snmp_walk($ip, $rocommunity, fans.'9');

			    foreach($chassis as $key => $cha) {
				$locname = get_fan_location($location[$key]);
				$interfaces[$ifnum++] = array(
					'interface' => "Fan$cha/$fanindex[$key]" ,
					'chassis' => $cha,
					'fanindex' => $fanindex[$key],
					'location' => $locname,
					'admin' => $present[$key]==3?'up':'down',
					'oper' => $condition[$key]==2?'up':'down',
				);
			    }
			}
			break;
		case 'temperature':
			$chassis = snmp_walk($ip, $rocommunity, temp.'1');

			if (is_array($chassis)) {
			    $tempindex = snmp_walk($ip, $rocommunity, temp.'2');
			    $location = snmp_walk($ip, $rocommunity, temp.'3');
			    $condition = snmp_walk($ip, $rocommunity, temp.'6');
			
			    foreach($chassis as $key => $cha) {
				$interfaces[$ifnum++] = array(
					'interface' => "Temperature$cha/$tempindex[$key]",
					'chassis' => $cha,
					'tempindex' => $tempindex[$key],
					'location' => get_fan_location($location[$key]),
					'admin' => 'up',
					'oper' => $condition[$key]==2?'up':'down',
				);
			    }
			}
			break;
	} // switch

	return $interfaces;
}

function get_fan_location($locid)
{
	$locations = array (
		1 => 'other', 2 => 'unknown', 3 => 'system', 
		4 => 'system board', 5 => 'io board', 6 => 'cpu',
		7 => 'memory', 8 => 'storage', 9 => 'removeable media',
		10 => 'power supply', 11 => 'ambient', 12 => 'chassis',
		13 => 'bridge card',
	);
	if (array_key_exists($locid, $locations )) {
		return $locations[$locid];
	} else {
		return "Unknown $locid";
	}
}
