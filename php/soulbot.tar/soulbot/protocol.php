<?
/*
	new generic functions for dealing with slsk packets.
*/
include_once('config.php'); // mostly for testing

// the following two functions are for stashing arrays
// this way I don't have to keep hammering the slsk server for the data.
function datasave($array, $filename) {
        $serialised = serialize($array);
        $f = fopen($filename, "w ");
        if (!$f)  {
            echo "\nCould not open $filename!";
            return;
        }
        $size = fwrite($f, $serialised);
        fclose($f);
}

function &dataload($filename) {
        if (file_exists($filename) ) {
            $f = fopen($filename, "r");
            $serialised = fread($f, filesize($filename) );
            fclose($f);
            if ($serialised < 0) {
                return null;
            }
            return unserialize($serialised);
        }
        return null;
}


// standard debug
function debug($msg){
	global $debugstart;
	if(DEBUG){
		$newmsg = explode("\r", $msg);
		for($a=0;$a<count($newmsg);$a++){
			echo "$debugstart	)*** ". $newmsg[$a] ."\n";
		}
		flush();
	}
	$debugstart++;
}
// peercodes debug
function debugpeer($msg, $direction="<<<"){
	global $debugpeerstart ;
	if(DEBUG){
		$newmsg = explode("\r", $msg);
		for($a=0;$a<count($newmsg);$a++){
			echo "$debugpeerstart	)$direction ". $newmsg[$a] ."\n";
		}
		flush();
	}
	$debugpeerstart++;
}
// debugger for reading from stream..
function bwdebug($msg){
	global $bwdebugstart ;
	if(DEBUG){
		echo $msg;
		flush();
	}
	$bwdebugstart++;
}

// registered shutdown function
function shutdown(){
  global $serverhost, $serverport;
  debug("");
  debug("--------------------------------------------------------");
  debug("Closing connection to $serverhost on port $serverport");
  @fclose($sock); // close down the connection.
  debug("Script execution finished.....");
}
function wait($len, $check=FALSE){
	for($a=$len;$a>0;$a--){
		debug("waiting on socket ... $a");
		sleep(1);
		if($check == TRUE){ doincoming(); }
	}
}
function waittick($len){
	echo "\n	";
	for($a=$len;$a>0;$a--){
		echo $a." ";
		flush();
		sleep(1);
	}
	echo "\n";
}

function sendpacket($sock, $packet){
	if(fputs($sock, $packet)){
		debug("Sent packet to socket");
		#doincoming();
		return true;
	}else{
		debug("Could not send packet to socket");
		return false;
	}
}

function uncompress_packet($rawpacket){
	if($unzlib = @gzuncompress($rawpacket)){
		debug("ZLIB DATA FOUND, returning uncompressed data.");
		return $unzlib;
	}else{
		debug("no zlib data, returning packet as is");
		return $rawpacket;
	}
}
function uncompress_packet2($rawpacket){
	if($unzlib = @gzinflate($rawpacket)){
		debug("ZLIB DATA FOUND, returning inflate data.");
		return $unzlib;
	}else{
		debug("no zlib inflate data, returning packet as is");
		return $rawpacket;
	}
}

function slsklogin(&$sock){
	    global $SERVERCODES;
    	    debug("Constructing login packet.");
            $packet = encodePacket($SERVERCODES[LOGIN], array
            (
                array(TYPE_STRING, SLSK_USER),
                array(TYPE_STRING, SLSK_PASS),
                array(TYPE_INT, SLSK_VERSION)
            ));
	    debug("Sending login packet.");
	    sendpacket($sock, $packet);
	    debug("--------------------------------------------------------");
	    doincoming($sock);
	    
	    $setwp = encodePacket($SERVERCODES[SETWAITPORT], array(array(TYPE_INT, PEERPORT)));
	    sendpacket($sock, $setwp);

	    $setfiles = encodePacket($SERVERCODES[SHAREDFOLDERSFILES], array(
			array(TYPE_INT,100),
			array(TYPE_INT,100)
			));
	    sendpacket($sock, $setfiles);
	    sendpacket($sock, encodePacket($SERVERCODES[SET_STATUS], array(array(TYPE_INT, STATUS_ONLINE))));
	    doincoming($sock);
}

function getglist(&$sock){
	global $SERVERCODES;
	$sendgl = encodePacket($SERVERCODES[GLOBALUSERLIST], array(array()), TRUE);#TYPE_INT, GLOBALUSERLIST
	sendpacket($sock, $sendgl);
}
function joinroom(&$sock, $room){
	global $SERVERCODES;
	sendpacket($sock, encodePacket($SERVERCODES[JOINROOM], array(array(TYPE_STRING, $room))));
}
function getpeer(&$sock, $user){
	global $SERVERCODES;
	sendpacket($sock, encodePacket($SERVERCODES[GETPEERADDRESS], array(array(TYPE_STRING, $user))));
}

