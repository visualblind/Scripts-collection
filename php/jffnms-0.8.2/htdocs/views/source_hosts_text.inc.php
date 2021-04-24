<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $item_text = str_replace("\n", "", str_replace("\t","",
	html("b",str_pad($host_name." ".$zone,30), "", "", "", false, true)." ".
	str_pad(html("u",$host_status, "", "", "", false, true),20)." ".
	str_pad($host_ip,15)));
?>
