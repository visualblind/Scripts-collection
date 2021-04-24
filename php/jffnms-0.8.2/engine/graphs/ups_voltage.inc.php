<?
/* UPS Voltage Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ups_voltage ($data) {

    $opts_DEF = rrdtool_get_def($data,array("voltage"));

    $opts_GRAPH = array(
        "AREA:voltage#0033AA:'Voltage '",
        "GPRINT:voltage:MAX:'Max\: %3.0lf %sVolts'",
        "GPRINT:voltage:AVERAGE:'Average\: %3.0lf %sVolts'",
        "GPRINT:voltage:LAST:'Last\: %3.0lf %sVolts\\n'",
    );

    $opts_header[] = "--vertical-label='Voltage'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
