<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_traffic_words ($data) { 

    $opts_DEF = rrdtool_get_def($data,array('rx_words','tx_words'));
    $opts_DEF[] = 'CDEF:inputbits=rx_words,UN,rx_words,rx_words,IF,32,*';
    $opts_DEF[] = 'CDEF:outputbits=tx_words,UN,tx_words,tx_words,IF,32,*';

    $opts_GRAPH = array( 		    
	"AREA:inputbits#00CC00:'Inbound '",
    	"GPRINT:inputbits:MAX:'Max\:%8.2lf %sbps'",
    	"GPRINT:inputbits:AVERAGE:'Average\:%8.2lf %sbps'",
    	"GPRINT:inputbits:LAST:'Last\:%8.2lf %sbps \\n'",

	"LINE2:outputbits#0000FF:Outbound",
    	"GPRINT:outputbits:MAX:'Max\:%8.2lf %sbps'",
    	"GPRINT:outputbits:AVERAGE:'Average\:%8.2lf %sbps'",
    	"GPRINT:outputbits:LAST:'Last\:%8.2lf %sbps'",
    );

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
