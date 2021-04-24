<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_cisco_mac_bytes ($data) { 

    if ($data["flipinout"]==1) { 
	$opts_DEF = rrdtool_get_def($data,array(output=>"input",input=>"output"));
	$flip_legend = "   (In / Out Flipped)";
    } else
	$opts_DEF = rrdtool_get_def($data,array("input","output"));
    
    $opts_GRAPH = array( 		    

	"CDEF:inputbits=input,UN,0,input,IF,8,*",
	"CDEF:outputbits=output,UN,0,output,IF,8,*",

        "COMMENT:'".$data["description"].", IP Address: ".$data["address"]." on ".substr($data["interface"],0,strpos($data["interface"],":"))."\\n'",

        "AREA:inputbits#00CC00:'Inbound  '",
        "GPRINT:inputbits:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:inputbits:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:inputbits:LAST:'Last\:%8.2lf %sbps$flip_legend\\n'",

        "LINE2:outputbits#0000FF:'Outbound '",
        "GPRINT:outputbits:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:outputbits:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:outputbits:LAST:'Last\:%8.2lf %sbps'"
    );

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
