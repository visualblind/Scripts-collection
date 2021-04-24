<?
/* Livingston Portmaster Serial Port Status. This file is part of JFFNMS
 * Copyright (C) <2004> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

	function poller_livingston_serial_port_status ($options) {
		global $pm3;
		
		$option = $options["poller_parameters"];

		// idle			1
		// connecting		2
		// established		3
		// disconnecting	4
		// command		5
		// noservice		6

		$oid_activity	= ".1.3.6.1.4.1.307.3.2.1.1.1.8";
		$oid_name	= ".1.3.6.1.4.1.307.3.2.1.1.1.2";

		if (!is_array($pm3["lines"]))
		    $pm3["lines"] = snmp_walk($options["host_ip"],$options["ro_community"],$oid_activity);

		if (!is_array($pm3["names"]))
		    $pm3["names"] = snmp_walk($options["host_ip"],$options["ro_community"],$oid_name);
		
		$lines = $pm3["lines"];
		$names = $pm3["names"];
		
		$total_ports = 0;
		$selected_ports = 0;
		
		if (is_array($lines))
		foreach ( $lines as $line ) {
			if ( $line == $option and (strpos($names[$total_ports],"S") !== false) )
				$selected_ports ++;

			//echo "line: $line, name: ".$names[$total_ports].", looking: $option, ports: $total_ports, sel: $selected_ports\n";

			$total_ports ++;
		}

		// debug($selected_ports);
		return $selected_ports;
	}
?>
