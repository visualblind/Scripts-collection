<?php
/* Alteon Load Balancing Switch Sessions Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_sessionrate_aggregation ($data) { 

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
    		rrdtool_get_def($interface,array("sessions$id" =>"total_sessions")));
	$graph = @array_merge($graph, array(
        "$graph_type:sessions$id#$used_color:'$name'",
        "GPRINT:sessions$id:MAX:'Max\:%5.2lf '",
        "GPRINT:sessions$id:AVERAGE:'Average\:%5.2lf '",
        "GPRINT:sessions$id:LAST:'Last\:%5.2lf\\n'"
    ));
    $graph_type='STACK';
   } 
    $opts_header[] = "--vertical-label='Sessions/second'";

    return array ($opts_header, @array_merge($defs,$graph));    
}

?>
