<?
/* Host Config Downloader (via plugins). This file is part of JFFNMS
 * Copyright (C) <2002-2003> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
 
    $jffnms_functions_include="engine";
    include ("../conf/config.php");

    $time_total = time_usec();
    
    $host_id = 0;
    
    if (isset($_SERVER["argv"][1])) $host_id = $_SERVER["argv"][1];
    
    if ($host_id > 1) $host_filter = "and hosts.id = $host_id";
    else unset($host_filter);
        
    $query_config=
	"SELECT hosts.id as host_id, hosts.ip as host_ip, hosts.rwcommunity, hosts.tftp as tftp_server, hosts_config_types.command\n".
	"FROM hosts, hosts_config_types\n".
	"WHERE hosts.config_type = hosts_config_types.id and hosts.config_type > 1 $host_filter\n".
	"ORDER BY hosts.id";
    
    $result_config = db_query ($query_config) or die ("Query failed - T2 - ".db_error());
    
    while ($config = db_fetch_array($result_config)) {
        $function_file = get_config_option("jffnms_real_path")."/engine/configs/".$config["command"].".inc.php";
	$now = date("Y-m-d H:i:s",time());
	unset ($error);
	
        //try to load command files
        if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file))) ) {

	    $config_time = time_usec();
	    
	    $config_filename = uniqid("").".dat"; //generate random filename
	    $real_filename = get_config_option ("tftp_real_path")."/".$config_filename;

	    touch($real_filename); //create the file
	    chmod($real_filename,0666);
	    
	    $function_data = array($config["host_ip"],$config["rwcommunity"],$config["tftp_server"],$config_filename);
		
	    $get_function = "config_".$config["command"]."_get";
	    $get_result = NULL;
		
	    if (function_exists($get_function)) 
	        $get_result = call_user_func_array($get_function,$function_data); //call downloader function
	    else 
		$error =  "ERROR: Calling Function '$get_function' doesn't exists";

	    if ($get_result==true) { //if the Downloader returned TRUE (the transfer init was ok)
	
	        $wait_function = "config_".$config["command"]."_wait";
	        if (function_exists($wait_function))
		    $wait_result = call_user_func_array($wait_function,$function_data); //call the wait function
		else 
		    $error = "Calling Function '$wait_function'";
		    
		if ($wait_result==true) { //if the Wait function returned OK
		    clearstatcache(); //get file data
		    $exist = file_exists($real_filename);
		    $size = filesize($real_filename);

		    if ($exist && ($size > 0)) { //if the file has contents 
			$config_data = implode("", file($real_filename)); //get contents

			$aux = current(hosts_config_list (NULL,$config["host_id"],NULL,1)); //get the old config from DB
		        $config_data_old = $aux["config"];
			$config_id_old = $aux["id"];
			unset ($aux);

			//Cisco Router NTP fix
			$config_data = preg_replace('/ntp clock-period \S+/', '', $config_data);
				
			if (md5 ($config_data) != md5 ($config_data_old)) { //if the old and the new config are not equal
		
			    $config_data = str_replace ("'","\'",$config_data); //escape '

			    $data = array(
				"host"=>$config["host_id"],
				"date"=>$now,
				"config"=>$config_data
			    );
			    $config_id = adm_hosts_config_add();
			    $result = adm_hosts_config_update($config_id,$data); //save the config in the DB
			    $info = "new config id $config_id";
			} else  
			    $info = "same config as last one ($config_id_old)";
		    } else 
			$error = "Storing the file in DB";
		} else 
		    $error = "Waiting transfer to finish";
	    } else 
		$error = "Getting File";
	    unlink($real_filename); //delete file
	} else 
	    $error = "Loading file $function_file";
	
	if (isset($error)) {    //insert event reporting problem
	    $error = "Error $error";
	    insert_event ($now,get_config_option("jffnms_administrative_type"),$config["host_id"],"CPU","error","host_config","Host Config Transfer $error",0,0);
	} else 
	    $error = "OK $info";
	
	$config_time = time_usec_diff ($config_time);

	logger(" :  H ".str_pad($config["host_id"],3," ",STR_PAD_LEFT)." : ".$config["host_ip"]." : ".$config["command"]." : $error ($config_time msec)\n");
	flush();
    }
    
    $time_total = time_usec_diff($time_total);
    logger( "TIMES \t: Total Time $time_total msec.\n");
    db_close();
?>
