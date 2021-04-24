<?
/* UPS Current Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ups_current ($data) {

    $opts_DEF = rrdtool_get_def($data,array("current"));

    $opts_GRAPH = array(
        "AREA:current#DD3300:'Current '",
        "GPRINT:current:MAX:'Max\: %3.0lf %sAmps'",
        "GPRINT:current:AVERAGE:'Average\: %3.0lf %sAmps'",
        "GPRINT:current:LAST:'Last\: %3.0lf %sAmps\\n'",
    );

    $opts_header[] = "--vertical-label='Current'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
