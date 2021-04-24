<?php
/* Generic snmp status poller. This file is part of JFFNMS
 * Copyright (C) <2004> Craig Small <csmall@small.dropbear.id.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

/*
 * parameters: <oid>|<val1>=<ret1>,<val2>=<ret2>,....
 *
 *  <oid> is the SNMP OID to be polled
 *  <valN> is the SNMP value to match
 *  <retN> is the value returned if SNMP get equals valN
 *
 * If there is no match, then 'down' is returned.
 */

    function poller_snmp_status ($options) {

	$community = $options['ro_community'];
	$ip = $options['host_ip'];

	list($oid, $valstr) = explode(',', $options['poller_parameters']);
	$match_pairs = explode('|', $valstr);

	if ($ip && $community && $oid && $valstr) {
		$snmp_value = snmp_get($ip, $community, $oid);
		foreach($match_pairs as $match_pair) {
		    list ($match_string, $return_value) = explode('=', $match_pair);
		    if (!$match_string || !$return_value) {
		        logger("The matching pair \"$match_pair\" is not in <match>=<value> format.\n");
			return 'down';
		    }

		    if ($match_string == $snmp_value)
		        return $return_value;
	        }
	}
	return 'down';
    }

?>
