<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_hostmib_users_procs ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("num_procs","num_users"));

    $opts_GRAPH = array( 		    
		    
        "AREA:num_procs#00CC00:'Number of Processes   '",
        "GPRINT:num_procs:MAX:'Max\:%8.0lf %s'",
        "GPRINT:num_procs:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:num_procs:LAST:'Last\:%8.0lf %s\\n'",

        "LINE2:num_users#0000FF:'Number of Users       '",
        "GPRINT:num_users:MAX:'Max\:%8.0lf %s'",
        "GPRINT:num_users:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:num_users:LAST:'Last\:%8.0lf %s'"
    );

    $opts_header[] = "--vertical-label='Processes/Users'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
