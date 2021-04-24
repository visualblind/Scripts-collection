<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_workers ($data) {

    $opts_DEF = rrdtool_get_def($data,array("bw","iw"));

    $opts_GRAPH = array(

        "AREA:bw#DD2200:'Busy Workers   '",
        "GPRINT:bw:MAX:'Max\:%8.0lf %s'",
        "GPRINT:bw:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:bw:LAST:'Last\:%8.0lf %s\\n'",
    
        "STACK:iw#00CC00:'Idle Workers   '",
        "GPRINT:iw:MAX:'Max\:%8.0lf %s'",
        "GPRINT:iw:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:iw:LAST:'Last\:%8.0lf %s'"
    );

    $opts_header[] = "--lower-limit=0";
    $opts_header[] = "--vertical-label='Workers'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
