<?php
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

define(swFCPortPhyState,  '1.3.6.1.4.1.1588.2.1.1.1.6.2.1.3');
    function poller_brocade_fcport_phystate ($options) {

	$community = $options['ro_community'];
	$ip = $options['host_ip'];
	$inst = $options['poller_parameters'];

	if ($ip && $community && $inst) {
		$snmp_value = snmp_get($ip, $community, swFCPortPhyState.".$inst");
		switch ($snmp_value) {
			case 1:
				return 'down|No card present';
			case 2:
				return 'down|No GBIC module';
			case 3:
				return 'down|Laser Fault';
			case 4:
				return 'down|No light received';
			case 5:
				return 'down|Not in sync';
			case 6:
				return 'up|In sync';
			case 7:
				return 'down|Port marked faulty';
			case 8:
				return 'down|Port locked to reference signal';
			default:
				return "down|Unknown status $snmp_value";
		}
	}
	return 'down';
    }

?>
