<?php
	/*
		This is the main configuration file for fuzzy.
		Change the variable values according to your configuration
		of fuzzy.
	*/
	
	/*
		Define the database access values here
	*/
	$host = "localhost";			//The host for the database
	$user = "snort_user";			//This is the database user
	$passwd = "snort_pass";			//This is the database password
	$database = "snort";			//This is the database name
	
	/*
		Define some system variables here
	*/
	$url = "";						//This is the base URL for the system (i.e. http://mysite.com/fuzzy/)
	$root = "";						//This is the ABSOLUTE PATH to fuzzy
	
	/*
		Define some interface variables here
	*/
	$title = "FuZZY - Version Karma (2.0)";		//Page title
	$banner = "FuZZY Acceptable Use Policy Infraction Detection - version Karma (2.0)";	//Page footer
	
	/*
		DO NOT EDIT BELOW HERE!
		******************************************************************************
	*/
	define("SQL_HOST",$host);
	define("SQL_USER",$user);
	define("SQL_PASS",$passwd);
	define("SQL_DB",$database);
	define("TITLE", $title);
	define("BASE_URL", $url);
	define("ROOT_PATH", $root);
	define("LIB", ROOT_PATH."lib/");
	define("VAR_PATH", ROOT_PATH."var/");
	define("URL_VAR", BASE_URL."var/");
	define("BANNER", $banner);
	define("IMAGES", BASE_URL."images/");

	$dir = opendir(LIB);
	$i = 0;
	while(false !== ($file = readdir($dir))) 
	{
		if(substr($file, -3) == "php")
			include_once(LIB.$file);
		$i++;	
	}
?>