<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_apc_voltages ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("in_voltage","out_voltage"));

    $opts_GRAPH = array( 		    		    
	"LINE2:in_voltage#FF0000:'Input Voltage\:  '",
	"GPRINT:in_voltage:MAX:'Max\:%5.0lf VAC'",
	"GPRINT:in_voltage:AVERAGE:'Average\:%5.0lf VAC'",
        "GPRINT:in_voltage:LAST:'Last\:%5.0lf VAC\\n'",
	"LINE2:out_voltage#0000FF:'Output Voltage\: '",
	"GPRINT:out_voltage:MAX:'Max\:%5.0lf VAC'",
	"GPRINT:out_voltage:AVERAGE:'Average\:%5.0lf VAC'",
        "GPRINT:out_voltage:LAST:'Last\:%5.0lf VAC\\n'"
    );

    $opts_header[] = "--vertical-label='Voltage'";

    return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));    
}
?>
