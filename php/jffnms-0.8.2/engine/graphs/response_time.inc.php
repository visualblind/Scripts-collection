<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Round Trip Time

function graph_response_time ($data) { 

    $opts_DEF = rrdtool_get_def($data,"response_time");

    $opts_GRAPH = array( 
        "AREA:response_time#00CC00:'Response Time\\n'",
        "GPRINT:response_time:MAX:'Max\:%5.0lf msec'",
        "GPRINT:response_time:AVERAGE:'Average\:%5.0lf msec'",
        "GPRINT:response_time:LAST:'Last\:%5.0lf msec'"
    );
    

    $opts_header[] = "--vertical-label='Response Time in Milliseconds'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
