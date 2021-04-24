<?php

array_push($queries_type_array, "SNMP");

function snmp_query($description, $ipaddress, $community, $ptime) {
  global $debug;
  
  $status = array();

  // Retrieve system name
  $socket = snmpget($ipaddress, $community, "system.sysName.0", $ptime);

  if (!$socket) {
    $status[0] = 0;
    $status[1] = $description." DOWN";
    if ($debug == 1) { $status[1] .= " - SNMP Error Reading system.sysName.0 Object ID."; }
  } else {
    $status[0] = 1;
    $status[1] = $description." UP";
    if ($debug == 1) { $status[1] .= " - ".$socket; }
  }
  
  if ($socket) { fclose($socket); }

  $status[1] .= "\n";
  return $status;

}

?>
