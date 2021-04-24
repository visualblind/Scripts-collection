<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function hex2dec(&$item,$key) { $item = hexdec($item);  }

function repack ($var) { 
    $var = pack("n",$var);
    $temp = unpack("n",$var);
    $aux = $temp[""];
    return $aux;
}
function checksum($buffer) {
    $cksum = 0;
    $counter = 0;
    //var_dump($buffer);
    $i = 1;
    
    foreach ($buffer as $value) {
	if ($i==0) {
	    $value1 .=$value;
	    $buff1[] = $value1;
	    $i = 1;
	    $value1=0;
	} else {
	    $value1=$value;
	    $i = 0;
	}
    }    
    $buff1[] = $value1;
    
    foreach ($buff1 as $value) {
	$aux = substr($value,2,4).substr($value,0,2);
	$value1 = hexdec($aux);

	//echo $counter++." $cksum $value $value1\n";

	$cksum += $value1;
    }

    $aux = repack(($cksum & 0xffff));

    $cksum1 = repack((($cksum >> 16) + $aux));
    $cksum2 = repack(($cksum1 + ($cksum1 >> 16)));
    $ans = ~$cksum2;
    $ans = repack($ans);

    //echo "sum1 : $cksum ".decbin($cksum)." ".dechex($cksum)."\n";
    //echo "sum2 : $cksum1 ".decbin($cksum1)." ".dechex($cksum1)."\n";
    //echo "sum3 :$cksum2 ".decbin($cksum2)." ".dechex($cksum2)."\n";
    //echo "answer : $ans ".decbin($ans)." ".dechex($ans)."\n";

    $csum1 = dechex($ans);
    $buffer[2] = substr($csum1,2,4);
    $buffer[3] = substr($csum1,0,2);

    return $buffer;
}


function view_packet($data){
    $datas = explode(" ",$data);
    $i = 1;
    foreach ($datas as $aux) {

	$val =  hexdec($aux);
	$val2 = chr($val); 
	$val3 = decbin($val);
	$val4 = str_pad($val3,8,"0",STR_PAD_LEFT); //bin

	$show1.= $aux; //hex
	$show4.= $val4; //bin
	
	if ((($i%2)==0))  $show1.= " ";
	if ((($i%2)==0))  $show4.= " ";

	if ($i == 8) { 
	    $show1.= "\n";
	    $show4.= "\n"; 
	    $i=1;
	} else {
	    $i++;
	}
    }
    echo "\n------------------------------------------\n";
    echo "$show1\n\n$show4";
    //echo "$show1";
    echo "\n------------------------------------------\n";

    flush();

}


    //       ty cd cksum ident seqnu data ---- 
    $data = "08 00 00 00 08 97 00 00 ".
				    "65 00 00 39 8e d8 3c a1 ". 
	    "e1 05 ".
		  "00 08 09 0a 0b 0c 0d 0e 0f 10 11 12 13 14 ". //data
	    "15 16 17 18 19 1a 1b 1c 1d 1e 1f 20 21 22 23 24 ". 
	    "25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34".
	    "";
	    //"35 36 37";


if (!$argv[2]) $cant = 2; else $cant = $argv[2];
if (!$argv[1]) $ipdest = "10.1.0.100"; else $ipdest = $argv[1];

unset($sock);
$sock = socket_create(AF_INET,SOCK_RAW,getprotobyname("ICMP"));
$set = socket_fd_alloc();
socket_fd_set($set,$sock);

$datas = explode(" ",$data);

echo "PING $ipdest ($ipdest) from localhost : ".count($datas)." bytes of data.\n";

for ($i = 0; $i < $cant; $i++) {
    $conn = socket_connect($sock,$ipdest,0);
    
    $datas[6]= "05"; // type (internal);
    $datas[7]= str_pad(dechex($i),2,"0",STR_PAD_LEFT); //seqnum
    
    $datas_aux = checksum($datas);

    //view_packet(join(" ",$datas_aux));

    unset($val1);
    foreach ($datas_aux as $aux) {
	$val =  hexdec($aux);
	$val2 = chr($val); 
	$val1 .= $val2;
	//echo ++$i."\t$val\t$val2\t$val3\n";
    }

    $times[$i] = gettimeofday();
    $aux = socket_write($sock,$val1,sizeof($val1));
    usleep(2000);
}

for ($i = 0; $i < $cant; $i++) {
    $aux = 2;
    if ($aux > 1) { 
	$num = 1;
	$timeout = 101;

	while (($num <= 0) and ($timeout < 100))  {
	    $num = socket_select($set, NULL, NULL, 0, 1000);
	    echo $timeout++." - $num\n";
	}


	if ($num > 0) {
	    $aux = socket_read($sock,100);
	    $time2 = gettimeofday();

	    $len = strlen($aux)-20;
	    unset($val3);
    	    for ($o = 1; $o < strlen($aux) ;$o++){
		$val = $aux[$o];
		$val1 = ord($val);
		$val2 = str_pad(dechex($val1),2,"0",STR_PAD_LEFT);
		$val3 .="$val2 ";
		//echo "$o\t$val\t$val1\t$val2\n";
    	    }
	    //var_dump($val3);
    
	    $data_recv = explode(" ",$val3);
	    //view_packet($val3);
    
	    $src =  array_slice($data_recv,11,4); array_walk($src,"hex2dec");
	    $dest = array_slice($data_recv,15,4); array_walk($dest,"hex2dec");
	    $type = $data_recv[19];
	    $seq1 = array_slice($data_recv,25,2); array_walk($seq1,"hex2dec");
	    $source = join(".",$src);
	    $destination = join(".",$dest);
	    $seq = join(":",$seq1);
	    $ttl= hexdec($data_recv[7]);
	    
	    $time1 = $times[$seq1[1]];
	    $time1_usec = $time1[sec]*1000000+$time1[usec];
	    $time2_usec = $time2[sec]*1000000+$time2[usec];
	    $rtt_usec = $time2_usec - $time1_usec; //msec
	    $rtt_msec = round(($rtt_usec/1000),3); //msec
	    $total_rtt[]=$rtt_msec;    
	
	    echo "$len bytes from $source: icmp_seq=$seq ttl=$ttl time=$rtt_msec msec ($rtt_usec usec)\n";
	} else  echo "Timeout...\n";
    } else echo "Send ERROR\n";
}

$cant_recv = count($total_rtt);
socket_close($sock);

foreach ($total_rtt as $rtt) $rtt_total+=$rtt;
$rtt_avg = round($rtt_total/$cant_recv,3);

echo "--- $ipdest ping statistics ---\n";
echo "$cant packets transmitted, $cant_recv packets received, ".(($cant_recv/$cant)*100)."% packet loss\n";
echo "round-trip avgv = $rtt_avg ms\n";


?>
