<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_bgp_updates ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(input=>"bgpin",output=>"bgpout",uptime_sec=>"bgpuptime"));

    $opts_GRAPH = array (
        "CDEF:uptime_min=uptime_sec,60,/",
        "CDEF:uptime_hour=uptime_min,60,/",
        "CDEF:input_5min=input,300,*",
        "CDEF:output_5min=output,300,*",
		    
        //"LINE1:uptime_sec#FF0000:'Peer Uptime\:'",
        "GPRINT:uptime_hour:LAST:'Peer Uptime\: %6.2lf Hours'",
        "GPRINT:uptime_sec:LAST:'(%9.0lf seconds)\\n'",

        "AREA:input_5min#00CC00:'Inbound  Updates in 5 minutes'",
        "GPRINT:input_5min:MAX:'Max\:%4.0lf %s'",
        "GPRINT:input_5min:AVERAGE:'Average\:%4.0lf %s'",
        "GPRINT:input_5min:LAST:'Last\:%4.0lf %s\\n'",

        "LINE2:output_5min#0000FF:'Outbound Updates in 5 minutes'",
	"GPRINT:output_5min:MAX:'Max\:%4.0lf %s'",
        "GPRINT:output_5min:AVERAGE:'Average\:%4.0lf %s'",
        "GPRINT:output_5min:LAST:'Last\:%4.0lf %s'"
    );

    $opts_header[] = "--vertical-label='BGP Updates per 5 Minutes'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
