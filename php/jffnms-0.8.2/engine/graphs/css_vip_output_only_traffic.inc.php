<?
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// output only traffic, for css vips

function graph_css_vip_output_only_traffic ($data) { 

    $opts_DEF = rrdtool_get_def($data,"output");
     
    $opts_GRAPH = array( 		    
	"CDEF:outputbits=output,UN,0,output,IF,8,*",	
	"HRULE:".$options["bandwidth"]."#AA0000:'Total Outbound Bandwidth\: ".($options["bandwidth"]/1000)." kbps $aux\\n'",     

	"AREA:outputbits#0000FF:Outbound",
        "GPRINT:outputbits:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:outputbits:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:outputbits:LAST:'Last\:%8.2lf %sbps'"
    );

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
