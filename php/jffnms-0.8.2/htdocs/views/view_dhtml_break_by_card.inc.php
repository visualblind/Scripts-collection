<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($db_break_by_card) 
	$text_to_show = array("Card",$card);
    else
	$text_to_show = array($card);

    $urls = array();
    if ($have_graph==1) $urls["map"] = array("Performance","view_performance.php?type_id=$type_id&host_id=$host_id","graph.png");
?>
