<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //DONT EXECUTE THIS FILE... IS FOR RELEASE CONFIGURATION ONLY

    $no_db=1;
    
    include("../../conf/config.php");

    $db_type="mysql";
    $dbhost="localhost";
    $db="jffnms-release";
    $dbuser="root";
    $dbpass="sun";

    if (!$do) $do = $argv[1];
    $file_output = $argv[2];
    $fp = fopen($file_output,"w+");

    $conexion = mysql_connect($dbhost, $dbuser, $dbpass) or die ("Could not connect - CON1");
    mysql_select_db($db) or die ("Could not select DB - CON2");

//    echo "<PRE>\n";


// -1 save all
// 0 empty
// 1+ leave records with id 1 or +

$tables = Array (
" interface_types  ",-1, 
" interface_types_fields",-1, 
" interface_types_field_types",-1, 
" graph_types      ",-1, 
" alarm_states     ",-1,
" severity         ",-1,
" syslog_types     ",-1,
" trap_receivers   ",-1,
" types            ",-1,
" slas             ",-1,
" slas_cond        ",-1,
" slas_sla_cond    ",-1,
" filters          ",-1,
" filters_fields   ",-1,
" filters_cond     ",-1,
" pollers	   ",-1,
" pollers_groups   ",-1,
" pollers_backend  ",-1,
" pollers_poller_groups",-1,
" autodiscovery    ",-1,
" hosts_config_types",-1,
//" event_tools    ",-1,
" tools          ",-1,

" interfaces_values  ",1, 
" hosts_config     ",1,
" satellites        ",1,
" events_latest    ",0,
" acct             ",0,
" alarms           ",0,
" syslog           ",0,
" traps            ",0,
" traps_varbinds   ",0,
" events           ",0,

" journal	   ",2,
" clients          ",2,
" zones            ",2, //changed to allow more zones //FIXME changed back

" auth             ",1, //changed
" profiles	   ",1, //changed
" profiles_values  ",299,
" profiles_options ",-1,

" hosts            ",1,
" interfaces       ",1,
" maps             ",1,
" maps_interfaces  ",1,

" triggers   	   ",2,
" triggers_rules   ",2,
" triggers_users   ",1,
" actions	   ",-1,

" nad_networks	   ",0,
" nad_ips   	   ",0,
" nad_hosts	   ",0

);


echo "* Tables in list: ".(count ($tables)/2)."\n";
//echo "Do: $do\n";
if ($do!=1) die("No DO Parameter\n");

//$tables=Array(); //disable

  for ($i=0; $i < count($tables); $i = $i+2)
    if ($tables[$i+1] != -1) {
	
	echo "* Deleting all but ".$tables[$i+1]." records from ".trim($tables[$i])."...";
	flush();
	
	$delete="DELETE FROM ".$tables[$i]. " where id > ".$tables[$i+1];
	$result= mysql_query ($delete) or die ("Query failed - T3 - ".mysql_error());

	echo ", fixing...";

	$repair="ALTER TABLE ".$tables[$i]." AUTO_INCREMENT = 1;";
	$result= mysql_query ($repair) or die ("Query failed - T2 - ".mysql_error());

	$repair="OPTIMIZE TABLE ".$tables[$i];
	$result= mysql_query ($repair) or die ("Query failed - T2 - ".mysql_error());

	$repair="REPAIR TABLE ".$tables[$i]." EXTENDED";
	$result= mysql_query ($repair) or die ("Query failed - T2 - ".mysql_error());

	$flush="FLUSH TABLE".$tables[$i];
	$result= mysql_query ($flush) or die ("Query failed - T2 - ".mysql_error());

	echo "done.\n";
    } else { //internal tables
	$tables[$i]=trim($tables[$i]);
	
	echo "* Marking table ".trim($tables[$i])."...";
	flush();
	$repair="ALTER TABLE ".$tables[$i]." AUTO_INCREMENT = 10001;";
	fputs ($fp,"$repair\n");
	//$result= mysql_query ($repair) or die ("Query failed - T2 - ".mysql_error());
	echo "done.\n";
    
    }
    
    if (1==2)
    foreach (users_list() as $user) { //delete all users
	echo "* Deleting UserID ".$user[id]." (".$user[usern].")\n";
	user_del($user[id]);
    }

    echo "* Refixing Users Table\n";
    $result= mysql_query ("ALTER TABLE auth AUTO_INCREMENT = 1") or die ("Query failed - T3 - ".mysql_error());
    $result= mysql_query ("ALTER TABLE profiles AUTO_INCREMENT = 1") or die ("Query failed - T3 - ".mysql_error());

    $repair = "ALTER TABLE profiles_values AUTO_INCREMENT = 300;";
    fputs ($fp,"$repair\n");
    $result= mysql_query ($repair) or die ("Query failed - T3 - ".mysql_error());
    $result= mysql_query ("ALTER TABLE triggers_users AUTO_INCREMENT = 1") or die ("Query failed - T3 - ".mysql_error());

    echo "* Fixing Satellite Table\n";
    $result= mysql_query ("UPDATE satellites set url = '' where id = 1") or die ("Query failed - T3 - ".mysql_error());
    
    $user = "admin";
    //$user = "";
    $pass = crypt("admin","ad");

    if ($user) {
    
	echo "* Creating User $user";
	$id = user_add($user);

	echo ", assigned id: $id, now applying profile.\n";
	user_modify($id,"",$pass,$pass,"Administrator",0);
    
	profile_add_option($id,"ADMIN_ACCESS"); 
        profile_add_option($id,"ADMIN_USERS"); 
	profile_add_option($id,"ADMIN_SYSTEM"); 
	profile_add_option($id,"ADMIN_HOSTS"); 
	profile_add_option($id,"MESSAGES_VIEW_ALL"); 
	profile_add_option($id,"REPORTS_VIEW_ALL_INTERFACES"); 
    }

    fclose($fp);
?>
