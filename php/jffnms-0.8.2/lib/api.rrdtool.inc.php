<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function rrdtool($method,$file,$opts,$force_no_module = 0) {
	global $rrdtool_executable;

	$error=0;
	$ret = 1;
	if (extension_loaded("RRDTool") && ($force_no_module==0)) { //DEPRECATED
	    if (is_array($opts)) foreach ($opts as $key=>$data) $opts[$key] = str_replace("'","",$data);

	    switch ($method) {
		case 'graph'  : $ret = @rrd_graph ($file,$opts,count($opts)); 
				if (!is_array($ret)) $error=1;  
				break;
	
		case 'update' : $ret = @rrd_update($file,$opts); 
				if ($ret==0) $error=1; 
				break;
	
		case 'create' : $ret = @rrd_create($file,$opts,count($opts)); 
				if ($ret==0) $error=1; 
				break;
		case 'fetch'  : $ret = @rrd_fetch($file,$opts,count($opts));
				if (!is_array($ret)) $error=1;
				break;
		case 'last'   : $ret = @rrd_last($file);
				if ($ret < 0) $error=1;
				break;
	    }
	} else {

	    if (get_config_option("os_type")=="windows")
        	if (is_array($opts))
            	    foreach ($opts as $key=>$data) { //windows
                	$opts[$key] = str_replace("'","\"",$opts[$key]);
                        $opts[$key] = str_replace(":/","\:/",$opts[$key]);
                    }

            if (is_array($opts)) $aux = join($opts," ");
                else $aux = $opts;

	    $use_pipe = false;
    
            if (get_config_option("os_type")=="windows")
                $command = $rrdtool_executable." ".$method." \"".$file."\" ".$aux;
            else {
                $command = $rrdtool_executable." ".$method." '".$file."' ".$aux;

		//Check if we can use the new Piped/Managed RRDTool method
		if (!isset($GLOBALS["rrdtool_not_use_pipe"]) && function_exists("proc_open")) 
		    $use_pipe = true;
	    }
	    
	    //debug($command);
	    	
	    if ($use_pipe)
		list ($ret1, $ret2) = rrd_pipe($method." '".$file."' ".$aux);
	    else
	        exec($command,$ret1,$ret2);
		
	    //debug($ret1);
	    //debug($ret2);
	    	    
	    if ($method=="fetch") {
		$start=0;
		reset ($ret1);
		$ret = false;
		
		if (count($ret1) > 1)
		    while (list ($key,$line) = each ($ret1)) 
	    		if (!empty($line)) {

			    $line1 = explode(" ",$line);

			    if (strpos($line,":") > 0) {

				for ($i = 1; $i < count($line1); $i++)			// Part 1 is timestamp
				    if ($line1[$i]!=="") 					// Part 2 maybe is a space
					$value[] = ($line1[$i]=="nan")?0:(float)$line1[$i]; // Part 3 (or 2) has the data
	
				$date = (int)$line1[0];					// Time Stamp
                    	        if (!isset($stop)) $stop=0;
			        if ($date > $stop) $stop = $date;
				if (($date < $start) or ($start==0)) $start = $date;
	
			    } else { 
				foreach ($line1 as $aux) 
				    if (!empty($aux) && ($aux!="timestamp")) 		// Avoid the timestamp as a DS (rrdtool >= 1.0.49)
					$ds_namv[]=trim($aux);

				$ds_cnt = count($ds_namv);
			    }
			    unset($ret1[$key]);
			}

			$ret = array("start"=>$start,"end"=>$stop,"step"=>300,"ds_cnt"=>$ds_cnt,"ds_namv"=>$ds_namv,"data"=>$value);
			//var_dump($ret);
	    }

	    $ret2 = 0; //FIXME why update goes bad with satellites
	    	
	    if (file_exists($file)==TRUE)	    
		switch ($method) { 
		    case 'graph' :  if (count($ret1) < 1	) { $error=1; $ret = $ret1; $info = $command; } else $ret = $ret1; break;
		    case 'update':  if ($ret2 != 0		) { $error=1; $ret = 0; } break;
		    case 'create':  if ($ret2 != 0		) { $error=1; $ret = 0; } break;
		    case 'last'  :  if ($ret2 != 0		) { $error=1; $ret = 0; } else $ret = $ret1[0]; break;
		    case 'fetch' :  if ($ret2 != 0		) { $error=1; $ret = 0; } break;
		    case 'tune'  :  if ($ret2 != 0		) { $error=1; $ret = 0; } break;
		}
	    else $ret = FALSE;
	}
	
	if ($error==1) echo("rrd_$method() ERROR: ".rrdtool_error($info));
	return $ret;
    }

    function rrdtool_graph($file,$opts) {
	return rrdtool("graph",$file,$opts);
    }

    function rrdtool_tune($file,$opts) {
	if (file_exists($file)===TRUE) return rrdtool("tune",$file,$opts,1);
	return FALSE;
    }

    function rrdtool_fetch($file,$opts) {
	return rrdtool("fetch",$file,$opts);
    }

    function rrdtool_last($file) {
	return rrdtool("last",$file,NULL);
    }

    function rrdtool_update($file,$opts) {
	return rrdtool("update",$file,$opts);
    }

    function rrdtool_create($file,$opts) {

	if ($result = rrdtool("create", $file, $opts) && (get_config_option("os_type")=="unix")) 
	    chmod ($file, 0660);
	    
	return $result;
    }

    function rrdtool_dump($file,$to) {
	return rrdtool("dump",$file," > $to");
    }

    function rrdtool_restore($file,$from) {
	return rrdtool("restore",$from,$file);
    }

    function rrdtool_error($info = NULL) {
	if (extension_loaded("RRDTool")) return rrd_error(); 
	else return $info;
    }

    function rrd_grapher($id, $graph_function, $sizex, $sizey, $title, $graph_time_start, $graph_time_stop, $aux = "") {

	if (($graph_function) && ($id)) {

	    $interface_data = interfaces_list($id);
	    $rrd_path = get_config_option("rrd_real_path");
	    
	    foreach ($interface_data as $int_id=>$aux1) 
    		$interface_data[$int_id]["filename"] = $rrd_path."/interface-".$int_id.".rrd";
	    
	    if (count($interface_data)==1) $interface_data=current($interface_data);
	    $function_data=$interface_data;
	    $function_data["id"]=$id;

	    $title = str_replace("'","",$title);	// ' fix

	    $start = $graph_time_start;
	    $end = $graph_time_stop;

	    if ($end==0) $end -= (7*60);	//if it was 0, then substract 7 minutes to be sure there's data

	    //debug ($graph_time_stop." = ".date("Y-m-d H:i:s", $graph_time_stop));
	    //debug ($end." = ".date("Y-m-d H:i:s", $end));
	    
	    //This is only used for N Percentile calculation
	    if ($aux == "get_graph_data")  		//if we were asked for the extra data (Export to CSV data points)
		$function_data["other_data"] = $aux;	//pass the request to the graph (traffic.inc.php)

	    $function_data["rrd_grapher_time_start"] = $start;
	    $function_data["rrd_grapher_time_stop"] = $end;
	    
	    $opts_header = array( 
		"--imgformat=PNG",
	    	"--start=".$start,
		"--end=".$end,
    		"--base=1000",
		"--lower-limit=1",
		"--title='".$title."'",
		"--alt-autoscale-max", 
		"--color=GRID#CCCCCC",
		"--color=MGRID#777777",
		"--height=".$sizey,
		"--width=".$sizex
	    );

    	    $real_function = "graph_".$graph_function;
	    $function_file = get_config_option("jffnms_real_path")."/engine/graphs/".$graph_function.".inc.php";

	    if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file))) ) {
	
		if (function_exists($real_function))
		    list($graph_header, $graph_definition, $other_data) = call_user_func_array($real_function,array($function_data));
		else 
		    logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
	    } else 
		logger ("ERROR Loading file $function_file.<br>\n");

	    
	    $opts = @array_merge(
			$opts_header,
			(($aux=="MINI")
			    ?array("--no-legend","--alt-y-mrtg")
			    :$graph_header),
			$graph_definition);
	    
	    $graph_filename = get_config_option ("engine_temp_path")."/".uniqid("").".dat"; //generate random graph filename
	    
	    $ret = rrdtool_graph($graph_filename, $opts);
	    
	    if (($aux!="MINI") && ($ret!=FALSE)) rrdtool_add_legend($graph_filename);

	    if ($aux != "get_graph_data") 	//if we were not asked for the extra data (currently 95 percentile data points)
		unset ($other_data);		// do not return it.

	    if (file_exists($graph_filename)===TRUE) { //read the File
		$fp = fopen($graph_filename,"rb");
		$graph_data = fread($fp,filesize($graph_filename));
		fclose($fp);
		unlink ($graph_filename); //delete file
		$graph_data = base64_encode ($graph_data);
	    }
	    
	    return array($ret, $graph_data, $other_data);
	}
    }
    
    function rrdtool_add_legend ($file, $type = 3) {
	$im = ImageCreateFromPNG($file);
	if ($im) {
	    switch ($type) {
		case 1:  
		    $legend = "http://jffnms.org JFFNMS";
		    break;
		case 2:
		    $legend = "JFFNMS";
		    break;
		case 3:
		    $legend = get_config_option("jffnms_site")." JFFNMS";
		    break;
	    }
	    $legend = trim($legend);
	    $len = strlen($legend)*7;
	    $posy = round((imagesy($im)*(0.5))+($len*0.5))+43;
	    ImageStringUP($im,3,imagesx($im)-15,$posy,$legend,ImageColorAllocate($im,150,150,150));

	    ImagePNG($im,$file);
	    ImageDestroy($im);
	}
    }

    function rrdtool_fetch_ds ($id,$dsnames,$from,$to) {
	if (!is_array($dsnames)) $dsnames = array($dsnames);
	
	$file = $GLOBALS["rrd_real_path"]."/interface-$id.rrd";
	$interface=current(interfaces_list($id));

	$type_info = interface_get_type_info($id);
	$all_dss = interface_parse_rrd_structure($type_info["rrd_structure_def"]);
	$rra = rrdtool_parse_rra($type_info["rrd_structure_rra"]);

	$opts = array ( $rra, "--start=$from", "--end=$to" );

	if ( ($interface["rrd_mode"] == 1) && (file_exists($file)===TRUE) ) {
		$ret = rrdtool_fetch($file, $opts);
		for ($i = 0; $i < count($ret["data"]);$i+=$ret["ds_cnt"]) 
		    foreach ($dsnames as $dsname)
			if (strlen($all_dss[$dsname]) > 0)
			    $values[$dsname][]=round((int)($ret[data][$i+$all_dss[$dsname]]),2);
	}
	
	if ($interface["rrd_mode"]==2) {
	    foreach ($dsnames as $dsname) {
		$dsn = $all_dss[$dsname]; 
		$file_ds = str_replace(".rrd","-$dsn.rrd",$file);
		if (file_exists($file_ds)===TRUE) {
		    $ret = rrdtool_fetch($file_ds, $opts);
		    for ($i = 0; $i < count($ret["data"])-1;$i+=$ret["ds_cnt"])
			if (isset($ret["data"][$i]))
			    $values[$dsname][]=round((int)($ret["data"][$i]),2);
		}
	    }	    
	}
	
	if (is_array($values)) {
	    $values["information"]["start"]=$ret["start"];
	    $values["information"]["stop"]=$ret["end"];
	}

	return $values;
    }

    //FIXME this is too specific for Physical Interfaces
    function get_rrd_rtt_pl ($id,$from,$to,$threshold,$bwin_db,$bwout_db,$flipinout){
	
	$values = rrdtool_fetch_ds($id,array("input","output","rtt","packetloss","bandwidthin","bandwidthout"),$from,$to);
	//debug ($values); die();
	
	$rtt_final_avg = 0;
	$pl_final_avg = 0;
	$cant_pings=50;
 
	if ( is_array($values) ) {

	    if ($flipinout==1) { //flip in/out
		$values[temptemp]=$values[input];
		$values[input]=$values[output];
		$values[output]=$values[temptemp];
		unset($values[temptemp]);
	    }

	    $cant_values = count ($values[input]);
	    for ($i = 0; $i < $cant_values ; $i++) {
	    
		$in = $values[input][$i]*8; //convert to bits (same as bandwidth)
    		$out = $values[output][$i]*8; //convert to bits (same as bandwidth)
		$rtt = $values[rtt][$i];
		$pl_orig = $values[packetloss][$i]; //0 - 50
		$pl = round($pl_orig*(100/$cant_pings));
		$bwin_rrd = $values[bandwidthin][$i]*8;
		$bwout_rrd = $values[bandwidthout][$i]*8;

		if ($rtt > 100000) $rtt = 0; // if data was not valid (100sec RTT is not posible)

		//if we have bandwidth ds's then use then, otherwise take the parameters.		
		if ($bwin_rrd > 0)   $bwin  = $bwin_rrd;  else $bwin  = $bwin_db;
		if ($bwout_rrd > 0) $bwout = $bwout_rrd; else $bwout = $bwout_db;
		
		//if is lower than the max threshold
		if ( ($rtt > 0) and ($in >0) and ($out > 0) ) { //valid values
		    $parsed++;
		    if (($in < ($threshold*$bwin/100)) and ($out < ($threshold*$bwout/100))) { //in threshold
			$result[]=Array(rtt=>$rtt,pl=>$pl);
			$counted=1;
		    } else 
			$counted = 0;
		}

		//debug("$id \t $in \t $out \t $rtt \t $pl \t ($bwin($bwin_rrd) - $bwout($bwout_rrd) - $threshold) \t $counted");
	
		unset($values[input][$i]);
		unset($values[output][$i]);
		unset($values[rtt][$i]);
		unset($values[packetloss][$i]);
	    }

	    $cant = count($result);
	    if ($cant > 0) {
		while (list ($key,$value) = each ($result)) {
		    $rtt_final += $value["rtt"];
		    $pl_final += $value["pl"];
		    unset ($result[$key]);
		}	    
		$rtt_final_avg = round($rtt_final/$cant);
		$pl_final_avg = round($pl_final/$cant,2);
	    } 
	    
	}

	//debug ("Total in Result: $cant_values");
	//debug ("Total Parsed: $parsed");
	//debug ("Total in Threshold: $cant");
    	return array("id"=>$id, "rtt"=>$rtt_final_avg, "pl"=>$pl_final_avg);
    }

    function rrdtool_parse_rra($info) {
	$aux = explode (":",$info);
	return $aux[1];
    }

    function rrdtool_get_def($interface,$dss) {
	if (!is_array($dss)) $dss = array($dss);
	$id = $interface["id"];
	$type_info = interface_get_type_info($id);

	$all_dss = interface_parse_rrd_structure($type_info["rrd_structure_def"]);
	$rra = rrdtool_parse_rra($type_info["rrd_structure_rra"]);

	foreach ($dss as $dsname => $ds) {
	    if (is_integer($dsname)) $dsname = $ds;
	    $dsn = $all_dss[$ds];
	    
	    if ($dsn!==NULL) { //if DS exists 
		$filename_ds = str_replace(".rrd","-$dsn.rrd",$interface["filename"]);

		if ($interface["rrd_mode"]==1) $dss_def[$dsname]="DEF:$dsname=".$interface["filename"].":$ds:$rra";
		if ($interface["rrd_mode"]==2) if (file_exists($filename_ds)) $dss_def[$dsname]="DEF:$dsname=$filename_ds:data:$rra";
	    }
	}
	//debug ($dss_def);
	return $dss_def;
    }

    function rrdtool_create_file($filename,$def,$rra,$res,$step) {

	$step = "--step $step"; 

	//replace data

	$opts = trim("$step $def $rra");
	$opts = str_replace("\n","", $opts);
	$opts = str_replace("  "," ",$opts);
        $opts = str_replace("<resolution>",$res,$opts);
	$ret = rrdtool_create($filename, explode(" ",$opts));
        return $ret;
    }

    function rrd_pipe ($command) {
	if (!is_array($GLOBALS["rrd_pipe"])) {
	    $GLOBALS["rrd_pipe"]["resource"] = 
		proc_open(get_config_option("rrdtool_executable"). " -", 
		    array(0=> array("pipe","r"), 1=>array("pipe","w")), $GLOBALS["rrd_pipe"]["pipe"]);
	    $GLOBALS["gc_save_vars"]["rrd_pipe"]=true;
	}
	
	fwrite($GLOBALS["rrd_pipe"]["pipe"][0], $command."\n");
	
	stream_set_blocking($GLOBALS["rrd_pipe"]["pipe"][1], false);

	while (($ret1!==false) || empty($ret)) {
	    usleep(10);
	    $ret1 = fgets($GLOBALS["rrd_pipe"]["pipe"][1]);

	    if ($ret1!=false) $ret[] = rtrim($ret1,"\n");
	}
	
	unset ($ret[count($ret)-1]); 
	
	//echo "<PRE>RRD: ".substr($command,0)." => ".vd($ret)."</PRE>\n";
	return array($ret, 1);
    }	
?>
