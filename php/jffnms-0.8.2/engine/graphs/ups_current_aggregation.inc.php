<?
/* Aggregate UPS current Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ups_current_aggregation ($data) { 

    $color_array = array("2","9","F");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $e."0".$c."0".$a."0";
    
    $opts_DEF = array();
    $opts_GRAPH = array();
    
    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$defs = rrdtool_get_def($interface,array("current$id"=>"current"));

	$opts_DEF = @array_merge($opts_DEF, $defs);

	$description = 
	    substr(str_pad($interface["host_name"]." ".$interface["zone_shortname"],20," ",STR_PAD_RIGHT),0,20)." ".
	    substr(str_pad($interface["interface"]." ".$interface["description"],20," ",STR_PAD_RIGHT),0,20);
	    
	$used_color = $colors[++$i*2];

	$opts_GRAPH = array_merge ($opts_GRAPH,array(
    	    "LINE2:current$id#$used_color:'".$description."\:'",
    	    "GPRINT:current$id:MAX:'Max\: %3.0lf %sA'",
    	    "GPRINT:current$id:AVERAGE:'Average\: %3.0lf %sA'",
    	    "GPRINT:current$id:LAST:'Last\: %3.0lf %sA\\n'"
	));
    }

    $opts_header[] = "--vertical-label='Currents'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
