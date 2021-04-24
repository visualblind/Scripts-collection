<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_packets ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(input=>"inpackets",output=>"outpackets"));

    $opts_GRAPH = array( 		    
		    
        "AREA:input#00CC00:'Input Pkts '",
        //"GPRINT:input:MAX:'Max\:%8.2lf %sPps'",
        "GPRINT:input:AVERAGE:'Average\:%8.2lf %sPps'",
        "GPRINT:input:LAST:'Last\:%8.2lf %sPps\\n'",

        "LINE2:output#0000FF:'Output Pkts'",
        //"GPRINT:output:MAX:'Max\:%8.2lf %sPps'",
        "GPRINT:output:AVERAGE:'Average\:%8.2lf %sPps'",
        "GPRINT:output:LAST:'Last\:%8.2lf %sPps'"
    );

    $opts_header[] = "--vertical-label='Packets per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
