<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($zone_id > 1) { 
	$text_to_show = array($zone,"Zone",dhtml_add_image ($item["zone_image"],$sizex,$sizey,"br"));
	
	$urls = array("events"=>array("Events","events.php?express_filter=zone,$zone_id,=","text.png"));
    }
?>
