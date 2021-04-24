<?
/* CPU Utilization Aggregation. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_cpu_util_aggregation ($data) {

    $opts_agg = array();
    $str_cdef_cpu .= "CDEF:cpu=0";
    $cant = count($data["id"]);

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$opts_agg = @array_merge($opts_agg,rrdtool_get_def($interface,array(
				    "cpu$id"=>"cpu")));

	$str_cdef_cpu .=",cpu$id,UN,0,cpu$id,IF,+";
    }

    $str_cdef_cpu .= ",$cant,/";

    $opts_GRAPH = array(
	$str_cdef_cpu,
	"COMMENT:'Number of Processors:".$cant."\\n'",

        "AREA:cpu#00CC00:'Average CPU Utilization '",
        "LINE1:cpu#0000FF:''",

	"GPRINT:cpu:MAX:'Max\:%8.2lf %%'",
        "GPRINT:cpu:AVERAGE:'Average\:%8.2lf %%'",
        "GPRINT:cpu:LAST:'Last\:%8.2lf %%'"
	);
	
    $opts_header[] = "--vertical-label='CPU Utilization %'";
    $opts_header[] = "--rigid";
    $opts_header[] = "--upper-limit=100";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));
}
?>
