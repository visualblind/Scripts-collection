<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
        ImageStringCenter ($im, $text_color, 0, array($item["host_name"],$item["zone"],$item["host_status"],$item["host_ip"]),$big_graph);
	
        $zone_image_filename = $jffnms_real_path."/htdocs/images/".$item["zone_image"];
	if (!empty($item["zone_image"]) && file_exists($zone_image_filename)===TRUE) {
	    $im_zone = ImageCreateFromPNG($zone_image_filename);
	    list($aux_w,$aux_h) = @getimagesize($zone_image_filename);
	    ImageCopy($im,$im_zone,$sizex-$aux_w,10,0,0,$aux_w,$aux_h);

	    ImageDestroy($im_zone);	
	    unset ($aux_w);
	    unset ($aux_h);
	}
	unset ($zone_image_filename);	

	foreach ($item["host_status_long"] as $alarm_key=>$qty)
    	    $infobox_text .= html("b",ucwords($alarm_key),"", "", "", false, true).": ".$qty.br();

	$infobox_text = str_replace("\n","",$infobox_text);

	unset($alarm_key);
	unset($qty);
?>
