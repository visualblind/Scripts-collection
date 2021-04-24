<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($big_graph==0) 
	$cols_max=round(($screen_size/$sizex))-1;

    $text_to_show = array($item["host_name"],$item["zone"],$item["host_status"],$item["host_ip"]);

    $infobox_text = join(br(),$text_to_show).br().br();

    $text_to_show[] = dhtml_add_image($item["zone_image"],$sizex,$sizey,$charsize+2);
    
    foreach ($item["host_status_long"] as $alarm_key=>$qty)
        $infobox_text .= html("b",ucwords($alarm_key),"", "", "", false, true).": ".$qty.br();

    $infobox_text = str_replace("\n","",$infobox_text);

    unset($alarm_key);
    unset($qty);
?>
