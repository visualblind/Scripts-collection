<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_traffic_util ($data) { 

    if ($data["flipinout"]==1) {
	$opts_DEF = rrdtool_get_def($data,array(output=>"input",input=>"output"));
	$flip_legend = "     (In / Out Flipped)";
    } else 
	$opts_DEF = rrdtool_get_def($data,array("input","output"));

    $opts_GRAPH = array( 		    
        "CDEF:inputbits=input,UN,0,input,IF,8,*",
        "CDEF:outputbits=output,UN,0,output,IF,8,*",	
        "HRULE:100#FF0000:"
    );
    
    if ($data["bandwidthin"] > 0)
	$opts_GRAPH = array_merge($opts_GRAPH,array(
    	    "CDEF:input1=inputbits,100,*,".  $data["bandwidthin"]. ",/",

	    "AREA:input1#00CC00:'Input Utilization '",
	    "GPRINT:input1:MAX:'Max\:%8.2lf %%'",
	    "GPRINT:input1:AVERAGE:'Average\:%8.2lf %%'",
	    "GPRINT:input1:LAST:'Last\:%8.2lf %%$flip_legend\\n'",
	));

    if ($data["bandwidthout"] > 0)
	$opts_GRAPH = array_merge($opts_GRAPH,array(
    	    "CDEF:output1=outputbits,100,*,".$data["bandwidthout"].",/",
        
	    "LINE2:output1#0000FF:'Output Utilization'",
    	    "GPRINT:output1:MAX:'Max\:%8.2lf %%'",
    	    "GPRINT:output1:AVERAGE:'Average\:%8.2lf %%'",
    	    "GPRINT:output1:LAST:'Last\:%8.2lf %%'" 
	));

    $opts_header[] = "--vertical-label='Utilization %'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
