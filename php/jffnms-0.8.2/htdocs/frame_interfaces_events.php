<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    require ("auth.php"); 

    echo tag("!DOCTYPE", "", "","HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\"", false);

    adm_header("Interfaces & Events","","",true);
    
    echo 
	tag("frameset", "", "", "rows='*,39%' frameborder='no' framespacing='0'").
	    tag ("frame", "", "", "name='map' src='frame_interfaces.php?".$QUERY_STRING."'", false).
	    tag ("frame", "", "", "name='events' src='blank.php'", false).
	tag_close("frameset").
    tag_close("html");
?>
