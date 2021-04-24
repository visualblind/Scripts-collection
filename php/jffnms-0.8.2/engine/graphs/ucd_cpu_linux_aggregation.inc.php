<?
/* Net-SNMP CPU Utilization Aggregation. This file is part of JFFNMS
 * Copyright (C) <2004> Robert St.Denis <service@iahu.ca>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_ucd_cpu_linux_aggregation ($data) {

    $opts_agg = array();
    $str_cdef_user 	.= "CDEF:cpu_user=0";
    $str_cdef_nice 	.= "CDEF:cpu_nice=0";
    $str_cdef_system 	.= "CDEF:cpu_system=0";
    $str_cdef_idle 	.= "CDEF:cpu_idle=0";

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	$opts_agg = array_merge($opts_agg,rrdtool_get_def($interface,array(
				    "cpu_user_ticks$id"=>"cpu_user_ticks",
				    "cpu_idle_ticks$id"=>"cpu_idle_ticks",
				    "cpu_nice_ticks$id"=>"cpu_nice_ticks",
				    "cpu_system_ticks$id"=>"cpu_system_ticks")));

	$cant += $interface["cpu_num"];

	$str_cdef_user 	.= ",cpu_user_ticks$id,+";
	$str_cdef_nice 	.= ",cpu_nice_ticks$id,+";
	$str_cdef_system.= ",cpu_system_ticks$id,+";
	$str_cdef_idle 	.= ",cpu_idle_ticks$id,+";

    }

    $str_cdef_user 	.= ",$cant,/";
    $str_cdef_nice 	.= ",$cant,/";
    $str_cdef_system 	.= ",$cant,/";
    $str_cdef_idle 	.= ",$cant,/";

    $opts_GRAPH = array(
	$str_cdef_user,
	$str_cdef_nice,
	$str_cdef_system,
	$str_cdef_idle,
		
	"COMMENT:'Number of Processors:".$cant."\\n'",
	
	"AREA:cpu_user#FF0000:'Average User   CPU Time'",
	"GPRINT:cpu_user:MAX:'Max\:%8.2lf %%'",
	"GPRINT:cpu_user:AVERAGE:'Average\:%8.2lf %%'",
	"GPRINT:cpu_user:LAST:'Last\:%8.2lf %%\\n'",

        "STACK:cpu_nice#0000FF:'Average Nice   CPU Time'",
        "GPRINT:cpu_nice:MAX:'Max\:%8.2lf %%'",
        "GPRINT:cpu_nice:AVERAGE:'Average\:%8.2lf %%'",
        "GPRINT:cpu_nice:LAST:'Last\:%8.2lf %%\\n'",

        "STACK:cpu_system#FFFF00:'Average System CPU Time'",
        "GPRINT:cpu_system:MAX:'Max\:%8.2lf %%'",
        "GPRINT:cpu_system:AVERAGE:'Average\:%8.2lf %%'",
        "GPRINT:cpu_system:LAST:'Last\:%8.2lf %%\\n'",

        "STACK:cpu_idle#00CC00:'Average Idle   CPU Time'",
        "GPRINT:cpu_idle:MAX:'Max\:%8.2lf %%'",
        "GPRINT:cpu_idle:AVERAGE:'Average\:%8.2lf %%'",
	"GPRINT:cpu_idle:LAST:'Last\:%8.2lf %%\\n'"
    );

    $opts_header[] = "--vertical-label='CPU Usage'";
    $opts_header[] = "--rigid";
    $opts_header[] = "--upper-limit=100";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));
}
?>
