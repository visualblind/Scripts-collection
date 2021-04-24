<?php
/* Alteon Load Balancing Switch Sessions Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_sessions ($data) { 

    $opts_DEF = rrdtool_get_def($data,"current_sessions");

    $opts_GRAPH = array( 
        "AREA:current_sessions#00CC00:'Sessions'",
        "GPRINT:current_sessions:MAX:'Max\:%5.0lf '",
        "GPRINT:current_sessions:AVERAGE:'Average\:%5.0lf '",
        "GPRINT:current_sessions:LAST:'Last\:%5.0lf \\n'",
    );
    if (!empty($data['max_connections'])) $opts_GRAPH[] = "COMMENT:'  Maximum Connections: ".$data['max_connections']."'";
    
    $opts_header[] = "--vertical-label='Sessions'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
