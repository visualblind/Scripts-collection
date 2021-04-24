<?
/* UPS load Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ups_load ($data) {

    $opts_DEF = rrdtool_get_def($data,array("load"));

    $opts_GRAPH = array(
        "AREA:load#0033FF:'Load '",
        "GPRINT:load:MAX:'Max\: %3.0lf %%'",
        "GPRINT:load:AVERAGE:'Average\: %3.0lf %%'",
        "GPRINT:load:LAST:'Last\: %3.0lf %%\\n'",
    );

    $opts_header[] = "--vertical-label='Load %'";
    $opts_header[] = "--rigid";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
