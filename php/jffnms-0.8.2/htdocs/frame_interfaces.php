<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    require ("auth.php"); 

    echo tag("!DOCTYPE", "", "","HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\"", false);

    adm_header("Interfaces","","",true);
    
    echo 
	tag("frameset", "", "", "rows='21,*' frameborder='no' framespacing='0'").
	    tag ("frame", "", "", "name='map_list' noresize scrolling='no' src='view_interfaces_map_list.php?".$QUERY_STRING."'", false).
	    tag ("frame", "", "", "name='map_viewer' src='blank.php'", false).
	tag_close("frameset").
    tag_close("html");
?>
