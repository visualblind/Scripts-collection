<?
/* HostMIB Sensors Value Graph. This file is part of JFFNMS.
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function graph_sensor_value ($data) { 
    
	$def = rrdtool_get_def($data, "value");
	
	switch (true) {
	
	    case (strpos($data["interface"],"temp")!==false):
		
		$far = (isset($data["show_celcius"]) && ($data["show_celcius"]==0))?1:0;
		
		$graph = array (
    		    "CDEF:temperature=value,".(($far==1)?"1.8,*,32,+":"1,*"),
    		    "AREA:temperature#DD0000:'Temperature in degrees ".(($far==1)?"Fahrenheit":"Celcius")."\:'",
    		    "GPRINT:temperature:MAX:'Max\:%5.2lf'",
    		    "GPRINT:temperature:AVERAGE:'Average\:%5.2lf'",
    		    "GPRINT:temperature:LAST:'Last\:%5.2lf \\n'"
		    );

		$label = "Temperature";
	    break;

	    case (strpos($data["interface"],"in")!==false):
		
		$graph = array (
    		    "AREA:value#0000DD:'Voltage\:'",
    		    "GPRINT:value:MAX:'Max\:%5.2lf %sV'",
    		    "GPRINT:value:AVERAGE:'Average\:%5.2lf %sV'",
    		    "GPRINT:value:LAST:'Last\:%5.2lf %sV\\n'"
		    );

		$label = "Voltage";
	    break;

	    case (strpos($data["interface"],"fan")!==false):
		
		$graph = array (
    		    "AREA:value#00DD00:'RPM\:'",
    		    "GPRINT:value:MAX:'Max\:%5.2lf rpm'",
    		    "GPRINT:value:AVERAGE:'Average\:%5.2lf rpm'",
    		    "GPRINT:value:LAST:'Last\:%5.2lf rpm\\n'"
		    );

		$label = "RPM";
	    break;


	    default:
		// Should we have a Default Case?
	    break;
	}
	
	return array (
	    array("--vertical-label='".$label."'"),
	    @array_merge($def, $graph)
	);
    }

?>
