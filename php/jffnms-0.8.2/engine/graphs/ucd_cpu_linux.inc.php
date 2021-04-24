<?
/* Linux CPU Graph. This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * Copyright (C) <2005> Robert St.Denis (SMP Aggregation)
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function graph_ucd_cpu_linux ($data) {

	$limit = 100;

	$opts_DEF = rrdtool_get_def($data,array("cpu_user_ticks","cpu_idle_ticks","cpu_nice_ticks","cpu_system_ticks"));

        $opts_GRAPH = array(
    		"HRULE:$limit#990000:'Number of Processors\: ".$data["cpu_num"]."\\n'",

		"CDEF:cpu_user=cpu_user_ticks,".$data["cpu_num"].",/",
		"CDEF:cpu_nice=cpu_nice_ticks,".$data["cpu_num"].",/",
		"CDEF:cpu_system=cpu_system_ticks,".$data["cpu_num"].",/",
		"CDEF:cpu_idle=cpu_idle_ticks,".$data["cpu_num"].",/",

		"AREA:cpu_user#FF0000:'User   CPU Time'",
		"GPRINT:cpu_user:MAX:'Max\:%8.2lf %%'",
		"GPRINT:cpu_user:AVERAGE:'Average\:%8.2lf %%'",
		"GPRINT:cpu_user:LAST:'Last\:%8.2lf %%\\n'",

		"STACK:cpu_nice#0000FF:'Nice   CPU Time'",
		"GPRINT:cpu_nice:MAX:'Max\:%8.2lf %%'",
                "GPRINT:cpu_nice:AVERAGE:'Average\:%8.2lf %%'",
                "GPRINT:cpu_nice:LAST:'Last\:%8.2lf %%\\n'",

                "STACK:cpu_system#FFFF00:'System CPU Time'",
                "GPRINT:cpu_system:MAX:'Max\:%8.2lf %%'",
                "GPRINT:cpu_system:AVERAGE:'Average\:%8.2lf %%'",
                "GPRINT:cpu_system:LAST:'Last\:%8.2lf %%\\n'",

                "STACK:cpu_idle#00CC00:'Idle   CPU Time'",
                "GPRINT:cpu_idle:MAX:'Max\:%8.2lf %%'",
                "GPRINT:cpu_idle:AVERAGE:'Average\:%8.2lf %%'",
    		"GPRINT:cpu_idle:LAST:'Last\:%8.2lf %%\\n'");


	$opts_header[] = "--vertical-label='CPU Usage'";
	$opts_header[] = "--rigid";
	$opts_header[] = "--upper-limit=$limit";

        return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
    }
?>
