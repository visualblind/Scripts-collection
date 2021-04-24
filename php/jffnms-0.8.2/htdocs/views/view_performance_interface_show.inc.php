<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    unset ($result);
    if (($have_graph==1) && ($source=="interfaces")) { 
	$interfaces_shown++;

	$filename = $source[0].$id."-graph.png";
	$real_filename = "$images_real_path/$filename";
	$result = performance_graph(&$interfaces,$id,$real_filename,$default_graph,$sizex,$sizey,
	    "",(-60*60*2),0,"MINI");

	if ($result!=false) {

	    //image management
	    $im_orig = imagecreatefrompng($real_filename);
	    $im_new  = imagecreate ($new_sizex,$new_sizey);

	    $back_color = ImageColorAllocate ($im_new, 245, 245, 245);
	    $text_color = ImageColorAllocate ($im_new, 0,0,0);
	    
	    imagecopy ($im_new, $im_orig, 0, 10, 20 ,5,imagesx($im_orig)-29,300);
	    imagedestroy ($im_orig);
	    
	    //source and view private code
	    include(call_source($view_type));

	    if ($alarm_name!="OK") {
		$alarm_color = ImageColorAllocate ($im_new, hexdec(substr($bgcolor, 0, 2)), hexdec(substr($bgcolor, 2, 2)),hexdec(substr($bgcolor, 4, 2)));
		
		imagefilledrectangle ($im_new, $new_sizex-10, 0, $new_sizex, 10, $alarm_color);
		imagerectangle ($im_new, $new_sizex-10, 0, $new_sizex, 10, $text_color);
	    }
	    
	    imagepng ($im_new, $real_filename);
	    imagedestroy ($im_new);
    
	    unset ($interface_html); 

    	    $a_events = "href=\"javascript:ir_url('".$urls["events"][1]."','".$urls["map"][1]."')\"";

	    $image_events = "onMouseOver=\"javascript: infobox_show(this,event,'$infobox_text');\" onMouseOut=\"javascript: infobox_hide();\"";
	    $interface_html = image($images_rel_path."/".$filename,$new_sizex,$new_sizey,ucfirst($source)." ".$id, "", "", "", "<image_events>");

	    if ($map_id <= 1) { 
		$interface_html = html("a", $interface_html, "", "", $a_events);
		$interface_html = str_replace ("<a_events>",$a_events,$interface_html);
		$interface_html = str_replace ("<image_events>",$image_events,$interface_html);

		echo td($interface_html);
	    }
	}

    } else 
	if ($map_id > 1) { //get image from the normal interface show
	    $old_view = $view_type;
	    $view_type = "normal";
	    include(call_view("interface_show"));
	    $view_type = $old_view;
	} else 
	    $cols_count--;  //only when not using map (dynmap)
    
    if (($source=="interfaces") and (($map_id > 1) or ($id == 1))) { 
        $view_type="dynmap";
        include (call_view("interface_process"));
    }
?>
