<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
	$no_db=0;
	$auth_configuration_file = "config.php";
	$auth_dirs = array("../conf","../../../conf","../../conf");

	foreach ($auth_dirs as $auth_dir) {
		if (file_exists($auth_dir."/".$auth_configuration_file)) { 
			include($auth_dir."/".$auth_configuration_file); 
			break;
		} 
	}
	
	unset($auth_configuration_file);
	unset($auth_dirs);
	unset($authenticated);
	
	$client_pages = array( //pages the customer is allowed to see
    		$jffnms_rel_path."/admin/calendar.php",
		$jffnms_rel_path."/view_performance.php",
		$jffnms_rel_path."/admin/reports/state_report.php"
		);

	switch ($jffnms_auth_method) {
	    case "http":
		list ($authenticated, $auth_type, $auth_data) = $jffnms->authenticate ($_SERVER["PHP_AUTH_USER"],$_SERVER["PHP_AUTH_PW"],false);
	
		if(is_array($auth_data))
		    extract($auth_data);

		if ($authenticated != 1 || ($HTTP_GET_VARS["logout"] == 1 && $HTTP_GET_VARS["OldAuth"] == $_SERVER["PHP_AUTH_USER"])) 
		    http_authenticate();
		
		break;

	    case "login":
		ini_set("session.save_handler", "files");
		session_name("jffnms");
		session_start();	

		if (isset($_REQUEST["logout"]) && ($_REQUEST["logout"]==1)) {
		    session_destroy();
		    session_start();
		}

		if (($jffnms_version=="0.0.0") && ($_SERVER["REMOTE_ADDR"]=="128.30.52.13")) { //W3C Validator
		    $_REQUEST["user"]="admin";
		    $_REQUEST["pass"]="admin";
		}
		
		if (!isset($_SESSION["authentification"]))
		    $authentification = $jffnms->authenticate ($_REQUEST["user"],$_REQUEST["pass"],true,"from ".$_SERVER["REMOTE_ADDR"]);

		list ($authenticated, $auth_type, $auth_data) = $authentification;
	
		if(is_array($auth_data))
		    extract($auth_data);

		if ($authenticated!=1) {
		    if (!empty($_REQUEST["pass"]))
			$error = "Invalid Username or Password";
		    else
			$error = "&nbsp;";
			
		    include ("login.php");
		    die();
		} else 
		    if (!isset($_SESSION["authentification"]))
			$_SESSION["authentification"]=$authentification;

		unset ($authentification);
		session_write_close();
		break;
	    
	    default:
		die("Bad Authentication Method.");
	}
	
	unset($authenticated);
            
	if ($auth_type==2) { //its a customer
		$GLOBALS["client_id"] = $auth_user_id; //overwrite the client_id to only show this customer data (the pages have to enforce it)

		if (!in_array($_SERVER['SCRIPT_NAME'], $client_pages)) {
			$url_limit = $jffnms_rel_path."/view_performance.php";
			Header("Location: $url_limit");
			die();
		}
	}

	unset($auth_type);
	unset($client_pages);
	unset($auth_data);

	if (!isset($clean_url_add_vara)) {
		$clean_url_add_vars = Array();
	}

	if (!isset($clean_url_del_vars)) {
		$clean_url_del_vars = Array();
	}
    
	clean_url($clean_url_add_vars, $clean_url_del_vars);
?>
