<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $current_installation = $_SERVER["argv"][1];
    $base_installation = $_SERVER["argv"][2];
    $result_path = $_SERVER["argv"][3];
    $result_name = $_SERVER["argv"][4];
    
    if (!$current_installation || !$base_installation || !$result_path || !$result_name)
	die ("Usage: php -q export_custom.php /opt/jffnms/ /opt/jffnms-0.8.x /tmp my_mods\n");

    @mkdir ($result_path);
    @mkdir ($result_path."/".$result_name);
    // Files
    
    $command = "diff -x*png -x*.ini* -x*rrd -x*log -x*sql -xjffnms.conf* -Nru ".
	    "$base_installation $current_installation > $result_path/$result_name/$result_name.patch";

    exec ($command,$result);
    
    // DB

    include($current_installation."/conf/config.php");

    $fp = fopen($result_path."/".$result_name."/".$result_name.".db.sql","w+");
    
// -1 save all
// 0 empty
// 1+ leave records with id 1 or +

$tables = array (
" interface_types  ",-1, 
" interface_types_fields",-1, 
" interface_types_field_types",-1, 
" graph_types      ",-1, 
" alarm_states     ",-1,
" severity         ",-1,
" syslog_types     ",-1,
" traps_types      ",-1,
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
" tools          ",-1,
" profiles_values  ",301,
" profiles_options ",-1,
" triggers   	   ",-1,
" triggers_rules   ",-1,
" actions	   ",-1
);

    for ($i=0; $i < count($tables); $i = $i+2) {
	$limit = ($tables[$i+1]==-1)?10000:$tables[$i+1];
	$command = "mysqldump -h $dbhost -u $dbuser -p$dbpass -n -t -c -w \"id >= $limit\" $db ".$tables[$i];
        //echo $command."\n";

	unset ($result);
        exec($command,$result);

	foreach ($result as $line)
	    if (!empty($line) && (!preg_match("/^--/",$line)))
		fputs ($fp,$line."\n");
    }
    fclose ($fp);

$command = "cd $result_path/$result_name/ ; tar -cz * > ../$result_name.tar.gz";
//echo $command;
exec ($command);

?>
