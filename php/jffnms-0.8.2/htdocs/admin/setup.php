<?
/* Setup & Autoconfiguration. This file is part of JFFNMS
 * Copyright (C) <2002-2004> Javier Szyszlican <javier@szysz.com>
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    function searchPath($cmd) {	
	$dirs = explode(":", $_SERVER["PATH"]);

	if ($GLOBALS["os_type"]=="windows") {
	    $cmd.=".exe";
	    $dirs[]="c:/php";
	    $dirs[]="c:/rrdtool";
	    $dirs[]=$GLOBALS["jffnms_real_path"];
	}
	
	for($x=0; $x<=count($dirs); $x++)
    	    if(is_file($dirs[$x] . "/" . $cmd)) 
        	return $dirs[$x] . "/" . $cmd;
	
	return false;
    }
   
    function autoConfig($option, $value) {

	switch($option) {
	    case "jffnms_real_path":
        	$value = str_replace("/htdocs/admin/setup.php", "", $_SERVER["SCRIPT_FILENAME"]);
        	break;

    	    case "tftp_real_path":
        	$value = $GLOBALS["jffnms_real_path"] . "/tftpd";
        	break;
    	    case "rrd_real_path":
        	$value = $GLOBALS["jffnms_real_path"] . "/rrd";
        	break;
    	    case "engine_temp_path":
        	$value = $GLOBALS["jffnms_real_path"] . "/engine/temp";
        	break;
    	    case "images_real_path":
        	$value = $GLOBALS["jffnms_real_path"] . "/htdocs/images/temp";
        	break;
    	    case "images_rel_path":
        	$value = $GLOBALS["jffnms_rel_path"]."/images/temp";
        	break;
    	    case "log_path":
        	$value = $GLOBALS["jffnms_real_path"] . "/logs";
        	break;
	
    	    case "jffnms_rel_path":
		$value = $_SERVER["REQUEST_URI"];
        	$value = str_replace("?", "", $value);
        	$value = str_replace("/admin/setup.php", "", $value);
        	break;

    	    case "jffnms_satellite_uri":
		$value = current_host().$_SERVER["REQUEST_URI"];
        	$value = str_replace("?", "", $value);
        	$value = str_replace("/admin/setup.php", "/admin/satellite.php", $value);
		break;

    	    case "php_executable":
        	$value = searchPath("php");
        	if($value == false) $value = searchPath("php4");
        	break;

    	    case "neato_executable":
    	    case "rrdtool_executable":
    	    case "diff_executable":
    	    case "nmap_executable":
    	    case "fping_executable":
    	    case "smsclient_executable":
		list ($file) = explode("_",$option);
        	$value = searchPath($file);
        	break;
		
	    case "os_type":
		$value = (strpos($_SERVER["SERVER_SOFTWARE"],"Win32") > 1)?"windows":"unix";
		break;
		
	    case "logo_image":
		$value = $GLOBALS["jffnms_rel_path"]."images/jffnms.png";
		break;
	}
    
	//TEST Fix for Windows Path \\\\\ escaping problem
	if ($value) $value = str_replace("\\","/",$value);
    
	return $value;  
    }

    function check_phpconf($value) {
	return (ini_get($value)==1)?true:false;
    }

    function check_enum($value) {
	return false;	//force Auto Config
    }

    function check_phpmodule($value) {
	return (extension_loaded($value)?true:false);
    }

    function check_db($value) {
	return 
	    (get_config_option("jffnms_access_method")=="local")
		?($conexion = @db_test())?true:false
		:true;
    }

    function check_disable($value) {
	return true;
    }

    function check_text($value) {
	return true;
    }

    function check_menu($value) {
	return true;
    }

    function check_bool($value) {
	return true;
    }

    function check_hidden($value) {
	return true;
    }

    function check_relative_directory($value) {
	return (@fopen(current_host() . $value . "/.check","r"))?true:false;
    }

    function check_uri($test_url) {
	$new_test_url = (strpos($test_url,"://")===false)
		?current_host()."/".$test_url."?from=/admin/setup.php"
		:$test_url;

    	return (($test_url=="none") || (@fopen($new_test_url,"r")))?true:false;
    }

    function check_file($value) {
	return (is_file($value)?true:false);
    }

    function check_directory($value) {
	return (($value!="../..") && is_dir($value))?true:false;
    }

    function check_satellite() {
	return (is_object($GLOBALS["jffnms"]) && ($GLOBALS["jffnms"]->ping()=="pong"))?true:false;
    }
   
    function verifyConfig($type, $key, $value) {
	$old_value = $value;
	
	if ($type!="label") {

	    $result = call_user_func("check_".$type, $value);

	    if ($result)
		$state = 1;
	    else {
		$auto_config_value = autoConfig($key, $value);
		$result = call_user_func("check_".$type, $auto_config_value);
		
    	        if($result || ($key=="os_type")) {
        	    $value = $auto_config_value;
        	    $state = 1;
    		} else 
        	    $state = 2;
	    }
	}
	//if ($old_value!=$value) 
	//    debug ("$type - $key - $old_value -> $value");
	
	return array($value, $state);
    }

    $no_db=1;
    include("../../conf/config.php");

    if ($jffnms_initial_config_finished==1) { 
	if ((get_config_option("jffnms_access_method")=="local") && (db_test())) $no_db = 0; 
	include("../auth.php"); 

	if (!profile("ADMIN_SYSTEM")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");
    }

    if (!empty($action)) {
    
	$new_config = array();
    
        foreach ($jffnms_configuration as $key=>$data) {
	    $new = &$GLOBALS["new_".$key];

	    if (($data["type"]=="bool") && empty($new)) $new = 0;
	
	    if (($new==="") && ($data["type"]!="relative_directory")) //Only Relative directories can be empty
		$new = $data["default"];
	    
	    $new_config[$key] = $new;
	}

	$new_config["jffnms_configured"] = 1; //mark the system as configured, to avoid redirects to setup

	save_configuration ($jffnms_config_file, $new_config, true);
	unset ($new_config);
	unset ($key);
	unset ($new);
	unset ($data);
	
	//force configuration re-read
	include("../../conf/config.php");
    }

    adm_header("Setup");

    foreach ($jffnms_configuration as $key=>$data) {
	
	if (!isset($data["type"])) $data["type"] = "text";

	$type = $data["type"];
	
	list($value, $state) = verifyConfig($data["type"], $key, $data["value"]);
	$input = "&nbsp;";
	$new_key = "new_".$key;
	$GLOBALS[$key] = $value;
	
	switch (true) {
	
	    case (in_array($type,array("text","file","directory","relative_directory","uri","satellite"))):
		$input = textbox ($new_key, $value,40); break;

	    case ($type=="label"):
		$input = $value .hidden($new_key, $value); break;

	    case ($type=="hidden"):
		$input = hidden($new_key, $value); break;

	    case ($type=="file"):
		$state = is_file($value)?1:2; break;
		
	    case ($type=="bool"):
		$input = checkbox($new_key,$value); break;

	    case ($type=="enum"):
		$options = array ();
		$aux = explode(";", $data["values"]);
		foreach ($aux as $aux1) {
		    list ($option_name, $option_value) = explode (":", $aux1);
		    $options[$option_value]=$option_name;
		}

		$input = select_custom($new_key,$options,$value);
		unset ($aux);
		unset ($options);
		unset ($aux1);
		unset ($options_name);
		unset ($options_value);
		break;

	    case ($type=="db" || $type=="module" || $type=="phpconf"):
		$state += 2; break;
	
	}
	
	if ($type=="text" || $type=="menu" || $type=="label" || $type=="enum" || $type=="bool") 
	    unset($state);
	
	if ($state==1) $result[$key] = "ok";
	if ($state==2) $result[$key] = "error";
	if ($state==3) $result[$key] = "yes";
	if ($state==4) $result[$key] = "no";
	
	$setup_options .= 
	    ($type!=="hidden")?
		tr_open().
	        td($data["description"], "field_".$type, "field_".$key, (($type=="menu")?3:1)).
	        (($type!="menu")?td($input, "value", "value_".$key, (empty($result[$key])?2:1)):"").
	        (!empty($result[$key])?td($result[$key], "result_".$result[$key]):"").
	        tag_close("tr")
	    :$input;
    }

    echo
	form(). 	
	table("setup");
    
    table_row("JFFNMS Setup","title");
    table_row(linktext("Main",$jffnms_rel_path."/")."&nbsp;".linktext("Help",$jffnms_site_help),"help");
    table_row("Using ".(file_exists($jffnms_config_file)?realpath($jffnms_config_file):"defaults"),"config_file");

    echo
	tr_open(). 
	td(
	    table("options").
		$setup_options.
	    table_close()
	,"setup_options").
	tag_close("tr");

    table_row(adm_form_submit("Save Changes","action"));

    echo
	table_close().
	form_close();

    adm_footer();
?>
