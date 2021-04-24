<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    require ("auth.php"); 

    echo tag("!DOCTYPE", "", "","HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\"", false);

    adm_header("","","",true);
    
    echo 
	tag("frameset", "", "", "rows='20,*' frameborder='no' framespacing='0'").
	    tag("frame", "controls", "", "name='controls' noresize scrolling='no' src='controls.php?'", false).
	    tag("frameset", "menu_frame", "", "cols='*,0' frameborder='no' framespacing='1'").
		tag ("frame", "", "", "name='work' noresize scrolling='yes' src='blank.php?'", false).
		tag ("frame", "", "", "name='menu' scrolling='no' src='admin/menu.php?'", false).

	    tag_close("frameset").
	tag_close("frameset").
    tag_close("html");

?>
