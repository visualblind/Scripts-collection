<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Packet Loss Over the Traffic Graph

function graph_traffic_pl ($data) { 

    if ($data["flipinout"]==1) {
	$opts_DEF = rrdtool_get_def($data,array(output=>"input",input=>"output",plraw=>"packetloss"));
	$flip_legend = "     (In / Out Flipped)";
    } else 
	$opts_DEF = rrdtool_get_def($data,array("input","output",plraw=>"packetloss"));

    $opts_GRAPH = array( 		    
        "CDEF:inputbits=input,8,*",
        "CDEF:outputbits=output,8,*",
        "HRULE:".$data["bandwidthin"]. "#55000:'Total Inbound  Bandwidth\: ".($data["bandwidthin"] /1000)." kbps\\n'",     
        "HRULE:".$data["bandwidthout"]."#99000:'Total Outbound Bandwidth\: ".($data["bandwidthout"]/1000)." kbps\\n'",     
		    
        "CDEF:plpor=plraw,2,*",
        "CDEF:pldiv=plraw,2,/",
        "CDEF:bigger=inputbits,outputbits,MAX",
        "CDEF:10bigger=10,bigger,*,100,/",
	"CDEF:pl=10bigger,pldiv,*",
		    
	"AREA:bigger#FFFFFF:",
	"STACK:pl#FF0000:'Packet Loss'",
	//"GPRINT:plpor:MAX:'Max\:%5.0lf %%'",
        "GPRINT:plpor:AVERAGE:'Average\:%5.0lf %%'",
        "GPRINT:plpor:LAST:'Last\:%5.0lf %%\\n'",

	"AREA:inputbits#00CC00:Inbound",
        "LINE2:outputbits#0000FF:'Outbound $flip_legend'"
    );

    $opts_header[] = "--vertical-label='% of Lost Packets'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