function handleincoming(&$sock){
	global $queueIn, $queueOut, $VqueueIn, $SERVERCODES, $PEERCODES;
        if (!$sock || @feof($sock)){
	    debug("End of file on sock ???wtf???.");
            return false;
        }
	$rawpacket = "";
	$mdata = stream_get_meta_data($sock);
	debug("sock is good listening... ". $mdata[unread_bytes] ." on the wire");
	if(!feof($sock) || $mdata[unread_bytes] > 0){
		stream_set_timeout($sock, 75); // so we are not wasting time
		$packetlen = (intval(implode('', unpack('I', fread($sock, 4)))));
		$numsnag = floor($packetlen/BWINC);
		$modr = $packetlen % BWINC;
	
		$toget = ($numsnag*BWINC)+$modr;
		debug("############# NUMSNAG = $numsnag - MODR = $modr (LEN: $packetlen, $toget");
		if($numsnag > 0){
			# we loop through reading it in incremental chunks as the server feeds it 
			# to us..
			echo "		"; // couple tabs
			$tmpcount = 0;
				$base = "";
			for($c=0;$c<$numsnag;$c++){
				$base = fread($sock, BWINC);//$packetlen $mdata[unread_bytes]
				if(strlen($base)<BWINC){
					$c--;
					sleep(1);
				}else{
					$rawpacket .= $base;
					bwdebug(".");
					$tmpcount += BWINC;
					if(($c%10)==0){
						echo "\n". $tmpcount ." vs ". strlen($rawpacket);
					}
				}
			}
			echo "\n";
			debug("############# PULLING REMAINDER $modr");
			$tmpcount += $modr;
			$rawpacket .= fread($sock, $modr); // get the bit that is left.
			
			#$rawpacket = implode("",$rawp);
			debug("############# TOTAL LEN IN packet:".strlen($rawpacket)." should be $tmpcount");
			
		}else{
			// it is smaller than the increment we have designated, just snag it in one go.
			$rawpacket = fread($sock, $packetlen);
		}
   		$msgCode = intval(@implode('', @unpack('I', substr($rawpacket,$current,4))));
   		$akey = array_search($msgCode, $SERVERCODES);
		if($akey == ""){ $akey = array_search($msgCode, $PEERCODES); }
		$queueIn[$msgCode][] = $rawpacket;
   		$VqueueIn[] = $msgCode;
		debug("<<<<<<<<<<<<<<<<<<<<<< ".$akey ."(". $msgCode.")<<<<<<<<<<<<<<<<<<<<<< : ".$mdata[unread_bytes]);
		if($mdata[unread_bytes]>4){
			#handleincoming($sock);
		}
		return true;
	}
     return false;
}


function doincoming(){
	global $PACKETS, $sock;
	#$mdata = stream_get_meta_data($sock);
	handleincoming($sock);
}
function dopeerincoming($psock){
	global $PACKETS;
	#$mdata = stream_get_meta_data($sock);
	handleincoming($psock);
}

// recursion
function _decodeenum($parameter, $rawpacket, $current, $varname){
	global $packet;
		$length = strlen($rawpacket);
			print_r($parameter);
			$amount = $packet[$varname];
                            list($name, $num, $enumType) = $parameter;
                            $num = is_numeric($num) ? $num : $packet[$num]; #$packet[$num];
			    debug("TESTING- NAME:$name NUM:$num  -- ". $parameter[1]." VN=$varname AM=$amount");
			    // uncomment for testing... otherwise is too much
			    #debug("DECODING ENUM name= $name, num= $num, enumType= $enumType");
                            for ($i = 0; $i < $num; $i++)
                            {
                                switch ($enumType)
                                {
                                    case TYPE_BYTE:
                                        $packet[$name][$i] = intval(implode('', unpack('C', substr($rawpacket,$current,1))));
                                        $current++;
                                        break;;
                                    case TYPE_INT:
                                        $packet[$name][$i] = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                        $current += 4;
                                        break;;
                                    case TYPE_STRING:
                                        $strlen = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                       	$current += 4;
                                       	$packet[$name][$i] = substr($rawpacket,$current,$strlen);
                                       	$current += $strlen;
                                        break;;
				    case TYPE_ENUM:
				    	// this is in place for peer file lists..
					// recursive keeps this much more simple.
				    	debug("--!!!-- NESTED ENUM here, lets decode it --!!!--");
					$current = _decodeenum($parameter[1], $rawpacket, $current);
				        break;;
                                }
                            }
	return $current;
}

