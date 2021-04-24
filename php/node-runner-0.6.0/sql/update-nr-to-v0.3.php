<?php

// This file is used to upgrade the database tables from Node Runner
// v0.2 to v0.3.  If you need to upgrade from an older version, you
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
# 1) Adds ptime column to alert_log and objects tables.
# 2) Adds smon_time and emon_time column to objects for monitoring timeframe.
# 3) Inserts 10 into ptime columns for alert_log and objects tables.
# 4) Inserts default monitoring timeframe into objects table.

$query1 = "ALTER TABLE alert_log ADD ptime int NOT NULL";
$result1 = mysql_db_query($db, $query1);
if (!$result1) {
	$err_msg .= mysql_error()."\n";
}

$query2 = "ALTER TABLE objects ADD ptime int NOT NULL";
$result2 = mysql_db_query($db, $query2);
if (!$result2) {
	$err_msg .= mysql_error()."\n";
}

$query3 = "ALTER TABLE objects ADD smon_time int NOT NULL";
$result3 = mysql_db_query($db, $query3);
if (!$result3) {
	$err_msg .= mysql_error()."\n";
}

$query4 = "ALTER TABLE objects ADD emon_time int NOT NULL";
$result4 = mysql_db_query($db, $query4);
if (!$result4) {
	$err_msg .= mysql_error()."\n";
}

$query5 = "UPDATE alert_log SET ptime=10";
$result5 = mysql_db_query($db, $query5);
if (!$result5) {
	$err_msg .= mysql_error()."\n";
}

$query6 = "UPDATE objects SET ptime=10";
$result6 = mysql_db_query($db, $query6);
if (!$result6) {
	$err_msg .= mysql_error()."\n";
}

$query7 = "UPDATE objects SET smon_time=0";
$result7 = mysql_db_query($db, $query7);
if (!$result7) {
	$err_msg .= mysql_error()."\n";
}

$query8 = "UPDATE objects SET emon_time=2359";
$result8 = mysql_db_query($db, $query8);
if (!$result8) {
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
