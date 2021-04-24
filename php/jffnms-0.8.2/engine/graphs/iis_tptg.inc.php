<?
/* IIS Graphs. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iis_tptg ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tp","tg"));

    $opts_GRAPH = array(
        "AREA:tp#00CC00:'Posts Per Second  '",
        "GPRINT:tp:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tp:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tp:LAST:'Last\:%8.0lf %s\\n'",

        "STACK:tg#0000CC:'Gets Per Second   '",
        "GPRINT:tg:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tg:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tg:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}
?>
