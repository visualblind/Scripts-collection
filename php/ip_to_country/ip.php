<?php
if (getenv(HTTP_X_FORWARDED_FOR)=="") {
$ip = getenv(REMOTE_ADDR);
}
else {
$ip = getenv(HTTP_X_FORWARDED_FOR);
}
$numbers=explode (".",$ip);
$code=($numbers[0] * 16777216) + ($numbers[1] * 65536) + ($numbers[2] * 256) + ($numbers[3]);    
$lis="0";
$user = file("data.dat");
for($x=0;$x<sizeof($user);$x++) {
$temp = explode(";",$user[$x]);
$opp[$x] = "$temp[0];$temp[1];$temp[2];$temp[3];$temp[4];";
if($code >= $temp[0] && $code <= $temp[1]) {
$list[$lis] = $opp[$x];
$lis++; 
}
}
if(sizeof($list) != "0") {
for ($i=0; $i<sizeof($list); $i++){
$p=explode(';', $list[$i]);
echo "You are from $p[4]";
}
}else{echo "Unable to determine your country"; }
?>
