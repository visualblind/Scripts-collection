<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //HOSTMIB Application Used Memory

    function graph_apps_memory ($data) { 

	$opts_DEF = rrdtool_get_def($data,array("used_memory_kb"=>"used_memory"));

	$opts_GRAPH = array(                     
	    "CDEF:used_memory=used_memory_kb,1000,*",
	    "AREA:used_memory#FF8800:'Memory\: \\n'", 
	    "GPRINT:used_memory:MAX:'Max\: %6.2lf %sB'", 
    	    "GPRINT:used_memory:AVERAGE:'Average\: %6.2lf %sB'", 
    	    "GPRINT:used_memory:LAST:'Last\: %6.2lf %sB\\n'", 
	); 

	$opts_header[] = "--vertical-label='Used Memory'"; 

        return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
    }

?>
