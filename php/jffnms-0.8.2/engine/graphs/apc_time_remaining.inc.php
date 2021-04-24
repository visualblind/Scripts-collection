<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //apc_time_remaining

    function graph_apc_time_remaining ($data) { 
    
	$opts_DEF = rrdtool_get_def($data,array("time_remaining_tt"=>"time_remaining"));

	$opts_GRAPH = array(                                    
	    "CDEF:time_remaining_sec=time_remaining_tt,100,/",
	    "CDEF:time_remaining_min=time_remaining_sec,60,/",
	    "CDEF:time_remaining_h=time_remaining_min,60,/",
	    "AREA:time_remaining_min#00DD00:'Time Remaining\:'",
            "GPRINT:time_remaining_min:MAX:'Max\:%5.0lf Minutes'",
	    "GPRINT:time_remaining_min:AVERAGE:'Average\:%5.0lf Minutes'",
            "GPRINT:time_remaining_min:LAST:'Last\:%5.0lf Minutes'",
	    "GPRINT:time_remaining_h:LAST:'(%3.2lf Hours)\\n'",
	);

	$opts_header[] = "--vertical-label='Time Remaining'";

    	return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));    
    }
?>
