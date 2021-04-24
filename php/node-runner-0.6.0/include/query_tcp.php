<?php

// This is an example script that queries raw TCP sockets.

array_push($queries_type_array, "TCP");

function tcp_query($description, $ipaddress, $port, $ptime) {
  global $debug,$allow_refused;
  
  $status = array();

  $socket = fsockopen($ipaddress, $port, $errno, $errstr, $ptime);

  if (($allow_refused == 1) && ($errno == 111)) {
    $status[0] = 1;
    $status[1] = $description." UP";
    if ($debug == 1) { $status[1] .= " - TCP Port ".$port." Responded \"refused\", but that's acceptable enough."; }
  } else if (!$socket) {
    $status[0] = 0;
    $status[1] = $description." DOWN";
    if ($debug == 1) { $status[1] .= " - TCP Error ".$errno.": ".$errstr; }
  } else {
    $status[0] = 1;
    $status[1] = $description." UP";
    if ($debug == 1) { $status[1] .= " - TCP Port ".$port." Responded Correctly."; }
  }
  
  if ($socket) { fclose($socket); }

  $status[1] .= "\n";
  return $status;

}

?>
