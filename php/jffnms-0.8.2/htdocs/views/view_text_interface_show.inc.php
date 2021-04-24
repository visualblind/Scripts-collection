<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (($id > 1) && ($host > 1)) {
	$interfaces_shown++;

	include(call_source($view_type)); //source and view private code

	$text = str_pad(strtoupper($alarm_name),12," ",STR_PAD_BOTH)."\t".$item_text;

	if (is_array($urls))
	foreach ($urls as $frame=>$aux_data) {
	    list ($url_name, $url) = $aux_data;
	    
	    if ($frame=="map") $frame = "_parent";
	    
	    $text  .= "\t".str_replace("\t","",str_replace("\n","",linktext($url_name, $url, $frame)));
	}

	$text .= "\n";

	echo $text;
    }
?>
