<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../conf/config.php");

    $cant_part=45;
    $readsize=15000;
    
    $process_data_func = "process_data2";
    $read_file_func = "read_file2";

    $cant_lines = 0;
    
    function process_line($fps,$filename,$ds_name,$line,$cant_ds,$save_ds,$new_lines,$last_update,$ds) {
	    //if ($GLOBALS[cant_lines] >= 10000) return 1;
	    $GLOBALS[cant_lines]++;
	    //echo "$line\n";
	    //var_dump($line);
	    $pos = strpos($line,"<v>");
	    $pos1 = strpos($line,"<lastupdate>");
	    
	    if ($pos1!==false) $last_update=$line;	
	    
	    if ($line=="<ds>") $save_ds = 1;
	    else 
		if ($line=="</ds>") { 
		    $save_ds = 0;
		    $fps[$cant_ds] = prepare_ds ($filename,$ds_name,$ds[$cant_ds],$last_update,$cant_ds);
		    $cant_ds++;
		} else 
		    if (($save_ds==1) && (strpos($line,"<name>") === false) )
			$ds[$cant_ds].=$line;
	
	    if ($pos!==false) $new_lines[]=$line;

	    $cant_new_lines = count($new_lines);
	    $cant_part = $GLOBALS[cant_part];
	    //$cant_part = 10;

	    if (($cant_new_lines > 1) && ($cant_new_lines%$cant_part==0))  
		$GLOBALS[process_data_func](&$fps,$filename,&$new_lines,$cant_part,&$cant_ds);    
	    
    }    

    function read_file2 ($fps,$filename,$ds_name,$interface_id) {
	
	$fp = fopen($filename,"r");
	$filename = $GLOBALS[rrd_real_path]."/interface-".$interface_id;
	$cant_ds=0;
	$save_ds=0;
	$new_lines = array();
	$line = "";
	$aux = "";
	$pos = 0;
    	while (!feof($fp)) {
	    if ($pos==0) {
		$aux = fread($fp,$GLOBALS[readsize]);
		echo ".";
	    }
	    
	    $pos = strpos ($aux,"\n");

	    if ($pos===false) {
		$pos = 0;
		echo "|";
	    } else {
		$pos1=true;
		while ($pos1!==false) {
		    $pos1 = strpos($aux,"\n");
		    $temp = substr($aux,0,$pos1);
		    $new_line = trim($line.$temp);
		    unset($line);

		    //echo "\npos: $pos\npos1: $pos1\nline: $line\naux: $aux\ntemp: $temp\nnew_line: $new_line\n";
	
		    //if ($new_line=="<rra>") break;
		    if ($new_line=="</rra>") {$b = 1; break;}
		    if ($new_line) $b = process_line(&$fps,$filename,$ds_name,$new_line,&$cant_ds,&$save_ds,&$new_lines,&$last_update,&$ds);

		    $aux = substr($aux,$pos1+1,strlen($aux));
		}
		$pos =0;
		if ($b==1) break;
	    }
	    //echo "\n1\npos: $pos\npos1: $pos1\nline: $line\naux: $aux\ntemp: $temp\nnew_line: $new_line\n";
	    $line .= substr($aux,0,strlen($aux));
	}	
	unset($new_lines);
	fclose($fp);
	return count($ds);
    }

    function process_data2 ($fps,$filename,$new_lines,$cant_part,$cant_ds) { 
	$data = array_splice($new_lines,0,$cant_part);
	for ($i = 0; $i < $cant_part; $i++) {
	    $pos2 = 0;    
	    $line = $data[$i];
	    $j = 0;
	    
	    while ($pos2!==false) {
		$line = substr($line,$pos2,strlen($line));

		$pos1 = strpos($line,"<v>")+3;
		$pos2 = strpos($line,"</v>");
	
		if ($pos2!==false) {
		    $value = trim(substr($line,$pos1,$pos2-$pos1));
	
		    fputs($fps[$j++],"<row><v>$value</v></row>\n");
		    $pos2 = $pos2+3;
		}
		//var_dump($line);
		//var_dump($pos1);
		//var_dump($pos2);
		//var_dump($value);	
	    }
	    unset ($data[$i]);
	}
	echo "!";
	flush();
    }


    function prepare_ds ($filename,$dsname,$definition,$last_update,$ds) {
	    //echo "Creating file $filename-$dsname-$ds...\n";
	    echo "$ds";
	    $fp = fopen ("$filename-$dsname-$ds","w+");
	    fputs($fp,"<rrd>\n<version>0001</version>\n<step>300</step>\n$last_update\n");
	    fputs($fp,"<ds>\n<name>data</name>\n$definition</ds>\n");
	    fputs($fp,"<rra>\n<cf>AVERAGE</cf>\n<pdp_per_row>1</pdp_per_row>\n<xff>5.0000000000e-01</xff>\n<cdp_prep>\n<ds><value>NaN</value><unknown_datapoints>0</unknown_datapoints></ds></cdp_prep>\n<database>\n");
	    return $fp;
    }

    function finish_ds ($fp,$filename,$dsname,$ds) {
	    $rrdfile= "$filename-$ds.rrd";
	    $xmlfile= "$filename-$dsname-$ds";
	    echo "$ds";
	    //echo "Finishing file $xmlfile...\n";
	    fputs($fp,"</database>\n</rra>\n</rrd>\n");
	    fclose($fp);
	
	    if (file_exists($rrdfile)) unlink ($rrdfile);
	    rrdtool_restore ($rrdfile,$xmlfile);
	    unlink ($xmlfile);
    }

    
    function start ($filename,$interface_id) {
	global $fps,$read_file_func,$cant_lines;
	
	$dsname="ds";
	$start = gettimeofday();
    
	$cant_ds = $read_file_func(&$fps,&$filename,$dsname,$interface_id);
	$end = gettimeofday();
    
	for ($i = 0; $i < $cant_ds; $i++)
	    finish_ds ($fps[$i],$filename,$dsname,$i);
    
	$elapsed = (($end[sec]*1000000)+$end[usec]) - (($start[sec]*1000000)+$start[usec]);
	$elapsed_sec = $elapsed / 1000000; $elapsed_sec_round=round($elapsed_sec,2);
        $elapsed_min = $elapsed_sec / 60; $elapsed_min_round=round($elapsed_min,3);
	$lines_per_sec = round($cant_lines / $elapsed_sec,2);
    
	echo "\nElapsed: $elapsed usec - $elapsed_sec_round sec - $elapsed_min_round min \nLines: $cant_lines\nLines Per Second: $lines_per_sec\n";
    }


    $query = "select id from interfaces where rrd_mode = 1 and id > 1";
    $result = db_query($query);
    set_time_limit(0);
    $fps = array();
    
    while ($rec = db_fetch_array($result)) {
	$interface_id = $rec[id];
	$filename_xml = "$rrd_real_path/interface-$interface_id.xml";
	$filename_rrd = "$rrd_real_path/interface-$interface_id.rrd";

	echo "\n\nStarting Interface $interface_id, file $filename_xml\n";

	if (file_exists($filename_rrd)) { //old .rrd exists
	    rrdtool_dump($filename_rrd,$filename_xml);

	    if (file_exists($filename_xml)) { //dump is ok?
	
		start ($filename_xml,$interface_id);

		if (file_exists("$rrd_real_path/interface-$interface_id-0.rrd")) { //upgrade ok
		    $errors["Upgrade OK"]++;
		    db_query("update interfaces set rrd_mode = 2 where id = $interface_id");
		    unlink($filename_rrd); //old rrd

		} else {
		    $errors["Problem in Upgrade"]++;
		    echo "Problem Upgrading, check if you have Free Disk Space\n";
		}
		unlink($filename_xml); //xml dump

	    } else {
		echo "RRD DumpFile $filename_xml not found, probably you dont have rrdtool setup fine, rerun /admin/setup.php\n";
		$errors["Dump Not Found"]++;
	    }
	} else {
	    echo "File $filename_rrd not found... don't worry, it's not a problem.\n";
	    $errors["RRD File Not Found"]++;
	}
    }
    ksort($errors);
    var_dump($errors);
?>
