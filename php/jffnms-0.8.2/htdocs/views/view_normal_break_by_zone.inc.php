<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($zone_id > 1) { 
	$zone_image_filename = "$jffnms_real_path/htdocs/images/".$item["zone_image"];
	if (!empty($item["zone_image"]) && file_exists($zone_image_filename)!=FALSE) {
	    $im_zone = ImageCreateFromPNG($zone_image_filename);
	    list($aux_w,$aux_h) = @getimagesize($zone_image_filename);
	    ImageCopy($im,$im_zone,ImageSX($im)-$aux_w,ImageSY($im)-$aux_h,0,0,$aux_w,$aux_h);

	    imagedestroy($im_zone);
	    unset ($aux_w);
	    unset ($aux_h);
	}	
	unset ($zone_image_filename);
	
	ImageStringCenter ($im, $text_color, 0, array("$zone","Zone"),$big_graph);
        $filename = "z$zone_id-$big_graph.png";
	$url = "javascript:ir_url('events.php?express_filter=zone,$zone_id,=','')";
    }
?>
