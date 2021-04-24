<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_tkb_aggregation ($data) {

    $opts_agg = array();
    $str_cdef_tkb .= 0;

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$opts_agg = array_merge($opts_agg,rrdtool_get_def($interface,array(
				    "tkb$id"=>"tkb")));

	$str_cdef_tkb .=",tkb$id,+";
    }

    $cant = count($data["id"]);
    $opts_agg[] = "CDEF:tkb=$str_cdef_tkb";


    $opts_GRAPH = array(
	"COMMENT:'Number of Servers:".$cant."\\n'",

	"CDEF:bytes=tkb,1000,*",
        "AREA:bytes#00CC00:'Throughput   '",
        "GPRINT:bytes:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:bytes:AVERAGE:'Average\:%8.0lf %sbps'",
        "GPRINT:bytes:LAST:'Last\:%8.2lf %sbps\\n'",
    );

    $opts_header[] = "--vertical-label='Bytes/Sec'";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));
}
?>
