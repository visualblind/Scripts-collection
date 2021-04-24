<?
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// generic "hits" graph, for css vips

function graph_css_vip_hits ($data) { 

    $opts_DEF = rrdtool_get_def($data,"hits");

    $opts_GRAPH = array( 		    
	"CDEF:hitcount=hits,UN,0,hits,IF",	

	"AREA:hitcount#0000FF:Hits",
        "GPRINT:hitcount:MAX:'Max\:%8.2lf %s hits'",
        "GPRINT:hitcount:AVERAGE:'Average\:%8.2lf %s hits/s'",
        "GPRINT:hitcount:LAST:'Last\:%8.2lf %s hits/s'"
    );

    $opts_header[] = "--vertical-label='Hits per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