function decodepacket($msgCode, $firstlen=0, $rawpacket){
	global $packet, $inbound, $SERVERCODES;
	if(!is_numeric($msgCode)){ $msgCode = ${$msgCode}; }
	$length = strlen($rawpacket);
	$current = $firstlen; 
	$inkey = array_search($msgCode, $SERVERCODES);
	debug("DECODING PACKET of type - $inkey TOTAL LEN=$length");
	if (isset($inbound[$inkey])){
		foreach ($inbound[$inkey] as $parameter){
			list($type, $name) = $parameter;
			debug("PACKET type= $type, name= $name ($current > $length)");
			#debug("CURRENT =  $current");
			if($current>$length){
				return $current;
			}

			switch ($type){
                        	case TYPE_BYTE:
                            		$packet[$name] = intval(implode('', unpack('C', substr($rawpacket,$current,1))));
                            		$current++;
                            		break;
                        	case TYPE_INT:
                            		$packet[$name] = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                           		$current += 4;
                            		break;
                        	case TYPE_STRING:
                            		$strlen = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
					#debug("String is $strlen long of $length (-".TYPE_STRING.") total");
                            		$current += 4;
					$str = substr($rawpacket,$current,$strlen);
					debug("String is $strlen long of $length (-".TYPE_STRING.") total ($str)");
                            		$packet[$name] = $str;
                            		$current += $strlen;
                            		break;
                        	case TYPE_ENUM:
					debug("ENUM here ". $parameter[1] ." TYPE or($parameter).. decoding...");

                            		list($name, $num, $enumType) = $parameter[1];
                            		$num = is_numeric($num) ? $num : $packet[$num];

			    		#debug("TOTAL NUMBER OF USERS: $num");
                            		for ($i = 0; $i < $num; $i++){
					if($current>$length){
						return $current;
					}
			    		#echo $current . "\n";
                                	switch ($enumType){
                                    	case TYPE_BYTE:
                                          $packet[$name][$i] = intval(implode('', unpack('C', substr($rawpacket,$current,1))));
                                          $current++;
                                          break;
                                    	case TYPE_INT:
                                          $packet[$name][$i] = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                          $current += 4;
                                          break;
                                    	case TYPE_STRING:
                                          $strlen = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                          $current += 4;
                                          $packet[$name][$i] = substr($rawpacket,$current,$strlen);
                                          $current += $strlen;
					  #echo $current . " ". $packet[$name][$i] ."\n";
                                          break;
                        	case TYPE_ENUM:
					debug("ENUM here ". $parameter[1] ." TYPE or($parameter).. decoding...");

                            		list($name, $num, $enumType) = $parameter[1];
                            		$num = is_numeric($num) ? $num : $packet[$num];

			    		#debug("TOTAL NUMBER OF USERS: $num");
                            		for ($i = 0; $i < $num; $i++){
					if($current>$length){
						return $current;
					}
			    		#echo $current . "\n";
                                	switch ($enumType){
                                    	case TYPE_BYTE:
                                          $packet[$name][$i] = intval(implode('', unpack('C', substr($rawpacket,$current,1))));
                                          $current++;
                                          break;
                                    	case TYPE_INT:
                                          $packet[$name][$i] = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                          $current += 4;
                                          break;
                                    	case TYPE_STRING:
                                          $strlen = intval(implode('', unpack('I', substr($rawpacket,$current,4))));
                                          $current += 4;
                                          $packet[$name][$i] = substr($rawpacket,$current,$strlen);
                                          $current += $strlen;
					  #echo $current . " ". $packet[$name][$i] ."\n";
                                          break;

					  
                                	}//switch
                            		}//for
                               break;

					  
                                	}//switch
                            		}//for
                               break;
				default:
					debug("ERROR: You need to supply a type for this messagecode = $msgCode");
					return false; // end of the road
			}// end switch
		}// end foreach
	}else{
		debug($msgCode." is not a recognized messagecode = $msgCode");
		return false;
	}
}

// ==================[ RAW PACKET CONSTRUCTOR ]================================
    function encodePacket($msgCode, $payload, $onlycode=FALSE){
    	global $SERVERCODES;
        if (!is_array($payload))
        {
	    debug("payload for packet not in array");
            return false;
        }
	$outkey = array_search($msgCode, $SERVERCODES);
	debug(">>>>>>>>>>>>>>>>>>>>>> $outkey >>>>>>>>>>>>>>>>>>>>>>");
        $payloadString = '';
	if(!$onlycode){
        foreach ($payload as $parameter)
        {
            list($type, $value) = $parameter;
            switch ($type)
            {
                case TYPE_BYTE:
		    debug("$outkey encoding byte");
                    $payloadString .= pack('C', $value);
                    break;
                case TYPE_INT:
		    debug("$outkey encoding int ($value)");
                    $payloadString .= pack('I', $value);
                    break;
                case TYPE_STRING:
		    debug("$outkey encoding string ($value)");
                    $payloadString .= pack('I', strlen($value)) . $value;
                    break;
                default:
                        debug("Warning: unhandled data type($msgCode). Packet could not be constructed");
                    return false;
            }
        }
	}
        $msgCode = pack('I', $msgCode);
        $msgLength = strlen($msgCode) + strlen($payloadString);
        return pack('I', $msgLength) . $msgCode . $payloadString;
    }

    function requestuserlist($sock){

    }
?>
