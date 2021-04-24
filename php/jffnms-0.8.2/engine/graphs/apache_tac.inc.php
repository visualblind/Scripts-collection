<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_tac ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tac"));

    $opts_GRAPH = array(

        "AREA:tac#00CC00:'Hits Per Second   '",
        "GPRINT:tac:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tac:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tac:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Hits/Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
