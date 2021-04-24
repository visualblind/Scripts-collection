<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Accounting Packets

function graph_acct_packets ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array(packets=>"acct_packets"));

    $opts_GRAPH = array( 		    
	"AREA:packets#00CC00:'Accounting Packets (Probably Outbound)\\n'",
    	"GPRINT:packets:MAX:'Max\:%6.0lf %s:Pps'",
    	"GPRINT:packets:AVERAGE:'Average\:%6.0lf %sPps'",
    	"GPRINT:packets:LAST:'Last\:%6.0lf %sPps'"
	);

    $opts_header[] = "--vertical-label='Accounting Packets per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
