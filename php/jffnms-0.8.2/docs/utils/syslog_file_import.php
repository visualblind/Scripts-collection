<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//This tool is for importing OLD syslog files to the JFFNMS DB.

    $fcont = file($argv[1]);
    $host = $argv[2];
    
    foreach ($fcont as $line) { 
	$pos1 = strpos($line,"16 ")+3;
	$pos2 = strpos($line,": ");
	$date = substr($line,$pos1,$pos2-$pos1);
	$date2 = "2002-05-16 ".$date;
	$date_unix = strtotime($date2);
	$date3 = date("Y-m-d H:i:s",$date_unix);
	
	$line = substr($line,0,strlen($line)-1);	
	$query = "insert into syslog (host,date,date_logged,message) VALUES ('$host','$date3','$date3','$line');";
	//echo "$date - $date2 - $date3 - $line\n";
	echo "$query \n";   
    }

?>

