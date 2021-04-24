<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Values comes as a reference to real data

    function handler_rrd_ds ($name, $value) {
	if ($value["auto_max"]==1) $value["max"]="<".$value["max_field"].">";
	if (empty($value["min"])) $value["min"] = 0;

	$value = "DS:$name:".$value["type"].":600:".$value["min"].":".$value["max"];
    }

?>
