<?php
/* Alteon Load Balancing Switch Sessions Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_octets_aggregation ($data) { 

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
    
    $graph_type='AREA';
    foreach ($data[id] as $id) {
    	$interface = $data[$id];
	$used_color = $colors[++$i*4];

	$interace['interface'] = str_replace(':','\:',$interface['interface']);
	$name = $interface['interface'].' '.$interface['description'];

	$defs = @array_merge ($defs,
    		rrdtool_get_def($interface,array("octets$id" =>"octets")));
	$graph = @array_merge($graph, array(
	"CDEF:bits$id=octets$id,UN,octets$id,octets$id,IF,8,*",
        "$graph_type:bits$id#$used_color:'$name'",
        "GPRINT:bits$id:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:bits$id:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:bits$id:LAST:'Last\:%8.2lf %sbps\\n'"
    ));
    $graph_type='STACK';
   } 
    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($defs,$graph));    
}

?>
