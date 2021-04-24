<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //it takes all the interfaces on ID and makes an aggregated graph

function graph_packets_aggregation ($data) { 
    $opts_agg = array();

    $str_cdef_in = "CDEF:inputpackets=0,";	    	
    $str_cdef_out = "CDEF:outputpackets=0,";	    	

    foreach ($data[id] as $id) {
	$interface=$data[$id];

	$opts_agg = @array_merge ($opts_agg,rrdtool_get_def($interface,array("input$id"=>"inpackets","output$id"=>"outpackets")));

	$str_cdef_in  .="input$id,UN,0,input$id,IF,+,";	    	
	$str_cdef_out .="output$id,UN,0,output$id,IF,+,";	    	
    }
    
    $opts_agg[] = $str_cdef_in;
    $opts_agg[] = $str_cdef_out;

    $opts_GRAPH = array( 		    

	"AREA:inputpackets#00CC00:'Inbound '",
    	"GPRINT:inputpackets:MAX:'Max\:%8.2lf %sPps'",
    	"GPRINT:inputpackets:AVERAGE:'Average\:%8.2lf %sPps'",
    	"GPRINT:inputpackets:LAST:'Last\:%8.2lf %sPps\\n'",
    
	"LINE2:outputpackets#0000FF:Outbound",
        "GPRINT:outputpackets:MAX:'Max\:%8.2lf %sPps'",
        "GPRINT:outputpackets:AVERAGE:'Average\:%8.2lf %sPps'",
        "GPRINT:outputpackets:LAST:'Last\:%8.2lf %sPps'"
    );

    $opts_header[] = "--vertical-label='Packets per Second'";

    return array ($opts_header, @array_merge($opts_agg,$opts_GRAPH));    
}
?>
