<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    if ($sizex) {
	$sizex *= 1.3;
	$sizey *= 1.3;

	$cols_max=round(($screen_size/$sizex))-1;
        $cols_count=$cols_max;
    }
    
    $break_by_zone = 0;
    $break_by_host = 0;
    $break_by_card = 0;
?>
