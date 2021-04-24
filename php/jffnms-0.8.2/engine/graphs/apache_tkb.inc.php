<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_tkb ($data) {

    $opts_DEF = rrdtool_get_def($data,array("tkb"));

    $opts_GRAPH = array(
	"CDEF:bytes=tkb,1000,*",
        "AREA:bytes#00CC00:'Throughput   '",
        "GPRINT:bytes:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:bytes:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:bytes:LAST:'Last\:%8.2lf %sbps\\n'",
    );

    $opts_header[] = "--vertical-label='Bytes/Sec'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
