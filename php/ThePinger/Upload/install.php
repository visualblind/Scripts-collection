<?php

//----------------------------------------------------------------------
//						 2005, Shield Tech
//							The Pinger
//						   Rowan Shield
//				email: shieldtech@thesilv3rhawks.com
//----------------------------------------------------------------------
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  at your option) any later version.
//
//----------------------------------------------------------------------

$self = $_SERVER['PHP_SELF'];
define( 'CONFILE', 'config.php');

function quote_smart($value)
{
	if (!get_magic_quotes_gpc()) {
		$value = addslashes($value);
	}
    if (!is_numeric($value)) {
        $value = "'" . mysql_real_escape_string($value) . "'";
    }
    return $value;
}

if (!isset($_POST['install'])) {
	echo "<form method='POST' action='$self'>
	<h1 align='center'>The Pinger</h1>
	<h2 align='center'>Installation</h2>
	<fieldset style='padding: 2'>
	<legend>Server Settings</legend>
	mySQL Host: <input type='text' name='SQLhost' size='20'><br>
	mySQL Database: <input type='text' name='SQLdb' size='20'><br>
	mySQL Prefix: <input type='text' name='SQLprefix' size='20'>  (Leave blank for default of 'pngr_')<br>
	mySQL Username: <input type='text' name='SQLuser' size='20'><br>
	mySQL Password: <input type='password' name='SQLpass' size='20'><br>
	<br>
	<fieldset style='padding: 2'>
	<legend>Operating System</legend>
	<input type='radio' name='OS' value='1'>Windows<br>
	<input type='radio' name='OS' value='2'>Unix Based (Includes Linux)</fieldset></fieldset><br>
	<fieldset style='padding: 2'>
	<legend>Admin Account Settings</legend>
	Admin Username: <input type='text' name='adminuser' size='20'><br>
	Admin Password: <input type='password' name='adminpass' size='20'><br>
	Reconfirm Password: <input type='password' name='adminpass2' size='20'></fieldset><p align='center'>
	<input type='submit' value='Install' name='install'>&nbsp; <input type='reset' value='Reset'></p>
</form>";
} else {
	$SQLhost = $_POST['SQLhost'];
	$SQLdb = $_POST['SQLdb'];
	$SQLprefix = $_POST['SQLprefix'];
	$SQLuser = $_POST['SQLuser'];
	$SQLpass = $_POST['SQLpass'];
	$OS = $_POST['OS'];
	$user = $_POST['adminuser'];
	$pass = md5($_POST['adminpass']);
	$pass2 = md5($_POST['adminpass2']);
	if (!$_POST['SQLprefix']) { $SQLprefix = "pngr_"; }
	if (!$_POST['SQLhost']) { $error [] = "SQL Host was left empty, if you are unsure, usually localhost works"; }
	if (!$_POST['SQLdb']) { $error [] = "SQL database was not filled"; }
	if (!$_POST['SQLuser']) { $error [] = "SQL username was not filled"; }
	if (!$_POST['SQLpass']) { $error [] = "SQL password was not filled"; }
	if (!$_POST['OS']) { $error [] = "No Operating System was selected"; }
	if (!$_POST['adminuser']) { $error [] = "No Admin Username was inputted"; }
	if (!$_POST['adminpass']) { $error [] = "No Admin Password was inputted"; }
	if (!$_POST['adminpass2']) { $error [] = "No Reconfirm Password was inputted"; }
	if (!($pass == $pass2)) { $error [] = "Admin Passwords do not match";	}
	if (count($error) == 0){
		if ($OS == "1") {
			$write = "wb";
		} elseif ($OS == "2") {
			$write = "w";
		}
		$file_string = "<?php\n";
		$file_string .= "//Start of The Pinger Settings\n";
		$file_string .= '$dbserver = '.'"'.$SQLhost.'";'."\n";
		$file_string .= '$dbname = '.'"'.$SQLdb.'";'."\n";
		$file_string .= '$dbprefix = '.'"'.$SQLprefix.'";'."\n";
		$file_string .= '$dbusername = '.'"'.$SQLuser.'";'."\n";
		$file_string .= '$dbpassword = '.'"'.$SQLpass.'";'."\n";
		$file_string .= '$OS = '.'"'.$OS.'";'."\n";
		$file_string .= "//End of The Pinger Settings\n";
		$file_string .= "?>\n";

		if (is_writable(CONFILE)) {
		    if (!$handle = fopen(CONFILE, $write)) {
		         echo "Cannot open file config.php";
		         exit;
	    	}
		    if (fwrite($handle, $file_string) === FALSE) {
		        echo "Cannot write to file config.php, please change the settings so the file is writeable";
		        exit;
		    }
		    fclose($handle);              
		} else {
		    echo "The configuration file is not writable, set-up will not continue.<br> please make sure that the conf_global.php file has the correct permissions.";
		}
		$link = mysql_connect($SQLhost, $SQLuser, $SQLpass)
  			OR die(mysql_error());

		$db_selected = mysql_select_db($SQLdb, $link);
		if (!$db_selected) {
		  	die ('Can\'t use $SQLdb : ' . mysql_error());
		}
		$query = sprintf("DROP TABLE IF EXISTS `".$SQLprefix."config`;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}

		$query = sprintf("CREATE TABLE  `".$SQLprefix."config` (
		  `config_name` varchar(255) NOT NULL,
		  `config_value` varchar(255) NOT NULL,
		  PRIMARY KEY  (`config_name`)
		) TYPE=MyISAM;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}
		
		$query = sprintf("DROP TABLE IF EXISTS `".$SQLprefix."ips`;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}

		$query = sprintf("CREATE TABLE  `".$SQLprefix."ips` (
		  `id` int(11) NOT NULL auto_increment,
		  `name` varchar(50) NOT NULL,
		  `address` varchar(50) NOT NULL,
		  PRIMARY KEY  (`id`)
		) TYPE=MyISAM;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}
		
		$query = sprintf("DROP TABLE IF EXISTS `".$SQLprefix."users`;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}

		$query = sprintf("CREATE TABLE  `".$SQLprefix."users` (
		  `id` int(11) NOT NULL auto_increment,
		  `username` varchar(16) NOT NULL,
		  `password` varchar(32) NOT NULL,
		  PRIMARY KEY  (`id`)
		) TYPE=MyISAM;");

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}

		// Make a safe query
		$query = sprintf("INSERT INTO ".$SQLprefix."users (username, password) VALUES (%s, %s)", quote_smart($_POST['adminuser']), quote_smart($pass));

		$result = mysql_query($query);

		if (!$result) {
		    $message  = 'Invalid query: ' . mysql_error() . "\n";
		    $message .= 'Whole query: ' . $query;
		    die($message);
		}

		echo "Installation complete<br><br>Please remove the install.php file so that no-one else can re-install The Pinger, which could cause you to loose all settings.<br><br>You can now login to the <a href='admin.php'>Administration Control Panel</a> with the Admin username and password you specified to adminstrate parts of The Pinger";
	} else {
		echo"<br><p class=\"head\">There were errors while trying to install The Pinger!<br/>\n";
		echo"Here are the errors:</p>\n";
		echo"<ul>\n";
		for ($i = 0; $i < count($error); $i++) {echo "<li>" . $error[$i] . "</li><br/>\n";} 
		echo"</ul>\n";
		echo"<p>Please go <a href=\"javascript:history.go(-1)\">back</a> and fix the errors to install The Pinger</p>\n";
	}
}

?>