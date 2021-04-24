<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    require_once ("config.parse.func.inc.php");

    $config_dirs = array("..",".","../conf","../../../conf","../../conf","/etc/jffnms");

    // Look for new Config Defaults
    if (false === ($jffnms_config_defaults_file = find_file ("jffnms.conf.defaults", $config_dirs)))
	die ("Configuration defaults (jffnms.conf.defaults) no found in ".join(", ",$config_dirs). ".");

    // Parse Defaults
    $jffnms_config_defaults = parse_config_file($jffnms_config_defaults_file);
    
    // Look for new Style Config 
    if (false !== ($jffnms_config_file = find_file ("jffnms.conf", $config_dirs)))
	$jffnms_config_type = "new";

    else //Look for Old Style ConfigFile (0.7.9 -> 0.8.0 Upgrade)
	if (false !== ($jffnms_config_file = find_file ("config.ini", $config_dirs)))
	    $jffnms_config_type = "old";

    if ($jffnms_config_file==false) { //No Real configuration found, use defaults 
	$jffnms_configuration = $jffnms_config_defaults;
	$jffnms_config_type = "default";

	$jffnms_config_file = dirname($jffnms_config_defaults_file)."/jffnms.conf";
    }    
    
    if ($jffnms_config_type == "old") {
    
	if (!isset($config_profile)) $config_profile = "standard";

	$config_ini = parse_ini_file($jffnms_config_file,true);

	if (count($config_ini)==2) { //FIX for PHP5 and our old config.ini
	    $config_ini["standard"] += $config_ini["none"];
	    unset ($config_ini["none"]);
	}
        
	while($config_key = key($config_ini[$config_profile])) {
	    list ($config_value,$config_aux) = explode ("#",current($config_ini[$config_profile]));

	    list ($config_type,$config_size,$config_comment) = explode(",",$config_aux);

	    $config_value = trim($config_value);
	    $config_comment = trim($config_comment);
	    $config_type = trim($config_type);
	    $config_size = trim($config_size);
	
	    if (($config_key=="jffnms_rel_path") && ($config_value=="/.")) $config_value = ""; //special case for relative path

	    $jffnms_configuration[$config_key]=array("value"=>$config_value,"comment"=>$config_comment,"type"=>$config_type,"size"=>$config_size);
	    next($config_ini[$config_profile]);
	}
    
	unset($config_ini);
	unset($config_key);
        unset($config_value);
        unset($config_type);
        unset($config_size);
        unset($config_comment);
        unset($config_aux);
	
	// Generate New Style config file 
	unset ($new_config);
	$avoid_config = array("jffnms_version", "db_working", "reg_globs", "allow_url_fopen", 
	    "normalColor", "overColor", "selectedColor", "table_row_color1", "table_row_color2", "events_latest_max",
	    "messages_refresh","logo_url");
	
	foreach ($jffnms_configuration as $var=>$data) 
	    if 	(!in_array($var,$avoid_config) && (strpos($var, "title")===false) && (strpos($var,"module")==false) &&
		($jffnms_config_defaults[$var]["default"]!=$data["value"]))
		    $new_config .= $var." = ".$data["value"]."\n";
	    
	$jffnms_config_file = dirname($jffnms_config_defaults_file)."/jffnms.conf";

	$config_fp = fopen($jffnms_config_file,"w+");
	fputs ($config_fp, $new_config);
	fclose($config_fp);
	
	unset ($var);
	unset ($data);
	unset ($avoid_config);
	unset ($config_fp);
	unset ($new_config);
    
	$jffnms_config_type = "new";
    } 

    if ($jffnms_config_type == "new")
	$jffnms_configuration = parse_config_file($jffnms_config_file, $jffnms_config_defaults);

    //Put the configuration variables in the Global Scope
    foreach ($jffnms_configuration as $jffnms_config_var=>$jffnms_config_data)
	if (!in_array($jffnms_config_data["type"],array("menu","test","phpconf","phpmodule")))
	    $GLOBALS[$jffnms_config_var]=$jffnms_config_data["value"];
    
    unset($jffnms_config_var);
    unset($jffnms_config_data);	    
    unset($jffnms_config_defaults_file);
    unset($jffnms_config_defaults);
    unset($jffnms_config_type);
    unset($config_dirs);
?>
