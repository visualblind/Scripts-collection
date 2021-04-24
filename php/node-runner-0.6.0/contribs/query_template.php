<?php

/*
If you're reading this, Node Runner probably doesn't do quite everything you
hoped it would do.  This is a template for building your own custom network
queries.  The lines below are those necessary to return appropriate data and
functionality to the Node Runner polling script.  I have commented each line
for a better explanation.  If you come up with a custom query that others may
find useful, please email it to me and I will evaluate it for future versions.
If you have little experience with php, networking, or sockets in general, it's
probably a good idea to do some reading before attempting to make your own
custom queries.
*/


/*
The following line identifies the query type in the database for each node.
The description here can be anything, and will show up as a possible query
type in the web interface.
*/
array_push($queries_type_array, "TCP");



/*
Now we set up our function, which will need to be added to the node.start script
after you have created it (see function "query_socket" in node.start).
*/
function tcp_query($description, $ipaddress, $port, $ptime) {
  global $debug; // include this line for debugging
  
  $status = array(); // this function should return an array (see end of function).

  $socket = fsockopen($ipaddress, $port, $errno, $errstr, $ptime);

  if (!$socket) {
    $status[0] = 0; // The value of the first element of the array should either
	                // be 0 for unresponsive nodes, 1 for responsive nodes.
					
    $status[1] = $description." DOWN"; // The value of the second element of the
									   // array serves as the status message you
									   // wish to receive.  Same with the level
									   // of debugging that you can add (below).
    
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
