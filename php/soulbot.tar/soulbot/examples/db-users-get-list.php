<?
/*
	This bot logs into the soulseek network and gets a list of every user and put them into a database
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
  	  sleep(15);
  	  doincoming();

 
	getglist(&$sock);
	
	waittick(20);
	doincoming();
	
	
  decodepacket(67, 4, $queueIn[67][0]);

while(list($key,$val)=each($packet[users])){
	$sql = "SELECT * FROM soul_soul.users WHERE user = '".addslashes($val)."'";
	$res = mysql_query($sql) or die("\nMYSQL ERROR\n".mysql_error()."\n $sql \n");
	if(mysql_num_rows($res)>0){
	
		$sql = "UPDATE soul_soul.users SET
				intStats 	= '".$packet[intStats][$key]."',
				avgspeed 	= ".$packet[avgspeed][$key].",
				downloadnum 	= ".$packet[downloadnum][$key].",
				something 	= ".$packet[something][$key].",
				files 		= ".$packet[files][$key].",
				dirs 		= ".$packet[dirs][$key].",
				slots 		= ".$packet[slots][$key]."
			WHERE user = '".addslashes($val)."'";
		mysql_query($sql) or die("\nMYSQL ERROR\n". mysql_error() ."\n $sql \n");
		
	}else{
	
		$sql = "INSERT INTO soul_soul.users SET
				user		= '".addslashes($val)."',
				intStats 	= '".$packet[intStats][$key]."',
				avgspeed 	= ".$packet[avgspeed][$key].",
				downloadnum 	= ".$packet[downloadnum][$key].",
				something 	= ".$packet[something][$key].",
				files 		= ".$packet[files][$key].",
				dirs 		= ".$packet[dirs][$key].",
				slots 		= ".$packet[slots][$key];
		
		mysql_query($sql) or die("\nMYSQL ERROR\n". mysql_error() ."\n $sql \n");
	}
}  
    
}//fi
?>
