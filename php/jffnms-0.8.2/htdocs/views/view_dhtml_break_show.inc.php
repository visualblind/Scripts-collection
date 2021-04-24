<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (is_array($text_to_show)) {
	$html_current_x += $html_separation_x;

        $bgcolor = "rgb(150,150,150)";
        $fgcolor = "white";

	$text_to_show = join(br(),$text_to_show);

        unset($events);

        $events = " onClick=\"javascript:ir_url('".$urls["events"][1]."','".$urls["map"][1]."')\"";

	dhtml_show_div ("b".++$break, $html_current_x, $html_current_y, $sizex, $sizey, $fgcolor, $bgcolor, $text_to_show, $events);

        $html_current_x += $sizex + $html_separation_x; //double separation
    }
?>
