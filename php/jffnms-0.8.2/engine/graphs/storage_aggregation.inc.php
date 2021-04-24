<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Aggregated Used Storage Graph

function graph_storage_aggregation ($data) { 

    $color_array = array("0","9","C","F","4");
    foreach ($color_array as $a) 
    foreach ($color_array as $c) 
    foreach ($color_array as $e) 
    	$colors[] = $a."0".$c."0".$e."0";
    
    $opts_DEF = array();
    $opts_GRAPH = array();
    
    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$defs = rrdtool_get_def($interface,array(
				    "storage_block_count_b$id"=>"storage_block_count",
				    "storage_block_size_b$id"=>"storage_block_size",	
				    "storage_used_blocks_b$id"=>"storage_used_blocks"));

	$aux = @array_merge ($defs,array (
    	    "CDEF:storage_block_count$id=storage_block_count_b$id", 
    	    "CDEF:storage_used_blocks$id=storage_used_blocks_b$id", 
    	    "CDEF:storage_block_size$id=storage_block_size_b$id", 
	
	    "CDEF:storage_free_blocks$id=storage_block_count$id,storage_used_blocks$id,-", 
	    "CDEF:storage_free$id=storage_free_blocks$id,storage_block_size$id,*", 

	    "CDEF:storage_total$id=storage_block_count$id,storage_block_size$id,*", 
	    "CDEF:storage_used$id=storage_used_blocks$id,storage_block_size$id,*", 

	    "CDEF:storage_free_p$id=storage_free$id,100,*,storage_total$id,/", 
	    "CDEF:storage_used_p$id=storage_used$id,100,*,storage_total$id,/"
	));

	$opts_DEF = @array_merge ($opts_DEF, $aux);

	$description = substr(str_pad($interface["host_name"]." ".$interface["interface"],60," ",STR_PAD_RIGHT),0,25);
	$description = str_replace (":","\:",$description); //escape : for Windows Disks
	$used_color = $colors[++$i*2];
	
	$opts_GRAPH = @array_merge ($opts_GRAPH,array(
    	    "LINE2:storage_used$id#$used_color:'$description'", 
	    
	    "GPRINT:storage_total$id:MAX:'%6.0lf %sB'",
	    
	    "GPRINT:storage_used$id:AVERAGE:'Used Avg\: %6.2lf %sB'", 
	    "GPRINT:storage_used_p$id:AVERAGE:'(%3.0lf %%)'", 
	    
	    "GPRINT:storage_used$id:LAST:'Last\: %6.2lf %sB'", 
	    "GPRINT:storage_used_p$id:LAST:'(%3.0lf %%)\\n'", 
	));
    }

    $opts_header[] = "--vertical-label='Used Storage'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
