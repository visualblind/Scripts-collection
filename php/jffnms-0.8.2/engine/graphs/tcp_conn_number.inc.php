<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_tcp_conn_number ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("tcp_conn_number"));
    
    $opts_GRAPH = array( 		    

        "AREA:tcp_conn_number#00CC00:'Established Connections '",
        "GPRINT:tcp_conn_number:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tcp_conn_number:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tcp_conn_number:LAST:'Last\:%8.0lf %s'",
    );

    $opts_header[] = "--vertical-label='Established Connections'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
