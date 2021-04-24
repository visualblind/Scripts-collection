<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    error_reporting(7);

    include ("config.parse.inc.php");

    if ($jffnms_configured!=1) { // Not yet configured
	
	$jffnms_setup_page = "/admin/setup.php";
	    
        $jffnms_rel_path = str_replace($jffnms_setup_page,"",$_SERVER["REQUEST_URI"]);

	if (strpos($_SERVER["REQUEST_URI"],$jffnms_setup_page) === false) { 	//we are not in the setup page

	    $jffnms_setup_location = "http://".$_SERVER["HTTP_HOST"].str_replace("//","/",$jffnms_rel_path.$jffnms_setup_page);
	    header("Location: ".$jffnms_setup_location);			//redirect to setup
	    die();    
	} else 
	    // Help setup with its real path
	    $jffnms_real_path = str_replace("/conf", "", str_replace("\conf", "", dirname(__FILE__))); 
    }

    if (!isset($jffnms_functions_include)) $jffnms_functions_include = "gui";
    
    $jffnms_logging_file = $_SERVER["SCRIPT_NAME"];
    
    if ($jffnms_functions_include!="none") {
	
	$jffnms_includes = array( "api","api.network" ); //add basic APIs and Network Communication

	if ($jffnms_access_method=="local") //add local clases
	    $jffnms_includes = array_merge( $jffnms_includes, array(
		"api.db","api.classes","api.events","api.rrdtool","api.user","api.profile",
		"api.interface","api.maps","api.hosts","api.zones","api.triggers","api.satellites",
		"api.tools", "api.nad"
	    ));

	if ($jffnms_functions_include!="engine") { //gui
	    $jffnms_includes[]="gui";
	    $jffnms_includes[]="gui.toolkit";
	    $jffnms_includes[]="gui.admin";
	    $jffnms_includes[]="gui.controls";
	}

	//Include the Lib Files.
        foreach ($jffnms_includes as $jffnms_include)
	    require_once($jffnms_real_path."/lib/".$jffnms_include.".inc.php");

	unset ($jffnms_include);
	
	set_time_limit(15*60);

	if ($jffnms_functions_include!="engine") { //gui

	    set_time_limit(420);

	    if (!isset($jffnms_init_classes)) $jffnms_init_classes = 0;

	    //init objects
	    if ($jffnms_access_method=="satellite") {
	        $aux = new jffnms_access_api($jffnms_init_classes); //remote
	        $jffnms = $aux->get("jffnms");
	        unset ($aux);
	    } else
	        $jffnms = new jffnms($jffnms_init_classes); //local
	}
    }

    unset($jffnms_include_load_ok);
    unset($jffnms_includes);
    unset($jffnms_functions_include); 
    unset($jffnms_init_classes); 
?>
