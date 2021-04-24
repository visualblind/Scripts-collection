<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Linux TC Rate Aggregation

function graph_tc_rate_aggregation ($data) { 

    $color_array = array("0","7","D");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $a.$a.$c.$c.$e.$e;

    $color_array = array("3","9","F");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $a.$a.$c.$c.$e.$e;
    
    $defs = array();
    $graph = array();
    
    foreach ($data[id] as $id) {
	$interface=$data[$id];
	$used_color = $colors[++$i*4];

	$interface["interface"] = str_replace(":","\:",$interface["interface"]);

	$name = substr(
	    substr(str_pad($interface["interface"]." ".$interface["description"],20," "),0,20).
	    str_pad(($interface["rate"]/1000),5," ",STR_PAD_LEFT)." kbps"
	    ,0,35);
	
	$defs = @array_merge ($defs,
	    rrdtool_get_def($interface,array("bytes$id"=>"bytes")),
	    array("CDEF:bits$id=bytes$id,UN,bytes$id,bytes$id,IF,8,*"));

	$graph = @array_merge ($graph, array(  
		"LINE2:bits$id#$used_color:'$name'",
    		"GPRINT:bits$id:MAX:'Max\:%8.2lf %sbps'",
    		"GPRINT:bits$id:AVERAGE:'Average\:%8.2lf %sbps'",
    		"GPRINT:bits$id:LAST:'Last\:%8.2lf %sbps\\n'",
	    ));
    
    }
    
    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($defs,$graph));
}
?>
