<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../auth.php");

    // Defaults    
    if (!$menu)  	$menu 	= "frame1";
    if (!$frame) 	$frame	= "frame2"; 

    if (!$scroll1) 	$scroll1= "yes";
    if (!$scroll2) 	$scroll2= "yes";

    if (!$size1) 	$size1	= "100%";
    if (!$size2) 	$size2	= "*";

    $name1 = (!$name1)
	?"menu_".$menu.".php?type=".$menu_type."&frame=".$frame
	:$jffnms_rel_path."/admin/".$name1;

    $name2 = (!$name2)
	?$jffnms_rel_path."/blank.php"
	:$jffnms_rel_path."/admin/".$name2;

    $frame_def = ($type=="vertical")?"rows='*' cols='".$size1.",".$size2."'":"cols='*' rows='".$size1.",".$size2."'";

    echo tag("!DOCTYPE", "", "","HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\"", false);

    adm_header("Menu","","",true);
    
    echo 
	tag("frameset", $menu, "", $frame_def." frameborder='no' framespacing='0'").
	    tag("frame", "", "", "name='".$menu ."' noresize scrolling='".$scroll1."' src='".$name1."'", false).
	    tag("frame", "", "", "name='".$frame."' noresize scrolling='".$scroll2."' src='".$name2."'", false).
	tag_close("frameset").
    tag_close("html");

?>
