<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    // Load Average Graph, UCD-SNMP 

    function graph_ucd_load_average ($data) { 

	$opts_DEF = rrdtool_get_def($data,array("load_average_1","load_average_5","load_average_15"));
         
        $opts_GRAPH = array( 
                "CDEF:la_1=load_average_1,UN,0,load_average_1,IF", 
                "CDEF:la_5=load_average_5,UN,0,load_average_5,IF", 
                "CDEF:la_15=load_average_15,UN,0,load_average_15,IF", 
                         
                "LINE1:load_average_1#FF0000:' 1 Minute  Load Average'", 
                "GPRINT:load_average_1:MAX:'Max\: %5.2lf'", 
                "GPRINT:load_average_1:AVERAGE:'Average\: %5.2lf'", 
                "GPRINT:load_average_1:LAST:'Last\: %5.2lf\\n'", 

                "LINE2:load_average_5#0000FF:' 5 Minutes Load Average'", 
                "GPRINT:load_average_5:MAX:'Max\: %5.2lf'", 
                "GPRINT:load_average_5:AVERAGE:'Average\: %5.2lf'", 
                "GPRINT:load_average_5:LAST:'Last\: %5.2lf\\n'", 
                        
                "LINE2:load_average_15#00CC00:'15 Minutes Load Average'", 
                "GPRINT:load_average_15:MAX:'Max\: %5.2lf'", 
                "GPRINT:load_average_15:AVERAGE:'Average\: %5.2lf'", 
                "GPRINT:load_average_15:LAST:'Last\: %5.2lf\\n'"); 


        $opts_header[] = "--vertical-label='Load Average'"; 
         
        return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));     
    } 
?> 
