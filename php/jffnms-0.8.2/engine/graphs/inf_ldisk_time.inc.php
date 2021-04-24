<?
/* SNMP Informant lDisk Percent Time Graph. This file is part of JFFNMS.
 * Copyright (C) <2005> David LIMA <dlima@fr.scc.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
*/

   function graph_inf_ldisk_time ($data) {

	$opts_DEF = rrdtool_get_def($data,array("read_time"=>"inf_d_read_time","write_time"=>"inf_d_write_time"));
    
    	$opts_GRAPH = array(
	
	    "CDEF:idle_time=100,read_time,-,write_time,-",

	    "AREA:read_time#0000CC:'Disk Read  Time'",
    	    "GPRINT:read_time:MAX:'Max\: %6.2lf %%'",
    	    "GPRINT:read_time:AVERAGE:'Average\: %6.2lf %%'",
    	    "GPRINT:read_time:LAST:'Last\: %6.2lf %% \\n'",

	    "STACK:write_time#FF0000:'Disk Write Time'",
    	    "GPRINT:write_time:MAX:'Max\: %6.2lf %%'",
    	    "GPRINT:write_time:AVERAGE:'Average\: %6.2lf %%'",
    	    "GPRINT:write_time:LAST:'Last\: %6.2lf %% \\n'",

	    "STACK:idle_time#00CC00:'Disk Idle  Time'",
    	    "GPRINT:idle_time:MAX:'Max\: %6.2lf %%'",
    	    "GPRINT:idle_time:AVERAGE:'Average\: %6.2lf %%'",
    	    "GPRINT:idle_time:LAST:'Last\: %6.2lf %% \\n'"
	);

	$opts_header[] = "--vertical-label='Disk Time Usage'";
	$opts_header[] = "--rigid";

	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
    }

?>
