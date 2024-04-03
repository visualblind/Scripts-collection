<?
/*
	This will populate a mysql database with the files shared by users on the 
	soulseek network.

	In order to run this, you will need to have run the following two files:
	first) db-users-get-list.php to grab a list, this can take a while..
	second) db-users-ip-port.php to get ip's port's for users. This can take a while, but 
	you can run this file starting after db-users-ip-port.php has run for a hour or so you
	actually have users to check.

	
*/
$dir = getcwd();
ini_set ("memory_limit", "124M");
include_once "../config.php";
include_once "../protocol.php";
include_once "../protomap.php";
include_once "../mysql.php";

define("MRETRY", 2);

#define("OVERIP", "156.17.236.74");
#define("OVERPORT", 2234);

#$savedsession = "$dir/slskuserlist.dat";

#register_shutdown_function("shutdown");
/*
	The following bit of code will loop for a number of times attempting to
	connect.
*/

function _getuserlist($uip, $uport){
	global $peerinbound, $PEERCODES, $queueIn;
	$queueIn = array();
	$inbound = $peerinbound;
	$SERVERCODES = $PEERCODES;
	
	$conntimes = 1;
	while(!$psock && $conntimes < MRETRY){
		debug("attempting to connect to peer($uip:$uport).. Try #$conntimes of ".MRETRY." max attempts");
		$psock = @fsockopen($uip, $uport, &$errno, &$errstr, 3);
		if($errno){
			debug("Could not connect ($errno - $errstr) retry in: ". RETRYINT);
			waittick(1);
		}
		$conntimes++;
	}
	if($conntimes > MRETRY){
		$error = "Maximum number of retries passed.. giving up.";
		return false;
	}
	if(!$error && $psock){
		debug("Connected to server: $uip on port $uport");
	  	if(stream_set_blocking($psock, TRUE)){
			debug("STREAM SET TO BLOCKING");
	  	}else{
			shutdown(); // do a clean shutdown of the socket
			die("ERROR could not set blocking mode to TRUE");
	  	}
  
 	 	stream_set_timeout($psock, 300); // I feel this is a good amount of time.
  
	  	#print_r(stream_get_meta_data($psock));

		// this is the peer init code.. we can't use standard construction because the first
		// part is a byte
  		$payloadString = "";
		$payloadString .= pack('I', strlen(SLSK_USER)) . SLSK_USER;
		$payloadString .= pack('I', strlen("P")) . "P";
		#$payloadString .= pack('I', strlen($value)) . $value;
		#$payloadString .= pack('I', 300);
		$payloadString .= pack('I', 456987);

        	$msgCode = pack('C', 1); // note this is BYTE
        	$msgLength = strlen($msgCode) + strlen($payloadString);
        	$initpeer = pack('I', $msgLength) . $msgCode . $payloadString;
		// init is constructed

    		sendpacket($psock, $initpeer);
    		wait(1);
    		sendpacket($psock, encodePacket($PEERCODES[], array(array(TYPE_INT, 4))));
    
  		sendpacket($psock, encodePacket($PEERCODES[GETSHAREDFILELIST], array(array(TYPE_INT, 4))));  
  		#waittick(10);
		/*
		for($x=0;$x<20;$x++){
			$mdata = stream_get_meta_data($psock);
			if(intval($mdata[unread_bytes])>0){
  				dopeerincoming($psock);
				$x = 20;
			}else{
				echo "$x	)". $mdata[unread_bytes]." in....\n";
				flush();
				sleep(1);
			}
		}//rof
		*/
		dopeerincoming($psock);
  		return $queueIn[5][0];
	}else{
		return false;
	}
}




