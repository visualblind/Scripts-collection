<?
/* Cisco Serial (Async) Port Discovery. This file is part of JFFNMS
 * Copyright (C) <2005> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function discovery_cisco_serial_port ($ip, $rocommunity, $hostid, $param) {

	$oid = ".1.3.6.1.4.1.9.2.2.1.1.1";

	$interface = array();

	if ($ip && $hostid && $rocommunity) {
		$state = snmp_walk($ip, $rocommunity, $oid);

		$number = 0;
		if (is_array($state))
		foreach ($state as $line)
		    if(strstr($line,"Async Serial"))
			$number++;

		if  ( $number > 0 ) {
			$interface[1]["description"] = "AS $ip";
			$interface[1]["interface"] = "Cisco Dialup Usage";
			$interface[1]["oper"] = "up";
			$interface[1]["admin"] = "ok";
			$interface[1]["nb_async_line"] = $number;
		}

	}

	return $interface;
}

?>
