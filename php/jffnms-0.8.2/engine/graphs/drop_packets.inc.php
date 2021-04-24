<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_drop_packets ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("drops"));

    $opts_GRAPH = array( 		    
        "AREA:drops#FF0000:'Drops '",
        "GPRINT:drops:MAX:'Max\:%4.0lf %sDps'",
        "GPRINT:drops:AVERAGE:'Average\:%4.0lf %sDps'",
        "GPRINT:drops:LAST:'Last\:%4.0lf %sDps\\n'"
    );
    $opts_header[] = "--vertical-label='Packet Drops per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
