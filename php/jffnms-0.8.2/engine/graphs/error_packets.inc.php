<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_error_packets ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(input=>"inputerrors",output=>"outputerrors"));

    $opts_GRAPH = array( 		    
		    
        "AREA:input#00CC00:'Input Errors '",
        //"GPRINT:input:MAX:'Max\:%4.0lf %sEps'",
        "GPRINT:input:AVERAGE:'Average\:%4.0lf %sEps'",
        "GPRINT:input:LAST:'Last\:%4.0lf %sEps\\n'",

        "LINE2:output#0000FF:'Output Errors'",
        //"GPRINT:output:MAX:'Max\:%4.0lf %sEps'",
        "GPRINT:output:AVERAGE:'Average\:%4.0lf %sEps'",
        "GPRINT:output:LAST:'Last\:%4.0lf %sEps'");

    $opts_header[] = "--vertical-label='Errors per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
