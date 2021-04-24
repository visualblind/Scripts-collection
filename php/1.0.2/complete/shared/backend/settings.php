<?php
include("../../includes/global.php");
$usr->Auth(2);

// update the settings-o!
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_sitename"]) . "' WHERE config_name = 'sitename'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_mainsite"]) . "' WHERE config_name = 'mainsite'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_mainurl"]) . "' WHERE config_name = 'mainurl'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_root"]) . "' WHERE config_name = 'rootpath'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_rooturl"]) . "' WHERE config_name = 'rooturl'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_defaultskin"]) . "' WHERE config_name = 'defaultskin'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_dateformat"]) . "' WHERE config_name = 'dateformat'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_serverport"]) . "' WHERE config_name = 'serverport'");
$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . dbSecure($_POST["c_logresults"]) . "' WHERE config_name = 'logresults'");

// and redirect the user
Header("Location: ../../admin.php?page=settings");
?>