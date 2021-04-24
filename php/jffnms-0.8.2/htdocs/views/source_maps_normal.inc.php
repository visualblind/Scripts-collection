<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
        ImageStringCenter ($im, $text_color, 0, array($item["map_name"],$item["map_status"]),$big_graph);
	    
	unset($infobox_text);
	foreach ($item["map_status_long"] as $alarm_key=>$qty)
	    $infobox_text.="<b>".ucwords($alarm_key)."</b>: $qty<br>";
?>
