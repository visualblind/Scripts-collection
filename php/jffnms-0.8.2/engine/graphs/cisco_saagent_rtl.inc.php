<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Cisco SA-Agent Round-Trip Latency grapher

function graph_cisco_saagent_rtl ($data) { 
    extract($data);
    
    $opts_DEF = rrdtool_get_def($data,array("rt_latency"));

    $opts_GRAPH = array(                                    
        "AREA:rt_latency#00CC00:'Round-Trip Latency'",
        "GPRINT:rt_latency:MAX:'Max\:%5.0lf msec'",
        "GPRINT:rt_latency:AVERAGE:'Average\:%5.0lf msec'",
        "GPRINT:rt_latency:LAST:'Last\:%5.0lf msec \\n'"
    );

    $opts_header[] = "--vertical-label='SA Agent Round-Trip Latency'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
