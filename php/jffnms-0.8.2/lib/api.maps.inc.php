<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
// MAPS INTERFACES

    function maps_list($ids = NULL, $parent = NULL, $where_special = NULL) {

	if (!is_array($where_special)) $where_special = array();
	if ($parent) $where_special[]=array("maps.parent","=",$parent); 
	if ($ids != 1) $where_special[]=array("maps.id",">","0");
	
	return get_db_list(
	    array("maps","parent"=>"maps"),
	    $ids,
	    array(	"maps.*",
			"parent_name"=>"parent.name"),
	    array_merge(
		array(array("maps.parent","=","parent.id")),
		$where_special),
	    array (
		array("maps.name","asc")
		),
	    "maps.id",
	    NULL);
    }

    function maps_status($map_id) {
	return interfaces_status(NULL,array(map=>$map_id));
    }

    function maps_status_all_down($map_id) {
	$result = maps_status($map_id);
	if (is_array($result) && ($result[down][qty]==$result[total][qty]) && $result[total][qty] > 0) return TRUE;
	else return FALSE;
    }

    function adm_maps_add($parent = 1) { 
	$id = db_insert("maps",array("name"=>"New Map ".rand(1,999),"parent"=>1));
	return $id;
    }

    function adm_maps_update($map_id,$data) {
	return db_update("maps",$map_id,$data);
    }

    function adm_maps_del($map_id) {
	
	$interfaces = maps_interfaces_list($map_id);

	foreach ($interfaces as $int) 
	    adm_maps_interfaces_del($int[id]);

	$interfaces = maps_interfaces_list($map_id);
	
	if (count($interfaces) == 0) return db_delete("maps",$map_id);
	else return FALSE;
    }


//------------------------------------------------------------------
// MAPS INTERFACES

    function maps_interfaces_list($ids = NULL, $where_special = NULL) {
	
	if (!is_array($where_special)) $where_special = array();

	$result = get_db_list(
	    array("maps","maps_interfaces","interfaces","clients","hosts","zones"),
	    $ids,
	    array(	"maps_interfaces.*",
			"map_name"=>"maps.name",
			"aux_interface"=>"interfaces.interface",
			"aux_customer"=>"clients.shortname",
			"aux_host"=>"hosts.name",
			"aux_zone"=>"zones.zone"
			),
	    array_merge(
	    array(
		array("maps_interfaces.map",">","1"),
		array("maps_interfaces.map","=","maps.id"),
		array("maps_interfaces.interface","=","interfaces.id"),
		array("interfaces.client","=","clients.id"),
		array("interfaces.host","=","hosts.id"),
		array("hosts.zone","=","zones.id")),
		$where_special),
	    array (
		array("maps.id","asc"),
		array("maps_interfaces.id","desc")
		),
	    "");
	    
	foreach ($result as $key=>$data)
	    $result[$key]["interface_description"] = $data["aux_host"]." ".$data["aux_zone"]." - ".$data["aux_customer"]." - ".$data["aux_interface"];

	return $result;
    }

    function adm_maps_interfaces_update($id,$data) {
	return db_update("maps_interfaces",$id,$data);
    }

    function adm_maps_interfaces_add($map = 1,$interface = 1) { 
	return db_insert("maps_interfaces",array("map"=>$map,"interface"=>$interface));
    }

    function adm_maps_interfaces_del($id) {
	return db_delete("maps_interfaces",$id);
    }

    function adm_maps_interfaces_del_from_all($int_id) {
	$query = "delete from maps_interfaces where interface='$int_id'";
	$result = db_query($query) or die ("Query Failed - maps_interface_del_from_all() - ".db_error());
	return $result;
    }

    function interface_in_map($map_id,$interface_id) {

	$query = "select id from maps_interfaces 
		where interface = '$interface_id' and map = '$map_id'";
	$result = db_query($query) or die ("Query Failed - ISM1 - ".db_error());
	$cant = db_num_rows($result); 
	if ($cant >= 1) return 1;
	    else return 0; 
    }

    function interface_maps($interface_id) {

	$maps = Array();
	
	$query = "select map from maps_interfaces 
		where interface = '$interface_id'";
	$result = db_query($query) or die ("Query Failed - ISM1 - ".db_error());
	
	while ($rs = db_fetch_array($result))
	    $maps[]=$rs[map];
	
	return $maps;
    }

    function maps_interfaces_status($map_id,$interface_id) { //alias of interface_in_map
	return interface_in_map($map_id,$interface_id);
    }

    function maps_interfaces_delete_links ($map_id,$interface_id) {
	$query = " DELETE from maps_interfaces where (interface = 1 and map = $map_id) and
		    (x = $interface_id or y = $interface_id);";
	return db_query($query) or die ("Query Failed maps_interfaces_delete_links($map_id,$interface_id) - ".db_error()); 
    }

?>
