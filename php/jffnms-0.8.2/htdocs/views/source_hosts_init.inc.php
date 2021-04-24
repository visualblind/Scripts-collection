<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $sizex *= 1.3;
    $sizey *= 1.43;

    $sizex += 5;

    if ($sizex > 0)
	$cols_max=round(($screen_size/$sizex));

    $cols_count=$cols_max;

    $break_by_zone = 0;
    $break_by_host = 0;
    $break_by_card = 0;

    $permit_host_modification = profile("ADMIN_HOSTS");

?>
