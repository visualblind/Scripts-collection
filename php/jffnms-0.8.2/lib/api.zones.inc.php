<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function zones_list($ids = NULL) {
	return get_db_list(
	    array("zones"),
	    $ids,
	    "zones.*",
	    array(array("zones.id",">","1")),
	    array(array("zone","asc")));
    }

    function adm_zones_add() {
	return db_insert("zones",array("zone"=>"a New Zone","image"=>"unknown.png"));
    }

    function adm_zones_update($id,$data) {
	return db_update("zones",$id,$data);
    }

    function adm_zones_del($id) {
	
	$list = hosts_list (NULL,$id);
	
	foreach ($list as $aux) 
	    adm_hosts_del($aux[id]);

	$list = hosts_list (NULL,$id);
	
	if (count($list) == 0) return db_delete("zones",$id);
	else return FALSE;
    }

    function zones_status ($zone_id = NULL, $only_in_rootmap = 0) {
	return interfaces_status(NULL,array(zone=>$zone_id,in_maps=>$only_in_rootmap));
    }

?>
