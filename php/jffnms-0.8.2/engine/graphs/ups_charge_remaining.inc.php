<?
/* UPS Charge Remaining Graph. This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function graph_ups_charge_remaining ($data) { 
    
	$opts_DEF = rrdtool_get_def($data,array("charge_remaining"));

	$opts_GRAPH = array(                                    
	    "AREA:charge_remaining#00DD00:'Charge Remaining\:'",
            "GPRINT:charge_remaining:MAX:'Max\: %3.0lf %%'",
	    "GPRINT:charge_remaining:AVERAGE:'Average\: %3.0lf %%'",
            "GPRINT:charge_remaining:LAST:'Last\: %3.0lf %%\\n'",
	);

	$opts_header[] = "--vertical-label='Charge Remaining %'";

    	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
    }
?>
