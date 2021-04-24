<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    // Solaris CPU Graph, UCD-SNMP 

    function graph_ucd_cpu_solaris ($data) { 

	$opts_DEF = rrdtool_get_def($data,array("cpu_user_ticks","cpu_idle_ticks","cpu_wait_ticks","cpu_kernel_ticks"));
         
        $opts_GRAPH = array(   
                "CDEF:user_ticks=cpu_user_ticks,UN,0,cpu_user_ticks,IF", 
                "CDEF:idle_ticks=cpu_idle_ticks,UN,0,cpu_idle_ticks,IF", 
                "CDEF:wait_ticks=cpu_wait_ticks,UN,0,cpu_wait_ticks,IF", 
                "CDEF:kernel_ticks=cpu_kernel_ticks,UN,0,cpu_kernel_ticks,IF", 

    		"HRULE:".($data["cpu_num"]*100)."#990000:'Number of Processors\: ".$options["cpu_num"]."\\n'",
                         
                "AREA:user_ticks#FF0000:'User   CPU Time'", 
                "GPRINT:user_ticks:MAX:'Max\:%8.2lf %%'", 
                "GPRINT:user_ticks:AVERAGE:'Average\:%8.2lf %%'", 
                "GPRINT:user_ticks:LAST:'Last\:%8.2lf %%\\n'", 

                "STACK:wait_ticks#0000FF:'Wait   CPU Time'", 
                "GPRINT:wait_ticks:MAX:'Max\:%8.2lf %%'", 
                "GPRINT:wait_ticks:AVERAGE:'Average\:%8.2lf %%'", 
                "GPRINT:wait_ticks:LAST:'Last\:%8.2lf %%\\n'", 

                "STACK:kernel_ticks#FFFF00:'Kernel CPU Time'", 
                "GPRINT:kernel_ticks:MAX:'Max\:%8.2lf %%'", 
                "GPRINT:kernel_ticks:AVERAGE:'Average\:%8.2lf %%'", 
                "GPRINT:kernel_ticks:LAST:'Last\:%8.2lf %%\\n'", 
                
                "STACK:idle_ticks#00CC00:'Idle   CPU Time'", 
                "GPRINT:idle_ticks:MAX:'Max\:%8.2lf %%'", 
                "GPRINT:idle_ticks:AVERAGE:'Average\:%8.2lf %%'", 
                "GPRINT:idle_ticks:LAST:'Last\:%8.2lf %%\\n'"); 

        $opts_header[] = "--vertical-label='CPU Usage'"; 
         
        return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));     
    }       
?> 
