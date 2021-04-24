<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function interfaces_get_by_field_value($host_id, $interface_type, $field_name, $field_value) {
    
	$query=
	    "SELECT i.id as interface_id,i.interface as interface ".
	    "FROM interfaces_values iv, interface_types_fields itf, interfaces i ".
	    "WHERE iv.field=itf.id AND iv.interface=i.id ".
		"AND itf.name='".$field_name."' AND itf.itype=".$interface_type." AND i.host=".$host_id." AND value='".$field_value."'";
    
	$result=db_query($query) or die("query failed ($query) - interfaces_get_id_by_field_value: ".db_error());
	
	if(0 < db_num_rows($result)) {
	    $row=db_fetch_array($result);
	    return $row;	    	    	    
	} else {
	    return array("interface"=>NULL,"interface_id"=>-1);
	}	
    }

    function interfaces_filter($filters = NULL) {
	$from = array();
	$where = array();
	$fields = array();
	$index = NULL;
	$order = NULL;
	
	$interface_id_filter = 1;
	
	//debug ($filters);
	if (is_array($filters))
	    foreach ($filters as $filter_type=>$filter_value) 
    		if ($filter_value)
		switch ($filter_type) { 
		
		    //normal field matches
		    case "client": 	$where[] = array("interfaces.client","=",$filter_value); break;
		    case "host": 	$where[] = array("interfaces.host","=",$filter_value); break;
		    case "type": 	$where[] = array("interfaces.type","=",$filter_value); break;
		    case "interface": 	$where[] = array("interfaces.interface","=","'$filter_value'"); break;
		    case "zone": 	$where[] = array("hosts.zone","=",$filter_value); break;

		    //interfaces in this map
		    case "map" : 	if ($filter_value > 1) {	
					    $where[] = array("maps_interfaces.interface","=","interfaces.id");
					    $where[] = array("maps_interfaces.map","=",$filter_value);
					    $from[] = "maps_interfaces";
					}
					break;

    		    //show interface in maps?
		    case "in_maps":	if ($filter_value==1) $where[]=array("interfaces.show_rootmap","!=",0); break;
    		    
		    //any where
		    case "custom":	if (is_array($filter_value)) $where=array_merge($where,$filter_value); break;
		
		    //fixed id
		    case "id": 		$where[] = array("interfaces.id","=",$filter_value); break;
		    
		    
		    //all graph fields needed for view_performance
		    case "with_graph":	$where[] = array("graph_types.type","=","interfaces.type");
					$from[] = "graph_types";
					$fields["graph_type"] = "graph_types.id"; 
					$fields["graph_type_default"] = "interface_types.graph_default"; 
					$fields["graph_type_agg"] = "graph_types.allow_aggregation"; 
					$fields["graph_type_description"] = "graph_types.description"; 
					$fields["graph_type_graph1"] 	= "graph_types.graph1"; 
					$fields["graph_type_graph1_sx"] = "graph_types.sizex1"; 
					$fields["graph_type_graph1_sy"] = "graph_types.sizey1"; 
					$fields["graph_type_graph2"] 	= "graph_types.graph2"; 
					$fields["graph_type_graph2_sx"] = "graph_types.sizex2"; 
					$fields["graph_type_graph2_sy"] = "graph_types.sizey2"; 
					$index = "no set index"; //dont summarize by ID
					break;

		    //default graph fields needed for view_interfaces
		    case "graph_fields":$where[]=array("interface_types.graph_default","=","graph_types.id");
					$fields["have_graph"]		="interface_types.have_graph";
					$fields["db_break_by_card"]	="interface_types.break_by_card";
					$fields["default_graph"]	="graph_types.graph1";
					$fields["have_tools"]		="interface_types.have_tools";
					$from[]="graph_types";
					break;
		
		    //map connections id = 1, x and y, for view_interface with map
		    case "map_cnx":	if ($filter_value > 1) {
					    $fields["map_int_id"] = "maps_interfaces.id";
					    $fields["map_x"] = "maps_interfaces.x";
					    $fields["map_y"] = "maps_interfaces.y";
					    $index = "no set index"; //to allow map conexions id = 1
					    $interface_id_filter = 0;
					}
					break;

		    //change order for view_interfaces
		    case "client_order":
		    case "map_order":	if ($filter_value==1) $order = array(
					    array("zones.zone"), array("hosts.name"), array("interfaces.type"), array("interfaces.interface"));
					break;

		    //With Host Information
		    case "host_fields": 
					$fields["host_rocommunity"]	="hosts.rocommunity";
					$fields["host_rwcommunity"]	="hosts.rwcommunity";
					$fields["host_satellite"]	="hosts.satellite";
					break;
					
		    case "only_visible":
					if ($filter_value) {
					    $where[] = array("interfaces.show_rootmap", "=", "1");
					    $where[] = array("hosts.show_host", "=", "1");
					    $where[] = array("zones.show_zone", "=", "1");
					}
					break;
		}
		
	    $where[]=array("interfaces.id",">",$interface_id_filter); //filter interface id 
	    
	    return array($where, $from, $fields, $index, $order);
    }		


    function interfaces_alarms ($ids = NULL, $filters = NULL, $alarm_filters = NULL) {
	if (!is_array($ids)) $ids=array($ids);
    
	$now = date("Y-m-d H:i:s",time());
	
	if ($start && $stop) { //FIXME implement this
	    //finished between start and end for availability
	    $fields = "SELECT interfaces.id, alarms.id as alarm, alarms.date_start, alarms.date_stop, types.description as type, interfaces.show_rootmap,";
	    $alarms_filter = "(alarms.date_start > '$start' and alarms.date_stop < '$stop')";
	    $alarm_state_filter = "alarm_states.state = ".ALARM_UP." /* UP */";
	    $order = "ORDER BY interfaces.id, alarms.date_start, alarms.date_stop desc";
	} else { 
	    //active alarms for maps
	    $fields = "SELECT interfaces.id as interface_id, alarm_states.description as alarm, alarm_states.activate_alarm as alarm_level, interfaces.show_rootmap, ".
	    "alarm_states.id as alarm_id, types.id as type_id, types.description as type, severity.bgcolor, severity.fgcolor, alarms.date_start, alarms.date_stop";
	    $alarms_filter = "(alarms.date_stop > '$now' /* SLAs */ or alarms.date_stop <= '0001-01-01 00:00:00' /* Not Ended */)"; 
	    $alarm_state_filter = "alarm_states.state != ".ALARM_UP." /* not UP */";
	    $group = "GROUP BY interfaces.id, alarms.active, alarm_states.id, alarm_states.description, alarm_states.activate_alarm, interfaces.show_rootmap, ".
		"types.id, types.description, severity.bgcolor, severity.fgcolor, alarms.date_start, alarms.date_stop";
	}

	list ($where_special,$aux_from) = interfaces_filter($filters);
	$aux_from = join(", ",$aux_from); 

	if ($filters["only_active"]==1)	
	    $alarm_join_type = "RIGHT"; //like a where, strict dont show record if it doesnt match
	else
	    $alarm_join_type = "LEFT OUTER"; //show null if not found

	$from   = "FROM zones, hosts".(($aux_from!="")?", $aux_from":"").", interfaces";
	$joins 	= 	"$alarm_join_type JOIN alarms on (alarms.interface = interfaces.id and interfaces.check_status = 1 and $alarms_filter)\n".
			"LEFT OUTER JOIN types on (types.id = alarms.type)\n".
			"LEFT OUTER JOIN severity on (types.severity = severity.id)\n". 
			"LEFT OUTER JOIN alarm_states on (alarms.active = alarm_states.id and $alarm_state_filter)";
	$where	= "WHERE interfaces.id > 1 and interfaces.host = hosts.id and hosts.zone = zones.id"; 
	
	if (is_array($where_special))
	    foreach ($where_special as $aux)
		$where .= " and ".join($aux," ");

	if (count($ids) > 0) {
	    foreach ($ids as $id) 
		if ($id) $where_ids_aux .= " or (interfaces.id = '$id')";     

	    if ($where_ids_aux) $where .= " and ((1=2)".$where_ids_aux.")";
	}
	
	$query = "$fields \n$from \n$joins \n$where \n$group \n$order";
	//debug($query);

	$result = db_query($query) or die ("Query Failed - interface_status - ".db_error());
	    
	return $result;	
    }

    function interfaces_status($ids = NULL, $filters = NULL) {
	
	$result = interfaces_alarms ($ids, $filters); 	

	if (!isset($filters["alarms_summary"])) $filters["alarms_summary"] = 1;	//Summary is Default
	if (!isset($filters["show_disabled"])) $filters["show_disabled"] = 1;	//By Default Show Disabled Interfaces

	$summary = ($filters["alarms_summary"]==1?true:false);
	$show_disabled = ($filters["show_disabled"]==1?true:false);

	$status = array();
	$all_status = array();

	while ($res = db_fetch_array($result)) {
	    //debug ($res);
	    if (!$summary) $status = $all_status[$res["interface_id"]];

	    //set total to 0
	    if (!isset($status[total][qty])) $status[total][qty]=0;

	    if ((($show_disabled) || ($res["show_rootmap"]!=2)) && 	//We're showing the disabled or interface is not disabled
		(!empty($res["alarm"]))) {					//Valid Interface Alarm
		
		$status[$res[alarm]][qty]++;
	    	$status[$res[alarm]][alarm_level]=$res[alarm_level];
		$status[$res[alarm]][bgcolor]=$res[bgcolor];
		$status[$res[alarm]][fgcolor]=$res[fgcolor];
		$status[$res[alarm]][alarm_id]=$res[alarm_id];
		$status[$res["alarm"]]["type_id"]=$res["type_id"];
		$status[$res["alarm"]]["type"]=$res["type"];
		$status[$res["alarm"]]["start"]=$res["date_start"];
		$status[$res["alarm"]]["stop"]=$res["date_stop"];
	    }

	    $status[total][qty]++; //increment total anyway
	    $status[total][alarm_level]=255;
	    $status[total][bgcolor]="64FF64";
	    $status[total][fgcolor]="000000";
	    $status[total][alarm_id]=ALARM_UP;
	    $status[total][type_id]=1;
	    ksort($status); //order so total is place at the end
	
	    if (!$summary) $all_status[$res["interface_id"]] = $status;
	}
	if (!$summary) $status = $all_status; 
	//debug ($status);

	return $status;
    }

    function interface_is_up($interface_id) {

	$query = "select alarms.id from alarms, alarm_states 
		where alarms.interface = '$interface_id' and alarms.active=alarm_states.id and alarm_states.state=".ALARM_DOWN;
	$result = db_query($query) or die ("Query Failed - IS1 - ".db_error());
	$cant = db_num_rows($result); 

	if ($cant == 0) return 1;
	    else return 0; 
    }

    function interfaces_list ($ids = NULL, $filters = NULL, $count = 0) {
    
	$index = "interfaces.id";	
    
	list ($where_special,$aux_from,$aux_fields, $aux_index, $aux_order) = interfaces_filter($filters);
    
	if ($aux_index) $index = NULL;

	$where = array_merge(
	    array(
		array("zones.id","=","hosts.zone"),
		array("slas.id","=","interfaces.sla"),
		array("hosts.id","=","interfaces.host"),
		array("clients.id","=","interfaces.client"),
		array("pollers_groups.id","=","interfaces.poll"),
		array("interface_types.id","=","interfaces.type")),
		$where_special);

	if (is_array($aux_order))
	    $order = $aux_order;
	else
	    $order =  array (
		array("interfaces.type","asc"),
		array("interfaces.interface","desc"),
		array("clients.name","asc"));
		    
	$from = array_merge(
		    array("interfaces","hosts","zones","slas","clients","pollers_groups","interface_types"),
		    $aux_from);

	if (!$count) 
	    $fields = array_merge(
		array(
		    "interfaces.id",
		    "interfaces.host",
		    "interfaces.type",
		    "interfaces.sla",
		    "interfaces.client",
		    "interfaces.show_rootmap",
		    "interfaces.interface",
		    "interfaces.poll",
		    "interfaces.check_status",
		    "interfaces.make_sound",
		    "interfaces.creation_date",
		    "interfaces.modification_date",
		    "interfaces.last_poll_date",
		    "interfaces.rrd_mode",
		    "interfaces.poll_interval",
		    "host_name"=>"hosts.name",
		    "host_ip"=>"hosts.ip",
		    "host_show"=>"hosts.show_host",
		    "host_poll_interval"=>"hosts.poll_interval",
		    "client_name"=>"clients.name",
		    "client_shortname"=>"clients.shortname",
		    "sla_description"=>"slas.description",
		    "sla_threshold"=>"slas.threshold",
		    "poller_group_description"=>"pollers_groups.description",
		    "type_description"=>"interface_types.description",
		    "zone"=>"hosts.zone",
		    "zone_name"=>"zones.zone",
		    "zone_image"=>"zones.image",
		    "zone_show"=>"zones.show_zone",
		    "zone_shortname"=>"zones.shortname"
		    ),
		$aux_fields);
	else {
	    $fields = array("count($index) as cant");
	    $index = NULL;
	    $order = NULL;
	}	
	
	//debug($filters); debug ($fields); debug ($from); debug ($where); debug ($ids); debug ($order);

	$result = get_db_list($from, $ids, $fields, $where, $order, $index);
    
	if ($count) $result = current(current($result));
	else 
	    if (count($result) > 0) {

		array_key_sort(&$result,convert_sql_sort($fields, $order));

		if ($index!=NULL) $result = array_rekey($result, "id");
							    
		//Get Interface Fields Values

		$ids = array();
		while (list ($id, $aux) = each ($result)) //get the ID of each returned interface
		    if ($aux["id"] > 1) $ids[$aux["id"]][]=$id;

    	        $data = interface_values(array_keys($ids),array("exclude_types"=>array(20)));

		while (list ($id, $aux) = each ($data["values"]))
		    foreach ($ids[$id] as $id_real)
			$result[$id_real]=array_merge($result[$id_real],$aux);

		reset ($result);

		if ($filters["with_field_type"]==1) 
		    $result = array_merge(array("field_types"=>$data["fields"]),$result);

		unset ($id_real);
		unset ($data);
	        unset ($ids);
		unset ($aux);
	    }
	
	//debug ($result);
	return $result;
    }

    function interface_count ($ids = NULL, $filters = NULL, $count = 0) {
	return interfaces_list ($ids,$filter,1);
    }

    function adm_interfaces_update($id,$interface_data) {
	
	if (key($interface_data)!="last_poll_date") //if only updating the last_poll_date don't
	    $interface_data["modification_date"]=time(); //update the modification date

	//Fix for Make Sound Bool Value
	if (array_key_exists("make_sound",$interface_data) && empty($interface_data["make_sound"])) 
	    $interface_data["make_sound"]=0;

	if (array_key_exists("check_status",$interface_data) && empty($interface_data["check_status"])) 
	    $interface_data["check_status"]=0;


	$data = interface_values($id,array("exclude_types"=>20));
	$fields = current($data["fields"]);
	$values = current($data["values"]);
	unset ($data);
	
	//debug ($interface_data);
	
	if (is_array($fields) && (count($fields) > 0)) {
	
	    //Update Handler
	    $field_data = current($fields);
	    $update_function = $field_data["update_handler"];
	    //debug ("Calling $update_function Handler");

	    $real_function = "handler_$update_function";
	    $function_file = get_config_option("jffnms_real_path")."/engine/handlers/$update_function.inc.php";
	
	    if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file)))) {
	        if (function_exists($real_function))
	            call_user_func_array($real_function,array($id, &$interface_data,$values));
	        else
		    logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
	    } else
		logger ("ERROR Loading file $function_file.<br>\n");

	    $interface_data = array_merge($values,$interface_data);
	
	    //Field processing

    	    while (list($field_name, $field_data) = each ($fields)) {
		$old_value = $values[$field_name];
		$new_value = $interface_data[$field_name];

		//Field Type Processing, could modify the new_value
	    
		$update_function = $field_data["type_handler"];
	        //debug ("Calling $update_function Handler for $field_name");

		$real_function = "handler_$update_function";
		$function_file = get_config_option("jffnms_real_path")."/engine/handlers/$update_function.inc.php";
	    
		if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file)))) {
	    	    if (function_exists($real_function))
	    		call_user_func_array($real_function,array($field_name,&$new_value));
		    else
			logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
    		} 
	    
		//Field Value Verification    

		//debug ($field_data["id"].":$field_name: $old_value => $new_value");
	    
		if ($old_value!=$new_value) { //different than before or default

		    if ($new_value == $field_data["default_value"]) { //if new is equal to default, delete value 
			//debug ("Deleting $field_name in interface $id field ".$field_data["id"]);
			interfaces_delete_value ($id,$field_data["id"]);
		    } else {  
		
			if ($old_value == $field_data["default_value"]) { //if old was equal to default, add a new value entry
			    //debug ("Adding $field_name to $new_value in interface $id field ".$field_data["id"]);
		    	    interfaces_insert_value ($id,$field_data["id"],$new_value);
			} else {
			    //debug ("Updating $field_name to $new_value in interface $id field ".$field_data["id"]);
		    	    interfaces_update_value ($id,$field_data["id"],$new_value);
			}
	    	    }
		}
		unset ($interface_data[$field_name]); //remove interface type fields from the global values
	    }
	}
	//debug ($interface_data);
	

	$result = db_update("interfaces",$id,$interface_data); //update only remaining interface-table data
	
	if (key($interface_data)!="last_poll_date") 	//if we are not just updating the last poll date
	    interface_adjust_rrd_max($id); 		// adjust the RRDs MAX values
	
	return $result;
    }

    function adm_interfaces_del($id) {
	//RRD Deletion
	$rrd_path = get_config_option("rrd_real_path");
	$type_info = interface_get_type_info($id);

	if ($type_info["rrd_mode"]==1) {
	    $rrd_file = "$rrd_path/interface-$id.rrd";
    	    if (file_exists($rrd_file)) $result["delete-rrd-$id"] = @unlink ($rrd_file);
	} else {
	    $dss = interface_parse_rrd_structure($type_info["rrd_structure_def"]);
	    foreach ($dss as $ds_name=>$ds_num) {
		$rrd_file = "$rrd_path/interface-$id-$ds_num.rrd";
    	        if (file_exists($rrd_file)) $result["delete-rrd-$id-$ds_num"] = @unlink ($rrd_file);
	    }
	    unset ($dss);
	}
	unset ($type_info);

	$result["delete-values-$id"] = interfaces_delete_value($id);
	
	$result["delete-db-$id"] = db_delete("interfaces",$id);

	$result["delete-from-maps-$id"] = adm_maps_interfaces_del_from_all($id);

	return $result;
    }

    function adm_interfaces_add($data = NULL) {
	$base_data = array("host"=>$host, "creation_date"=>time());

	if ($data===NULL) $data = 1; 				//old behavior, NULL data means host = 1
	if (is_numeric($data)) $base_data["host"]=$data; 	//old behavior, parameter was the host id
	if (is_array($data)) $base_data = array_merge($base_data,$data); //new behavior, parameter is data to be added
    
	return db_insert("interfaces",$base_data);
    }

    //RRDTOOL
    //-------

    function interface_get_type_info ($interface_id) {
    
	$query = "
	    SELECT 
		interface_types.id as type,
		interface_types.rrd_structure_step, interface_types.rrd_structure_res,
		interface_types.rrd_structure_rra, interface_types.graph_default, interfaces.rrd_mode
	    FROM 
		interfaces, interface_types 
	    WHERE 
		interfaces.type =  interface_types.id and interfaces.id = $interface_id";
	$result = db_query($query) or die ("Query failed - IGT1 - ".db_error());;

	if (db_num_rows($result) == 1) {
	    $register = db_fetch_array($result);

	    //get RRD Structure from Interface Values
	    $normal_data = interface_values($interface_id,array("exclude_types"=>20));
	    $normal_data = current($normal_data["values"]);
	    
	    $rrd_data = interface_values($interface_id,array("ftype"=>20));
	    $rrd_data = current($rrd_data["values"]);

	    if (is_array($rrd_data)) {
		$register["rrd_structure_def"] = join(" ",$rrd_data);
	
		//This is just for Physical Interfaces, legacy
		if (isset($normal_data["bandwidthin"]))
		    $normal_data["bandwidth"] = max($normal_data["bandwidthin"],$normal_data["bandwidthout"]);
		
		foreach ($normal_data as $key=>$value) //replace variables for max in rrd
		    $register["rrd_structure_def"] = str_replace("<$key>",calculate_rrd_max($value),$register["rrd_structure_def"]);
	    }

	    return $register;
	}
    }

    function calculate_rrd_max ($max) {
	$max = (($max * 1.5)/8)+1; //1.5 times the bigger bw in bytes, plus 1
	return round($max);
    }

    //to be used in update
    function interface_adjust_rrd_max($interface_id) {

	if ($info = interface_get_type_info($interface_id)) {
	    
	    $aux1 = explode(" ",trim($info["rrd_structure_def"]));
	    $filename = $GLOBALS["rrd_real_path"]."/interface-$interface_id.rrd";
	    
	    if ((is_array($aux1)) && (count($aux1) > 0)) //if it has a RRD Structure and more than 1 DS
	    foreach ($aux1 as $dsn=>$ds) {
		$aux = explode(":",$ds);
	        
		$filename_ds = str_replace(".rrd","-$dsn.rrd",$filename);

		if ($info["rrd_mode"]==1) $result[] = rrdtool_tune($filename,"-a ".$aux[1].":".$aux[5]);
		if ($info["rrd_mode"]==2) $result[] = rrdtool_tune($filename_ds,"-a data:".$aux[5]);
	    }
	}
    }

    function interface_parse_rrd_structure($structure) {
	$dss_def = explode(" ",trim($structure));

	foreach ($dss_def as $dsn=>$ds) {
	    list (,$name) = explode (":",$ds);
	    $dss[$name]=$dsn;
	}
	return $dss;
    }


    //AVAILABILITY
    //------------
    
    //FIXME merge this function with interfaces_status/interfaces_alarms because the SQL is repeated too many times
    function interface_get_availability($ids, $date_from_unix, $date_to_unix, $alarm_types, $detail = 0) {

	$time_span = 60; //span between alarms to be considered distinct
	$degraded = 30; //if the alarm lasted less than 30 seconds, it was degraded time, not unavailable 
	
	$date_from = date("Y-m-d H:i:s",$date_from_unix);
	$date_to = date("Y-m-d H:i:s",$date_to_unix);
	$period = $date_to_unix - $date_from_unix;
	
	if ($period==0) $period = 1; //fix division problems period cannot be zero
	
	if (!is_array($ids)) $ids = array($ids);
    
	foreach ($ids as $id) 
	    if ($id) $interface_ids_filter .= " or interfaces.id = $id ";
 
	if (is_array($alarm_types)) 
	    if (current($alarm_types)!="SELECT_ALL") {
    		$types_filter = " and ( 1=2 ";
		foreach ($alarm_types as $value) 
		    $types_filter.=" or alarms.type = $value"; 
		$types_filter .=" )";
	    }
	$cant_types = count($alarm_types);
	$info = array();//result
    
	$query=
	"\n Select interfaces.id, alarms.id as alarm,".
	"\n alarms.date_start, alarms.date_stop, types.description as type".
	    
	"\n\n from interfaces \n".
	
	"\n LEFT OUTER JOIN alarms on (alarms.interface = interfaces.id) and ".
	"\n (alarms.date_start > '$date_from') and (alarms.date_stop < '$date_to')".
	"\n $types_filter ".
	"\n LEFT OUTER JOIN types on (types.id = alarms.type)".
	"\n LEFT OUTER JOIN alarm_states on (alarm_states.id = alarms.active and alarm_states.state = ".ALARM_UP.")";
    
	if ($interface_ids_filter) $query .= "\n\n where ( 1=2 $interface_ids_filter)";

	$query .= "\n order by interfaces.id, alarms.date_start, alarms.date_stop desc";
	
	//debug ($query);
	$result = db_query ($query) or die ("Query failed - interface_get_availability() - ".db_error());

	$data = array();
	$unav = array();
	$ok = 1;

	$total_seconds = 0;
	$total_degraded_seconds = 0;
	
	while ($ok == 1) {
	    if (count($data) > 1) {
		if ($data[alarm]) {  //we have an alarm 
		    $start_unix = strtotime($data[date_start]);
		    $stop_unix = strtotime($data[date_stop]);
		    $duration = $stop_unix - $start_unix; //calculate duration
		    
		    if ($duration > 1) { //valid duration
		    
			if (($stop_unix > ($last+$time_span)) or ($cant_types == 1)) {

			    if ($duration < $degraded) 	//unavailable time
				$total_degraded_seconds += $duration;	

			    $total_seconds+=$duration; //add duration of the alarm
			    $last = $stop_unix; //take this alarm as the last one
			    $counted = 1;
			} else 
			    $counted  = 0;
	    
			if ($detail==1) { //save detail data
			    $detail_data = $data;
		    	    $detail_data[duration] = $duration;
			    $detail_data[counted] = $counted;
	
			    $info[interfaces][$data[id]][detail][]=$detail_data;
			}

			//outages raw array
			//Look for already used places and add a new key to not overwrite other values
			$i = 0;	
			while (isset($unav["$start_unix-$i"])) $i++;
			$unav["$start_unix-$i"]="D";
			
			$i = 0; 
			while (isset($unav["$stop_unix-$i"])) $i++;
			$unav["$stop_unix-$i"]="U";
		    }
		}
	    }

    	    $data = db_fetch_array($result) or $ok = 0; //read a new record
	    if ($old_id != $data[id]) { //when the interface changes
	
		if ($old_id > 0) { // if we had an older id, consolidate
		    $info[interfaces][$old_id][degraded_seconds] = $total_degraded_seconds;
		    $info[interfaces][$old_id][unavail_seconds] = $total_seconds;
		    $info[interfaces][$old_id][unavail_percent] = round(($total_seconds*100)/$period,3);
		    $info[summary][interfaces]++;
		}
	    
		//initialize variables
		$last=0;
		$total_seconds = 0;
		$total_degraded_seconds = 0;
	    
		$old_id = $data[id];
	    }
	} 

	list( $info[summary][unavail_seconds], $info[summary][outages]) = calculate_unavail_time($unav);
	$info[summary][total_seconds]=$period;
	$info[summary][unavail_percent] = round(($info[summary][unavail_seconds]*100)/$period,3);
	$info[summary][unavail_percent_average] = round($info[summary][unavail_percent] / $info[summary][interfaces],3);

	return $info;
    }

    function calculate_unavail_time($unav) {
	ksort($unav);
	$outages=0;
	$cant_outages=0;
	$total_duration = 0;
	$outages_data = array();

	foreach ($unav as $date=>$data) {
	    list ($date) = explode ("-",$date); //clean the date

	    if ($data=="D") {
		if ($outages == 0) {  //start outage
		    $cant_outages++;
		    $outages_data[$cant_outages][start]=$date;
		}
		$outages++;
	    }
	    else {
		$outages--;

		if ($outages == 0) {  //end outage
		    $outages_data[$cant_outages][stop]=$date;
		    $outages_data[$cant_outages][duration]=$date-$outages_data[$cant_outages][start];
		    $total_duration += $outages_data[$cant_outages][duration];    

		    //dont save data, FIXME in the future we could do some graph with this.
		    unset($outages_data[$cant_outages]);
		}
	    }
	    
	    if ($outages < 0) $outages = 0;

	    //echo "$data: ".date("Y-m-d H:i:s",$date)." OUT: $outages Duration:".$outages_data[$cant_outages][duration]."<br>";
	}	  
	
	if ($outages > 0) { //some events hanging
	    $outages_data[$cant_outages][stop]=$date;
	    $outages_data[$cant_outages][duration]=$date-$outages_data[$cant_outages][start];
	    $total_duration += $outages_data[$cant_outages][duration];    
	}

	//debug ($outages_data);
	//view_outage($outages_data);
	return array($total_duration,$outages_data);
    }

    function view_outage($unav) {
	foreach ($unav as $data)
	    echo 
		date("Y-m-d H:i:s",$data[start])." - ".
		date("Y-m-d H:i:s",$data[stop]). " - ".
		time_hms($data[duration])." (".$data[duration].")".
	    "<br>";
    }

    //INTERFACES VALUES
    //-----------------

    function interface_values ($ids = array(),$filters = array()) {
	$fields = array();
	$values = array();
	
	if (!is_array($ids)) $ids = array($ids);
	
	$ids = array_merge(array("1=2"),$ids);
	
	$ids_filter = "( ".join(" or i.id = ",$ids)." )";

	$types_filter = "";
	foreach ($filters as $filter_field => $filter_value)
	    switch ($filter_field) {
		case "exclude_types" :
					if (!is_array($filter_value)) $filter_value = array($filter_value);
					$filter_value=array_merge(array(""),$filter_value);
					$types_filter .= trim(join(" and ft.id != ",$filter_value));
					break;
		case "ftype" :
					$types_filter .= "and ft.id = ".$filter_value;
					break;
	    }
	
	$query= "
	    SELECT
		ft.description as field_type_description, ft.handler,
		f.id as field_id, f.description, f.name,  f.showable, f.overwritable, f.default_value, f.ftype,
		v.value,
		it.update_handler,
		i.type,	i.id
	    FROM
                interface_types_field_types as ft
	    INNER JOIN
                interface_types as it on (ft.id > 1 $types_filter)
	    INNER JOIN 
	        interface_types_fields as f on (f.itype = it.id and f.ftype = ft.id)
	    INNER JOIN
                interfaces as i on (it.id = i.type)
	    LEFT OUTER JOIN
                interfaces_values as v on (v.interface = i.id and v.field = f.id)
	    WHERE
		$ids_filter 
	    ORDER BY
		f.pos
	";
	//debug ($query);
	$result = db_query ($query) or die ("Query Failed - interface_values() - ".db_error());    

        while ($r = db_fetch_array($result)) {

	    $fields [$r["type"]][$r["name"]] = array(
		"id"=>$r["field_id"],
	        "description"=>$r["description"],
	        "type"=>$r["ftype"],
	        "type_description"=>$r["field_type_description"],
		"type_handler"=>$r["handler"],
		"update_handler"=>$r["update_handler"],
	        "showable"=>$r["showable"],
	        "overwritable"=>$r["overwritable"],
		"default_value"=>$r["default_value"]
	    );

	    $values [$r["id"]][$r["name"]] = ($r["value"]!==NULL)?$r["value"]:$fields[$r["type"]][$r["name"]]["default_value"];
	}
	
	return array("fields"=>$fields, "values"=>$values);
    }

    function interfaces_update_value ($interface, $field, $value) {
	
	if (is_numeric($interface) && is_numeric($field)) {
	    $query = "UPDATE interfaces_values SET value = '$value' WHERE interface=$interface AND field=$field";
	    $result = db_query($query) or die ("Query Error - ".db_error());
	} else
	    $result = false;
	return $result;
    }

    function interfaces_insert_value ($interface, $field, $value) {
	
	if (is_numeric($interface) && is_numeric($field)) {
	    $query = "INSERT INTO interfaces_values (interface,field,value) VALUES ($interface,$field,'$value')";
	    $result = db_query($query) or die ("Query Error - ".db_error());
	} else
	    $result = false;
	return $result;
    }

    function interfaces_delete_value ($interface, $field = NULL) {
	
	if (is_numeric($interface)) {
	    $query = "DELETE FROM interfaces_values WHERE interface=$interface ".((is_numeric($field))?"AND field=$field":"");
	    $result = db_query($query) or die ("Query Error - ".db_error());
	} else
	    $result = false;
	return $result;
    }

    function interface_types_fields_list ($ids = NULL,$filters = array()) {
	    
	$where = array();
	foreach ($filters as $field=>$value) 
	    switch ($field) {
	        case "itype" : 
		    $where[]=array("interface_types_fields.itype","=",$value);
		    break;
		case "exclude_types":
		    $where[]=array("interface_types_fields.ftype","!=",$value);
		    break;
	    }
	     
	return get_db_list(	
	    array("interface_types_fields","interface_types","interface_types_field_types"), $ids, 
	    array("interface_types_fields.*",
		"itype_description"=>"interface_types.description",
		"ftype_description"=>"interface_types_field_types.description",
		"ftype_handler"=>"interface_types_field_types.handler"
	    ) ,	
	    array_merge(
		array(	
		    array("interface_types_fields.itype","=","interface_types.id"),
		    array("interface_types_fields.ftype","=","interface_types_field_types.id"),
		    array("interface_types_fields.id",">",1)),
		$where
	    ),
	    array(
	        array("interface_types_fields.itype","asc"),
	        array("interface_types_fields.ftype","asc"), 
	        array("interface_types_fields.pos","asc"),
	        array("interface_types_fields.description","desc"),
	        array("interface_types_fields.id","desc")
	    )); 
    }

?>
