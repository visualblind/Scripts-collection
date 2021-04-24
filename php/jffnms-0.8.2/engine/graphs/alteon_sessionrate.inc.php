<?php
/* Alteon Load Balancing Switch Sessions Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_sessionrate ($data) { 

    $opts_DEF = rrdtool_get_def($data,"total_sessions");

    $opts_GRAPH = array( 
        "AREA:total_sessions#00CC00:'Session Rate'",
        "GPRINT:total_sessions:MAX:'Max\:%5.2lf %sSps'",
        "GPRINT:total_sessions:AVERAGE:'Average\:%5.2lf %sSps'",
        "GPRINT:total_sessions:LAST:'Last\:%5.2lf %sSps'"
    );
    
    $opts_header[] = "--vertical-label='Sessions/second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
