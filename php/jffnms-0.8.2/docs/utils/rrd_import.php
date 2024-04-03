<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../conf/config.php");
    
    echo "<PRE>";
    
    $start = 1021557600;
    $end = 1021576800;

    $query = "select id from interfaces where poll > 1 and id = 3";
    $result = db_query($query);
    
    while ($record = db_fetch_array($result)) {
	extract($record);
	
	$file = "$rrd_real_path/interface-$id.rrd";
	$file1 = "$rrd_real_path/interface-$id.rrd.aux";
	
	$aux = "/tmp/interface-$id.rrd.xml";
	$aux2 = "/tmp/interface-$id.rrd.xml.new";
	
	unlink($aux);
	exec("$rrdtool_executable dump $file > $aux");
	
	$ok=0;
	unset($new_files);

	$fp = fopen ($aux,"r");
	$fp2 = fopen ($aux2,"w+");
	
	$insert = file ($file1);
	
	while ($line = fgets($fp,4096)) {

	    if ($ok==1) {
		$date = trim(substr($line,strpos($line,"/")+2,strpos($line," -->")-strpos($line,"/"))-2);

		//echo "$date\n";

		if (($date >= $start) && ($date <=$end)) { 
		    $line = $insert[$i++];
		    echo $line;
		} 
		

		if (strpos($line,"</database>") > 1) $ok=0;

	    } else if (strpos($line,"<database>") > 1) $ok=1;
	
	    fwrite($fp2,$line);
	}
	
	fclose($fp);
	fclose($fp2);
	unlink($aux);

	exec("$rrdtool_executable restore $aux2 $file.new");

	unlink($aux2);

	exec("chown apache.apache $file.new");
	exec("cp -f $file $file.old");
	exec("cp -f $file.new $file");
	die();
    }

?>