<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (($id > 1) && ($host > 1)) { 
	$interfaces_shown++;

	$html_current_x += $html_separation_x;

	include(call_source($view_type));

	if (($show_rootmap==2) || ($check_status==0)) { //if its "Mark Disabled"
	    $small_box = $sizex*0.13;
	
	    if ($show_rootmap==2) $small_box_color = $bgcolor_status;
	    if ($check_status==0) $small_box_color = "777777";
	    
	    $text_to_show[] = html("div", "", "", "", "style='position:absolute; top:0; left:".($sizex-$small_box)."; ".
		"width: $small_box; height: $small_box; background-color: $small_box_color;'");
	}
	
    	$text_to_show = trim(str_replace("\n","",join(br(),$text_to_show)));

	if ($id==$mark_interface)
	    $border = "border-style: double;";
	else
	    $border = "";
	    
	unset ($events);

        $events = " onClick=\"javascript:ir_url('".$urls["events"][1]."','".$urls["map"][1]."')\"";

	if ((strlen($infobox_text) > 1) && $popups)
	    $events .= " onMouseOver=\"javascript: show_info(this,'$infobox_text');\" onMouseOut=\"javascript: hide_info(this);\"";

	dhtml_show_div ($id, $html_current_x, $html_current_y, $sizex, $sizey, $fgcolor, $bgcolor, $text_to_show, $events, $border);

	include("toolbox.inc.php");
	echo $toolbox;
	
	$html_current_x += $sizex;
    }
?>
