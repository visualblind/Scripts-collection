<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function tool_tcp_cnx_info() {
	$info = array (
	    "type"=>"table", 
	    "param"=>array(
		"fields"=>array("Remote IP","Remote Port","State"),
		"action_field"=>"Close Connection"
	    ),
	    "state_label"=>"closed",
	    "description_label"=>"Connection"
	);
	return $info;
    }

    function tool_tcp_cnx_get($int) {

	if (!$GLOBALS["tcpConnEntry"] && (!empty($int["host_rocommunity"]))) 
	    $GLOBALS["tcpConnEntry"] = snmp_walk ($int["host_ip"],$int["host_rocommunity"],".1.3.6.1.2.1.6.13.1.1",1);

	$tcpConnEntry = $GLOBALS["tcpConnEntry"];
	$values = array();
	
	if (is_array($tcpConnEntry)) {
	    reset($tcpConnEntry);
    
	    while (list($key,$state) = each ($tcpConnEntry))
		if (strpos($state,"5")!==FALSE) { //only established
		    $entry = explode(".",$key);
		    $entry = array_slice ($entry, count($entry)-10,10); //get only the last 10 items (SRC-IP(4) + srcport + DEST-IP(4) + destport)
		    $entry_port = $entry[4]; //srcport (local)

		    if ($int["port"]==$entry_port) //if the search and found ports are equal
			$values[join(".",$entry)]=array(join(".",array_slice($entry,5,4)),$entry[9],substr($state,0,strpos($state,"(")));
		}
	}

	return $values;    
    }

    function tool_tcp_cnx_set($int, $values) {
	$final_result = true;

	if (is_array($values)) {
	    foreach ($values as $value)
		$result[] = snmp_set($int["host_ip"],$int["host_rwcommunity"],".1.3.6.1.2.1.6.13.1.1.".$value,"i",12);

	    foreach ($result as $res) 
		if ($res!=true) 
		    $final_result = false;
	}
	
	return $final_result;
    }

?>
