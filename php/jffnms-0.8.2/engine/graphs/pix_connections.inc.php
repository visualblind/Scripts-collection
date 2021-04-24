<?
/* This file is part of JFFNMS
 * Copyright (C) <2004> Mario Spendier <mario.spendier@at.flextronics.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_pix_connections ($data) {

    $opts_DEF = rrdtool_get_def($data,array("pix_connections"));

    $opts_GRAPH = array(

        "AREA:pix_connections#00CC00:'Established Connections '",
        "GPRINT:pix_connections:MAX:'Max\:%8.0lf %s'",
        "GPRINT:pix_connections:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:pix_connections:LAST:'Last\:%8.0lf %s'",
    );

    $opts_header[] = "--vertical-label='Established Connections'";

    return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));
}

?>
