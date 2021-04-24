<?php

// This file is used to upgrade the database tables from Node Runner
// v0.1 to v0.2.  If you need to upgrade from an older version, you
// MUST run each of the older update files first.  It is HIGHLY
// recommended that you just use the install script (select UPGRADE),
// but if you absolutely *need* to update the database manually,
// you can fill in the values below can call the script from the
// php interpreter.  Otherwise, leave them blank.

$database_host = '';
$database_name = '';
$database_user = '';
$database_pass = '';

if (!$dbhost) { $dbhost = $database_host; }
if (!$db) { $db = $database_name; }
if (!$dbuser) { $dbhost = $database_user; }
if (!$dbpass) { $dbhost = $database_pass; }

if ($database_host && $database_name && $database_user && $database_pass) {
  unset($err_msg);
  $connect = mysql_connect($database_host,$database_user,$database_pass);
  if (!$connect) { $err_msg .= mysql_error()."\n"; }
}


# DATABASE CHANGELOG:
# 1) Adds downtime column to alert_log table
# 2) Adds lastnotif column to alert_log table
# 3) Inserts 0 into all downtime and lastnotif columns

$query1 = "ALTER TABLE alert_log ADD downtime int NOT NULL";
$result1 = mysql_db_query($db, $query1);
if (!$result1) {
	$err_msg .= mysql_error()."\n";
}

$query2 = "ALTER TABLE alert_log ADD lastnotif char(30) NOT NULL";
$result2 = mysql_db_query($db, $query2);
if (!$result2) {
	$err_msg .= mysql_error()."\n";
}

$query3 = "UPDATE alert_log SET downtime=0";
$result3 = mysql_db_query($db, $query3);
if (!$result3) {
	$err_msg .= mysql_error()."\n";
}

$query4 = "UPDATE alert_log SET lastnotif=1";
$result4 = mysql_db_query($db, $query4);
if (!$result4) {
	$err_msg .= mysql_error()."\n";
}


# Generate some output if this files is run by itself.
if ($database_host && $database_name && $database_user && $database_pass) {
  if ($err_msg) {
  	echo "\nMySQL ERROR:\n\n".$err_msg."\n\n";
  } else {
  	echo "\nDatabase populated successfully.\n\n";
  }
}

?>
