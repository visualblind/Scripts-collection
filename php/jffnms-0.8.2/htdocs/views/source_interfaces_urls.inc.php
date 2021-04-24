<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $urls = array();

    $urls["events"] = array("Events", "events.php?map_id=$map_id&express_filter=interface,$interface,=^host,$host,=", "text.png");

    if ($have_graph==1) $urls["map"] = array("Performance", "view_performance.php?interface_id=$id", "graph.png");

    if ($have_tools==1) $urls["tools"] = array("Tools", "admin/tools.php?interface_id=$id", "tool.png");

    if ($permit_interface_modification==1) $urls["modification"] = array("Edit", "admin/adm/adm_interfaces.php?interface_id=$id&action=edit", "edit.png");

    if (($permit_interface_modification==1) && ($alarm_type_id==$jffnms_administrative_type) && ($client_id==1)) //force interface configuration when is autodiscovered.
	$urls = array ("events"=>array("Edit", "admin/adm/adm_interfaces.php?interface_id=$id&action=edit", "edit.png"));

?>
