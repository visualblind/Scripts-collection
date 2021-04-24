<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Cisco SA Agent Jitter grapher

function graph_cisco_saagent_jitter ($data) { 
    extract($data);
    
    $opts_DEF = rrdtool_get_def($data,array("forward_jitter","backward_jitter"));

    $opts_GRAPH = array(                                    
        "AREA:forward_jitter#00CC00:'Forward  Jitter '",
        "GPRINT:forward_jitter:MAX:'Max\:%5.0lf'",
        "GPRINT:forward_jitter:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:forward_jitter:LAST:'Last\:%5.0lf \\n'",

        "LINE1:backward_jitter#0000FF:'Backward Jitter '",
        "GPRINT:backward_jitter:MAX:'Max\:%5.0lf'",
        "GPRINT:backward_jitter:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:backward_jitter:LAST:'Last\:%5.0lf \\n'",
    );

    $opts_header[] = "--vertical-label='SA Agent Jitter'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
