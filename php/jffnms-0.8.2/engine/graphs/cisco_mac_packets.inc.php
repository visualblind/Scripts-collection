<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_cisco_mac_packets ($data) { 

    if ($data["flipinout"]==1) {
	$opts_DEF = rrdtool_get_def($data,array(outputpackets=>"inputpackets",inputpackets=>"outputpackets"));
	$flip_legend = "   (In / Out Flipped)";
    } else
	$opts_DEF = rrdtool_get_def($data,array("inputpackets","outputpackets"));
    
    $opts_GRAPH = array( 		    

        "COMMENT:'".$data["description"].", IP Address: ".$data["address"]." on ".$data["interface"]."\\n'",
		    
        "AREA:inputpackets#00CC00:'Input Packets '",
        "GPRINT:inputpackets:MAX:'Max\:%8.2lf %sPps'",
        "GPRINT:inputpackets:AVERAGE:'Average\:%8.2lf %sPps'",
        "GPRINT:inputpackets:LAST:'Last\:%8.2lf %sPps$flip_legend\\n'",

        "LINE2:outputpackets#0000FF:'Output Packets'",
        "GPRINT:outputpackets:MAX:'Max\:%8.2lf %sPps'",
        "GPRINT:outputpackets:AVERAGE:'Average\:%8.2lf %sPps'",
        "GPRINT:outputpackets:LAST:'Last\:%8.2lf %sPps'"
    );

    $opts_header[] = "--vertical-label='Packets per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
