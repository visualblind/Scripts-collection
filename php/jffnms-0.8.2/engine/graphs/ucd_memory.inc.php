<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    // Real Memory, UCD-SNMP 

    function graph_ucd_memory ($data) { 

	$opts_DEF = rrdtool_get_def($data,array(
						mem_free_b=>"mem_available",
						mem_total_b=>"mem_total",
						swap_free_b=>"swap_available",
						swap_total_b=>"swap_total"));

        $opts_GRAPH = array( 
                "CDEF:mem_free=mem_free_b,1024,*", 
                "CDEF:mem_total=mem_total_b,1024,*", 
                "CDEF:swap_free=swap_free_b,1024,*", 
                "CDEF:swap_total=swap_total_b,1024,*",
		 
                "CDEF:mem_used=mem_total,mem_free,-", 
                "CDEF:swap_used=swap_total,swap_free,-", 
                    
                "CDEF:mem_free_p=mem_free,100,*,mem_total,/", 
                "CDEF:mem_used_p=mem_used,100,*,mem_total,/",                                  
                    
                "CDEF:swap_free_p=swap_free,100,*,swap_total,/", 
                "CDEF:swap_used_p=swap_used,100,*,swap_total,/", 

                "LINE3:mem_total#FF0000:'Total Memory\:   '", 
                "GPRINT:mem_total:MAX:'%6.2lf %sB\\n'", 

                "LINE3:swap_total#AA0000:'Total Swap\:     '", 
                "GPRINT:swap_total:MAX:'%6.2lf %sB\\n'", 
                 
                "AREA:mem_used#FF8800:'Used Memory'", 
                "GPRINT:mem_used:MAX:'Max\: %6.2lf %sB'", 
                "GPRINT:mem_used_p:MAX:'(%3.0lf %%)'", 
                "GPRINT:mem_used:AVERAGE:'Average\: %6.2lf %sB'", 
                "GPRINT:mem_used_p:AVERAGE:'(%3.0lf %%)'", 
                "GPRINT:mem_used:LAST:'Last\: %6.2lf %sB'", 
                "GPRINT:mem_used_p:LAST:'(%3.0lf %%)\\n'", 

                "STACK:swap_used#FFDD00:'Used Swap  '", 
                "GPRINT:swap_used:MAX:'Max\: %6.2lf %sB'", 
                "GPRINT:swap_used_p:MAX:'(%3.0lf %%)'", 
                "GPRINT:swap_used:AVERAGE:'Average\: %6.2lf %sB'", 
                "GPRINT:swap_used_p:AVERAGE:'(%3.0lf %%)'", 
                "GPRINT:swap_used:LAST:'Last\: %6.2lf %sB'", 
                "GPRINT:swap_used_p:LAST:'(%3.0lf %%)\\n'", 
        
                "STACK:mem_free#00CC00:'Free Memory'", 
                "GPRINT:mem_free:MAX:'Max\: %6.2lf %sB'", 
                "GPRINT:mem_free_p:MAX:'(%3.0lf %%)'", 
                "GPRINT:mem_free:AVERAGE:'Average\: %6.2lf %sB'", 
                "GPRINT:mem_free_p:AVERAGE:'(%3.0lf %%)'", 
                "GPRINT:mem_free:LAST:'Last\: %6.2lf %sB'", 
                "GPRINT:mem_free_p:LAST:'(%3.0lf %%)\\n'",

                "STACK:swap_free#00EE00:'Free Swap  '", 
                "GPRINT:swap_free:MAX:'Max\: %6.2lf %sB'", 
                "GPRINT:swap_free_p:MAX:'(%3.0lf %%)'", 
                "GPRINT:swap_free:AVERAGE:'Average\: %6.2lf %sB'", 
                "GPRINT:swap_free_p:AVERAGE:'(%3.0lf %%)'", 
                "GPRINT:swap_free:LAST:'Last\: %6.2lf %sB'", 
                "GPRINT:swap_free_p:LAST:'(%3.0lf %%)\\n'"
	); 

        $opts_header[] = "--vertical-label='Used Memory'"; 

        return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH)); 
    } 
?> 
