<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//Apache 2.0.x Example
//Total Accesses: 2739
//Total kBytes: 11439
//CPULoad: .0303957
//Uptime: 403478
//ReqPerSec: .00678847
//BytesPerSec: 29.0314
//BytesPerReq: 4276.57
//BusyWorkers: 1
//IdleWorkers: 9


//Apache 1.3 Example
//Total Accesses: 46283
//Total kBytes: 2886996
//CPULoad: 1.35633
//Uptime: 8276
//ReqPerSec: 5.59244
//BytesPerSec: 357212
//BytesPerReq: 63874.1
//BusyServers: 44
//IdleServers: 21

    function poller_apache ($options) {

	$raw_data = file ("http://".$options["ip_port"]."/server-status?auto");

	foreach ($raw_data as $line) {
	    $pos = strpos($line, ":");
	    $field = str_replace(" ","",substr($line,0,$pos));
	    $value = substr($line, $pos+2, strlen($line));
	    $values[$field]=round(trim("0".$value),3);
	}
	
	//Fix for Apache 1.3.x, that calls the Workers, Servers
	if (isset($values["BusyServers"])) $values["BusyWorkers"] = $values["BusyServers"];
	if (isset($values["IdleServers"])) $values["IdleWorkers"] = $values["IdleServers"];
	
	return 
	    $values["TotalAccesses"]."|".$values["TotalkBytes"]."|".$values["CPULoad"]."|".$values["Uptime"]."|".
	    $values["BytesPerReq"]."|".$values["BusyWorkers"]."|".$values["IdleWorkers"];
    }
?>
