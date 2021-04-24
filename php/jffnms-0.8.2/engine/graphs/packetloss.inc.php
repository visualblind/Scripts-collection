<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Only Packet Loss

function graph_packetloss ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array(plraw=>"packetloss"));

    $opts_GRAPH = array( 		    		    
	"LINE1:plraw#FF0000:'Packet Loss      '",
	"GPRINT:plraw:MAX:'Max\:%5.0lf'",
	"GPRINT:plraw:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:plraw:LAST:'Last\:%5.0lf \\n'"
    );

    $opts_header[] = "--vertical-label='Lost Packets'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
