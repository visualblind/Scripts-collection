<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function graph_packets_new ($data) { 

    $opts_DEF = rrdtool_get_def($data,array("inpackets","outpackets","inputerrors","outputerrors"));

    $opts_GRAPH = array(    
	//Sanitize the 4 DS's
	"CDEF:input=inpackets,UN,0,inpackets,IF",
	"CDEF:output=outpackets,UN,0,outpackets,IF",

	"CDEF:inputerr=inputerrors,UN,0,inputerrors,IF",
	"CDEF:outputerr=outputerrors,UN,0,outputerrors,IF",

	//This is to get the output as negative
	"CDEF:outputrev=output,-1,*",
	
	//Total packets = valid packets + error packets
	"CDEF:totin=input,inputerr,+",
	"CDEF:totout=output,outputerr,+",

	//Input packts % of the total packtes
	"CDEF:inpct1=input,100,*,totin,/",
	"CDEF:outpct1=output,100,*,totout,/",

	// In case tot is 0, then % is 100%
	"CDEF:inpct=inpct1,UN,100,inpct1,IF",
	"CDEF:outpct=outpct1,UN,100,outpct1,IF",

	//Errors pkts % of the total packtes limited from 0.01% to 100%
	"CDEF:ierrpct1=inputerr,100,*,totin,/,0.01,100,LIMIT",
	"CDEF:oerrpct1=outputerr,100,*,totout,/,0.01,100,LIMIT",
	
	// In case tot is 0, then 0% errors
	"CDEF:ierrpct=ierrpct1,UN,0,ierrpct1,IF",
	"CDEF:oerrpct=oerrpct1,UN,0,oerrpct1,IF",

        "AREA:input#00CC00:'Input Packets '",
        "GPRINT:input:MAX:'Max\: %6.2lf %sPps'",
	"GPRINT:inpct:MAX:'(%6.2lf%%)'",

	"GPRINT:input:AVERAGE:'Average\: %6.2lf %sPps'",
	"GPRINT:inpct:AVERAGE:'(%6.2lf%%)'",

	"GPRINT:input:LAST:'Last\: %6.2lf %sPps'",
	"GPRINT:inpct:LAST:'(%6.2lf%%)\\n'",

	"STACK:ierrpct#FF0000:'Input Errors  '",
	"GPRINT:inputerr:MAX:'Max\: %6.2lf %sPps'",
	"GPRINT:ierrpct:MAX:'(%6.2lf%%)'",

	"GPRINT:inputerr:AVERAGE:'Average\: %6.2lf %sPps'",
	"GPRINT:ierrpct:AVERAGE:'(%6.2lf%%)'",

	"GPRINT:inputerr:LAST:'Last\: %6.2lf %sPps'",
	"GPRINT:ierrpct:AVERAGE:'(%6.2lf%%)\\n'",

	"COMMENT:'\\n'",

	"AREA:outputrev#0000FF:'Output Packets'",
	"GPRINT:output:MAX:'Max\: %6.2lf %sPps'",
	"GPRINT:outpct:MAX:'(%6.2lf%%)'",

	"GPRINT:output:AVERAGE:'Average\: %6.2lf %sPps'",
	"GPRINT:outpct:AVERAGE:'(%6.2lf%%)'",

	"GPRINT:output:LAST:'Last\: %6.2lf %sPps'",
	"GPRINT:outpct:LAST:'(%6.2lf%%)\\n'",

	"STACK:oerrpct#AA0000:'Output Errors '",
	"GPRINT:outputerr:MAX:'Max\: %6.2lf %sPps'",
	"GPRINT:oerrpct:MAX:'(%6.2lf%%)'",

	"GPRINT:outputerr:AVERAGE:'Average\: %6.2lf %sPps'",
	"GPRINT:oerrpct:AVERAGE:'(%6.2lf%%)'",

	"GPRINT:outputerr:LAST:'Last\: %6.2lf %sPps'",
	"GPRINT:oerrpct:AVERAGE:'(%6.2lf%%)\\n'"
    );

    $opts_header[] = "--vertical-label='Packets per Second'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
