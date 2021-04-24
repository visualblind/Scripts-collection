<?php

// This file is used to upgrade the database tables from Node Runner
// v0.4.2 thru .9 to v0.5.0.  If you need to upgrade from an older version, you
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
# 1) Adds comments field to objects table for misc comments per node.
#    The comments field is optional, so no default entries will be made.
# 2) Adds users table for web interface authentication.
# 3) Inserts default entry for admin
# 4) Add dont_poll table for optimizing node.start script

$query1 = "ALTER TABLE objects ADD comments TEXT NOT NULL";
$result1 = mysql_db_query($db, $query1);
if (!$result1) {
	$err_msg .= mysql_error()."\n";
}

$query2 = "CREATE TABLE users (
   userid int(11) NOT NULL auto_increment,
   username varchar(255) NOT NULL,
   password text NOT NULL,
   admin int(1) NOT NULL,
   PRIMARY KEY (userid)
)";
$result2 = mysql_db_query($db, $query2);
if (!$result2) {
	$err_msg .= mysql_error()."\n";
}

$query3 = "INSERT INTO users VALUES('','admin','0260dc1993945f6ee97424b2c4d6d02d','1')";
$result3 = mysql_db_query($db, $query3);
if (!$result3) {
	$err_msg .= mysql_error()."\n";
}

$query4 = "CREATE TABLE dont_poll (
   serverid int(11) NOT NULL,
   description varchar(100) NOT NULL,
   PRIMARY KEY (serverid)
)";
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
