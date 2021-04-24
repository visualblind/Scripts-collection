<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_tcp_conn_delay ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("conn_delay"));

    $opts_GRAPH = array( 		    
		    
        "AREA:conn_delay#00CC00:'Connection Delay '",
        "GPRINT:conn_delay:MAX:'Max\:%8.2lf %ssec'",
        "GPRINT:conn_delay:AVERAGE:'Average\:%8.2lf %ssec'",
        "GPRINT:conn_delay:LAST:'Last\:%8.2lf %ssec'",
    );

    $opts_header[] = "--vertical-label='Connection Delay'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
