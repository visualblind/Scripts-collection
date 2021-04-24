<?
/* IIS Graphs. This file is part of JFFNMS
 * Copyright (C) <2004 Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iis_tbr ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tbr"));

    $opts_GRAPH = array(

        "AREA:tbr#00CC00:'Total Bytes Received   '",
        "GPRINT:tbr:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tbr:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tbr:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Total Bytes Received'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}

?>
