<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_cplo ($data) {

    $opts_DEF = rrdtool_get_def($data,array("cplo","up"));

    $opts_GRAPH = array(

	"GPRINT:up:LAST:'Uptime\: %8.0lf %s seconds\\n'",
        "AREA:cplo#00CC00:'CPU Load   '",
        "GPRINT:cplo:MAX:'Max\:%8.0lf %s'",
        "GPRINT:cplo:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:cplo:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='CPU Load'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
