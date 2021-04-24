<?php
// Intended to serve as database abstraction layer for MySQL
// Limited to functions required by Node Runner
// Global variables from nr.inc

function db_connect() {
	global $dbhost,$dbuser,$dbpass;
	$connect = mysql_connect($dbhost,$dbuser,$dbpass);
	if (!$connect) {
		echo mysql_error();
	}
	return $connect;
}

function db_query($qstring) {
	global $db;
	$query = mysql_db_query($db,$qstring);
    if (!$query) {
        echo mysql_error();
    }
    return $query;
}

function db_num_rows($qhandle) {
	// return only if qhandle exists, otherwise 0
	if ($qhandle) {
		return @mysql_num_rows($qhandle);
	} else {
		return 0;
	}
}

function db_fetch_array($qhandle) {
	return @mysql_fetch_array($qhandle);
}

?>
