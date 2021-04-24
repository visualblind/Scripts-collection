<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function sat_session_start ($session_id) {
	$temp_dir = get_config_option("engine_temp_path");
	
	$file_name = $temp_dir."/sess_".$session_id;
	$sess_data_keys = array();
	
	if (file_exists($file_name)) {
	    $sess_raw_data = join("",file($file_name));
	
	    $sess_data = unserialize($sess_raw_data);
	
	    $sess_data_keys = array_keys($sess_data);
	
	    foreach ($sess_data_keys as $key)
		$GLOBALS[$key]=$sess_data[$key];
	    
	}

	$GLOBALS["sat_session"]=array("filename"=>$file_name,"vars"=>$sess_data_keys,"vars_ser"=>$sess_raw_data);
	return count ($ses_data_keys);
    }

    function sat_session_register() {
	$variables = func_get_args();
	
	$GLOBALS["sat_session"]["vars"] = array_merge($GLOBALS["sat_session"]["vars"],$variables);
	return count($GLOBALS["sat_session"]["vars"]);
    }

    function sat_session_close() {
	
	foreach ($GLOBALS["sat_session"]["vars"] as $key)
	    $sess_data[$key] = &$GLOBALS[$key];

	$time_ser = time_usec();
    
	$sess_data_raw = serialize($sess_data);
	
	$time_ser = time_usec_diff($time_ser);
	
	
	if ($sess_data_raw != $GLOBALS["sat_session"]["vars_ser"]) {
	    $time_save = time_usec();
	
	    $file_name = $GLOBALS["sat_session"]["filename"];
	    $fp = fopen($file_name,"w+");
	    fwrite($fp,$sess_data_raw);
	    fclose($fp);
	
	    $time_save = time_usec_diff ($time_save);
	} else
	    $time_save = 0; 


	return array($time_ser,$time_save);
    }

    function sat_session_destroy() {

	$a = unlink ($GLOBALS["sat_session"]["filename"]);
	unset ($GLOBALS["sat_session"]);
	return $a;
    }    
?>
