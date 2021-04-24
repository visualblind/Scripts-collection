<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $im = @ImageCreate ($sizex, $sizey) or die ("Cannot Initialize new GD image stream");
    $background_color = ImageColorAllocate ($im, 150 ,150, 150);
    $text_color = ImageColorAllocate ($im, 255, 255, 255);
    $filename = "";
?>
