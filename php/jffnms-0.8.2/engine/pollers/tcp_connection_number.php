<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

//Read the tcp.tcpConnTable.tcpConnEntry.tcpConnState table to find out
//which ports are used in the host

function poller_tcp_connection_number ($options) {
    $cant = 0;
    $port = $options["port"];

    if (!isset($GLOBALS["tcpConnEntry"])) //save the table for other calls to this poller
	if ($options["ro_community"]) 
	    $GLOBALS["tcpConnEntry"] = snmp_walk ($options["host_ip"],$options["ro_community"],".1.3.6.1.2.1.6.13.1.1",1);

    $tcpConnEntry = $GLOBALS["tcpConnEntry"];
    
    if (is_array($tcpConnEntry)) {
	reset($tcpConnEntry);
	//var_dump($tcpConnEntry);
    
	while (list($key,$state) = each ($tcpConnEntry))
	    if (strpos($state,"5")!==FALSE) { //only established
		$entry = explode(".",$key);
		$entry = array_slice ($entry, count($entry)-10,10); //get only the last 10 items (SRC-IP(4) + srcport + DEST-IP(4) + destport)
		$entry_port = $entry[4]; //srcport (local)

		if ($port==$entry_port) //if the search and found ports are equal
		    $cant++;
	    }
    }
    
    return $cant;
}
?>
