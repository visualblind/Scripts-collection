<?
/* IPTables Bytes/Packets Graph. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_iptables_rate ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("bytes"=>"ipt_bytes","packets"=>"ipt_packets"));

    $opts_DEF["bits"]="CDEF:bits=bytes,UN,bytes,bytes,IF,8,*";
    
    $opts_GRAPH = array(
	"AREA:bits#00CC00:'Rate   '",
    	"GPRINT:bits:MAX:'Max\:%8.2lf %sbps'",
    	"GPRINT:bits:AVERAGE:'Average\:%8.2lf %sbps'",
    	"GPRINT:bits:LAST:'Last\:%8.2lf %sbps\\n'",

	"LINE2:packets#0000FF:Packets",
    	"GPRINT:packets:MAX:'Max\:%8.0lf %spps'",
    	"GPRINT:packets:AVERAGE:'Average\:%8.0lf %spps'",
    	"GPRINT:packets:LAST:'Last\:%8.0lf %spps'",
	);

    $opts_header[] = "--vertical-label='Bits per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
