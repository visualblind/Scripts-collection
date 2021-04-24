<?
/* Livingston Portmaster Serial Port Discovery. This file is part of JFFNMS
 * Copyright (C) <2004> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

	function discovery_livingston_serial_port ($ip, $rocommunity, $hostid, $param) {

		$oid = ".1.3.6.1.4.1.307.3.2.1.1.1.8";
	
		$interface = array();
		$number = 0;

		if ($ip && $hostid && $rocommunity) {
			$state = snmp_walk($ip, $rocommunity, $oid);
			$number = count($state);

			//Remove two : one failed and one console
			$number --;

			if  ( $number > 0 ) {
				$interface[1]["description"] = "AS $ip";
				$interface[1]["interface"] = "Serial lines";
				$interface[1]["oper"] = "up";
				$interface[1]["admin"] = "ok";
				$interface[1]["interface_number"] = $number;
			}
		}
		
		return $interface;
	}
?>
