<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (($active_only==0) || ($id > 1)) { //dont show connections if we're only showing active interfaces
	$dynmap_objects[$map_int_id][int_id]=$id;
        $dynmap_objects[$map_int_id][x]=$map_x;
	$dynmap_objects[$map_int_id][y]=$map_y;

        $dynmap_objects[$map_int_id][a_events]=$a_events;
        $dynmap_objects[$map_int_id][html]=$interface_html;
        $dynmap_objects[$map_int_id][image_events]=$image_events;
        $dynmap_objects[$map_int_id]["toolbox"]=$toolbox;
    }
?>
