<?php
// global.php global include file
error_reporting(E_ERROR | E_WARNING | E_PARSE);
//error_reporting(E_ALL);

// include the basic files
include("functions.php");
include("database.php");
require("config.php");
include("usersys.php");

// check for lack of being installed and install directory
if ($dbname == ""){
	Header("Location: install/install.php");
	Die();
} elseif (is_dir("install/")){
	Header("Location: install/install.php?do=step3");
	Die();
}

// connect to the database
$db = new Database($dbhost, $dbuser, $dbpass, $dbname);

// extract configuration from db
$site_config = Array();
$sql = "SELECT * FROM " . $dbprefix . "config";
$result = $db->execute($sql);
if ( !($result = $db->execute($sql)) )
	{ Die("Could not query config table");
} else {
	do{
		// put config into array
		$config[$result->fields["config_name"]] = $result->fields["config_value"];
	} while($result->fields = mysql_fetch_array($result->res));
}

// add extra information
$_GLOBALS["skin"] = $config["defaultskin"];

// initialise classes
$usr = new UserSys;

// start the session
StartSession();
?>