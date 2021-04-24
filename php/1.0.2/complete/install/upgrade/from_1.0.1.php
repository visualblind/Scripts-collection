<?php
require("../../includes/global.php");

$sql = "SELECT * FROM " . $dbprefix . "config WHERE config_name = 'versionint'";
$rec = $db->execute($sql);
$version = intval($rec->fields["config_value"]);

// check version
if (!($version == 2)){ die("You are not running version 1.0.1"); }

// run the update SQL
$sql = "UPDATE " . $dbprefix . "config SET config_value = '1.0.2' WHERE config_name = 'version'";
$db->execute($sql);

$sql = "UPDATE " . $dbprefix . "config SET config_value = 3 WHERE config_name = 'versionint'";
$db->execute($sql);

// and notify user
echo("Finished upgrade to latest version!");
?>