<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $sizex = 65;
    $sizey = 50;

    $new_sizex = 120;
    $new_sizey = 85;

    $map_refresh=3*60; //set the refresh to 3 minutes

    $cols_max=round(($screen_size/($new_sizex)));
    $table_width="100%";
    $cols_count=$cols_max;

    if (($map_id > 1) && ($source=="interfaces")) { //switch to dynmap if we are using a map (has x,y) and source is interfaces
	$sources[$source]["dynmap"]=$view_type; //set my source
	$views["dynmap"]["interface_show"]=$view_type; //set my interface show

	$view_type = "dynmap"; 
	include (call_view("init"));
    }
?>
