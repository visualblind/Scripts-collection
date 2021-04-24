<?php
/* SNMP Informant Disk Graph. This file is part of JFFNMS.
 * Copyright (C) <2005> David LIMA <dlima@fr.scc.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
*/

   function graph_inf_ldisk_rate ($data) {

	$opts_DEF = rrdtool_get_def($data,array("read_rate"=>"inf_d_read_rate","write_rate"=>"inf_d_write_rate"));
    
    	$opts_GRAPH = array(
    	    "CDEF:ldisk_rate_total=read_rate,write_rate,+",
	    "CDEF:write_rate_graph=write_rate,-1,*",

	    "COMMENT:'  Disk Total '",
    	    "GPRINT:ldisk_rate_total:MAX:'Max\:%8.2lf %sBps '",
	    "GPRINT:ldisk_rate_total:AVERAGE:'Average\:%8.2lf %sBps '",
	    "GPRINT:ldisk_rate_total:LAST:'Last\:%8.2lf %sBps \\n'",
	
	    "AREA:read_rate#0000CC:'Disk Reads '",
    	    "GPRINT:read_rate:MAX:'Max\:%8.2lf %sBps '",
    	    "GPRINT:read_rate:AVERAGE:'Average\:%8.2lf %sBps '",
    	    "GPRINT:read_rate:LAST:'Last\:%8.2lf %sBps \\n'",

	    "AREA:write_rate_graph#FF0000:'Disk Writes'",
    	    "GPRINT:write_rate:MAX:'Max\:%8.2lf %sBps '",
    	    "GPRINT:write_rate:AVERAGE:'Average\:%8.2lf %sBps '",
    	    "GPRINT:write_rate:LAST:'Last\:%8.2lf %sBps \\n'"
	);

	$opts_header[] = "--vertical-label='Disk Rate (Bytes per Second)'";

	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
    }

?>