/*
	The following takes the raw shared files data given to us by the user and
	turns it into an array.
	Can't use the standard decoder because of the complexity.
*/
function decodefiledata($data){
	#$data = uncompress_packet($data);
	$current = 0;
	$numDirs = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
	for($a=0;$a<$numDirs;$a++){
		$strlen = intval(@implode('', unpack('I', substr($data,$current,4)))); $current += 4;
		$directoryname = substr($data,$current,$strlen);
		$current += $strlen;
		$filesindir = intval(@implode('', unpack('I', substr($data,$current,4)))); $current += 4;
		echo "DIRECTORY/  $directoryname\n";

		#
		#	stub directory
		#	
		for($b=0;$b<$filesindir;$b++){
			$oddbyte = intval(implode('', unpack('C', substr($data,$current,1)))); $current += 1;
			$strlen = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
			$filename = substr($data,$current,$strlen); $current += $strlen;
			
			$size1 = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
			$size2 = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
			
			$strlen = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
			$ext = substr($data,$current,$strlen); $current += $strlen;
			
			$nattrib = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
			#echo "	".$filename."($size1)($size2)($ext) ($nattrib)\n";

			$atype = array(); $valu=array(); //clear
	
			for($c=0;$c< $nattrib;$c++){
				#{"att".$c}
				$attr[$c]["type"] = intval(implode('', unpack('I', substr($data,$current,4)))); $current += 4;
				$attr[$c]["value"] = intval(implode('', unpack('I', substr($data,$current,4)))); 
				$current += 4;
			}

			#
			#	stub file
			#
			$ret[$directoryname][] = array($filename,$size1,$size2,$ext,$attr);
		}
	}
    return $ret;
}


function getfilelist($user){
	$sql = "SELECT * FROM soul_soul.users WHERE user = '".addslashes($user)."'";
	$res = mysql_query($sql);
	if($list = mysql_fetch_assoc($res)){
	  $uip = long2ip($list[ipaddress]); 
	  $uport = $list[portnum]; # 2234 is 99% of the time.

	  #if(OVERIP){
	  #	$uip = OVERIP;
	  #	$uport = OVERPORT;
	  #}
	  
	  if($uip <> "0.0.0.0"){
		debug("IP: $uip : $uport");
		// $dir THIS IS FOR GET SHARED DATA
		if($files = _getuserlist($uip, $uport)){
			$totlen = strlen($files);
		
			debug("STRLEN=$totlen TESTING FOR int = $test");

			$newfile = substr($files,4,$totlen);
			$final = uncompress_packet($newfile);

			return decodefiledata($final);
		}else{
			return false;
		}
	  }
	}
}


#^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ functions above^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

$sql = "SELECT uid, user  FROM soul_soul.users WHERE intStats > 0 ORDER BY RAND()";
$res = mysql_query($sql) or die(mysql_error());
while($list = mysql_fetch_assoc($res)){
	debug ("CHECKING ". stripslashes($list[user]));
	$files = getfilelist(stripslashes($list[user]));
	sleep(1);
	while(list($key,$val)=@each($files)){
		$currdir = addslashes($key);
		$userid = $list[uid];
		$sql = "SELECT * FROM soul_soul.directories WHERE
			userid = $userid
			AND directory = '$currdir'";
		$dirc = mysql_query($sql);
		if(mysql_num_rows($dirc)>0){
			$dlist = mysql_fetch_assoc($dirc);
			$direct = $dlist[uid];
			$sql = "DELETE FROM soul_soul.files WHERE directoryid = $direct";
			mysql_query($sql);
		}else{
			$akey = addslashes($key);
			$sql = "INSERT INTO soul_soul.directories SET
				userid = $userid,
				directory = '$akey'";
			mysql_query($sql) or die(mysql_error());
			$direct = mysql_insert_id();
		}
		

		while(list(,$filearr)=each($val)){

			$filename = addslashes($filearr[0]);
			$exten = addslashes($filearr[3]);
			$size = $filearr[1];
			$bitrate = $filearr[4][0][value];
			$length = $filearr[4][1][value];
		
			if($length == ""){$length = 0;}
			if($bitrate == ""){$bitrate = 0;}
			if($size == ""){$size = 0;}
			if($exten == ""){$exten = "unk";}
			if($filename <> ""){		
			$sql = "INSERT INTO soul_soul.files SET
				userid = ". $list[uid] .",
				directoryid  =  $direct,
				filename = '$filename',
				exten = '$exten',
				size = ".$filearr[1].",
				bitrate = $bitrate,
				length = $length";
			mysql_query($sql) or die(mysql_error());
			}
		}
	}
	
}

#getfilelist("kproout");
?>
