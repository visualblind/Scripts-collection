<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Cisco SA Agent Packetloss grapher

function graph_cisco_saagent_packetloss ($data) { 
    extract($data);
    
    $opts_DEF = rrdtool_get_def($data,array("forward_packetloss","backward_packetloss"));

    $opts_GRAPH = array(                                    
        "AREA:forward_packetloss#00CC00:'Forward  % Packet Loss'",
        "GPRINT:forward_packetloss:MAX:'Max\:%5.0lf'",
        "GPRINT:forward_packetloss:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:forward_packetloss:LAST:'Last\:%5.0lf \\n'",

        "LINE1:backward_packetloss#0000FF:'Backward % Packet Loss'",
        "GPRINT:backward_packetloss:MAX:'Max\:%5.0lf'",
        "GPRINT:backward_packetloss:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:backward_packetloss:LAST:'Last\:%5.0lf \\n'",
    );

    $opts_header[] = "--vertical-label='SA Agent % Packet Loss'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
