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

// Connect
$link = mysql_connect($dbserver, $dbusername, $dbpassword)
  	OR die(mysql_error());

$db_selected = mysql_select_db($dbname, $link);
if (!$db_selected) {
  	die ('Can\'t use $dbname : ' . mysql_error());
}

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

?>