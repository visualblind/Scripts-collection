<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (count($items) > 0) {
	$graphviz.="\n $graphviz_hosts $graphviz_nodes \n $graphviz_cnx";
	$graphviz.="}\n"; 
	
	$graphviz_filename = uniqid("");
        $graphviz_name = "$images_real_path/$graphviz_filename";
	$graphviz_file = fopen($graphviz_name.".dot","w+");	
	fwrite($graphviz_file,$graphviz,strlen($graphviz));
	fclose($graphviz_file);

	$graphviz_exec = "$neato_executable -Timap -o $graphviz_name.map $graphviz_name.dot";
	$result_exec = exec($graphviz_exec);

	//echo "<PRE>".join(" ",file("$graphviz_name.dot"))."</PRE>";
	
	$graphviz_exec = "$neato_executable -Tpng -o $graphviz_name.png $graphviz_name.dot";
	//echo $graphviz_exec;
	$result_exec = exec($graphviz_exec);
	$map_html = "<td align='center'><a target=\"events\" href=\"$images_rel_path/$graphviz_filename.map\"><img src=\"$images_rel_path/$graphviz_filename.png\" border=0 ISMAP></a></td>\n";
        echo $map_html;	
    }
?>
