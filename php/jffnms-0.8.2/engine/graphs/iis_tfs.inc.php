<?
/* IIS Graphs. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iis_tfs ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tfs"));

    $opts_GRAPH = array(

        "AREA:tfs#00CC00:'Total Files Sent   '",
        "GPRINT:tfs:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tfs:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tfs:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Total Files Sent'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}

?>
