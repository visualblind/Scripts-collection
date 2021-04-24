<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function graph_sql_records ($data) { 
    
	$ds = "records_".(($data["absolute"]==1)?"absolute":"counter");

	$opts_DEF = rrdtool_get_def($data,array($ds));
	
	$opts_GRAPH = array(
	    (is_numeric($data["max_records"])?"HRULE:".$data["max_records"]."#FF0000:'Max Records\: ".$data["max_records"]." records'":""),
	    (is_numeric($data["min_records"])?"HRULE:".$data["min_records"]."#22FF22:'Min Records\: ".$data["min_records"]." records'":""),

	    "LINE3:".$ds."#000066:'Current Records\: '",
    	    "GPRINT:".$ds.":LAST:'%8.2lf %s\\n'",
	);

	$opts_header[] = "--vertical-label='Records'";
	if (is_numeric($data["max_records"])) $opts_header[] = "--upper-limit=".round($data["max_records"]*1.2);
	if (is_numeric($data["min_records"])) $opts_header[] = "--lower-limit=".round($data["min_records"]*0.8);

	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));    
    }
?>
