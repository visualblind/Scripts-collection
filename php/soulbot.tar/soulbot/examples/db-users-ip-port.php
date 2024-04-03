<?
/*
	This is a simple example of use the protocol.
	It logs into the network and pulls user info from the database.
	It loops through the users and gets their IP and port number for their 
	shares.

	It has a loop which can be removed, but will probably result in your
	being banned from slsk
*/

$dir = getcwd();
ini_set ("memory_limit", "124M");
include "../config.php";
include "../protocol.php";
include "../protomap.php";
include "../mysql.php";

$savedsession = "$dir/slsksession.dat";

register_shutdown_function("shutdown");
/*
	The following bit of code will loop for a number of times attempting to
	connect.
*/


$conntimes = 1;
while(!$sock || $conntimes > RETRY){
	debug("attempting to log in.. Try #$conntimes of ".RETRY." max attempts");
	$sock = @fsockopen($serverhost, $serverport, &$errno, &$errstr, 30);
	if($errno){
		debug("Could not connect ($errno - $errstr) retry in: ". RETRYINT);
		waittick(RETRYINT);
	}
	$conntimes++;
}
if($conntimes > RETRY){
	$error = "Maximum number of retries passed.. giving up.";
}
if(!$error && $sock){
debug("Connected to server: $serverhost on port $serverport");
  if(stream_set_blocking($sock, TRUE)){
	debug("STREAM SET TO BLOCKING");
  }else{
	shutdown(); // do a clean shutdown of the socket
	die("ERROR could not set blocking mode to TRUE");
  }
  
  stream_set_timeout($sock, 300); // I feel this is a good amount of time.

  slsklogin($sock);
  sleep(15);
  for($a=0;$a<7;$a++){
	  doincoming();
	  sleep(1);
  }
  

  $GETMLT = 10;
  $INC = 0;
  $sql = "SELECT count(*) as tot FROM soul_soul.users";
  $res = mysql_query($sql) or die("\nMYSQL ERROR\n".mysql_error()."\n $sql \n");
  $amt = mysql_fetch_assoc($res);
  $tot = $amt['tot'];

  $loops = floor($tot/$GETMLT);
  
  for($a=0;$a<$loops;$a++){
	$sql = "SELECT * FROM soul_soul.users WHERE ipaddress = 0 ORDER BY RAND() DESC LIMIT $INC, $GETMLT";
	#debug($sql);
	$INC += $GETMLT;
	$res = mysql_query($sql) or die("\nMYSQL ERROR\n".mysql_error()."\n $sql \n");
	while($list = mysql_fetch_assoc($res)){
		$user = stripslashes($list['user']);
		#sendpacket($sock, encodePacket($SERVERCODES[GETPEERADDRESS], array(array(TYPE_STRING, $user))));
		getpeer($sock, $user);
		$packet = "";
		doincoming();
		decodepacket(3, 4, $queueIn[3][0]);
		array_pop($queueIn[3]);
		#print_r($packet);

		$username = $packet['username'];
		$ipaddress = $packet['ipaddress'];
		$portnumber = $packet['portnumber'];

		if($ipaddress == ""){$ipaddress=0;}
		if($portnumber == ""){$portnumber=0;}
		
		$sql = "SELECT * FROM soul_soul.users WHERE user = '".addslashes($username)."'";
		$ures = mysql_query($sql);
		$uamt = mysql_fetch_assoc($ures);
		$uid = $uamt['uid'];

		
		if($uid <> 0){
		  $sql = "UPDATE soul_soul.users SET
				ipaddress = $ipaddress,
				portnum = $portnumber
			WHERE uid = $uid";
		  mysql_query($sql);#or die("\nMYSQL ERROR\n".mysql_error()."\n $sql \n");
		}
		#debug( $sql );
	}//wend
	sleep(1);
  }//rof
  
}//fi
?>
