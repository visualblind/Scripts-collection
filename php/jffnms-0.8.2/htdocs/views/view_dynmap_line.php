<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $im =imagecreate($totalx,$totaly);
    $cRed=ImageColorAllocate($im,255,0,0);
    ImageColorTransparent($im,$cRed);
    $cBlack=ImageColorAllocate($im,0,0,0);

    foreach ($con as $aux) {
	list ($x1,$y1,$x2,$y2) = explode (",",$aux); 
	ImageLine($im,$x1,$y1,$x2,$y2,$cBlack);  
    }
    
    Header("Content-type: image/png"); 
    ImagePNG($im);
?>
