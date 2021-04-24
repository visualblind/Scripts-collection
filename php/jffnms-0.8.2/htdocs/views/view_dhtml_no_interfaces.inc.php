<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $text_to_show ="No ".(($active_only==1)?"Alarmed ":"")." ".ucfirst($source)." Found";

    dhtml_show_div ("no_interfaces", ($screen_size/2)-200, 50, 1, 1, "black", $map_color, 
	$text_to_show,"","border-style:none; font-size: 30px; overflow: visible;");
?>
