<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_tcpmib_connections ($data) { 

    $opts_DEF = rrdtool_get_def($data,array(a=>"tcp_active",p=>"tcp_passive",e=>"tcp_established"));

    $opts_GRAPH = array(   
	"CDEF:tcp_established=e,300,*",
	"CDEF:tcp_active=a,300,*",
	"CDEF:tcp_passive=p,300,*",
		    
        "AREA:tcp_established#00CC00:'Established Connections          '",
        "GPRINT:tcp_established:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tcp_established:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tcp_established:LAST:'Last\:%8.0lf %s\\n'",

        "LINE2:tcp_active#0000FF:'Outgoing Connection Attempts     '",
        "GPRINT:tcp_active:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tcp_active:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tcp_active:LAST:'Last\:%8.0lf %s\\n'",

        "LINE2:tcp_passive#FF0000:'Incoming Connection Attempts     '",
        "GPRINT:tcp_passive:MAX:'Max\:%8.0lf %s'",
        "GPRINT:tcp_passive:AVERAGE:'Average\:%8.0lf %s'",
        "GPRINT:tcp_passive:LAST:'Last\:%8.0lf %s'"
    );

    $opts_header[] = "--vertical-label='TCP Connections Status'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>