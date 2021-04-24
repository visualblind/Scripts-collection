<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function dhtml_show_div ($id, $html_current_x, $html_current_y, $sizex, $sizey, $fgcolor, $bgcolor, $text_to_show, $events="", $more_styles="") {
        echo html("div",$text_to_show, $id, "interface", "style='".
        "top: $html_current_y; left: $html_current_x; width: $sizex; height: $sizey; ".
        "background-color: $bgcolor; color: $fgcolor; $more_styles' ".$events);
    }
    
    function dhtml_add_image ($image,$sizex,$sizey,$pos = "br") {
	global $jffnms_real_path, $jffnms_rel_path;
	
	$zone_image_filename = $jffnms_real_path."/htdocs/images/".$image;
	
	if (!empty($image) && file_exists($zone_image_filename)!=FALSE) {
	    list($aux_w,$aux_h) = @getimagesize($zone_image_filename);

	    $zone_image_filename = $jffnms_rel_path."/images/".$image;

	    switch ($pos) {
		case "br": //bottom right
			$top = $sizey-$aux_h;
			$left = $sizex-$aux_w;
			break;
		default:
			$top=$pos;
			$left = $sizex-$aux_w;
	    }
	    
    	    $image_div = html("div", "", "", "", "style='position:absolute; top: ".$top."px; left:".$left."px; width: ".$aux_w."px; height: ".$aux_h."px; ".
	    "background-image: url(".$zone_image_filename."); z-index: -10;'");
	}	
	return $image_div;
    }    


    $view_type = "normal";
    include(call_view("init"));
    
    $view_type = "dhtml";

    $html_separation_x = 10;
    $html_separation_y = 7;

    $html_current_x = 0;
    $html_current_y = 10;

    $charsize = 10;
    $sizey += 3;
    $cols_max -= 1;
    $cols_count = $cols_max;
    
    if ($big_graph==1)
        $charsize *= 1.5;
	
    $popups = (profile("POPUPS_DISABLED")==1?false:true);

?>
