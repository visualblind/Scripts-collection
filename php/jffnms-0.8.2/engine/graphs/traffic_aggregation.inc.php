<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //it takes all the interfaces on ID and makes an aggregated graph

function graph_traffic_aggregation ($data) { 
    $opts_agg = array();
    $bandwidth_agg_in=0;
    $bandwidth_agg_out=0;

    $str_cdef_in = "CDEF:input=0,";	    	
    $str_cdef_out = "CDEF:output=0,";	    	

    foreach ($data["id"] as $id) {
	$interface=$data[$id];

	if ($interface["flipinout"]==1) {
	    $opts_agg = @array_merge ($opts_agg,rrdtool_get_def($interface,array("output$id"=>"input","input$id"=>"output")));
	    $flip_legend = " (Some In / Out Flipped)";
	} else 
	    $opts_agg = @array_merge ($opts_agg,rrdtool_get_def($interface,array("input$id"=>"input","output$id"=>"output")));

	$bandwidthin += $interface["bandwidthin"];
	$bandwidthout += $interface["bandwidthout"];

	$str_cdef_in  .="input$id,UN,0,input$id,IF,+,";	    	
	$str_cdef_out .="output$id,UN,0,output$id,IF,+,";	    	
    }
    
    $opts_agg[] = $str_cdef_in;
    $opts_agg[] = $str_cdef_out;
    $bandwidthin_k = $bandwidthin/1000;
    $bandwidthout_k = $bandwidthout/1000;

    $opts_GRAPH = array( 		    
	"CDEF:inputbits=input,UN,0,input,IF,8,*",
	"CDEF:outputbits=output,UN,0,output,IF,8,*",	
	//"CDEF:total_inputbits=inputbits,UN,0,inputbits,IF,300,*,PREV,UN,0,PREV,IF,+",
	//"CDEF:total_outputbits=outputbits,UN,0,outputbits,IF,300,*,PREV,UN,0,PREV,IF,+",

	"HRULE:$bandwidthin#FF0000:' '",
	"COMMENT:'Inbound Bandwidth: $bandwidthin_k kbps'",     
	"HRULE:$bandwidthout#AA0000:' '",
	"COMMENT:'Outbound Bandwidth: $bandwidthout_k kbps\\n'",     

	(!empty($flip_comment))?"COMMENT:'$flip_legend\\n'":"",
	"AREA:inputbits#00CC00:'Inbound '",
    	"GPRINT:inputbits:MAX:'Max\:%8.2lf %sbps'",
    	"GPRINT:inputbits:AVERAGE:'Average\:%8.2lf %sbps'",
    	"GPRINT:inputbits:LAST:'Last\:%8.2lf %sbps\\n'",
	//"GPRINT:total_inputbits:MAX:'Total\:%8.2lf %sbps\\n'",

	"LINE2:outputbits#0000FF:Outbound",
        "GPRINT:outputbits:MAX:'Max\:%8.2lf %sbps'",
        "GPRINT:outputbits:AVERAGE:'Average\:%8.2lf %sbps'",
        "GPRINT:outputbits:LAST:'Last\:%8.2lf %sbps\\n'",
	//"GPRINT:total_outputbits:MAX:'Total\:%8.2lf %sbps'",
    );

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));    
}
?>
