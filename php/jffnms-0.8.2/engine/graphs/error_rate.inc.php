<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Errors by Packets

function graph_error_rate ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("inpackets","outpackets",inputerr=>"inputerrors",outputerr=>"outputerrors"));

    $opts_GRAPH = array( 		    
        "CDEF:input=inputerr,100,*,inpackets,inputerr,+,/",
        "CDEF:output=outputerr,100,*,outpackets,outputerr,+,/",

        "AREA:input#00CC00:'Input  Errors'",
	"GPRINT:input:MAX:'Max\: %8.4lf %s%%'",
        "GPRINT:input:AVERAGE:'Average\: %8.4lf %s%%'",
        "GPRINT:input:LAST:'Last\: %8.4lf %s%%\\n'",

	"LINE2:output#0000FF:'Output Errors'",
        "GPRINT:output:MAX:'Max\: %8.4lf %s%%'",
        "GPRINT:output:AVERAGE:'Average\: %8.4lf %s%%'",
        "GPRINT:output:LAST:'Last\: %8.4lf %s%%'" 
    );

    $opts_header[] = "--vertical-label='Errors by Packets Rate'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}
?>
