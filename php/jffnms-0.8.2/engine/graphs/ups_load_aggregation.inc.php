<?
/* Aggregate UPS Load Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ups_load_aggregation ($data) { 

    $color_array = array("3","C","F");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $e."0".$c."0".$a."0";
    
    $opts_DEF = array();
    $opts_GRAPH = array();
    
    foreach ($data["id"] as $id) {
	$interface=$data[$id];
	
	if ($interface["line_type"]=="OUTPUT") {

	    $defs = rrdtool_get_def($interface,array("load$id"=>"load"));

	    $opts_DEF = @array_merge($opts_DEF, $defs);

	    $description = 
		substr(str_pad($interface["host_name"]." ".$interface["zone_shortname"],20," ",STR_PAD_RIGHT),0,20)." ".
	        substr(str_pad($interface["interface"]." ".$interface["description"],20," ",STR_PAD_RIGHT),0,20);
	    
	    $used_color = $colors[++$i*2];
    
	    $opts_GRAPH = array_merge ($opts_GRAPH,array(
    		"LINE2:load$id#$used_color:'".$description."\:'",
    	        "GPRINT:load$id:MAX:'Max\: %3.0lf %%'",
    	        "GPRINT:load$id:AVERAGE:'Average\: %3.0lf %%'",
    	        "GPRINT:load$id:LAST:'Last\: %3.0lf %%\\n'"
	    ));
	}
    }

    $opts_header[] = "--vertical-label='Loads'";
    $opts_header[] = "--rigid";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
