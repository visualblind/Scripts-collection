<?
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Used Storage Graph

function graph_storage ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(
				    storage_block_count_b=>"storage_block_count",
				    storage_block_size_b=>"storage_block_size",	
				    storage_used_blocks_b=>"storage_used_blocks"));

    $opts_GRAPH = array(                     
        "CDEF:storage_block_count=storage_block_count_b", 
        "CDEF:storage_used_blocks=storage_used_blocks_b", 
        "CDEF:storage_block_size=storage_block_size_b", 
         
        "CDEF:storage_free_blocks=storage_block_count,storage_used_blocks,-", 
                    
        "CDEF:storage_free=storage_free_blocks,storage_block_size,*", 
        "CDEF:storage_total=storage_block_count,storage_block_size,*", 
        "CDEF:storage_used=storage_used_blocks,storage_block_size,*", 
                    
        "CDEF:storage_free_p=storage_free,100,*,storage_total,/", 
        "CDEF:storage_used_p=storage_used,100,*,storage_total,/", 

        "LINE3:storage_total#FF0000:'Total Storage\:    '", 
        "GPRINT:storage_total:MAX:'%6.0lf %sB\\n'", 
                 
        "AREA:storage_used#FF8800:'Used Storage '", 
        "GPRINT:storage_used:MAX:'Max\: %6.2lf %sB'", 
        "GPRINT:storage_used_p:MAX:'(%3.0lf %%)'", 

        "GPRINT:storage_used:AVERAGE:'Average\: %6.2lf %sB'", 
        "GPRINT:storage_used_p:AVERAGE:'(%3.0lf %%)'", 

        "GPRINT:storage_used:LAST:'Last\: %6.2lf %sB'", 
        "GPRINT:storage_used_p:LAST:'(%3.0lf %%)\\n'", 
        
        "STACK:storage_free#00CC00:'Free Storage '", 
        "GPRINT:storage_free:MAX:'Max\: %6.2lf %sB'", 
        "GPRINT:storage_free_p:MAX:'(%3.0lf %%)'", 

        "GPRINT:storage_free:AVERAGE:'Average\: %6.2lf %sB'", 
        "GPRINT:storage_free_p:AVERAGE:'(%3.0lf %%)'", 

        "GPRINT:storage_free:LAST:'Last\: %6.2lf %sB'", 
        "GPRINT:storage_free_p:LAST:'(%3.0lf %%)\\n'", 
    ); 

    $opts_header[] = "--vertical-label='Used Storage'"; 

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
