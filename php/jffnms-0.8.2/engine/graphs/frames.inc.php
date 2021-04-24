<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_frames ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(input=>"rx_frames",output=>"tx_frames"));

    $opts_GRAPH = array( 		    
		    
        "AREA:input#00CC00:'Input Frms '",
        //"GPRINT:input:MAX:'Max\:%8.2lf %sFps'",
        "GPRINT:input:AVERAGE:'Average\:%8.2lf %sFps'",
        "GPRINT:input:LAST:'Last\:%8.2lf %sFps\\n'",

        "LINE2:output#0000FF:'Output Frms'",
        //"GPRINT:output:MAX:'Max\:%8.2lf %sFps'",
        "GPRINT:output:AVERAGE:'Average\:%8.2lf %sFps'",
        "GPRINT:output:LAST:'Last\:%8.2lf %sFps'"
    );

    $opts_header[] = "--vertical-label='Frames per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
