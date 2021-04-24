<?
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_octets ($data) { 
	
    $opts_DEF = rrdtool_get_def($data,'octets');
    $opts_DEF['bits']='CDEF:bits=octets,UN,octets,octets,IF,8,*';

    $opts_GRAPH = array(
        "AREA:bits#00CC00:'Traffic '",
	"GPRINT:bits:MAX:'Max\:%8.2lf %sbps'",
	"GPRINT:bits:AVERAGE:'Average\:%8.2lf %sbps'",
	"GPRINT:bits:LAST:'Last\:%8.2lf %sbps'",
    );

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));    
}
?>
