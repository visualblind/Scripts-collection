<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apc_load_capacity ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("capacity","load"));

    $opts_GRAPH = array( 		    		    
	"LINE2:capacity#FF0000:'Battery Capacity\:'",
	"GPRINT:capacity:MAX:'Max\:%5.0lf %%'",
	"GPRINT:capacity:AVERAGE:'Average\:%5.0lf %%'",
        "GPRINT:capacity:LAST:'Last\:%5.0lf %%\\n'",
	"LINE2:load#0000FF:'Output Load\:     '",
	"GPRINT:load:MAX:'Max\:%5.0lf %%'",
	"GPRINT:load:AVERAGE:'Average\:%5.0lf %%'",
        "GPRINT:load:LAST:'Last\:%5.0lf %%\\n'"
    );

    $opts_header[] = "--vertical-label='Percentage'";

    return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));    
}
?>
