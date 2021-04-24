<?php

// This file is used to populate the database for new installations
// of Node Runner.  This file is called from the install script,
// but if you absolutely *need* to build the database manually,
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

# --------------------------------------------------------
#
# Table structure for table 'alert_log'
#

$pre_query1 = "DROP TABLE IF EXISTS alert_log";
$pre_result1 = mysql_db_query($db, $pre_query1);
if (!$pre_result1) {
	$err_msg .= mysql_error()."\n";
}

$query1 = "
CREATE TABLE alert_log (
   id int(11) NOT NULL auto_increment,
   dependency char(10) NOT NULL,
   description char(100) NOT NULL,
   ipaddress char(30) NOT NULL,
   port char(10) NOT NULL,
   query_type tinytext NOT NULL,
   server char(1) NOT NULL,
   time int(11) NOT NULL,
   downtime int(11) NOT NULL,
   lastnotif int(11) NOT NULL,
   ptime int(11) NOT NULL,
   url varchar(255) NULL,
   snmp_comm tinytext NULL,
   resolved char(1) NOT NULL,
   PRIMARY KEY (id)
)";
$result1 = mysql_db_query($db, $query1);
if (!$result1) {
	$err_msg .= mysql_error()."\n";
}


# --------------------------------------------------------
#
# Table structure for table 'mail_group'
#

$pre_query2 = "DROP TABLE IF EXISTS mail_group";
$pre_result2 = mysql_db_query($db, $pre_query2);
if (!$pre_result2) {
	$err_msg .= mysql_error()."\n";
}

$query2 = "
CREATE TABLE mail_group (
   id int(11) NOT NULL auto_increment,
   name varchar(100) NOT NULL,
   email text NOT NULL,
   PRIMARY KEY (id)
)";
$result2 = mysql_db_query($db, $query2);
if (!$result2) {
	$err_msg .= mysql_error()."\n";
}


#
# Default data for table 'mail_group'
#

$query3 = "INSERT INTO mail_group (id, name, email) VALUES ( '1', 'root', 'root@localhost');";
$result3 = mysql_db_query($db, $query3);
if (!$result3) {
	$err_msg .= mysql_error()."\n";
}



# --------------------------------------------------------
#
# Table structure for table 'objects'
#

$pre_query4 = "DROP TABLE IF EXISTS objects";
$pre_result4 = mysql_db_query($db, $pre_query4);
if (!$pre_result4) {
	$err_msg .= mysql_error()."\n";
}

$query4 = "
CREATE TABLE objects (
   id int(11) NOT NULL auto_increment,
   dependency char(10) NOT NULL,
   description char(100) NOT NULL,
   ipaddress char(30) NOT NULL,
   port char(10) NOT NULL,
   query_type tinytext NOT NULL,
   server char(1) NOT NULL,
   enabled char(1) NOT NULL,
   mail_group char(10) NOT NULL,
   ptime int(11) NOT NULL,
   smon_time int(11) NOT NULL,
   emon_time int(11) NOT NULL,
   url varchar(255) NULL,
   snmp_comm tinytext NULL,
   days varchar(27) NOT NULL,
   comments text NOT NULL,
   auth_user varchar(255) NULL,
   auth_pass varchar(255) NULL,
   PRIMARY KEY (id)
);";
$result4 = mysql_db_query($db, $query4);
if (!$result4) {
	$err_msg .= mysql_error()."\n";
}

#
# Default data for table 'objects'
#

$query5 = "INSERT INTO objects (id, dependency, description, ipaddress, port, query_type, server, enabled, mail_group, ptime, smon_time, emon_time, url, days, comments, auth_user, auth_pass) VALUES ( '1', 'NONE', 'NODE RUNNER', '127.0.0.1', '80', 'TCP', '', 'Y', '1', '5', '0', '2359', NULL, 'Sun Mon Tue Wed Thu Fri Sat','', NULL, NULL);";
$result5 = mysql_db_query($db, $query5);
if (!$result5) {
	$err_msg .= mysql_error()."\n";
}



# --------------------------------------------------------
#
# Table structure for table 'users'
#

$pre_query6 = "DROP TABLE IF EXISTS users";
$pre_result6 = mysql_db_query($db, $pre_query6);
if (!$pre_result6) {
	$err_msg .= mysql_error()."\n";
}

$query6 = "
CREATE TABLE users (
   userid int(11) NOT NULL auto_increment,
   username varchar(255) NOT NULL,
   password text NOT NULL,
   admin int(1) NOT NULL,
   PRIMARY KEY (userid)
);";
$result6 = mysql_db_query($db, $query6);
if (!$result6) {
	$err_msg .= mysql_error()."\n";
}


#
# Default data for table 'users'
#

$query7 = "INSERT INTO users VALUES('','admin','0260dc1993945f6ee97424b2c4d6d02d','1');";
$result7 = mysql_db_query($db, $query7);
if (!$result7) {
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
