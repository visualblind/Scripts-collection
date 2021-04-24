<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function backend_rrd($options,$result) {

    $ret = -1;
    
    $filename = $GLOBALS["rrd_real_path"]."/interface-".$options["interface_id"].".rrd";

    $type_info = interface_get_type_info($options["interface_id"]);

    //RRD File Creation
    if ($type_info["rrd_mode"]==1)  //one file
	if (file_exists($filename)==FALSE) 
	    $ret = rrdtool_create_file($filename,$type_info["rrd_structure_def"],$type_info["rrd_structure_rra"],
		$type_info["rrd_structure_res"],$type_info["rrd_structure_step"]);

    if ($type_info["rrd_mode"]==2) { //multiple files
	$rrd_struct = explode (" ",$type_info["rrd_structure_def"]);
	foreach ($rrd_struct as $dsn=>$data) {
	    $filename_ds = str_replace(".rrd","-$dsn.rrd",$filename);
	    $aux = explode(":",$data);
	    $aux[1]="data";

	    if (file_exists($filename_ds)==FALSE)
		$ret = rrdtool_create_file($filename_ds,join(":",$aux),$type_info["rrd_structure_rra"],
		    $type_info["rrd_structure_res"],$type_info["rrd_structure_step"]);
	}
    }

    $dss = interface_parse_rrd_structure ($type_info["rrd_structure_def"]);
    $num_ds = count($dss);

    if ( $ret == 0 ) {
        $err = rrdtool_error();
        logger( "RRD error: $err",0);
	return 0;
    } else { 
	// RRD File update 
	
	$output = array();
	$rrd_options[0] = "N";
	
	if ($options["backend_parameters"]=="*") { //ALL DS's
	    $poller_buffer = $GLOBALS["session_vars"]["poller_buffer"]; //get data from the poller buffer 

	    foreach ($dss as $ds_name=>$ds_number) { 
		$buffer_name = "$ds_name-".$options["interface_id"];
		if (isset($poller_buffer[$buffer_name])) 
		    $rrd_options[$ds_number+1] = $poller_buffer[$buffer_name];
	    }
	} else { //only one DS
	    if ($type_info["rrd_mode"]==1) 	//all DS's on the same file
		sleep(1);			//to avoid errors

	    $rrd_options[$dss[$options["poller_name"]]+1] = $result;
	}

	for ($i = 1; $i < $num_ds+1; $i++) 
	    if (!isset($rrd_options[$i]) || !is_numeric($rrd_options[$i])) //if its not valid
		$rrd_options[$i]="U"; //Put in NaN

	if ($type_info["rrd_mode"]==1) { //all DS's on the same file
	    $ret = rrdtool_update($filename,join (":",$rrd_options));
	    $output[] = "ALL=".join (":",$rrd_options);
	}

	if ($type_info["rrd_mode"]==2) { //only one DS by file
	    $ds_names = array_keys($dss);
	    
	    for ($dsn = 0; $dsn < $num_ds; $dsn++)
		if (is_numeric($rrd_options[$dsn+1])) { //if there is a value 
	    	    $filename_ds = str_replace(".rrd","-$dsn.rrd",$filename);
		    $ret = rrdtool_update($filename_ds,$rrd_options[0].":".$rrd_options[$dsn+1]);
		    $output[] = $ds_names[$dsn].":".$rrd_options[$dsn+1];
		}

	    unset ($ds_names);
	}
	
	if ( $ret == 0 ) logger( "RRD error: ".rrdtool_error(),0);

	return join(" - ",$output);
    }
}

?>
