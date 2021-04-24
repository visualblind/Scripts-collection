<?
/* UPS Time Remaining Graph. This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function graph_ups_time_remaining ($data) { 
    
	$opts_DEF = rrdtool_get_def($data,array("minutes_remaining"));

	$opts_GRAPH = array(                                    
	    "CDEF:minutes_remaining_h=minutes_remaining,60,/",
	    "AREA:minutes_remaining#00DD00:'Time Remaining\:'",
            "GPRINT:minutes_remaining:MAX:'Max\: %3.0lf min'",
	    "GPRINT:minutes_remaining:AVERAGE:'Average\: %3.0lf min'",
            "GPRINT:minutes_remaining:LAST:'Last\: %3.0lf min'",
	    "GPRINT:minutes_remaining_h:LAST:'(%3.2lf Hours)\\n'",
	);

	$opts_header[] = "--vertical-label='Time Remaining'";

    	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
    }
?>
