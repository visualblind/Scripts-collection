<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function hosts_status ($host_id = NULL, $map_id = NULL, $only_in_rootmap = 0, $client_id = NULL) {
	return interfaces_status(NULL,array("host"=>$host_id,"map"=>$map_id,"in_maps"=>$only_in_rootmap, "show_disabled"=>0, "client"=>$client_id));
    }

    function hosts_list($ids = NULL, $zone_id = NULL, $where_special = NULL, $count = 0) {

	if (is_array($zone_id))
	    return hosts_list_filtered($zone_id);

	$index = "hosts.id";
    
    	if (!is_array($where_special)) $where_special = array();
	if (is_numeric($zone_id)) $where_special[]=array("hosts.zone","=",$zone_id);

	$order = array (
	    array("hosts.name","asc"),
	    array("zones.zone","asc"));

	if (!$count) {
	    $fields = array(
		"hosts.*",
		"zone_description"=>"zones.zone", 
		"autodiscovery_description"=>"autodiscovery.description",
		"default_customer_description"=>"clients.name",
		"satellite_description"=>"satellites.description",
		"zone_image"=>"zones.image",
		"config_type_description"=>"hosts_config_types.description"
		);
		
	} else {
	    $fields = array("count($index) as cant");
	    $index = NULL;
	    $order = NULL;
	}
	
	return get_db_list(
	    array("zones","hosts","autodiscovery","clients","satellites","hosts_config_types"),
	    $ids,$fields,
	    array_merge(
	    array(
		array("hosts.zone","=","zones.id"),
		array("autodiscovery.id","=","hosts.autodiscovery"),
		array("clients.id","=","hosts.autodiscovery_default_customer"),
		array("satellites.id","=","hosts.satellite"),
		array("hosts_config_types.id","=","hosts.config_type"),
		array("hosts.id",">","0")),
		$where_special),
	    $order,
	    $index);
    }

    function hosts_list_filtered ($filters = array()) {
	$interfaces = interfaces_list(NULL,$filters);
	
	while (list(,$int) = each ($interfaces)) 
	    $hosts[]=$int["host"];
	
	$hosts = array_unique($hosts);
	return hosts_list($hosts);
    }

    function hosts_count($ids = NULL, $zone_id = NULL, $where_special = NULL) {
	return current(current(hosts_list($ids, $zone_id, $where_special, 1)))-1;
    }
    
    function adm_hosts_add($zone_id = 1) {
	if (!is_numeric($zone_id)) $zone_id = 1;
	
	return db_insert("hosts", array("name"=>"New Host", "zone"=>$zone_id, "creation_date"=>time()));
    }

    function adm_hosts_update($host_id,$host_data) {
	
	// if the only fields to update are the last_poll_* ones don't update the modification_date
    	if ((count($host_data)==2) && isset($host_data["last_poll_date"]) && isset($host_data["last_poll_time"])) 
	    ;
	else
	    $host_data["modification_date"]=time(); //update the modification date

	if (isset($host_data["dmii"]) && (substr($host_data["dmii"],0,1)!="M") && (substr($host_data["dmii"],0,1)!="I")) 
	    $host_data["dmii"] = 1;
	
	$result = db_update("hosts",$host_id,$host_data);
	return $result;
    }

    function adm_hosts_del($host_id) {
	
	$interfaces = interfaces_list (NULL,array(host=>$host_id));
	
	foreach ($interfaces as $int) 
	    adm_interfaces_del($int[id]);

	$interfaces = interfaces_list (NULL,array(host=>$host_id));
	
	if (count($interfaces) == 0) return db_delete("hosts",$host_id);
	else return FALSE;
    }

    function hosts_dmii_interfaces_list ($host_id) {
	$host_data = current(hosts_list($host_id));
	$dmii = $host_data["dmii"];

	if ($dmii[0]=="M") return array_keys(interfaces_list(NULL,array("map"=>substr($dmii,1))));
	if ($dmii[0]=="I") return array(substr($dmii,1)); //return an array with only the interface id
	
	return 1; //force not to do nothing in poller plan
    }

    function hosts_dmii_if_all_down_list($host_id,$dmii_map) {
	$result = NULL;
	$dmii_down = maps_status_all_down($dmii_map);
	
	if ($dmii_down)  //if they are all down, dont poll the others
	    $result = array_keys(interfaces_list(NULL,array(map=>$dmii_map,host=>$host_id))); //only poll the Designated Main Interfaces

	return $result;
    }

    function hosts_status_dmii($host_id) {
	$host_data = current(hosts_list($host_id));
	$dmii = $host_data["dmii"];

	if ($dmii[0]=="M") return hosts_dmii_if_all_down_list($host_id,substr($dmii,1)); //set to a map
	if ($dmii[0]=="I") //set to an interface
	    if (!interface_is_up(substr($dmii,1))) //is down
		return array(substr($dmii,1)); //return an array with only the interface id

	return FALSE; //not down
    }

