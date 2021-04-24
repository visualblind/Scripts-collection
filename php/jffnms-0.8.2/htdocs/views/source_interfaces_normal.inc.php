<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("source_interfaces_infobox.inc.php");

    $text_to_show = array($int,ucfirst($shortname),$aux_description);
    
    if (($active_only==1) && ($host_id < 1)) //if we're in the alarmed interfaces screen, and not filtering by host
	$text_to_show = array_merge(array($host_name), $text_to_show); //add the host name as the first line of the graph

    ImageStringCenter ($im, $text_color, 0, $text_to_show, $big_graph);

    unset ($text_to_show);
?>
