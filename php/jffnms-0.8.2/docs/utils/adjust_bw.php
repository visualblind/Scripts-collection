<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
include ("../../conf/config.php");

$interfaces = interfaces_list();

foreach ($interfaces as $int){
    echo $int[id]." - ".$int[bandwidthin]." - ".$int[bandwidthout];
    if ($int[bandwidthin] > 2) 
	$result = interface_adjust_rrd($int[id],$int[bandwidthin],$int[bandwidthout]);
    echo "Result $result\n";
}
?>