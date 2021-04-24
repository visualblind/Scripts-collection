<?
/* Cisco Serial (Async) Port Usage Count. This file is part of JFFNMS
 * Copyright (C) <2005> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function poller_cisco_serial_port_status ($options) {
	global $port_status;

	// 1 : Async
	// 2 : DSX
	// 3 : Free

	$option = $options["poller_parameters"];
	$host_ip = $options["host_ip"];
	$host_ro = $options["ro_community"];

	if (!is_array($port_status["description"]))
		$port_status["description"] = snmp_walk($host_ip, $host_ro, ".1.3.6.1.2.1.2.2.1.2");

	if (!is_array($port_status["admin"]))	
		$port_status["admin"] = snmp_walk($host_ip,$host_ro,".1.3.6.1.2.1.2.2.1.7");
	
	if (!is_array($port_status["operation"]))
		$port_status["operation"] = snmp_walk($host_ip,$host_ro,".1.3.6.1.2.1.2.2.1.8");

	$max = count($port_status["description"]);
	$nb_e1 = 0;

	for ($index=0; $index < $max; $index++) {
		if (strstr($port_status["description"][$index],"E1") or strstr($port_status["description"][$index],"T1")) {
			if (strstr($port_status["admin"][$index],"up") and strstr($port_status["operation"][$index],"up")) {
				$nb_e1 ++;
			}
		}
	}

	if (!is_array($port_status["lines"]))
	    $port_status["lines"] = snmp_walk($host_ip,$host_ro,".1.3.6.1.4.1.9.2.2.1.1.2");

	if (!is_array($port_status["names"]))
	    $port_status["names"] = snmp_walk($host_ip,$host_ro,".1.3.6.1.4.1.9.2.2.1.1.1");
	
	$lines = $port_status["lines"];
	$names = $port_status["names"];
	
	$total_ports = 0;
	$selected_ports = 0;
	$number_ports = 0;
	
	foreach ( $lines as $line ) {
		$is_async = strstr($names[$total_ports],"Async Serial");
		$is_dsx = strstr($names[$total_ports],"DSX1");
			
		if ($is_async)
			$number_ports++;

		if ((int)($lines[$total_ports])) {
			if ($option == 1) {
		       		if ($is_async)
					$selected_ports ++;
			}
			elseif ($option == 2) {
		       		if ($is_dsx)
					$selected_ports ++;
			}
			else {
				if ($is_async or $is_dsx)
					$selected_ports ++;
			}
		}
			
		$total_ports ++;
	}

	if ($option == 2 or $option == 3)
		$selected_ports -= $nb_e1;
	
	if ($option == 3)
		$selected_ports = $number_ports - $selected_ports;

	// debug($selected_ports);
	return $selected_ports;
}

?>
