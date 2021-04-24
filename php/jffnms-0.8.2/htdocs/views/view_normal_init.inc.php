<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (!$big_graph) $big_graph=0;

    $sizex = 60;
    $sizey = 30;

    if (($active_only==1) && ($host_id < 1)) //add one more line for host name in Alarmed Interfaces
	$sizey += 10;

    if ($big_graph==1) {
        $sizex *= 1.5;
        $sizey *= 1.5;
    }
	
    $cols_max=round(($screen_size/$sizex))-1;
    $table_width="100%";
    $cols_count=$cols_max;

    $rnd = substr(time(),5,10);

    $popups = (profile("POPUPS_DISABLED")==1?false:true);

    if (($map_id > 1) && ($source=="interfaces")) { //switch to dynmap if we are using a map (has x,y) and source is interfaces
	$sources[$source]["dynmap"]=$view_type; //set my source
	$views["dynmap"]["interface_show"]=$view_type; //set my interface show
	$view_type = "dynmap"; 
	include (call_view("init"));
    }
?>
