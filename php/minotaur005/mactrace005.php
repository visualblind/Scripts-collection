<?
//****************************************************************************
// Minotaur - a PHP layer-2 traceroute script
// MAC address traceroute script ver o.oo5 09/03/2003
//    by Min-Hsao Chen minhsao@mintrix.net
//    http://www.mintrix.net/projects/
//
// The purpose of this script is to trace through a switch network and find 
// the port where a specific mac address is connect.
//     Go to http://www.mintrix.net/projects/ for more details
//
// Requirements:
//     - This script requires the network switches to be cisco based switches.
//        - NEW !!! WORKS on 2948G-L3
//        - will work on other IOS based or CATos based switches
//     - The cisco switches must have TACACS+ support ... no TACACS version might be coming
//     
// Disclaimer
//    This script is open source … if you are going to use this script please have the 
//    courtesy and send me an email and say hi.  This is script is under the GNU general 
//    public license. This script is provided "AS IS".  I will not be responsible 
//    for anything that happens because of this script.  
//    If there are any questions please email me. 
//    I will try to answer your question as soon as I can.  Thank you very much 
//    and have fun tracing.
//    
//****************************************************************************

// user edit area

$snmppublicstr="public"; // public snmp string 
$consolepw="cisco";
$enablepw="cisco123";
//

// edit with caution from this point on
?>
<!-- Main HTML -->
<div align="left">
  <table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="72%" id="AutoNumber1">
    <tr>
      <td width="23%">
      <img border="0" src="minotaurlogoB.jpg" width="108" height="131"></td>
      <td width="77%" align="left"><b><font size="5" face="Verdana">MINOTAUR</font></b><small><br>
      a layer-2 traceroute script <br>
ver. o.oo5 ... <br>
09/03/2003<br>
<a href="mailto:minhsao@mintrix.net">minhsao@mintrix.net</a>
</small>

      </td>
    </tr>
  </table>
</div>
<form method="post" action="mactrace005.php">

Username:
<input type="text" name="username" value="<? echo "$username";?>" size="20"  size="13"><br>

Password:
<input type="password" name="password" value="<? echo "$password";?>" size="20" size="13"><br>

MAC or IP ADDRESS :
<input type="text" name="address" value="<? echo "$address";?>" size="20" size="16"><br>

<i>Seed switch IP (optional)</i> :
<input type="text" name="seedip" value="<? echo "$seedip"; ?>"size="20"  size="16"><br>

<input type="submit" value="Go get it"  >
</form>


<?
// main program

if ($username)
{
 echo "please wait... <br>\n ";
 flush();		
	
// Sets start time.
$timeparts = explode(" ",microtime());
$starttime = $timeparts[1].substr($timeparts[0],1);


// get the gateway if needed
if (isitip($address)){
  $localrouter=findgateway($address);
  if (!$localrouter) {       // default router
      $adevice=explode(".",$address); // finding router ip
      $temp=array_pop($adevice);
      array_push($adevice,"20");   // default router 4th octect
      $localrouter=implode(".",$adevice);
  }
  echo "gateway IP : $localrouter<br>";
  $mac=getmacfromtelnet($localrouter,$username,$password,$ostype,$address);
  
}else{
  $mac=$address;
  echo "MAC: $mac <br>";
}// got mac
flush();

// get seed device if needed
if (!$seedip){
    //echo "getting seed device... from $localrouter <br>";
    $seedip=getseedip($localrouter,$username,$password,$ostype,$address);
}
$nextip=$seedip; // device IP is the next ip
// got seed


$mac=str_replace("-","",$mac);  // strip out the dashes 
$mac=str_replace(".","",$mac);  // strip out the dots
$mac=str_replace(":","",$mac);  // strip out the colons 
$mac=strtolower($mac);

  


  echo "Seed device : $seedip <br>";
  flush();
  $count=-1;
  echo "<pre>";	
  echo "<b>OS TYPE		FROM IP			PORT				TO </b><br>";
  flush();
  while ($nextip){	
  	
  	$typeofos= getostypebysnmp($nextip,$snmppublicstr);
  	$nextip=rtrim($nextip);
 	echo "$typeofos		 <a href=\"telnet:\\\\$nextip\">$nextip</a>		";// telnet option
  	$nextip=locatethismac($username,$password,$nextip,$typeofos,$mac);
  	if ($nextip){
  	     echo "			$nextip";
  	   }else{
  	     echo "			$mac";
  	   }
  	$count+=1;
        echo "<br>";
      
  	flush();

  }// end while
  echo "</pre>";
  echo "<br> $count hop(s) from the seed device<br>";
  
  //total time taken
  $timeparts = explode(" ",microtime());
  $total_time = ($timeparts[1].substr($timeparts[0],1)) - $starttime;
  echo "<br><font size=\"0\"><i>Total time: ".substr($total_time,0,4)." secs.</i></font><br>";
}else {
  echo "Please user your TACACS UserID and Password <br>";
}

//functions

