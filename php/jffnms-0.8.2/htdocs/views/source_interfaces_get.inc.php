<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($map_id > 1) $only_rootmap = 0;
    
    $interfaces_filter = array("map"=>$map_id,"host"=>$host_id,"in_maps"=>$only_rootmap,"map_order"=>1,
	"only_active"=>$active_only,"alarms_summary"=>0,"with_field_type"=>1, "client"=>$client_id);

    $alarms = $interfaces->status(NULL,$interfaces_filter); //get alarm list
    $ids = array_keys($alarms); //get first list of ids
    
    if (count($ids)==0) $ids[]=1; //if no alarms found, forbid the interface list from returning all the interfaces

    $interfaces_filter["graph_fields"]=1; //get graph data
    $interfaces_filter["map_cnx"]=$map_id; //get map conexion information

    if ($map_id > 1) $ids[]=1; //allow id = 1 for maps cnx
    $ints = $interfaces->get_all($ids,$interfaces_filter); //get interface data

    if (is_array($ints["field_types"])) {
	$all_types_fields = $ints["field_types"];
	unset ($ints["field_types"]);
    }
    
    $ids = array();
    while (list($key, $aux) = each ($ints)) $ids[] = array("int_id"=>$aux["id"],"pos_id"=>$key); //make a interface id list

    foreach ($ids as $aux_id) { 
	$alarm_data = $alarms[$aux_id["int_id"]]; //get alarm data
	$item = $ints[$aux_id["pos_id"]]; //get interface data

    	list ($aux1, $bgcolor, $fgcolor, $aux1, $alarm_name) = alarms_get_status ($alarm_data); //process alarms

	$alarm_name = ($alarm_name=="total")?NULL:$alarm_name;

	$aux=array(
	    //required
	    "id"=>$item["id"],
	    "interface"=>$item["interface"],
	    "host"=>$item["host"],
	    "make_sound"=>$item["make_sound"],
	    "type"=>$item["type_description"],
	    "type_id"=>$item["type"],
	    //if the host is in show, use the interface show field, if its not, use the host field 
	    "show_rootmap"=>($item["zone_show"]==1?(($item["host_show"]==1)?$item["show_rootmap"]:$item["host_show"]):$item["zone_show"]),
	    "check_status"=>$item["check_status"],

	    //alarm
	    "alarm_name"=>$alarm_name,
	    "alarm_type_id"=>($alarm_name)?$alarm_data[$alarm_name]["type_id"]:NULL,
	    "alarm_type_description"=>($alarm_name)?$alarm_data[$alarm_name]["type"]:NULL,
	    "alarm_start"=>($alarm_name)?$alarm_data[$alarm_name]["start"]:NULL,
	    "alarm_stop"=>($alarm_name)?$alarm_data[$alarm_name]["stop"]:NULL,
	    "alarm"=>($alarm_name)?$alarm_data[$alarm_name]["alarm_id"]:NULL,
	    "bgcolor_aux"=>($alarm_name)?$bgcolor:NULL,
	    "fgcolor_aux"=>($alarm_name)?$fgcolor:NULL,

	    
	    //internal
	    //host
	    "host_name"=>$item["host_name"],
	    "host_ip"=>$item["host_ip"],

	    //client
	    "client_id"=>$item["client"],
	    "client_name"=>$item["client_name"],
	    "shortname"=>($item["client_shortname"]?$item["client_shortname"]:$item["client_name"]),

	    //zone
	    "zone"=>$item["zone_name"],
	    "zone_id"=>$item["zone"],
	    "zone_shortname"=>$item["zone_shortname"],
	    "zone_image"=>$item["zone_image"],

	    //type
	    "have_graph"=>$item["have_graph"],
	    "have_tools"=>$item["have_tools"],
	    "db_break_by_card"=>$item["db_break_by_card"],
	    "default_graph"=>$item["default_graph"],

	    //map
	    "map_int_id"=>($map_id>1)?$item["map_int_id"]:NULL,
	    "map_x"=>($map_id>1)?$item["map_x"]:NULL,
	    "map_y"=>($map_id>1)?$item["map_y"]:NULL
	);

	//Interface Type Specific Fields Management

	$fields = &$all_types_fields[$item["type"]];

	$aux_description = array();
	if (is_array($fields) && ($item["id"] > 1))	
	foreach ($fields as $fname=>$fdata)
	    switch ($fdata["type"]) {
	    
		case 7: 	if (!empty($item[$fname])) 
				    $aux_description[$fdata["description"]] = //Sanitize the Description
					str_replace("\r\n","",nl2br(htmlspecialchars($item[$fname])));
				break;
		
		case 3: 	$aux["index"] = $item[$fname];
				break;
		
		case 8:		$aux[$fname] = $item[$fname];
				break;
	    } 

	$aux["description"] = $aux_description;

	ksort($aux);
	$items[]=$aux;
    }

    unset($fname);
    unset($all_types_fields);
    unset($fields);    
    unset($aux_description);
    unset($interfaces_filter);
    unset($alarms);
    unset($ints);
    unset($key);
    unset($aux_id);
    unset($ids);
    unset($item);
    unset($alarm_data);
    unset($int_id);
    unset($aux1);
    unset($fgcolor);
    unset($bgcolor);
    unset($alarm_name);
    unset($aux);
    
    //debug ($items);
?>
