<?php

// This file is used to upgrade the database tables from Node Runner
// v0.5.2 to v0.6.0.  If you need to upgrade from an older version, you
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
# 1) Adds query_type field to objects and alert_log tables.
# 2) Sets default query_type to TCP, since that's all there was prior to v0.6.
# 3) Drops dont_poll table, since that's no longer needed.
# 4) Adds snmp_comm for SNMP Community to objects table.
# 5) Alters mail_group database - convert BLOB to TEXT.
# 6) Alter field type for time and lastnotif on alert_log table.


$query1 = "ALTER TABLE alert_log ADD query_type tinytext NOT NULL AFTER port";
$result1 = mysql_db_query($db, $query1);
if (!$result1) {
	$err_msg .= mysql_error()."\n";
}

$query2 = "UPDATE alert_log SET query_type='TCP'";
$result2 = mysql_db_query($db, $query2);
if (!$result2) {
	$err_msg .= mysql_error()."\n";
}

$query3 = "ALTER TABLE objects ADD query_type tinytext NOT NULL AFTER port";
$result3 = mysql_db_query($db, $query3);
if (!$result3) {
	$err_msg .= mysql_error()."\n";
}

$query4 = "UPDATE objects SET query_type='HTTP' WHERE url<>''";
$result4 = mysql_db_query($db, $query4);
if (!$result4) {
	$err_msg .= mysql_error()."\n";
}

$query5 = "UPDATE objects SET query_type='ECP' WHERE (url='' OR url IS NULL)";
$result5 = mysql_db_query($db, $query5);
if (!$result5) {
	$err_msg .= mysql_error()."\n";
}

$query6 = "DROP TABLE dont_poll";
$result6 = mysql_db_query($db, $query6);
if (!$result6) {
	$err_msg .= mysql_error()."\n";
}

$query7 = "ALTER TABLE `alert_log` ADD `snmp_comm` TINYTEXT AFTER `url`";
$result7 = mysql_db_query($db, $query7);
if (!$result7) {
	$err_msg .= mysql_error()."\n";
}

$query8 = "ALTER TABLE `objects` ADD `snmp_comm` TINYTEXT AFTER `url`";
$result8 = mysql_db_query($db, $query8);
if (!$result8) {
	$err_msg .= mysql_error()."\n";
}

$query9 = "ALTER TABLE `mail_group` CHANGE `email` `email` TEXT NOT NULL";
$result9 = mysql_db_query($db, $query9);
if (!$result9) {
	$err_msg .= mysql_error()."\n";
}

$query10 = "ALTER TABLE `alert_log` CHANGE `time` `time` INT NOT NULL";
$result10 = mysql_db_query($db, $query10);
if (!$result10) {
	$err_msg .= mysql_error()."\n";
}

$query11 = "ALTER TABLE `alert_log` CHANGE `lastnotif` `lastnotif` INT NOT NULL";
$result11 = mysql_db_query($db, $query11);
if (!$result11) {
	$err_msg .= mysql_error()."\n";
}

# Clear the down list for safety reasons.
$query12 = "UPDATE `alert_log` SET resolved='Y'";
$result12 = mysql_db_query($db, $query12);
if (!$result12) {
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
