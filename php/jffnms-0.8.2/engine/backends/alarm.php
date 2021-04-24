<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    // backend_parameters = EventTypeId (to generate the alarm),[alarm_state|nothing] (if result is empty what to use), time_wait (seconds to wait before between down and up events

function backend_alarm($options,$alarm_description) {
    
    if (is_string($alarm_description)) { // This is used with the pollers

	//if we recieved an | in the result, parse it to use the right part as th event_info for the new event
    
	if (strpos($alarm_description,"|")!==FALSE) list ($alarm_description,$event_info) = explode ("|",$alarm_description);
	if (strpos($alarm_description,";")!==FALSE) list ($alarm_description,$event_info) = explode (";",$alarm_description);

    } else {				// this is used by the trap system

	$alarm_description = $options["status"];
	$event_info = $options["info"];
    }

    
    // Parse paramters
    list($event_type_id,$assume,$time_wait) = explode(",",$options["backend_parameters"]);

    // Assing parameters or defaults
    if (empty($time_wait)) $time_wait = 60; // 1 minute

    if (empty($alarm_description)) { 		//if no result
	if (empty($assume))			//and assume is not set    
	    $alarm_description = "down"; 	//assume 'down'
	else
	    if ($assume!="nothing")
		$alarm_description = $assume; 	//assume that as the result
    }
    
    $alarm_state = alarm_lookup($alarm_description); //get the internal state from the descriptive name (closed => ALARM_DOWN)
        
    if ($event_type_id && $alarm_state) { 
	$now = time();
	$now_date = (isset($options["date"])?$options["date"]:date("Y-m-d H:i:s",$now)); // use date set in the params (traps), or now 
	
	$processed = 0;
	
	$other_alarm = have_other_alarm($options["interface_id"],$event_type_id,array(ALARM_DOWN,ALARM_TESTING));
	//var_dump($other_alarm);
	
	if ($alarm_state == ALARM_ALERT) { //I got an ALERT result, then create the alert event
	    $processed = 1;
	}
	
	if (($alarm_state == ALARM_UP) && ($other_alarm["cant"] > 0)) { //I got an UP and there was a down event, update it
	    
	    $start_date_unix = strtotime($other_alarm["alarm"]["start_date"]);
	    $date_aux = $start_date_unix+$time_wait;
	    //logger("Verify: $start_date_unix + 3min = $date_aux - now: ".time()."\n");
	
	    if ($now > $date_aux ) {//if it has 3 minutes down, for not colliding with the consolidate events
		$processed = 1;
	    } else {
		//FIXME Detect flapping, I got an UP 3 minutes after the DOWN
	    }
	}

	if  ((($alarm_state == ALARM_DOWN) || ($alarm_state == ALARM_TESTING)) && 
	     (($other_alarm["cant"]==0) || ($other_alarm["alarm"]["alarm_state"]!=$alarm_state))){
    	    //we got a down/testing, and there is not another event or the event found is the NOT same as this one, then add it	
	    
	    if ($alarm_state == ALARM_TESTING) $event_info = "(looped)";
	    $processed = 1;
	}

	if ($processed==1) {
    	    $event_id = insert_event($now_date,$event_type_id,$options["host_id"],$options["interface"],$alarm_description,$options["poller_name"],$event_info,0,0);
	    return "Event Added: $event_id";
	} else
	    return "Nothing was done";

    } else
	return "Invalid Result"; 
}

?>