//HOSTS CONFIG
//===================================================================================

    function adm_hosts_config_add($host_id = 1) { 
    	return db_insert("hosts_config",array(config=>"New Config",host=>$host_id));
    }

    function adm_hosts_config_update($host_id,$data) { 
    	return db_update("hosts_config",$host_id,$data);
    }

    function adm_hosts_config_del($id) { 
    	return db_delete("hosts_config",$id);
    }


   function hosts_config_list($ids = NULL,$host_id = NULL, $init = NULL,$span = NULL, $where_special = NULL) {

	if (!is_array($where_special)) $where_special = array();

        if ($host_id) $where_special[]=array("hosts.id","=",$host_id);
        if ($ids) $order = "asc"; else $order = "desc"; //diff execution order

        return get_db_list(
            array("hosts_config","zones","hosts"),
            $ids,
            array(      "hosts_config.*",
                        "zone_description"=>"zones.zone",
                        "host_description"=>"hosts.name" ),
            array_merge(
            array(
                array("hosts.zone","=","zones.id"),
                array("hosts_config.host","=","hosts.id"),
                array("hosts_config.id",">","1")),
                $where_special),
            array (
                array("hosts_config.date",$order),
                array("hosts.id","asc")),
                "",NULL,$init,$span

            );
    }

    function hosts_config_diff ($id1, $id2) {

	if ($id1 != $id2) {

	    $aux = hosts_config_list(array($id1,$id2));
	    $str1 = $aux[0]["config"];
	    $str2 = $aux[1]["config"];
	
	    $engine_temp = get_config_option("engine_temp_path");
	
	    $name1 = $engine_temp."/".uniqid("").".dat";
	    $name2 = $engine_temp."/".uniqid("").".dat";

	    $pf = fopen($name1,"w");
	    fputs($pf,$str1);
	    fclose($pf);

	    $pf = fopen($name2,"w");
	    fputs($pf,$str2);
	    fclose($pf);

	    $diff_executable = get_config_option("diff_executable");

	    if (file_exists($diff_executable)) {
		$c = exec($diff_executable." -Nru ".$name1." ".$name2, $diff);

		unlink($name1);
	        unlink($name2);
	    
	        $diff = join("\n",array_slice($diff, 3));
	    
		return $diff;
	    }
	}
	
	return false;
    }

    function hosts_config_put($host_id,$filename) {
	    
	$host = current(hosts_list($host_id));

	if ($host[tftp_mode]==1) { //OLD-CISCO-SYS-MIB
	    $oid = ".1.3.6.1.4.1.9.2.1.53.$host[tftp]";
	    $aux = snmp_set($host[ip],$host[rwcommunity],$oid,"s",$filename,60,0);
	    if ($aux==TRUE) $result = 2;
	}
	    
	if ($host[tftp_mode]==0) { //CISCO-CONFIG-COPY-MIB
	    $oid = ".1.3.6.1.4.1.9.9.96.1.1.1.1";
	    snmp_set($host[ip],$host[rwcommunity],"$oid.14.999","i",6); //destroy
	    snmp_set($host[ip],$host[rwcommunity],"$oid.14.999","i",5); //create and wait
	    snmp_set($host[ip],$host[rwcommunity],"$oid.2.999","i","1"); //tftp
	    snmp_set($host[ip],$host[rwcommunity],"$oid.3.999","i","1"); //running
	    snmp_set($host[ip],$host[rwcommunity],"$oid.4.999","i","4"); //network
	    snmp_set($host[ip],$host[rwcommunity],"$oid.5.999","a",$host[tftp]); //server
	    snmp_set($host[ip],$host[rwcommunity],"$oid.6.999","s",$filename); //filename
	    snmp_set($host[ip],$host[rwcommunity],"$oid.14.999","i",1); //activate
	    $result = snmp_get($host[ip],$host[rwcommunity],"$oid.10.999");
	}

	return $result;
    }

    function poller_plan($filters = NULL) {

	$filter = "";

	if (is_array($filters)) 
	foreach ($filters as $key=>$data)
	    if ($data)
	    switch ($key) { 
		case "interface"	: 
		case "interfaces"	: if (!is_array($data) && (strpos($data,",")!==false)) $data = explode(",",$data);
					  if (!is_array($data)) $data = array($data);
					  $filter.=" and ( interfaces.id = ".join(" or interfaces.id = ",$data)." )"; 
					  break;
	
		case "host"		: 
		case "hosts"		: if (!is_array($data) && (strpos($data,",")!==false)) $data = explode(",",$data);
					  if (!is_array($data)) $data = array($data);
					  $filter.=" and ( hosts.id = ".join(" or hosts.id = ",$data)." )"; 
					  break;
		case "type"		: if ($data>1) $filter.=" and interfaces.type = $data"; break;
		case "pos" 		: if ($data>0) $filter.=" and pollers_poller_groups.pos = $data"; break;
	    }
	    	
	$query_poller="
		SELECT
		    interfaces.id as interface_id, interfaces.interface, interfaces.show_rootmap,
		    hosts.rwcommunity as rw_community, hosts.rocommunity as ro_community, hosts.id as host_id, hosts.ip as host_ip, 
		    interface_types.autodiscovery_parameters,
		    pollers_poller_groups.pos as poller_pos, 
		    pollers.name as poller_name, pollers.command as poller_command, pollers.parameters as poller_parameters,
		    pollers_backend.command as backend_command, pollers_backend.parameters as backend_parameters

		FROM 
		    interfaces, hosts, pollers, pollers_poller_groups, pollers_backend, interface_types
	
		WHERE 
		    hosts.id = interfaces.host and 
		    interfaces.poll = pollers_poller_groups.poller_group and pollers_poller_groups.poller = pollers.id and
		    pollers_backend.id = pollers_poller_groups.backend and pollers_poller_groups.poller_group > 1 and
		    interfaces.type = interface_types.id and
		    (interfaces.check_status = 1 or pollers_backend.type != 1) and
		    ((interfaces.last_poll_date + interfaces.poll_interval) < ".(time()+(60*2)).")
		
		$filter
	    
		ORDER BY 
		    pollers_poller_groups.pos, interfaces.id";

	$result = db_query ($query_poller) or die ("Query failed - poller_plan - ".db_error());	
	//debug ($query_poller);
	
	$random = rand(10,99);
	$time_start = time_usec();
	$poller_plan = array();
	
	while ($data = db_fetch_array($result)) {
	    $id = $data["interface_id"];
	    $interface_ids[$id] = true; //to count the number of interfaces

	    $fields = array("interface","show_rootmap","rw_community","ro_community","host_id",
	        "host_ip","autodiscovery_parameters");
	    
	    if (!isset($interfaces[$id])) {
	        $aux = interface_values ($id,array("exclude_types"=>array(20))); //get interface values //FIXME we should include all fields= interface_values ($id,array("exclude_types"=>array(20))); //get interface values //FIXME we should include all fields
		$interfaces[$id] = $aux["values"][$id];
		
		foreach ($fields as $field)
		    $interfaces[$id][$field] = $data[$field];
	    }

	    foreach ($fields as $field)
	        unset ($data[$field]);

	    //if the poller parameters has a <tag>, replace every <data key> in poller_parameters with the value
	    if (strpos($data["poller_parameters"],"<")!==false) {
		$aux = array_merge ($data,$interfaces[$id]);
	        foreach ($aux as $field=>$value) 
		    $data["poller_parameters"] = str_replace("<$field>",$value,$data["poller_parameters"]);
	    }
	    
	    //add item to the poller plan
	    $poller_plan[]=$data;

	    unset ($field);
	    unset ($fields);
	    unset ($value);
	    unset ($id);
	    unset ($data);
	    unset ($aux);
	}
	
	db_free ($result);
	unset ($result);

	reset ($poller_plan);
	
	return array("interface_data"=>$interfaces, "plan"=>$poller_plan, 
	    "items"=>count($poller_plan)+count($interface_ids), //number of items + 1 per 1 interface LPD
	    "random"=>$random, "time_start"=>$time_start);
    }
    
    function poller_plan_next (&$result) {
	list(,$data) = each($result["plan"]);

	if (is_array($data)) {
	    $result["interfaces_ids"][$data["interface_id"]]=time(); //add interface to queue

	    $data = array_merge($data,$result["interface_data"][$data["interface_id"]]); //merge poller and interface data with the interface values

	    //pass poller plan constants
	    $data["random"]=$result["random"];
	    $data["time_start"]=$result["time_start"];
	} else 
	    if (count($result["interfaces_ids"]) > 0) { //add the LPD
		list ($int_id,$last_poll_date) = each ($result["interfaces_ids"]);
	    
		if (is_numeric($int_id)) {
		    $data = array (
			"interface_id"=>$int_id,
		        "poller_pos"=>"LPD",
		        "poller_name"=>"last_poll_date",
		        "poller_command"=>"internal",
		        "poller_parameter"=>$last_poll_date,
		        "backend_command"=>"db",
		        "backend_parameters"=>"last_poll_date"
		    );
		    unset ($result["interfaces_ids"][$int_id]); //remove from queue
		}
	    } else
		$data = false;

	return $data;
    }

