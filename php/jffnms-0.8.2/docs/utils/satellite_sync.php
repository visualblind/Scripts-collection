<?
/* Satellite Sync is part of JFFNMS
 * Copyright (C) <2003> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");

    if (!$_SERVER["argv"][0]) $sync = $SCRIPT_NAME;
	else $sync = $_SERVER["argv"][0];

    $sat_id 	= $_SERVER["argv"][1];
    $hosts_ids 	= $_SERVER["argv"][2];
    $tasks 	= $_SERVER["argv"][3];

    if (empty($tasks)) $tasks = "distribute,rrdsync,eventssync";
    
    if ($jffnms_satellite_uri=="none") die("Satellite not configured.\n");
    
    $my_sat_id = satellite_get_id($jffnms_satellite_uri);
    
    if (!$sat_id) {
	$masters = array_keys (satellite_get_masters());
	$peers = array_keys (satellite_get_peers($my_sat_id));
	
	$query_sats="
	    SELECT hosts.id as host_id, satellites.id as sat_id 
	    FROM satellites 
	    LEFT OUTER JOIN hosts on (hosts.satellite = satellites.id and hosts.id > 1)
	    WHERE satellites.id > 1 
	    ORDER by satellites.id asc";

	$result_sats = db_query ($query_sats) or die ("Query failed - R2 - ".db_error());

	while ($sat_data = db_fetch_array($result_sats)) 
	if ($my_sat_id != $sat_data["sat_id"]) { // no distribution to me

	    //echo "Host ".$sat_data[host_id]." - Sat ".$sat_data[sat_id]."\n";
	    $paths = satellite_get_paths($sat_data["sat_id"],NULL,1); //paths down to the destinations using only parents //FIXME multiple masters

	    $paths = satellite_clean_distribution_path($paths,$my_sat_id);

	    if (is_array($paths)) { //there are paths from me to the destination satellite (i'm in the middle)

		    $next_hops = satellite_get_last_distribution_path($paths);

	    	    //logger("S$my_sat_id\t: To get to Satellite ".$sat_data[sat_id]." I have to send data to satellite(s) ".join (" and ",$next_hops)."\n");
		    foreach ($next_hops as $hop) 
			if (!in_array($hop,$masters))  { //if the next hop is not a master 
			    if ($sat_data["host_id"])  //if it has a host assiged
				$distribution[$hop][]=$sat_data["host_id"]; //send host data
		    	    else 
				if (!is_array($distribution[$hop])) //empty hosts, to send only basic data
				    $distribution[$hop]=array();
		    }
	    } else 
		;//echo "No paths from $my_sat_id down to $sat_id\n";
	}
	unset ($result_sats);

	//var_dump($distribution);	
	
	if (is_array($distribution)) { //if there is something to do...
	    if (count($distribution) > 1) { //more than one destination satellite, spawn processes.
		foreach (array_keys($distribution) as $dest_sat_id) {
		    
		    $hosts = join($distribution[$dest_sat_id],",");
		    
		    if (get_config_option("os_type")=="windows") $open = "start /MIN $php_executable -q $sync $dest_sat_id $hosts $tasks";
			else $open = "$php_executable -q $sync $dest_sat_id $hosts $tasks &";

		    echo "$open\n";
		    $p = popen($open,"w");
		    sleep(2); //wait before spawning new proceses
		    unset($sat_id);
		}
	    } else { //if only one, continue directly
		$sat_id = current(array_keys($distribution));
		if (count($distribution[$sat_id]) > 0) $hosts_ids = join($distribution[$sat_id],",");
	    }
	}
    }


    if ($sat_id > 1) { //no one distributes to 1
    	if ($hosts_ids)
	    $hosts = explode (",",$hosts_ids);
	
	if ($tasks) 
	    $sync_tasks = explode (",",$tasks);

	if (in_array("distribute1",$sync_tasks)) { 
	
	    if (count($hosts) > 0)
		logger("S$my_sat_id\t: Sending Basic and Hosts $hosts_ids data to Satellite $sat_id ...\n");
	    else
		logger("S$my_sat_id\t: Sending Basic data to Satellite $sat_id ...\n");

	    $result = satellite_distribute($sat_id,$hosts);
	    //var_dump ($result);

	    $text = "S$my_sat_id\t: Satellite $sat_id sync ".$result["items"]." objects, ".$result["total_errors"]." errors, ".
		    $result["total_sent"]." items sent, ".$result["total_recv"]." recv: ".$result["total_add"]." added, ".$result["total_mod"]." modified, ".$result["total_del"]." deleted. Total time: ".$result["total_time"]."\n";
	    logger($text); 

	    if (($result["total_recv"]!=$result["total_sent"]))
		foreach ($result["data"] as $data_type=>$info)
        	    logger("S$my_sat_id\t: Satellite $sat_id - $data_type\tS:".$info["sent"]." R:".$info["recv"]." A:".$info["added"]." M:".$info["modified"]." D:".$info["deleted"]."\n");    

	    if ($result["total_errors"]>0) //if any errors were found
		foreach ($result["data"] as $data_type=>$info)
		    if (isset($info["error"])) //if this data type has an error field
			logger("S$my_sat_id\t: Satellite $sat_id Data Type: $data_type, Error: ".$info["error"]."\n");    
	}
	
	if (in_array("rrdsync",$sync_tasks)) 
	    if (count($hosts) > 0) { //if there are hosts assigned to this satellite
	    
	    	$result = satellite_rrdsync ($sat_id,$hosts);
		
		if ($result["status"]==true)
		    $text = "S$my_sat_id\t: Satellite $sat_id RRDsync ".$result["number_of_files"]." files, ".$result["stats"];
		else
		    $text = "S$my_sat_id\t: Satellite $sat_id RRDsync ".$result["number_of_files"]." files, ERROR:".$result["error"];
	    
	        logger($text);
	    }
    }

    function satellite_rrdsync ($sat_id, $hosts) {
	
	$interfaces = array();
	$status = false;
	
	foreach ($hosts as $host_id) 
	    $interfaces = array_merge($interfaces,array_keys(interfaces_list(NULL,array("host"=>$host_id))));
	
	if (count($interfaces) > 0) { //if the hosts have some interfaces

	    $interfaces_file = get_config_option("engine_temp_path")."/".uniqid("").".dat.list";
	    $rsync = "rsync";
	    $rrd_path = get_config_option("rrd_real_path");
	    $satellite_data = current(satellite_get ($sat_id));

	    //generate file with all the interface's filenames
	    $fp = fopen($interfaces_file,"w+");
	    foreach ($interfaces as $interface_id)
	        fputs($fp,"interface-$interface_id-*.rrd\n");
	    fclose($fp);
	    var_dump($interfaces_file);
	    die();    
	    preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $satellite_data["url"],$aux); 	
	    $sat_host  = $aux[2];

	    $remote_rrd_path = satellite_call ($sat_id,"jffnms","config_option","rrd_real_path");
	    
	    $rsync_command = "rsync -rzve 'ssh' --include-from=$interfaces_file --exclude='*' $sat_host:$remote_rrd_path/ $rrd_path/";
	    exec ($rsync_command,$a,$b);

	    if ($b == 0) { //everything ok
		$aux = count($a);
		$number_of_files = $aux-3; //3 is the number of informational lines
		$stats = $a[$aux-2]." ".$a[$aux-1];
		$status = true;
	    } else
		$error = join("",$a);
	    
	    unlink ($interfaces_file);
	} else
	    $error = "No Interfaces to Sync.";
	
	$result = array("status"=>$status,"number_of_files"=>$number_of_files,"stats"=>$stats,"error"=>$error);		
	return $result;
    }	    

    db_close();
?>
