<?php

//----------------------------------------------------------------------
//						 2005, Shield Tech
//							The Pinger
//						   Rowan Shield
//				email: shieldtech@thesilv3rhawks.com
//----------------------------------------------------------------------
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  at your option) any later version.
//
//----------------------------------------------------------------------

require "requires.php";

////////// CONFIGURATION /////////////////
//$ip_array = array("Router:192.168.1.1","This Server:192.168.1.2","Aitken College:203.49.175.91","Google:www.google.com","Non-Existant IP:192.168.1.99"); // you have to write here a descriptive name for every PC to be monitored and its IP address --> name:ipaddress
////////// END OF CONFIGURATION //////////

$address_array = array();

$query = sprintf("SELECT * FROM " . $dbprefix . "ips");

$result = mysql_query($query);

if (!$result) {
    $message  = 'Invalid query: ' . mysql_error() . "\n";
    $message .= 'Whole query: ' . $query;
    die($message);
}

// Use result
// Attempting to print $result won't allow access to information in the resource
// One of the mysql result functions must be used
// See also mysql_result(), mysql_fetch_array(), mysql_fetch_row(), etc.
while ($row = mysql_fetch_assoc($result)) {
	$string = $row['name'] . ":" . $row['address'];
	array_push($address_array, $string);
}

function ping($pc,$ip,$OS){
  if ($OS == "1") {
	$cmd = shell_exec("ping -n 1 $ip");
  } elseif ($OS == "2") {
	$cmd = shell_exec("ping -c 1 $ip");
  }

  $data_mount = explode(",",$cmd);
  if (eregi("0", $data_mount[1])) {
	$connection = "<img src=\"images/off.gif\">";
  }
  if (eregi("1", $data_mount[1])) {
	$connection = "<img src=\"images/on.gif\">";
  }
  $result = "<tr><td align='center'>$connection</td><td align='center'><i>$pc</i></td><td align='center'>$ip</td></tr>";
  return $result;
}

echo "<title>The Pinger</title>
<table cellspacing='0' width='100%'>
	<tr>
		<td width='15%' align='center'><b>Status</b></td>
		<td width='45%' align='center'><b>System Name</b></td>
		<td width='30%' align='center'><b>IP or URL Address</b></td>
	</tr>";

while(list($k,$v) = each($address_array)){
 $ip = explode(":",$v);
 $result = ping($ip[0],$ip[1],$OS);
 echo $result;
}
echo "</table><br><br>";
echo $power;

?>