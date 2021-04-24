<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($filename) { 
        ImagePng ($im,"$images_real_path/$filename");
	ImageDestroy($im);	

	echo td (linktext(image("$images_rel_path/$filename",$sizex,$sizey),$url));
    }
?>
