<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($host > 1) //dont process the unknown host
	$graphviz_hosts .="\tH$host\t[shape=egg,fillcolor=\"#000000\",fontcolor=\"#FFFFFF\",style=filled,label=\"$host_name $zone_shortname\"];\n";
?>
