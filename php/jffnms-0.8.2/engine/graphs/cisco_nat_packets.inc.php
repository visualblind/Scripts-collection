<?
/* Cisco NAT Packets. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_cisco_nat_packets ($data) { 

    $result = array_merge(
	rrdtool_get_def($data, array(
	    "icmp_in"    => "cisco_nat_icmp_inbound", 
	    "tcp_in"     => "cisco_nat_tcp_inbound",
	    "udp_in"     => "cisco_nat_udp_inbound",
	    "other_in"   => "cisco_nat_other_ip_inbound",
	    "_icmp_out"  => "cisco_nat_icmp_outbound",
	    "_tcp_out"   => "cisco_nat_tcp_outbound",
    	    "_udp_out"   => "cisco_nat_udp_outbound",
	    "_other_out" => "cisco_nat_other_ip_outbound"
	)),array(

	"CDEF:icmp_out=_icmp_out,-1,*",
	"CDEF:tcp_out=_tcp_out,-1,*",
	"CDEF:udp_out=_udp_out,-1,*",
	"CDEF:other_out=_other_out,-1,*",
	
         
        "LINE2:icmp_in#8D00BA:'+ Inbound  ICMP '", 
        "GPRINT:icmp_in:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:icmp_in:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:icmp_in:LAST:'Last\:%8.2lf %spps \\n'",

        "LINE2:tcp_in#00CC00:'+ Inbound  TCP  '", 
        "GPRINT:tcp_in:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:tcp_in:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:tcp_in:LAST:'Last\:%8.2lf %spps\\n'",

        "LINE2:udp_in#FF0000:'+ Inbound  UDP  '", 
        "GPRINT:udp_in:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:udp_in:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:udp_in:LAST:'Last\:%8.2lf %spps \\n'",

        "LINE2:other_in#0090F0:'+ Inbound  Other'", 
        "GPRINT:other_in:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:other_in:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:other_in:LAST:'Last\:%8.2lf %spps \\n'",
	
	"LINE2:icmp_out#8D00BA:'- Outbound ICMP '", 
        "GPRINT:_icmp_out:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:_icmp_out:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:_icmp_out:LAST:'Last\:%8.2lf %spps \\n'",

        "LINE2:tcp_out#00CC00:'- Outbound TCP  '", 
        "GPRINT:_tcp_out:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:_tcp_out:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:_tcp_out:LAST:'Last\:%8.2lf %spps\\n'",

        "LINE2:udp_out#FF0000:'- Outbound UDP  '", 
        "GPRINT:_udp_out:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:_udp_out:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:_udp_out:LAST:'Last\:%8.2lf %spps \\n'",

        "LINE2:other_out#0090F0:'- Outbound Other'", 
        "GPRINT:_other_out:MAX:'Max\: %8.2lf %spps'", 
        "GPRINT:_other_out:AVERAGE:'Average\:%8.2lf %spps'",
        "GPRINT:_other_out:LAST:'Last\:%8.2lf %spps \\n'"
	
    )); 

    $opts_header[] = "--vertical-label='Packets per Second'"; 

    return array ($opts_header, $result);
}
?>