function getseedip($routerip,$username,$password,$ostype,$address){
// this function finds the seedip from the default gateway.
       $command="show ip arp $address";
       $data=getdatafromdevice($routerip,$username,$password,$command,$typeofos); // get the info
       // $ndata=str_replace("\n","<br>",$data);
       // echo "$ndata <br>";
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$address /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression splitf
       $port=rtrim($parts[5]); // pick out the interface from ip arp
       // echo "$port <br>";
       $seedswitch=get_cdp_neighbor($username,$password,$routerip,$typeofos,$port);
       // echo "seedip = $seedswitch <br>";
       return $seedswitch;
}

function isitip($address){
   $dotcount=substr_count($address,".");
   if ($dotcount=="3"){
         return true;
    }else{
         return false;
    }
} // end of isitip


// find the ip's local router functions
function findgateway($device){
// this function finds the default gateway of the device
   $tracearray=traceroute($device);   	
   $numberofdevices=count($tracearray);
   //var_dump($tracearray);
   $routerip=preg_split("/ +/",$tracearray[$numberofdevices-2]);
   //echo "gateway IP : $routerip[2] <br>";
   return $routerip[2];
}


Function traceroute ($destip) {
    // traceroute function that does a ICMP traceroute.	
    // not the best way to do it .. bit it will do for now
    exec("traceroute -I $destip",$tracearray);
    return $tracearray;  
}

// end of finding gateway functions


function getmacfromtelnet($routerip,$username,$password,$ostype,$ipaddress){
// this function gets the arptable by telneting into the router and do 
// a "show ip arp ip address" then return the mac address
// this might be able to be speed up	
	$command="show ip arp ".$ipaddress;
	$data=getdatafromdevice($routerip,$username,$password,$command,$ostype);
	$data=cleandata($data,$command,$ostype);
	$rawtablearray=explode("\n",$data); // breaks the string to array units per line
	$title=array_shift($rawtablearray); // take out the title
	
	   $line=$rawtablearray[0];
	   $parts=preg_split( "/ +/", $line ); // perl expression split
	   $mac=str_replace(".","",$parts[3]);
	   echo "MAC: $mac = IP: $ipaddress <br>";	
		
        return $mac; // returns mac address
}

function str_split($chaine, $length=1)
{ $retour= FALSE;
  $incrmt= (int)$length;
  if (0 < $incrmt)
  { $retour= array();
    $offset= 0;
    $limite= strlen($chaine);
    while ($offset < $limite)
    { $retour[]= substr($chaine, $offset, $incrmt);
      $offset += $incrmt;
    }
  }// if (0 < $incrmt)
  return ($retour);
}

function convertmac ($mac, $typeofos){
// converts xxxxxxxxxxxx to 
//   xx-xx-xx-xx-xx-xx for catos
// or
//   xxxx.xxxx.xxxx for ios

  if ($typeofos=="catos"){
      $macarray=str_split($mac, 2);
      $output=implode ("-",$macarray);
  }else{
      $macarray=str_split($mac, 4);
      $output=implode (".",$macarray);
  }
  
  return $output; // converted mac address	
}


function locatethismac ($username,$password,$device,$typeofos,$mac){
// This function locate the mac address and returns an array of the port and ip
 
  $mac = convertmac ($mac,$typeofos); 
  if ($typeofos=="catos"){
       $command="show cam $mac";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       // $ndata=str_replace("\n","<br>",$data);
       // echo "$ndata <br>";
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$mac /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression split
       $port=$parts[2];
  }elseif ($typeofos=="L3IOS"){
       $command="show bridge $mac";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       // $ndata=str_replace("\n","<br>",$data);
       // echo "$ndata <br>";
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$mac /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression split
       $port=$parts[2];
  }elseif ($typeofos=="2950/3550"){   
       $command="show mac-address-table";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$mac /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression split
       $port=rtrim($parts[4]);
  }elseif ($typeofos=="C1900"){   
       $command="show mac address $mac";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       $data=cleandata($data,$command,$ostype);
       $mac=strtoupper($mac);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$mac /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression split
       $port=$parts[1].$parts[2];
  }else {
       $command="show mac address $mac";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       // $ndata=str_replace("\n","<br>",$data);
       // echo "$ndata <br>";
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= implode ("",preg_grep ("/$mac /", $list));
       $parts=preg_split( "/ +/", $line ); // perl expression splitf
       $port=rtrim($parts[3]);
       
  }
  
  if ($port=="") {
      echo "<font color=\"#FF0000\"><b>Can not find MAC address in $device</b></font> <br>";
      exit ("Try another Seed Device<br><br>");
  }else { 
    $oneport=explode("-",$port); // ignore trunking in catos ex. 2/1-2 will only be 2/1
    $nextip=get_cdp_neighbor($username,$password,$device,$typeofos,$oneport[0]);
    echo "$port	";  // display port on the switch
  }
  	
  
  return $nextip;
}


