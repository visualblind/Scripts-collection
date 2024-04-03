<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $no_db=1;
    
    include("../../conf/config.php");

    $db_type="mysql";    
    $dbhost="localhost";
    $db="jffnms";
    $dbuser="root";
    $dbpass="sun";

    if (!$do) $do = $argv[1];

    $conexion = mysql_connect($dbhost, $dbuser, $dbpass) or die ("Could not connect - CON1");
    mysql_select_db($db) or die ("Could not select DB - CON2");
    echo "* Refixing Users Table\n";

    $result= mysql_query ("ALTER TABLE auth AUTO_INCREMENT = 1") or die ("Query failed - T3 - ".mysql_error());
    $result= mysql_query ("ALTER TABLE profiles AUTO_INCREMENT = 1") or die ("Query failed - T3 - ".mysql_error());
    $result= mysql_query ("ALTER TABLE profiles_values AUTO_INCREMENT = 300") or die ("Query failed - T3 - ".mysql_error());
    
    $user = "admin";

    if ($user) {
    
	echo "* Creating User $user";
	$id = user_add($user);

	echo ", assigned id: $id, now applying profile.\n";
	user_modify($id,"","",$user,"Administrator",0);
    
	profile_add_option($id,"ADMIN_ACCESS"); 
        profile_add_option($id,"ADMIN_USERS"); 
	profile_add_option($id,"ADMIN_SYSTEM"); 
	profile_add_option($id,"ADMIN_HOSTS"); 
	profile_add_option($id,"MESSAGES_VIEW_ALL"); 
	profile_add_option($id,"REPORTS_VIEW_ALL_INTERFACES"); 
    }
