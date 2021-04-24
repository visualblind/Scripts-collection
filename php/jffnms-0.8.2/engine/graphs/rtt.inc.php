<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Round Trip Time

function graph_rtt ($data) { 

    $opts_DEF = rrdtool_get_def($data,"rtt");

    $opts_GRAPH = array( 
        "AREA:rtt#00CC00:'Round Trip Time\\n'",
        "GPRINT:rtt:MAX:'Max\:%5.0lf msec'",
        "GPRINT:rtt:AVERAGE:'Average\:%5.0lf msec'",
        "GPRINT:rtt:LAST:'Last\:%5.0lf msec'"
    );
    
    if (!empty($data["peer"])) $opts_GRAPH[]="COMMENT:'Peer IP Address: ".$data["peer"]."'";

    $opts_header[] = "--vertical-label='RTT in Milliseconds'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