function get_cdp_neighbor($username,$password,$device,$typeofos,$port){
       
       
       if (strstr($port,"BVI")){
         return $device;
       }elseif (strstr($port,"Vlan")){
       	    $port="";
       }
       $command="show cdp neighbor $port detail";
       $data=getdatafromdevice($device,$username,$password,$command,$typeofos); // get the info
       $data=cleandata($data,$command,$ostype);
       $list=explode("\n",$data);
       $line= preg_grep ("/IP Address: | IP address: /", $list);
       $line=implode("",$line);
       $parts=preg_split( "/ +/", $line ); // perl expression split
       $nextip=$parts[3];
       return $nextip;
}

function getostypebysnmp($deviceip,$cstring){
// This function uses snmp to get the switch type
// default switch type is IOS
   
    $ostypeoid=".1.3.6.1.2.1.1.1.0";
    $rawosdata=snmpget($deviceip, $cstring,$ostypeoid);
    if (strstr($rawosdata,"L3")){
       $output="L3IOS";
    }elseif(strstr($rawosdata,"1900")){
       $output="C1900";	
    }elseif(strstr($rawosdata,"Catalyst")){
       $output="catos";
    }elseif(strstr($rawosdata,"2950")||strstr($rawosdata,"3550")){
       $output="2950/3550";
    }elseif(strstr($rawosdata,"3500")||strstr($rawosdata,"2900")){
       $output="ios";
    }else {
       $output="ios";
       echo " <font color=\"#FF0000\"><b>UNKnown Switch type </b></font><br>";
       echo " email me the text below <br>";
       echo " $rawosdata <br>";
    }
    
    return $output;
}

function getostype($username,$password,$device,$ostype){
// old method of getting os type
    $command="xxx";
    $data=getdatafromdevice($device,$username,$password,$command,$ostype);
    $data=cleandata($data,$command,"1");
    $array=explode("\n",$data);
    $ostype=array_pop($array);
    return $ostype;
}

function cleandata($incoming,$cmd,$os) {
// remove all header for clean data section
  $in_array=explode("\n",$incoming);
  $out=array();
  $found="";
  $typeofos="";
  foreach ($in_array as $in){
     if (!$found){
        $parts=explode("#",$in);
        $cmd=rtrim($cmd);
	$part=rtrim($parts[1]);
        if ($part==$cmd){
	  $found="1";
	  $typeofos="ios";
	  }else{
	   $parts=explode("(enable)",$in);
           $part=trim(rtrim($parts[1]));
           if ($part==$cmd){
	   $found="1";
	   $typeofos="catos";
	   }
	  }
	}else{
	   array_push($out,$in);
	}
  }

  if (!$found) {
       echo "ERROR : BAD LOGIN OR PASSWORD";
       $incoming=preg_replace("/\n/","<br>",$incoming);
       echo "<br> ERROR DEBUG <br>";
       echo " if this is the first time you get this message hit GO GET IT AGAIN <br>";
       echo " if you continue to get is message plese email me the text below so <br>";
       echo " I can debug the script <br>";
       echo "<b>Please email me this error so I can fix the issue</b> <br>";
       echo $incoming; // print $res
       echo "<br> END OF ERROR DEBUG <br>";
       var_dump($res);
       exit("Cant find enable maybe timed out due to slow response from the device <br> \n");
  }
  if ($os) {
     array_push($out,$typeofos);
  }
  $output=implode("\n",$out);
  return $output; // clean data list
} //end cleandata



function getdatafromdevice($device,$username,$password,$command,$ostype){
// This function gets the data from the device via port 23 aka telnet

  $enablepw=$GLOBALS["enablepw"];
  if ($device != ""){
      $fp = fsockopen($device, 23,$errno, $errstr, 1);
      
     }

  if(!$fp){    
  	echo "Impossible to connect because : <br> $errstr <br>\n"; //can't connect
        exit ("Please Enter a Valid IP ADDRESS <br> \n");         
  } else {
      // logging in get info
      if ($ostype=="C1900"){  // special case c1900s
      	 socket_set_timeout($fp, 30);
      	 sleep(20);
      	 fputs ($fp, "k \n");
         fputs ($fp, "enable \n");
         fputs ($fp, $enablepw);
         //fputs ($fp, "\n");
         //fputs ($fp, "\n");
         //fputs ($fp, $consolepw);
         fputs ($fp, "\n");
      }else {
       socket_set_timeout($fp, 10);
       fputs ($fp, "\n");
       fputs ($fp, "\n");
       fputs ($fp, "\n");
       fputs ($fp, "\n");
       fputs ($fp, "\n");
       fputs ($fp, "\n");
       fputs ($fp, $username);
       fputs ($fp,"\n");
       fputs ($fp, $password);
       fputs ($fp,"\n");
      
       sleep(1);  // may need it if it don't work right
       if ($ostype=="catos") {
         fputs ($fp, "set length 0 \n");
  	 } else {
            fputs ($fp, "terminal length 0\n");
         }
       fputs ($fp, "\n");
       fputs ($fp, " enable \n");
       fputs ($fp, $password);
       fputs ($fp,"\n");
      }
      fputs ($fp, $command);
      fputs ($fp,"\n");
      fputs ($fp, " exit\n");
      $res = fread($fp, 100000);
      fclose($fp);
      }
   return $res;
 }



?>