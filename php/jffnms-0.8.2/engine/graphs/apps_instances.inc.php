<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Application Instances

function graph_apps_instances ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("current_instances"));

    $opts_GRAPH = array(
        "HRULE:".$data["instances"]."#00FF00:'Instances when added\: ".$data["instances"]."\\n'",
        "LINE3:current_instances#FF0000:'Instances\: '",
        "GPRINT:current_instances:MAX:'Max\:%5.0lf'",
        "GPRINT:current_instances:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:current_instances:LAST:'Last\:%5.0lf \\n'"
    );

    $opts_header[] = "--vertical-label='Number of Threads'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
