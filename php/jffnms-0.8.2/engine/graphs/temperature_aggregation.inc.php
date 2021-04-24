<?
/* Aggregate Temperature Graph. This file is part of JFFNMS
 * Copyright (C) <2004> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_temperature_aggregation ($data) { 

    $color_array = array("0","9","C","F","4");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $e."0".$c."0".$a."0";
    
    $opts_DEF = array();
    $opts_GRAPH = array();
    
    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$defs = rrdtool_get_def($interface,array(
				"temp_c$id"=>"temperature"));

	$opts_DEF = @array_merge($opts_DEF, $defs);
	$far = (isset($interface["show_celcius"]) && ($interface["show_celcius"]==0))?1:0;

	$description = 
	    substr(str_pad($interface["host_name"]." ".$interface["zone_shortname"],20," ",STR_PAD_RIGHT),0,20)." ".
	    substr(str_pad(str_replace("temperature","",$interface["description"]),20," ",STR_PAD_RIGHT),0,20)." ".
	    str_pad((($far==1)?"Fahrenheit":"Celcius"),10," ");
	    
	$used_color = $colors[++$i*2];

	$opts_GRAPH = array_merge ($opts_GRAPH,array(
    	    "CDEF:temperature$id=temp_c$id,".(($far==1)?"1.8,*,32,+":"1,*"),
    	    "LINE2:temperature$id#$used_color:'".$description."\:'",
    	    "GPRINT:temperature$id:MAX:'Max\:%5.0lf'",
    	    "GPRINT:temperature$id:AVERAGE:'Average\:%5.0lf'",
    	    "GPRINT:temperature$id:LAST:'Last\:%5.0lf \\n'"
	));
    }

    $opts_header[] = "--vertical-label='Temperature'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
