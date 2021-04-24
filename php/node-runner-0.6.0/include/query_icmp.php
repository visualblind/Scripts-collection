<?php

// This is an example script that queries ICMP on a given node.

array_push($queries_type_array, "ICMP");


// Note that I did not write this class, but thanks a bunch to whomever did.
class Net_Ping
{
  var $icmp_socket;
  var $request;
  var $request_len;
  var $reply;
  var $errstr;
  var $time;
  var $timer_start_time;
  function Net_Ping()
  {
   $this->icmp_socket = socket_create(AF_INET, SOCK_RAW, 1);
   socket_set_block($this->icmp_socket);
  }

  function ip_checksum($data)
  {
     for($i=0;$i<strlen($data);$i += 2)
     {
         if($data[$i+1]) $bits = unpack('n*',$data[$i].$data[$i+1]);
         else $bits = unpack('C*',$data[$i]);
         $sum += $bits[1];
     }

     while ($sum>>16) $sum = ($sum & 0xffff) + ($sum >> 16);
     $checksum = pack('n1',~$sum);
     return $checksum;
  }

  function start_time()
  {
   $this->timer_start_time = microtime();
  }

  function get_time($acc=2)
  {
   // format start time
   $start_time = explode (" ", $this->timer_start_time);
   $start_time = $start_time[1] + $start_time[0];
   // get and format end time
   $end_time = explode (" ", microtime());
   $end_time = $end_time[1] + $end_time[0];
   return number_format ($end_time - $start_time, $acc);
  }

  function Build_Packet()
  {
   $data = "abcdefghijklmnopqrstuvwabcdefghi"; // the actual test data
   $type = "\x08"; // 8 echo message; 0 echo reply message
   $code = "\x00"; // always 0 for this program
   $chksm = "\x00\x00"; // generate checksum for icmp request
   $id = "\x00\x00"; // we will have to work with this later
   $sqn = "\x00\x00"; // we will have to work with this later

   // now we need to change the checksum to the real checksum
   $chksm = $this->ip_checksum($type.$code.$chksm.$id.$sqn.$data);

   // now lets build the actual icmp packet
   $this->request = $type.$code.$chksm.$id.$sqn.$data;
   $this->request_len = strlen($this->request);
  }

  function Ping($dst_addr,$timeout,$percision=3)
  {
   // lets catch dumb people
   if ((int)$timeout <= 0) $timeout=5;
   if ((int)$percision <= 0) $percision=3;

   // set the timeout
   socket_set_option($this->icmp_socket,
     SOL_SOCKET,  // socket level
     SO_RCVTIMEO, // timeout option
     array(
       "sec"=>$timeout, // Timeout in seconds
       "usec"=>0  // I assume timeout in microseconds
       )
     );

   if ($dst_addr)
   {
     if (@socket_connect($this->icmp_socket, $dst_addr, NULL))
     {

     } else {
       $this->errstr = "Cannot connect to $dst_addr";
       return FALSE;
     }
     $this->Build_Packet();
     $this->start_time();
     socket_write($this->icmp_socket, $this->request, $this->request_len);
     if (@socket_recv($this->icmp_socket, &$this->reply, 256, 0))
     {
       $this->time = $this->get_time($percision);
       return $this->time;
     } else {
       $this->errstr = "ICMP Timed out";
       return FALSE;
     }
   } else {
     $this->errstr = "Destination address not specified";
     return FALSE;
   }
  }
}


function icmp_query($description, $ipaddress, $ptime) {
    GLOBAL $debug;

    $status = array();
    
$ping = new Net_Ping;
$ping->ping($ipaddress,$ptime);

if ($ping->time) {
  $status[0] = 1;
  $status[1] = $description." UP";
  if ($debug == 1) { $status[1] .= " - Queried in: ".$ping->time." seconds."; }
} else {
  $status[0] = 0;
  $status[1] = $description." DOWN";
  if ($debug == 1) { $status[1] .= " - ".$ping->errstr.""; }
}

  $status[1] .= "\n";
  return $status;
}

?>
