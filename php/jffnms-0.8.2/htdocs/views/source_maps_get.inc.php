<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
/*
    id, make_sound, show_rootmap, alarm (id), fgcolor_aux, bgcolor_aux, alarm_name, have_graph, 
    db_break_by_card, alarm_type_id (event type), default_graph
    interface, type, host
    
    break_by_card: interface, type
    break_by_zone: zone, zone_id, zone_image
    break_by_host: host_name, zone_shortname, host(id), zone_image 
*/
    $api = $jffnms->get("maps");

    $cant = $api->get();
    if ($cant > 0)   
    while ($map = $api->fetch()) 
	if (($map["id"]>1) && (($map_id==1) || ($map_id == $map["id"]))) { //if not rootmap and ( requested mas is all or requested = actual) 
	    
	    $alarms = $api->status($map["id"]);
	    
	    list ($status, $bgcolor, $fgcolor, $status_long, $alarm_name) = alarms_get_status ($alarms);
	
	    if (($active_only==0) || (count($alarms) > 1)) { //if all hosts or host with more than total in alarms (has a alarm)
	        $item = array(
			//required info
			"id"=>$map["id"],
		        "host"=>$map["id"],
			"make_sound"=>1,
			"show_rootmap"=>1,
			"check_status"=>1,
		        "db_break_by_card"=>0,
			"type"=>"Maps",
			"interface"=>"Map".$map["id"],
			
			"alarm"=>(($alarms[$alarm_name]["alarm_id"]!=ALARM_UP)?$alarms[$alarm_name]["alarm_id"]:NULL),
			"fgcolor_aux"=>$alarms[$alarm_name]["fgcolor"],
			"bgcolor_aux"=>$alarms[$alarm_name]["bgcolor"],
			"alarm_name"=>(($alarm_name!="total")?$alarm_name:NULL),
			"alarm_type_id"=>0, //fixed, use only for administrative

		        //internal info
			"map_status"=>$status,
			"map_status_long"=>$status_long,
			"map_name"=>$map["name"]
		    );
		    $items[] = $item;
		    unset ($item);
	    }
	    unset ($alarm_name);
    	    unset ($alarms);
	    unset ($map);
	}

	if (count($items) > 0)
	    array_key_sort(&$items, array("map_name"=>SORT_ASC));
	
	unset ($cant);
	unset ($api);
?>