// AUTODISCOVERY
//===================================================================================

    function hosts_interfaces_from_db ($host_id,$type_id) {

	    $db_interfaces = array();
	    $fields_types = array();

	    $aux = interfaces_list(NULL,array("host"=>$host_id,"type"=>$type_id,"with_field_type"=>1));
	    
	    if (count($aux) > 0) {
		if (is_array($aux["field_types"][$type_id]))
    		    while (list($field,$fdata) = each ($aux["field_types"][$type_id]))
	    		if ($fdata["type"]==3) {
		            $index=$field;
		    	    break;
			}
	
		unset ($field);
	    	unset ($fdata);
		unset ($aux["field_types"]);
		reset ($aux);
			
		while (list(,$data) = each ($aux))
		    $db_interfaces[$data[$index]]=$data;

	    }
	    unset ($aux);
	    
	    return $db_interfaces;
    }
    
    function hosts_interfaces_from_discovery ($function,$host_ip,$community,$host_id,$parameters) {

    	$real_function = "discovery_$function";
	$function_file = get_config_option("jffnms_real_path")."/engine/discovery/$function.inc.php";
    
	if ((in_array($function_file,get_included_files())) || (include_once($function_file))) {
	
	    if (function_exists($real_function)) {
		$host = call_user_func_array($real_function,array($host_ip,$community,$host_id,$parameters));
		return $host;
	    } else logger("ERROR: Calling Function 'discovery_$function' doesn't exists.<br>\n");
	} else logger ("ERROR Loading file $function_file.<br>\n");
	
	return FALSE;
    }
?>
