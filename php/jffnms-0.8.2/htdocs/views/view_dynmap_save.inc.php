<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (is_array($update) && profile("ADMIN_HOSTS")) {
	$maps = $jffnms->get("maps_interfaces");
	
	$cant = count($update);
	
	foreach ($update as $aux) {
	
	    list ($dynmap_id,$dynmap_x,$dynmap_y) = explode (",",$aux);
	
	    if ($dynmap_id==1) {
		if ($dynmap_x==$dynmap_y) //unlink
		    $result = $maps->delete_links($map_id,$dynmap_x);
		else  //new link
		    $result = $maps->update($maps->add($map_id),array(x=>$dynmap_x,y=>$dynmap_y)); 
	    } else //change pos
		$result = $maps->update($dynmap_id,array(x=>$dynmap_x,y=>$dynmap_y));

	    if ($cant==1) debug ("Saving $dynmap_id $dynmap_x $dynmap_y $result");
	    if ($debug==1) debug($dynmap_objects);
	}
	if ($cant > 1) debug ("Saving $cant Objects $result");
	
	die(); 
    }
?>
