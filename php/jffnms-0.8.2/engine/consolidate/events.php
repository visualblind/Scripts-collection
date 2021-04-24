<?
/* Events Analizer is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $query_events = "
	SELECT  /*! HIGH_PRIORITY */ 
		events.id, events.date, events.type, alarm_states.state,
		interfaces.id as interface, alarm_states.id as alarm, types.alarm_up, types.alarm_duration

	FROM 	events, types, interfaces, alarm_states

	WHERE 	events.interface != '' and events.state != '' and 
		events.type = types.id and events.interface = interfaces.interface and 
		events.host = interfaces.host and types.generate_alarm = 1 and 
		events.analized = 0 and alarm_states.description = events.state and
		interfaces.check_status = 1

	GROUP BY    	events.id, events.date, events.type, alarm_states.state,
			interfaces.id, alarm_states.id, types.alarm_up, types.alarm_duration

	ORDER BY	events.date asc, events.id asc, interfaces.id";

    //var_dump ($query_events);
    $result_events = db_query ($query_events) or die ("Query failed - consolidate events - ".db_error());

    logger( "Events to Process: ".db_num_rows($result_events)."\n");
    
    while ($event = db_fetch_array($result_events)) {
	$processed = 0;

	if (($event["alarm_up"]) && ($event["alarm_up"] > 1)) $event["type"] = $event["alarm_up"]; // override type

	logger( "E ".$event["id"].":= @".$event["date"]." - state: ".$event["state"].
		" - int: ".$event["interface"]." - type: ".$event["type"]."\n");
	
	//find a down
	$other_alarm = have_other_alarm($event["interface"],$event["type"],array(ALARM_DOWN,ALARM_TESTING)); //verify down or testing 
	logger( "E ".$event["id"].":= Other Down Alarms: ".$other_alarm["cant"]."\n");

	if ($event["state"]==ALARM_ALERT) { //alert SLA or administrative
	    $date_stop = date("Y-m-d H:i:s",(strtotime($event["date"])+$event["alarm_duration"]+30)); // add the alarm duration + 30 sec
	     
	    logger( "E ".$event["id"].":= ALERT Interface ".$event["interface"]."\n");
	    insert_alarm($event["date"],$date_stop,$event["interface"],$event["type"],$event["alarm"],$event["id"],$event["id"]);
	    $processed = 1;
	    unset($date_stop);
	}

	if (($other_alarm["cant"] > 0) && ($processed==0)) { 
	//We have found other active (down,testing) alarms of this interface
	//and the event was not an ALERT event (not already processed) then is a new DOWN or an UP
	//FIXME Flapping
	
	    $alarm_data = array("date_stop"=>$event["date"], "referer_stop"=>$event["id"]);

	    if (($event["state"]==ALARM_DOWN) || ($event["state"]==ALARM_TESTING)) {
		$other_alarm["cant"]=0; //let the next if enter.
		$alarm_data["active"] = ALARM_UP; //here we play because in the first 4 alarm_states the id is equal to the state
		//FIXME This is a FLAP also
	    } else 
		$alarm_data["active"] = $event["alarm"];
	
	    logger( "E ".$event["id"].":= UP Interface ".$event["interface"]."\n");

	    alarms_update ($other_alarm["alarm"]["start_id"],$alarm_data); //bring up the older event
	
	    //mark this, and the other alarm referer_start events as ACK (for events console)    
	    events_ack($event["id"],1);
	    events_ack($other_alarm["alarm"]["referer_start"],1);
	
	    $processed = 1;
	    
	    unset ($alarm_data);
	}

	if ((($event["state"]==ALARM_DOWN) || ($event["state"]==ALARM_TESTING)) && //it's a down or testing event
	    ($other_alarm["cant"] == 0)) {	//and we dont have any other active alarm, then is a DOWN/TESTING
	
	    logger ("E ".$event["id"].":= DOWN/TESTING Interface ".$event["interface"]."\n");
	    insert_alarm ($event["date"],"",$event["interface"],$event["type"],$event["alarm"],$event["id"],"");	    
	    $processed = 1;
	} 

	if (($processed==1) || ($event["state"]==ALARM_UP) || ($event["state"]==ALARM_DOWN) || ($event["state"]==ALARM_TESTING)) { 
    	    events_analized ($event["id"]);
	}
    }
?>
