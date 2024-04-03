<?
/*
	This is a example of loading from a saved session with a bot
	and working on that information.
*/
$dir = getcwd();
include "../config.php";
include "../protocol.php";
include "../protomap.php";
include "../mysql.php";

$savedsession = "$dir/slsksession.dat";

debug("loading session");
$session = dataload($savedsession);
debug("session loaded");

decodepacket(67, 4, $session[67][0]);

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
?>
