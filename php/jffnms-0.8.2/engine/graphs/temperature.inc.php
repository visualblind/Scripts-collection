<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Temperature

function graph_temperature ($data) { 
    
    $opts_DEF = rrdtool_get_def($data,array("temp_c"=>"temperature"));
   
    $far = (isset($data["show_celcius"]) && ($data["show_celcius"]==0))?1:0;

    $opts_GRAPH = array(
        "CDEF:temperature=temp_c,".(($far==1)?"1.8,*,32,+":"1,*"),
        "AREA:temperature#FF0000:'Temperature in degrees ".(($far==1)?"Fahrenheit":"Celcius")."\:'",
        "GPRINT:temperature:MAX:'Max\:%5.0lf'",
        "GPRINT:temperature:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:temperature:LAST:'Last\:%5.0lf \\n'"
    );

    $opts_header[] = "--vertical-label='Temperature'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
}

?>
