<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
	unset ($aux_description_formated);
	
	foreach ($item["description"] as $aux_desc=>$aux_value)
	    $aux_description_formated .= "<br><b>$aux_desc:</b> ".htmlentities($aux_value);
	
	$aux_description = join(" ",$item["description"]); //to be used elsewere

	$infobox_text =
	    "<b>$host_name</b> $zone<br><b>$interface</b>".(($alarm_name!="OK")?" <i>($alarm_name)</i>":"").
	    "$aux_description_formated<br>$client_name ".
	    (($permit_interface_modification==1)?"<a target=events href=admin/adm/adm_interfaces.php?interface_id=$id&action=edit>($type $index)</a>":"($type $index)");

	//FIXME this has to be more generic
	if (isset($item["bandwidthin"])) $infobox_text .= "<br>D".($bandwidthin/1000)."k/U".($bandwidthout/1000)."k";
	
	if ($item["alarm_name"]!==NULL)
	    $infobox_text .= "<br><font size=2><b>Alarm:</b> ".$item["alarm_type_description"]." ".ucwords($item["alarm_name"])." since ".$item["alarm_start"]."</font>";
?>
