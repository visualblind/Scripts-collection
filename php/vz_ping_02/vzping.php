<?php
/*
Vz Ping 0.2 by Luca Penzo March 2003
email <fedro@linux.it>
web http://vz.webhop.net/

USE of the script :
Simply include this script in another PHP page (or an html with SSI enabled)
I wrote this script to know what machines are connected in my LAN simply opening a web page
To use it your PHP must be able to execute shell scripts
If it doesn't work , try writing the complete absolute path to your ping program
Maybe you have to modify the script according to your ping software
The ip address must be pingable !!! Otherway you'll not have any ON or OFF option

GPL License
*/

////////// CONFIGURATION /////////////////
$ips_array=array("PC_1_NAME:192.168.x.x","PC_2_NAME:192.168.x.x","PC_3_NAME:192.168.x.x"); // you have to write here a descriptive name for every PC to be monitored and its IP address --> name:ipaddress
////////// END OF CONFIGURATION //////////
function ping($PC,$ip){
$cmd=shell_exec("ping -c 1 -w 1 $ip");

  $dati_mount=explode(",",$cmd);
  if (eregi ("0", $dati_mount[1], $out)) {$connesso="<img src=\"off.gif\">";}
  if (eregi ("1", $dati_mount[1], $out)) {$connesso="<img src=\"on.gif\">";}
  $esito="$connesso [$ip] <b>$PC</b><br>";
return $esito;
}

while(list($k,$v)=each($ips_array)){
 $dati_ip=explode(":",$v);
 $esito=ping($dati_ip[0],$dati_ip[1]);
 echo $esito;
}
?>

