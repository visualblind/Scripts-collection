<?
/* IPTables Chains Aggregation Graph. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iptables_rate_aggregation ($data) { 

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

	list(,$interface["interface"]) = explode (" ", $interface["interface"]);

	$defs = @array_merge ($defs,
	    rrdtool_get_def($interface,array("bytes$id"=>"ipt_bytes")),
	    array("CDEF:bits$id=bytes$id,UN,bytes$id,bytes$id,IF,8,*"));

	$graph = @array_merge ($graph, array(  
		"LINE2:bits$id#$used_color:'".str_pad($interface["interface"],25)."'",
    		"GPRINT:bits$id:MAX:'Max\:%8.2lf %sbps'",
    		"GPRINT:bits$id:AVERAGE:'Average\:%8.2lf %sbps'",
    		"GPRINT:bits$id:LAST:'Last\:%8.2lf %sbps\\n'",
	    ));
    
    }
    
    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($defs,$graph));
}
?>
