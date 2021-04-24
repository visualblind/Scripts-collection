<?php

// This is an example script that queries a UDP service on a given node.
// Note that this script will only work without modification if you are querying
// something like the "daytime" service that doesn't require anything more than
// a character return as input.

array_push($queries_type_array, "UDP");

function udp_query($description, $ipaddress, $port, $ptime) {
  global $debug;
  
  $status = array();

  $socket = fsockopen("udp://$ipaddress", $port, $errno, $errstr, $ptime);
  stream_set_timeout($socket, $ptime);
  if ($socket) {
    fwrite($socket,"\n");
    $output = fread($socket, 35);
  }

  if ((!$socket) || (!$output)) {
    $status[0] = 0;
    $status[1] = $description." DOWN";
    if ($debug == 1) { $status[1] .= " - UDP Port ".$port." Unreachable."; }
  } else {
    $status[0] = 1;
    $status[1] = $description." UP";
    if ($debug == 1) { $status[1] .= " - Daytime: ".$output; }
  }
  
  if ($socket) { fclose($socket); }

  $status[1] .= "\n";
  return $status;

}

?>
