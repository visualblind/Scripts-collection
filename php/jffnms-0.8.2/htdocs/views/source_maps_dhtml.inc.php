<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($big_graph==0) 
	$cols_max=round(($screen_size/$sizex))-1;

    $text_to_show = array($item["map_name"],$item["map_status"]);

    $infobox_text = join("<br>",$text_to_show)."<br><br>";

    foreach ($item["map_status_long"] as $alarm_key=>$qty)
        $infobox_text.="<b>".ucwords($alarm_key)."</b>: $qty<br>";

    unset($alarm_key);
    unset($qty);

?>
