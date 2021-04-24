<?
/* Launcher System. This file is part of JFFNMS
 * Copyright (C) <2004-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function launcher_empty_items () {
	return array();
    }
    
    function launcher_system_init() {
	return true;
    }
    
    function launcher_heartbeat() {
	ob_end_clean();
        echo ".";
        flush();
        ob_flush();
        ob_start();
    }

    function read_child($child, $wait = 1) {

	$r = array($child["output"]);
	
	if (($wait===false) || ($nr = stream_select($r, $w = NULL, $e = NULL, $wait)) !== false) {
	    $ret1 = fgets($child["output"]);
	    if ($ret1!=false) $ret .= rtrim($ret1,"\n");
	}

	return $ret;
    }

    function write_child($child, $text) {
	return fputs($child["input"], $text."\n");
    }
    
    function start_child ($heartbeat) {
	$command = get_config_option("php_executable")." -q ".$_SERVER["argv"][0]." - $heartbeat";

	$res = proc_open($command, array(0=> array("pipe","r"), 1=>array("pipe","w")), $pipes);

	sleep(1);	//PHP Startup wait time
		
	if (is_resource($res)) {

	    stream_set_blocking($pipes[1], false);
	
	    $child = array("resource"=>$res, "input"=>$pipes[0], "output"=>$pipes[1], "status"=>READY);
	    list(,,$child["pid"]) = explode(" ",read_child($child,10));
	    
	    logger(str_pad("START",10)."Started child with PID ".$child["pid"]."\n");

	    return $child;
	}    
	
	return false;				    
    }
    
    function stop_child($child, $reason = "") { 

	$text = "Stopping child with PID ".$child["pid"].", reason: $reason and it";
    
	fputs ($child["input"],"quit\n");

	$goodbye = str_replace(".","",read_child($child));
    	
	if ($goodbye!=="")
	    $text .= " exited normally saying: $goodbye";
	else {
	    $result = posix_kill($child["pid"], 9);
	    $text .= " had to be Killed!";
	}
	
	fclose($child["input"]);
	fclose($child["output"]);
	//proc_close($child["resource"]);
	unset ($child["resource"]);
	
	logger(str_pad("STOP",10).$text."\n");
	
	sleep(1);
	
	return ($result==0)?true:false;
    }

    function launcher_system_status ($time_passed, &$remaining_items, &$pending_items, &$bad_items,
	&$done_items, &$childs, &$childs_ids, $running_childs, $number_of_items) {
	
        for ($id = 0; $id < count($childs_ids); $id++)
            if (is_array($childs[$childs_ids[$id]]))		// Create a Scoreboard-type list of the childs status
        	$childs_status .= (($childs[$childs_ids[$id]]["status"]==READY)?"R":(($childs[$childs_ids[$id]]["status"]==BUSY)?"W":"I"));

        //Output everything
        logger (str_pad("STATUS",10)."Remaining/Pending/Done/Bad=Total items: ".
        	count($remaining_items)."/".count($pending_items)."/".
	        count($done_items)."/".count($bad_items)."=".$number_of_items.
		", Childs: ".$running_childs.":".$childs_status.", Time ".$time_passed."\n");
    }    
    
    function child_status ($child, $result) {
	$status = (current(explode(" ",$result))=="OK")?true:false;

	logger (str_pad("WORK",10)."Child ".str_pad($child["pid"],7)." ".
	    ($status				
    		?"finished working on item ".str_pad($child["item"],3)
		:"had a problem with item ".str_pad($child["item"],3))
	    ." Status: $result\n");

	return $status;
    }

    // Program Body


    $jffnms_functions_include="engine";
    include_once("../conf/config.php");

    // Select the launcher mode
    // TODO Windows expcetions to the new master
    if (!isset($launcher_mode) && ($_SERVER["argv"][1]=="master")) 	$launcher_mode = "master";
    if (!isset($launcher_mode) && (!isset($_SERVER["argv"][1])))	$launcher_mode = "old_master";
    if (!isset($launcher_mode) && ($_SERVER["argv"][1]=="-"))		$launcher_mode = "managed";
    if (!isset($launcher_mode) && (count($_SERVER["argv"]) > 0))	$launcher_mode = "old_child";

    if (!isset($launcher_item_source)) $launcher_item_source = "launcher_empty_items";

    if (!isset($launcher_mode)) {
	logger ("Launcher Mode could not be defined.\n");    
	exit;
    }

    if ($launcher_mode=="master") {

	sleep(5);
	if (is_process_running(join(" ", $_SERVER["argv"]),2))
	    die ("Process Already Running.\n");


	$time_start = time();
	set_time_limit(0);

	// child Status
	define ("READY", 0);
	define ("BUSY", 1);
	define ("RESTING", 2);

	// Configuration
	$number_of_childs_at_start = (!is_numeric($_SERVER["argv"][2])?5:$_SERVER["argv"][2]);

	if (!isset($launcher_detach)) $launcher_detach = true;

	if (!isset($timeout)) $timeout = 30;
	if (!isset($max_tries)) $max_tries = 2;
	if (!isset($rest_time)) $rest_time = 3;
	if (!isset($read_timeout)) $read_timeout = 3;
	if (!isset($heartbeat)) $heartbeat = 5;

	if (!isset($refresh_time)) $refresh_time = 120;
	if (!isset($refresh_items)) $refresh_items = true;
	if (!isset($max_refresh_time)) $max_refresh_time = (60*60*1);

	if (!isset($launcher_init)) $launcher_init = "launcher_system_init";
	if (!isset($launcher_status)) $launcher_status = "launcher_system_status";
	if (!isset($launcher_child_status)) $launcher_child_status = "child_status";
	if (!isset($launcher_time_status)) $launcher_time_status = 1;

	if (!isset($launcher_start_end_status)) $launcher_start_end_status = true;

	if ($launcher_detach==true)
	    detach();

	//internal data
	$remaining_items = array();
	$pending_items = array();
	$done_items = array();
	$bad_items = array();
	$running_childs = 0;
	$number_of_items = 0;
	$childs = array();
	$childs_ids = array();
	$first_run = true;

	call_user_func_array($launcher_init, array());

	if ($launcher_start_end_status)	
	    logger("Launcher Starting. Parameters: childs: $number_of_childs_at_start, Timeout: $timeout, ".
		"item Retries: $max_tries, Rest Time: $rest_time secs, ".
	        "Read Timeout: $read_timeout, Child Hearbeat every $heartbeat secs.\n");

	while (true) { 
	
	    if ((!$refresh_items && $first_run) || ($refresh_items && ($old_refresh_time + $refresh_time) < $now)) {

		//item List
	        db_close();				//DB is not longer needed
		$items = call_user_func_array($launcher_item_source, array($refresh_items));
		db_close();				//DB is not longer needed
		$number_of_items = count($items);

		foreach ($items as $item)
		    $remaining_items[$item]=0;		//Put each item with 0 tries

	        unset ($items);

		logger (str_pad("ITEMS",10)."Added ".$number_of_items." items\n");
	
		$number_of_childs = ((count($remaining_items)>$number_of_childs_at_start)	// we have more items than childs
		    ?$number_of_childs_at_start						// thats ok
	    	:count($remaining_items));							// if we have more childs, then we will only need as much items we have

		$old_refresh_time = $now;
		$first_run = false;
	    }
	    	    
	    $read_fd = array();								//Get the Output FDs from each child
	    for ($id = 0; $id < count($childs_ids); $id++)
		if (is_array($childs[$childs_ids[$id]]) && is_resource($childs[$childs_ids[$id]]["output"]))
		    $read_fd[] = $childs[$childs_ids[$id]]["output"];
	
	    if (count($childs_ids) == 0) 
		sleep($read_timeout);
	
	    if (($running_childs > 0) && (false !== ($nr = stream_select($read_fd, $write = NULL, $except = NULL, $read_timeout))))
	        for ($o = 0; $o < count($childs_ids); $o++)
		    if (is_array($childs[$childs_ids[$o]]) && in_array($childs[$childs_ids[$o]]["output"], $read_fd)) {	//to see if his FD had data
			$id = $childs_ids[$o];

			$data = read_child($childs[$id], false);	// Read data from the child in question
			
			if ($data!="")
			    $childs[$id]["time"] = $now;		// Update the last communication timestamp
			
			$data = str_replace(".","",$data);		// Remove the dots from the input because it may also contain a response
			
			if ($data!=="") {				// If it had something else than the dots
			
			    $item = $childs[$id]["item"];		//get the running item
			
			    $childs[$id]["status"] = RESTING;			//This child finished its work, now to rest

			    // Call Child Status function
			    $result = call_user_func_array($launcher_child_status, array($childs[$id], $data));

			    if ($result) {					//if the response was OK and it did all the items

				$done_items[$item]=$pending_items[$item];	// Copy the item to the done list

			        unset ($pending_items[$item]);			// Remove it from the pending list
			        $childs[$id]["item"] = NULL;			// This child is not working on this item now
			    
			    } else {						// If it was not OK, then it was an error
				
				$remaining_items[$item] = $pending_items[$item];	// Get the item back to the remaining list
				unset ($pending_items[$item]);				// Remove it from the pending list

				stop_child($childs[$id]);
			    }
			} else	// Data was just dots (ie it has been doing something), so we only needed to update the timestamp
			    ;//logger (str_pad("WORK",10)."child $id, is working on item $item\n");
		    }
	    
	    $items_put_to_work = 0;
	    
	    for ($o = 0; $o < count($childs_ids); $o++)
		if (is_array($childs[$childs_ids[$o]])) {
		    $id = $childs_ids[$o];

		    		
		    // Let the childs rest
		    if (($childs[$id]["status"]==RESTING) && 				// its busy
		        (($childs[$id]["time"] + $rest_time) < $now))			// it has passed the rest time
		    	    $childs[$id]["status"] = READY;				// mark it as ready

		    // Give childs Work
		    if (($childs[$id]["status"]==READY) && (count($remaining_items) > 0)) { 	// if its ready and we've remaining items
		
			reset($remaining_items);
			
			while (list($item) = each ($remaining_items))
			if (!isset($pending_items[$item]) &&					// it was not in the pending list
			    ($remaining_items[$item] < $max_tries)) {				// tries not excedded
			    
			    $remaining_items[$item]++;						// count that we're trying this item one more time

		    	    logger(str_pad("WORK",10)."Child ".str_pad($childs[$id]["pid"],7)." was ready, putting it to work on item $item, Try: ".($remaining_items[$item])."\n");

			    write_child($childs[$id], $item);					// Tell this child to do this item
		    
		    	    $pending_items[$item]=$remaining_items[$item];			// Copy this item data to the pending list
		    	    unset ($remaining_items[$item]);					// Remove it from the Remaining List

		    	    $childs[$id]["item"] = $item;					// Save that this child is working on this item
		    	    $childs[$id]["status"] = BUSY;					// Mark it as busy
		    	    $childs[$id]["time"] = $now;					// Update the last communication with the child timestamp

			    if (++$items_put_to_work > 10) break 2;

			    break;
			}
		    }
		    
		    // Restart hanged childs
	    	    if (($timeout!==false) &&						// TimeOut Enabled
			//($childs[$id]["status"]==BUSY) && 				// its busy
			(($childs[$id]["time"] + $timeout) < $now)) {			// it has passed timeout

			$item = $childs[$id]["item"];
			$remaining_items[$item] = $pending_items[$item];		// Copy this item from the pending to the remaining list
			unset ($pending_items[$item]);					// Remove it from the pending list

			stop_child($childs[$id], "timeout");				// Stop this child
			unset ($childs[$id]);						// Remove it from the childs list
			$running_childs--;						// count one less

			break;								// Don't do anything else
		    }

		    // Stop useless childs
		    
		    if (($refresh_items==false) && ($childs[$id]["status"]!=BUSY) && 		// its ready and we're not going to refresh
			((count($pending_items) + count($remaining_items)) < $running_childs)) {// Less pending than childs
			
			stop_child($childs[$id], "is not needded");				// kill a child
			unset ($childs[$id]);
			$running_childs--;							// count one less
			$number_of_childs--;							// We will need only child less
		    }
		}

	    // Bad items
	    foreach ($remaining_items as $item=>$aux)
		if ($remaining_items[$item] >= $max_tries) {		//If this item has been tried more than our max.
	
		    logger(str_pad("WORK",10)."Item $item re-tries excedded (".$remaining_items[$item]."), giving up.\n");

		    $bad_items[$item]=$remaining_items[$item];		// Copy it to the bad items list
		    unset ($remaining_items[$item]);			// Remove it from the Remaining list
		}

	    // Start childs
	    $number_of_childs_started = 0;
	    if ((count($pending_items) + count($remaining_items)) > $running_childs)		// if there are more reaminign items than needed childs
		while ($running_childs < $number_of_childs) {		// If we have less running childs than we should
		    $child = start_child($heartbeat);			// Start one more
		    if (is_array($child)) {			
			$childs[]=$child;					// Add it to the childs list
		        $running_childs++;					// Count one more
		    }
		    if (++$number_of_childs_started > 5) break;
		}

	    $now = time();
	    $childs_ids = array_keys($childs);
    	    
	    // Status output
	    if ($time_status_old + $launcher_time_status < $now) {	// if more than X seconds passed since last

		$time_passed = $now - $time_start;			// Count how much time has passed

		if (isset($launcher_status))
		    call_user_func_array($launcher_status,
			array($time_passed, $remaining_items, $pending_items, $bad_items, $done_items,
			    $childs, $childs_ids, $running_childs, $number_of_items));
	
		$time_status_old = $now;
	    }

	    if (!$refresh_items && (count($remaining_items)==0) && (count($pending_items)==0)) 	// While we have Remaining or Pending items
		break;

	    if (($max_refresh_time!==false) && ($time_start + $max_refresh_time < $now)) 	// While we have Remaining or Pending items
		break;

	} //while (true)

	for ($o = 0; $o < count($childs_ids); $o++)
	    if (is_array($childs[$childs_ids[$o]])) {
	        $id = $childs_ids[$o];
	
		stop_child($childs[$id], "is not needded");				// kill a child
		unset ($childs[$id]);
	    }
	    
	if ($launcher_start_end_status)	{

	    $time_passed = $now - $time_start;			// Count how much time has passed
	    ksort($bad_items);

	    logger("Launcher Ended. Parameters: childs: $number_of_childs_at_start, Timeout: $timeout, ".
		"item Retries: $max_tries, Rest Time: $rest_time secs, ".
	        "Read Timeout: $read_timeout, child Hearbeat every $heartbeat secs. ".
		"Total Time: $time_passed sec\n".
	        ((count($bad_items) > 0)
		    ?"We couldn't finish processing the following items: ".join(", ",array_keys($bad_items))
		    :"All Items were processed correctly.").
		"\n");
	}
    }

    // OLD child system
    if ($launcher_mode == "old_master") {

	$items = call_user_func_array($launcher_item_source, array($refresh_items));
	$cant = count($items);
	if (!isset($items_per_child)) $items_per_child = 2;
	
	//$number_of_childs = 3;
	//$items_per_child = round($cant/$number_of_childs)+1;
	
	for ($i = 0; $i < $cant; $i += $items_per_child) {
	    spawn (false, join(",",array_slice($items, $i, $items_per_child))." 0 0 0"); //fork myself with this paremeters
	    sleep(2); //wait before spawning new proceses
	}
    }

    // Managed child
    if ($launcher_mode == "managed") {    
	$heartbeat = is_numeric($_SERVER["argv"][2])?$_SERVER["argv"][2]:5;

	if (!isset($read_timeout)) $read_timeout = 3;
	if (!isset($launcher_goodbye)) $launcher_goodbye = true;
	
	set_time_limit(0);
	
	$fp = fopen("php://stdin","r");
	
	echo "READY PID ".posix_getpid()."\n";
	
	$gc_save_vars = array();

	while (!feof($fp) && ($input!="QUIT")) {
	    
	    $read_fd = array($fp);
	    $input = "";
	    
	    if (false !== ($nr = stream_select($read_fd, $write = NULL, $except = NULL, $read_timeout))) 
		if ($nr > 0) {
		    $input = strtoupper(trim(fgets($fp)));
		    $heartbeat_timer = time();
		}
	    
	    if (($heartbeat_timer > 0) && ($heartbeat_timer + ($heartbeat*50)) < time()) {
	    	$input = "QUIT";
		$launcher_goodbye = false;
	    }
	    
	    if (($input!=="") && ($input!="QUIT")) {
	    
		$input = "POLL ".trim(str_replace("POLL","",$input));
		$params = array_slice(explode(" ",$input),1);	//remove the first item

		if (count($gc_save_vars)==0) {		//GC: save all tue current variables
		    foreach ($GLOBALS as $key=>$val)
			$gc_save_vars[$key]=$key;
		    $gc_save_vars["gc_save_vars"]=true;
		}

		if (count ($params) > 0) {

		    if (isset ($launcher_function)) {

			if (isset($launcher_param_managed_handler))
			    $params = call_user_func($launcher_param_managed_handler, $params);

			$result = call_user_func_array($launcher_function, $params);
			
			$result = "OK ".join(" ",$result);
		    } else
			$result = "ERROR Function not set";
		} else
		    $result = "ERROR item not set";

		echo $result."\n";
		$heartbeat_timer = time();
		
		//GC: unset all globals that are not in the gc_save_vars array 
		foreach ($GLOBALS as $key=>$val)
        	    if (!isset($gc_save_vars[$key])) {
			unset($GLOBALS[$key]);
			unset($$key);
		    }
	    }
	}
	
	if ($launcher_goodbye)
	    echo "BYE Quit.\n";
    }

    // Old System Child
    if ($launcher_mode == "old_child") { 
	if (isset ($launcher_function)) {

	    $params = array_slice($_SERVER["argv"],1);	//remove the first item
	
	    if (isset($launcher_param_normal_handler))
		$params = call_user_func($launcher_param_normal_handler, $params);

	    call_user_func_array($launcher_function,$params);
	}
    }
?>
