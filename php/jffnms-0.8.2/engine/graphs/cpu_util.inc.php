<?
/* Windows and Cisco CPU Utilization Graph. This file is part of JFFNMS.
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_cpu_util ($data) { 

    $opts_DEF = rrdtool_get_def($data,"cpu");

    $limit = 100;
    
    $opts_GRAPH = array( 		    

        "HRULE:".$limit."#FF0000:",

        "AREA:cpu#00CC00:'CPU Utilization '",
        "LINE1:cpu#0000FF:''",

	"GPRINT:cpu:MAX:'Max\:%8.2lf %%'",
        "GPRINT:cpu:AVERAGE:'Average\:%8.2lf %%'",
        "GPRINT:cpu:LAST:'Last\:%8.2lf %%'"
    );

    $opts_header[] = "--vertical-label='CPU Utilization %'";
    $opts_header[] = "--rigid";
    $opts_header[] = "--upper-limit=".$limit;

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
