<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $urls = array(); 
    
    $urls["events"] = array("Events", "events.php?map_id=$map_id&express_filter=host,$id,=" , "text.png");
    $urls["map"] = array("View Interfaces", "frame_interfaces.php?host_id=$id&break_by_card=1&break_by_zone=0&active_only=$active_only&events_update=0&map_id=$map_id&only_rootmap=$only_rootmap","int1.png");
    $urls["tools"] = array("Tools", "admin/tools.php?host_id=$id", "tool.png");

    if ($permit_host_modification==1) $urls["modification"] = 
	array("Edit", "admin/adm/adm_standard.php?admin_structure=hosts&filter=$id&actionid=$id&action=edit", "edit.png");

?>
