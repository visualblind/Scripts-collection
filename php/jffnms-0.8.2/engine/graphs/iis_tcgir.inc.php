<?
/* IIS Graphs. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iis_tcgir ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tcgir"));

    $opts_GRAPH = array(

        "AREA:tcgir#00CC00:'Total CGI Requests   '",
        "GPRINT:tcgir:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tcgir:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tcgir:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Total CGI Requests'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}

?>
