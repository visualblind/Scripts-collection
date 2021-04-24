<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apache_tac_aggregation ($data) {

    $opts_agg = array();
    $str_cdef_tac .= 0;

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$opts_agg = array_merge($opts_agg,rrdtool_get_def($interface,array(
				    "tac$id"=>"tac")));

	$str_cdef_tac .=",tac$id,+";
    }

    $cant = count($data["id"]);
    $opts_agg[] = "CDEF:tac=$str_cdef_tac";

    $opts_GRAPH = array(
	"COMMENT:'Number of Servers:".$cant."\\n'",

        "AREA:tac#00CC00:'Hits Per Second   '",
        "GPRINT:tac:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tac:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tac:LAST:'Last\:%8.0lf %s\\n'",
    );

    $opts_header[] = "--vertical-label='Hits / Second'";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));
}

?>
