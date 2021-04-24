<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_bpr ($data) {

    $opts_DEF = rrdtool_get_def($data,array("bpr"));

    $opts_GRAPH = array(

        "AREA:bpr#00CC00:'Bytes Per Request   '",
        "GPRINT:bpr:MAX:'Max\:%8.0lf %s'",
        "GPRINT:bpr:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:bpr:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Bytes Per Request'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
