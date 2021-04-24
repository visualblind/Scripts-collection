<?
/* BGP Accepted/Advertised routes graph. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_bgp_routes ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("in"=>"accepted_routes", "out"=>"advertised_routes"));

    $opts_GRAPH = array(
	"LINE2:in#00CC00:'Accepted Routes  '",
    	"GPRINT:in:MAX:'Max\:%8.2lf %s'",
    	"GPRINT:in:AVERAGE:'Average\:%8.2lf %s'",
    	"GPRINT:in:LAST:'Last\:%8.2lf %s\\n'",

	"LINE2:out#0000FF:'Advertised Routes'",
    	"GPRINT:out:MAX:'Max\:%8.2lf %s'",
    	"GPRINT:out:AVERAGE:'Average\:%8.2lf %s'",
    	"GPRINT:out:LAST:'Last\:%8.2lf %s'",
	);

    $opts_header[] = "--vertical-label='Routes'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
