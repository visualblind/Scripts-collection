<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($id > 1) {  
	$interfaces_shown++;

	$graphviz_nodes .="\tI$id\t[shape=box,fillcolor=\"#$bgcolor\",fontcolor=\"#$fgcolor\",style=filled,label=\"$int\",URL=\"".str_replace(" ","+",$jffnms_rel_path."/".$urls["events"][1])."\"];\n";
	if ($source=="interfaces") 
	    $graphviz_cnx .="\tH$host -- I$id \t;\n";
    }
?>
