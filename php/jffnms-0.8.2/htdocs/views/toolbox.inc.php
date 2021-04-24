<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    $toolbox = tag("div", "t".$id,"", "style='position: absolute; visibility: hidden; z-index: 10;'").
	table().tr_open();
    
    foreach ($urls as $frame=>$aux) {
	list ($text,$url,$graph) = $aux;
	$toolbox .= td("&nbsp;".linktext(image($graph,"","",$text),$url,$frame,"","",0,$text));
    }
    
    $toolbox .= tag_close("tr").table_close().tag_close("div");

?>
