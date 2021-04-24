<?
/* Poller. This file is part of JFFNMS
 * Copyright (C) <2002-2003> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");

    if (empty($host_id)) $host_id = $_SERVER["argv"][1];
    if (empty($interface_id)) $interface_id = $_SERVER["argv"][2];
    if (empty($sat_id)) $sat_id = $_SERVER["argv"][3];
    if (empty($poller_pos)) $poller_pos = $_SERVER["argv"][4];
    if (empty($itype)) $itype = $_SERVER["argv"][5];

    if (!$_SERVER["argv"][0]) $poller = $SCRIPT_NAME;
	else $poller = $_SERVER["argv"][0];
    
    if ($jffnms_satellite_uri=="none") $my_sat_id = 1; //Only Master Configuration, no satellites
    else $my_sat_id = satellite_get_id($jffnms_satellite_uri);
    
    if (!$my_sat_id) $my_sat_id = 1; //only master but with URL set
    
    if (!$host_id) {

	$query_hosts="Select id, satellite from hosts where id > 1 and poll = 1";
	$result_hosts = db_query ($query_hosts) or die ("Query failed - R2 - ".db_error());
	while ($host = db_fetch_array($result_hosts)) {
	
	    $paths = satellite_get_paths($host["satellite"]);
	    
	    if (is_array($paths))
		$paths = satellite_get_first_distribution_path($paths);
	    else
		if ($host["satellite"] == $my_sat_id) //local
		    $paths[]=$my_sat_id;

	    if (is_array($paths))	    
	    foreach ($paths as $sat_id) 
		if ($sat_id==$my_sat_id) { //local: I'm the one defined to poll this host
			
		    spawn (false, $host["id"]." 0 $sat_id 0 0"); //fork myself with this paremeters
		    sleep(3); //wait before spawning new proceses
		}
	}
	
	db_close();
	exit;
    }

    $time_start = time_usec();

    if ($sat_id < 1) $sat_id = $my_sat_id;
    
    $masters=array_keys(satellite_get_masters($my_sat_id)); //get Masters from DB
    if (count($masters)<1) $masters=Array($my_sat_id); //Only One
    $cant_masters = count($masters);

    foreach ($masters as $master) { 
	if ($my_sat_id!=$master) { //I'm not a master
		
	    $paths = satellite_get_paths($master); //get paths to master

	    if (is_array($paths)) {
		$paths = satellite_clean_poller_path($paths,$my_sat_id); //get only paths from me to master
	    
		$paths_description = Array();
	        foreach ($paths as $path) $paths_description[] = join(array_reverse($path),"->");
    
		$peers = satellite_get_last_distribution_path($paths); //get my peers on those paths
	    
		logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Possible Paths to $master... ".join($paths_description,", ")."\n");
    		logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Testing Satellite Conexions to $master...\n");
	    	
		$working_paths[$master]=Array();
		
		foreach ($peers as $key=>$peer) { //test all peers to the master
		    $sat = current(satellite_get($peer));
		    $ping = satellite_send_ping($sat,$master,"get","$my_sat_id-elect");
		    if ($ping["result"]==true) //test if my peer can get to the master
			$working_paths[$master][count($paths[$key])][$sat["id"]]=array("url"=>$sat["url"],"session"=>$ping["session"]);
		}
	    }
	} else
	    $working_paths[$master][0][$my_sat_id]=array("url"=>"Local"); //put me as the master local

	//select the best path
	//var_dump($working_paths[$master]);
	ksort ($working_paths[$master]); //sort by hops
	$best_paths = current($working_paths[$master]); //get all paths from the least number of hops
	if (!is_array($best_paths)) $best_paths=Array();

	$cant = count($best_paths);
	    
	if ($cant > 0) { //ok we have some destinations
	    if ($cant > 1)  //we dont want to amplify the poller, send this only once
		$pos = rand (0,$cant-1);	//pick one random path 
	    else 
		$pos = 0;
		    
	    $keys = array_keys($best_paths);
	    $peer_to_master[$master] = Array($keys[$pos]=>$best_paths[$keys[$pos]]); //select only one peer per master
	    
	    if (($cant_masters > 1) || ($my_sat_id != $master)) logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Using direct connexion to Satellite ".$keys[$pos].": ".$peer_to_master[$master][$keys[$pos]][url]."\n");
	} else { //no destinations were ok
    	    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : No Available Peer Satellites to $master.\n");
	}
    }

    $poller_plan_filter = array("interface"=>$interface_id,"host"=>$host_id,"pos"=>$poller_pos,"type"=>$itype);

    //take care of Designated Main Interfaces (DMII) 
    if ((empty($interface_id) || ($interface_id=="dmii")) && empty($poller_pos)) { 
	
	if (is_array($peer_to_master))
	foreach ($peer_to_master as $master_id=>$peer) {
	
	    if ($my_sat_id!=$master_id) { //I'm not the master
		list ($peer_sat_id,$peer_data) = each ($peer);
	
		$message = array (
		    "sat_id"=>$master_id, 
		    "class"=>"hosts",
	    	    "method"=>"status_dmii",
	    	    "session"=>$peer_data["session"],
	    	    "params"=>array($host_id)
		);
		$dmii = satellite_query ($peer_data["url"],$message);
	    
	    } else 
		$dmii = hosts_status_dmii($host_id);
	    break;
	}

	if ($dmii && ($interface_id!="dmii")) { //we have DMII down, inform and filter the poller plan
	    $poller_plan_filter["interfaces"] = $dmii;
	    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Designated Main Interface(s) ".join(",",$dmii)." is/are down, only polling them\n");

	    if ($my_sat_id!=$master_id) { //I'm not the master
		$message = array (
		    "sat_id"=>$master_id, 
	    	    "class"=>"events",
		    "method"=>"add",
	    	    "session"=>$peer_data["session"],
	    	    "params"=>array(date("Y-m-d H:i:s",time()),25,$host_id,"Polling","down","poller","Failed",1)
		);
		
		satellite_query ($peer_data["url"],$message,NULL,2);
	    } else
		insert_event(date("Y-m-d H:i:s",time()),25,$host_id,"Polling","down","poller","Failed",1);
	}
	
	if ($interface_id=="dmii") //just poll DMII
	    $poller_plan_filter["interface"] = hosts_dmii_interfaces_list($host_id);
    }

    $poller_plan_result = poller_plan ($poller_plan_filter); //Get the Poller Plan (things to poll)
    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Poller Start : ".$poller_plan_result["items"]." Items.\n"); 
    flush();

    $times = array();
    
    if (is_Array($peer_to_master)) 
    while ($poller_data = poller_plan_next($poller_plan_result)) {

	    $poller_command = $poller_data["poller_command"];
	    $backend_command = $poller_data["backend_command"];
	    $poller_filename = "$jffnms_real_path/engine/pollers/$poller_command.php";
	    $backend_filename = "$jffnms_real_path/engine/backends/$backend_command.php";

	    //unset result variables
	    unset($poller_result);
    	    $backend_result=array();
	    $backend_result_description=array();
	    $times_description=array();

	    if ((file_exists($poller_filename)==TRUE) && (file_exists($backend_filename)==TRUE)) {
		
		$time_poller_query = time_usec();
	
		include_once($poller_filename);
		$poller_result = call_user_func_array("poller_$poller_command",Array($poller_data));
	
		$time_poller_query = time_usec_diff($time_poller_query);
	
		foreach ($peer_to_master as $master_id=>$peer) {
		    $time_backend_query = time_usec();
	
		    if ($my_sat_id!=$master_id) { //I'm not the master
			list ($peer_sat_id,$peer_data) = each ($peer);

			$comment = "src:$my_sat_id-pos:$poller_pos-int:".$poller_data["interface_id"];

			$message = array (
			    "sat_id"=>$master_id, 
			    "method"=>"poller",
			    "session"=>$peer_data["session"],
			    "params"=>array( 	//only one parameter
				array(		//an array with this values
				    "host_id"=>$poller_data["host_id"],
			    	    "interface_id"=>$poller_data["interface_id"],
				    "poller_pos"=>$poller_data["poller_pos"],
				    "poller_result"=>$poller_result,
				))
			);
	
			//var_dump($message);
			
			$result = satellite_query ($peer_data[url],$message,$comment,0);
		
			//var_dump ($result); //see complete answer
	
			$backend_result[$master_id] = $result[backend_result];

		    } else { //I'm the master execute locally
			include_once($backend_filename);
			$backend_result[$master_id] = call_user_func_array("backend_$backend_command",Array($poller_data,$poller_result));
		    }
		    
		    // Profiling
		    if (isset($result["times"])) $times[$master_id]=$result["times"]; //copy the result profiling data
	
		    $times[$master_id]["backend_query"][$my_sat_id]=time_usec_diff($time_backend_query); //backend local o remote time
		    $times[$master_id]["poller_query"][$my_sat_id]=$time_poller_query; //polling time
	
		    if (isset($result["times"])) {
			$times[$master_id]["real_total"][$my_sat_id]=$times[$master_id]["backend_query"][$my_sat_id]+$times[$master_id]["poller_query"][$my_sat_id];
			$times[$master_id]["step_total"][$my_sat_id]=$times[$master_id]["real_total"][$my_sat_id]-$times[$master_id]["real_total"][$peer_sat_id];
		    }
		} //foreach master

	    } else  //no poller files
		logger("ERROR: $poller_command or $backend_command Modules not Found...",0);

	    //only to show better output

	    $times_description[]="P:".$time_poller_query; //my polling time

	    unset ($old_data);
	    
	    foreach ($backend_result as $master_id=>$data) {
		$time_data = $times[$master_id];
		
		//result data verification
		
		if (isset($old_data) && ($data!=$old_data)) 
		    logger("ERROR: Backend Result MissMatch ($data != $old_data)\n");
		
		$old_data = $data;
		
		if ($master_id == $my_sat_id) $sat = "L"; else $sat = "S$master_id";
		    
		if ($cant_masters > 1) {
		    $backend_result_description[]="$sat:$data";
		    $times_description[]="$sat:".$time_data["backend_query"][$my_sat_id];
		} else {
		    $backend_result_description[]=$data;
		    $times_description[]=$time_data["backend_query"][$my_sat_id];
		}
	    }
	    
	    //Cut the Poller Parameters String
	    $poller_param_description = isset($poller_data["poller_parameters"])?$poller_data["poller_parameters"]:"";
	    if ($aux = strlen($poller_param_description) > 10) 
		$poller_param_description = substr($poller_param_description,0,4)."..".substr($poller_param_description,strlen($aux)-4,4); 

	    //debug output	
	    logger( " :  H ".str_pad($host_id,3," ",STR_PAD_LEFT).
		    " :  I ".str_pad($poller_data["interface_id"],3," ",STR_PAD_LEFT).
		    " :  P ".str_pad($poller_data["poller_pos"],3," ",STR_PAD_LEFT).
		    " : ".(($backend_command=="buffer")?"$poller_command:":"").$poller_data["poller_name"]."(".$poller_param_description."): $poller_result ".
		    "-> $backend_command(".$poller_data["backend_parameters"]."): ".join($backend_result_description," | ").
		    " (time ".join($times_description," | ").") ".
		    "\n"
		    //.vd($times) //profiling data
		    );
	    flush();
	    $time_poller_aux = time_usec();
    } //while 
    else //if no masters
	logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Couldn't Find any Peers to any Master.\n");

    //destroy the established sessions
    if (is_Array($working_paths)) 
    foreach ($working_paths as $master_id=>$aux) foreach ($aux as $aux1)
	foreach ($aux1 as $peer_sat_id=>$peer_sat)
	    if (isset($peer_sat["session"])) { //if we have established a session with this peer
		$message=array("sat_id"=>$master_id,"method"=>"none",session_destroy=>1,"session"=>$peer_sat["session"]);	
		    
		//var_dump($message);
		$result = satellite_query ($peer_sat["url"],$message,"$my_sat_id-destroy",0);
		//var_dump($result); //see session_destory confimations
		if ($peer_to_master[$master_id][$peer_sat_id]["session"]) $use="Used";
		    else $use="Tested"; 

		if (!is_array($result["session_destroy"])) $result["session_destroy"] = array($result);

    		logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Closing $use Satellite Conexion for $master_id to $peer_sat_id ... ".join(array_reverse(array_keys($result[session_destroy])),"->")."\n");
	    }
		
    $time = time_usec_diff($time_start);
    logger(" :  H ".str_pad($host_id,3," ",STR_PAD_LEFT)." : Poller End, Total Time: $time msec.\n");

    adm_hosts_update($host_id,array("last_poll_date"=>time(), "last_poll_time"=>round($time/1000))); 

?>
