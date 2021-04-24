<?
/* Load Average Aggregation. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ucd_load_average_aggregation ($data) {

    $opts_agg = array();
    $cant = count($data["id"]);

    $str_cdef_1  .= "CDEF:load_average_1=0";
    $str_cdef_5  .= "CDEF:load_average_5=0";
    $str_cdef_15 .= "CDEF:load_average_15=0";

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$opts_agg = array_merge($opts_agg,rrdtool_get_def($interface,array(
				    "load_average_1$id"=>"load_average_1",
				    "load_average_5$id"=>"load_average_5",
				    "load_average_15$id"=>"load_average_15")));


	$str_cdef_1 .=",load_average_1$id,+";
        $str_cdef_5 .=",load_average_5$id,+";
	$str_cdef_15 .=",load_average_15$id,+";
    }

    $str_cdef_1 .= ",$cant,/";
    $str_cdef_5 .= ",$cant,/";
    $str_cdef_15 .= ",$cant,/";

    $opts_GRAPH = array(
    	$str_cdef_1,
    	$str_cdef_5,
	$str_cdef_15,

	"COMMENT:'Number of Processors:".$cant."\\n'",

        "LINE1:load_average_1#FF0000:' 1 Minute  Load Average'",
        "GPRINT:load_average_1:MAX:'Max\: %5.2lf'",
        "GPRINT:load_average_1:AVERAGE:'Average\: %5.2lf'",
        "GPRINT:load_average_1:LAST:'Last\: %5.2lf\\n'",

        "LINE2:load_average_5#0000FF:' 5 Minutes Load Average'",
        "GPRINT:load_average_5:MAX:'Max\: %5.2lf'",
        "GPRINT:load_average_5:AVERAGE:'Average\: %5.2lf'",
        "GPRINT:load_average_5:LAST:'Last\: %5.2lf\\n'",

        "LINE2:load_average_15#00CC00:'15 Minutes Load Average'",
        "GPRINT:load_average_15:MAX:'Max\: %5.2lf'",
        "GPRINT:load_average_15:AVERAGE:'Average\: %5.2lf'",
        "GPRINT:load_average_15:LAST:'Last\: %5.2lf\\n'"
    );

    $opts_header[] = "--vertical-label='Load Average'";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));
}
?>
