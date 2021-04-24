<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Accounting Bytes

function graph_acct_bytes ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(input=>"acct_bytes"));

    $opts_DEF[inputbits]="CDEF:inputbits=input,UN,input,input,IF,8,*";

    $opts_GRAPH = array( 		    
	"AREA:inputbits#00CC00:'Accounting Traffic (probably Outbound)\\n'",
    	"GPRINT:inputbits:MAX:'Max\:%6.2lf %sbps'",
    	"GPRINT:inputbits:AVERAGE:'Average\:%6.2lf %sbps'",
    	"GPRINT:inputbits:LAST:'Last\:%6.2lf %sbps'"
	);

    $opts_header[] = "--vertical-label='Accounting Traffic per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
