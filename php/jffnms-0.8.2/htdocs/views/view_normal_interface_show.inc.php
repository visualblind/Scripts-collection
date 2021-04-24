<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $filename = "";
        
    if (($id > 1) && ($host > 1)) { 
	$interfaces_shown++;

	$im = ImageCreate ($sizex, $sizey);
	$background_color = ImageColorAllocate ($im, hexdec(substr($bgcolor, 0, 2)), hexdec(substr($bgcolor, 2, 2)),hexdec(substr($bgcolor, 4, 2)));
	$text_color = ImageColorAllocate ($im, hexdec(substr($fgcolor, 0, 2)), hexdec(substr($fgcolor, 2, 2)),hexdec(substr($fgcolor, 4, 2)));
	    
	$mark_interface_filename="0";
	if ($id==$mark_interface) {
	    ImageFilledRectangle($im,0,0,$sizex,$sizey,ImageColorAllocate ($im, 0, 0, 0));
	    $mark_interface_filename="1";
	}
	    
	$filename = $source[0].$id."-".$big_graph."-".$mark_interface_filename.".png";
	
	ImageFilledRectangle($im,3,3,$sizex-3,$sizey-3,$background_color);
	
	$infobox_text = "";

	if (($show_rootmap==2) || ($check_status==0)) { //if its "Mark Disabled"
	    $small_box = $sizex*0.13;
	
	    if ($show_rootmap==2) $small_box_color = ImageColorAllocate ($im, hexdec(substr($bgcolor_status, 0, 2)), hexdec(substr($bgcolor_status, 2, 2)),hexdec(substr($bgcolor_status, 4, 2)));
	    if ($check_status==0) $small_box_color = ImageColorAllocate ($im, hexdec(77), hexdec(77), hexdec(77));
	    
    	    ImageFilledRectangle($im,$sizex-7,0,$sizex,7,$small_box_color);
	}
		
	//source and view private code
	include(call_source($view_type));

	ImagePng ($im,$images_real_path."/".$filename);
    
	ImageDestroy($im);	

	unset ($interface_html); 
	unset ($image_events);
	unset ($a_events);

	$a_events = "href=\"javascript:ir_url('".$urls["events"][1]."','".$urls["map"][1]."')\"";

	if ((strlen($infobox_text) > 1) && $popups)
	    $image_events = "onMouseOver=\"javascript: infobox_show(this,event,'$infobox_text');\" onMouseOut=\"javascript: infobox_hide();\"";

	$interface_html .= image($images_rel_path."/".$filename."?r=".$rnd,$sizex,$sizey,ucfirst($source)." ".$id,"","","","<image_events>");
	
	include("toolbox.inc.php");
    }

    if (($map_id > 1) && ($source=="interfaces")) { //switch to dynmap if we are using a map (has x,y) and source is interfaces
	$view_type="dynmap";
	include (call_view("interface_process"));
    } else 
	if ($filename) {
	
	    $interface_html = "<a <a_events>>".$interface_html."</a>";
	    $interface_html = str_replace ("<a_events>",$a_events,$interface_html);
	    $interface_html = str_replace ("<image_events>",$image_events,$interface_html);

	    $interface_html .= $toolbox;
	
	    echo 
		tag("td", "","","bgcolor='".$map_color."'").
		$interface_html.
		tag_close("td");
	}
?>
