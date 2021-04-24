<?
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_memory ($data) { 

    $opts_DEF = rrdtool_get_def($data,array('mem_total', 'mem_used'));

    $opts_GRAPH = array( 		    
    	"CDEF:mem_free=mem_total,mem_used,-",
        "CDEF:mem_free_p=mem_free,100,*,mem_total,/",
        "CDEF:mem_used_p=mem_used,100,*,mem_total,/",

        "LINE3:mem_total#FF0000:'Total Memory\:    '", 
        "GPRINT:mem_total:MAX:'%6.0lf %sB\\n'", 
		
        "AREA:mem_used#FF8800:'Used Memory '",
	"GPRINT:mem_used:MAX:'Max\: %6.2lf %sB'",
	"GPRINT:mem_used_p:MAX:'(%2.0lf %%)'", 

        "GPRINT:mem_used:AVERAGE:'Average\: %6.2lf %sB'",
        "GPRINT:mem_used_p:AVERAGE:'(%2.0lf %%)'", 

        "GPRINT:mem_used:LAST:'Last\: %6.2lf %sB'",
	"GPRINT:mem_used_p:LAST:'(%2.0lf %%)\\n'", 
        
	"STACK:mem_free#00CC00:'Free Memory '",
        "GPRINT:mem_free:MAX:'Max\: %6.2lf %sB'",
	"GPRINT:mem_free_p:MAX:'(%2.0lf %%)'", 

        "GPRINT:mem_free:AVERAGE:'Average\: %6.2lf %sB'",
	"GPRINT:mem_free_p:AVERAGE:'(%2.0lf %%)'", 

        "GPRINT:mem_free:LAST:'Last\: %6.2lf %sB'",
	"GPRINT:mem_free_p:LAST:'(%2.0lf %%)\\n'", 
    );

    $opts_header[] = "--vertical-label='Used Memory'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
