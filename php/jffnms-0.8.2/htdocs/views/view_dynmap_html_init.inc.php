<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (($action=="edit") && (!profile("ADMIN_HOSTS"))) $action = "view";

    unset($refresh);
    
    if ($action=="edit") {
	$body_events = "select_object_by_mouse(event)";
	clean_url(Array("alarms_last"=>NULL,"alarms_time"=>NULL)); //remove alarm data from url when editting
    } else
	unset($body_events);

    adm_header("Dynmap", $map_color, (isset($body_events)?"OnContextMenu='javascript: ".$body_events."; return false;'":""));

echo script("
    var sizex = $sizex;
    var sizey = $sizey;

    if (window.innerHeight) { //Mozilla
	totalx = window.innerWidth;
	totaly = window.innerHeight;
    } else { //IE
	totalx = document.documentElement.offsetWidth;
	totaly = document.documentElement.offsetHeight;
    }
    
    totalx = totalx - 65;
    totaly = totaly - 20;
    
    var objects = new Array();
    var already_lines = new Array();
    var selected_name = null;
    var link_to_a = null;
    var was_moved = null;
    var	gridx = 10;
    var	gridy = 10;

    var objects_to_save = new Array();
    var objects_to_save_id = 0;
    
    document.write(
    '\<style\> ".
    ".mapbox { width:'+totalx+'; height: '+totaly+'; visibility:visible; position:absolute; left:0; top:0; } ".
    ".infobox { visibility: hidden; position: absolute; } ".
    "\</style\>');

    function debug (data) {
	".(($debug!=1)?"if (1==2)":"")."
	real_debug(data);
    }");
?>
<SCRIPT SRC="views/infobox.js"></SCRIPT>
<SCRIPT SRC="views/view_dynmap.js"></SCRIPT>
<script src="views/toolbox.js"></script>

<div class='mapbox'><table bgcolor="<? echo $map_color ?>" width="100%" height="100%"><tr><td>&nbsp</td></tr></table></div>
