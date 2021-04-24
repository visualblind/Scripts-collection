<?php

// This is an example script that queries the HTTP service on a given node.

array_push($queries_type_array, "HTTP");

function http_query($description, $ipaddress, $port, $url, $username, $pass, $ptime) {
    GLOBAL $debug,$allow_refused;
    
    $socket = fsockopen($ipaddress, $port, $errno, $errstr, $ptime);
	$status = array();
    
    // If 'connection refused (111)' was received by socket, the web server must be down or blocked by firewall.
    if (($socket == 111) || (!$socket)) {
        $status[0] = 0;
        $status[1] = $description." DOWN";
        if ($debug == 1) { $status[1] .= " - HTTP Error Code ".$errno.": ".$errstr; }
	} else { // else connection responded, so here we go...

	  $start_time = mktime();

      unset($authmsg);
      if ($username && $pass) {
         $str = "$username:$pass";
         $b64response = base64_encode($str);
         $authmsg = "Authorization: Basic $b64response\r\n";
      }

      if ($url == "/") { $url = ""; }

      $msg = "GET /". $url ." HTTP/1.0\r\nHost: $ipaddress\r\n$authmsg\r\n";
      fputs($socket,$msg);

      // Get HTML status codes
      $response = fread($socket,32);
      $lines = explode("\n", $response);
      $code_out = chop($lines[0]);
      $code_out = substr($code_out, 9, 3);
      unset($debug_status);
      if ($debug == 1) { $debug_status = "\nHTML Code: $code_out"; }

      // Array of acceptable HTML error codes
      $ok_array = array(200, 302, 401);

      if (in_array($code_out, $ok_array)) {
      // Web server must be responding, so check page load times
          $status[0] = 1;
          $status[1] = $description." UP".$debug_status;
          while (!feof($socket)) {
              $data = fgets ($socket,128);
              $mid_time = mktime();
	        if (($mid_time - $start_time) > $ptime) {
                    $status[0] = 0;
                    $status[1] = $description." UNRESPONSIVE - HTTP Page Load > ".$ptime." Seconds";
                    break;
                }
          }
	  
      }
      
	}
	if ($socket) { fclose($socket); }
	$status[1] .= "\n";
    return $status;
}

?>
