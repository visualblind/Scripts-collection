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
    $api = $jffnms->get("hosts");

    $cant = $api->get();
    if ($cant > 0)   
    while ($host = $api->fetch()) 
	if ($host["show_host"]>0) { //dont show 
	    
	    $alarms = $api->status($host["id"], $map_id, $only_rootmap, $client_id);
	    
	    if (($host["id"] > 1) && ((($map_id == 1) && ($client_id==0)) || ($alarms[total][qty] > 0))) { 

		list ($status, $bgcolor, $fgcolor, $status_long, $alarm_name) = alarms_get_status ($alarms);
	
		if (($active_only==0) || (count($alarms) > 1)) { //if all hosts or host with more than total in alarms (has a alarm)
		    $item = array(
			//required info
			"id"=>$host["id"],
		        "host"=>$host["id"],
			"make_sound"=>1,
			"show_rootmap"=>$host["show_host"],
			"check_status"=>$host["poll"],
		        "db_break_by_card"=>0,
			"type"=>"Hosts",
			"interface"=>"Host".$host["id"],
			
			//alarm info
			"alarm"=>(($alarms[$alarm_name]["alarm_id"]!=ALARM_UP)?$alarms[$alarm_name]["alarm_id"]:NULL),
			"fgcolor_aux"=>$alarms[$alarm_name]["fgcolor"],
			"bgcolor_aux"=>$alarms[$alarm_name]["bgcolor"],
			"alarm_name"=>(($alarm_name!="total")?$alarm_name:NULL),
			"alarm_type_id"=>0, //fixed, use only for administrative

		        //internal info
			"host_status"=>$status,
			"host_status_long"=>$status_long,
			"host_ip"=>$host["ip"],
			"host_name"=>$host["name"],
			"host_lat"=>$host["lat"],
			"host_lon"=>$host["lon"],
			"zone"=>$host["zone_description"],
			"zone_image"=>$host["zone_image"]
		    );
		    $items[] = $item;
		    unset ($item);
		}
		unset ($alarm_name);
	    }
    	    unset ($alarms);
	    unset ($host);
	}
	unset ($cant);
	unset ($api);
?>
