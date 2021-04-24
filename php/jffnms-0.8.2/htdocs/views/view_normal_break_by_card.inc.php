<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($db_break_by_card) 
	ImageStringCenter ($im, $text_color, 0, array("Card",$card),$big_graph);
    else
	ImageStringCenter ($im, $text_color, 0, $card ,$big_graph);
    
    $card_filename = $card; //fix the card name to use in a filename
    $card_filename = str_replace(" ","_",$card_filename);
    $card_filename = str_replace("/","_",$card_filename);

    $filename = "c".$card_filename."-$big_graph.png";

    if ($have_graph==1)
	$url = "javascript:ir_url('','view_performance.php?type_id=$type_id&host_id=$host_id')";
    else
	unset ($url);

    unset ($card_filename);
?>
