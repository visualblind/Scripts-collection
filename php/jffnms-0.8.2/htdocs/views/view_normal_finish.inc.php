<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if (($map_id > 1) && ($source=="interfaces")) { //switch to dynmap if we are using a map (has x,y) and source is interfaces
	$view_type = "dynmap"; 
	include (call_view("init"));
    }
?>
