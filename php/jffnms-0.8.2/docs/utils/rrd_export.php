<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../conf/config.php");
    
    echo "<PRE>";
    
    $start = 1021557600;
    $end = 1021576800;

    $query = "select id from interfaces where poll > 1";
    $result = db_query($query);
    
    while ($record = db_fetch_array($result)) {
	extract($record);
	
	$file = "$rrd_real_path/interface-$id.rrd";
	$aux = "/tmp/interface-$id.rrd.xml";
	
	unlink($aux);
	exec("$rrdtool_executable dump $file > $aux");
	
	$ok=0;
	unset($new_lines);

	$fp = fopen ($aux,"r");
	
	while (($line = fgets($fp,4096)) && ($ok != 2)) {

	    if ($ok==1) {
		$date = trim(substr($line,strpos($line,"/")+2,strpos($line," -->")-strpos($line,"/"))-2);

		//echo "$date\n";

		if (($date >= $start) && ($date <=$end)) { 
		    $new_lines[]=$line;
		    echo $line;
		}

		if (strpos($line,"</database>") > 1) $ok=2;

	    } else if (strpos($line,"<database>") > 1) $ok=1;
	}
	
	fclose($fp);
	unlink($aux);

	$fp = fopen("$file.aux","w+");
	foreach ($new_lines as $line) fputs($fp,$line);
	fclose($fp);

    }

?>