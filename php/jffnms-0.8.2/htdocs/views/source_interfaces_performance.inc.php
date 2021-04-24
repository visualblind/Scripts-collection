<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $text = substr($int." - ".$shortname,0,20);
    $size_text = strlen ($text)*6;
    imagestring ($im_new, 2, ($new_sizex-$size_text)/2, 0, $text, $text_color);

    include ("source_interfaces_infobox.inc.php");
?>
