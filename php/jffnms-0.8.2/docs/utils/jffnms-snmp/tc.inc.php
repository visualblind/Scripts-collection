<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function unit_convert (&$value, $unit) {
    switch ($unit) {
	case "Kbit" : $value *= 1000; break;
	case "Mbit" : $value *= 1024 * 1000; break;
    }
}

function tree_tc () {

    $dev = "/proc/net/dev";
    $devices_raw = file($dev);
    unset ($devices_raw[0]);
    unset ($devices_raw[1]);

    $dev_id = 1;
    foreach ($devices_raw as $aux) {
	$dev_name = trim(substr($aux,0,strpos($aux,":")));
	$devices[$dev_id][index]=$dev_id;
	$devices[$dev_id][name]=$dev_name;
	$dev_id++;
    }

    $tc="/sbin/tc";
    
    foreach ($devices as $dev_id=>$aux) {
	unset ($result);
	$dev_name = $aux[name];
	exec("$tc -s class show dev $dev_name",$result);

	$pos = 0;
	foreach ($result as $data) {
	    $data = trim($data);

	    if ($pos==0)
		if (preg_match ("/^class (\S+) (\S+) (?:parent \S+(?: leaf \S+|)(?: prio \d+|)|root(?: prio \d+|)) rate (\d+)(\S+) ceil (\d+)(\S+).+/",$data,$parts)) {
		    $aux = explode (":",$parts[2]);
		    $class_id = $dev_id.str_pad($aux[0],2,"0",STR_PAD_LEFT).str_pad($aux[1],3,"0",STR_PAD_LEFT);
		    unset ($aux);
		
		    $classes[$class_id][index]=$class_id;
		    $classes[$class_id][device]=$dev_id;
		    $classes[$class_id][name]=$parts[2];
		    $classes[$class_id][type]=$parts[1];
		    $classes[$class_id][rate]=$parts[3];
		    $classes[$class_id][ceil]=$parts[5];
		    
		    unit_convert ($classes[$class_id][rate],$parts[4]);
		    unit_convert ($classes[$class_id][ceil],$parts[6]);
		}

	    //Sent 72133756 bytes 250090 pkts (dropped 0, overlimits 0 requeues 0)
	    //Sent 198540532 bytes 822282 pkt (dropped 587, overlimits 0 requeues 0)
	    if ($pos==1) 
		if (is_array($classes[$class_id]) &&
		    preg_match ("/Sent (\d+) bytes (\d+) pkt(?:s*) \(dropped (\d+), overlimits (\d+)/",$data,$parts)) {

		    $classes[$class_id][bytes]=$parts[1]*1;
		    $classes[$class_id][packets]=$parts[2]*1;
		    
		    $classes[$class_id][dropped]=$parts[3];
		    $classes[$class_id][overlimit]=$parts[4];

		    truncate_counter ($classes[$class_id][bytes]);
		    truncate_counter ($classes[$class_id][packets]);
		}
		
	    $pos++;

	    if (empty($data)) $pos = 0;
	}
    }
    $info[devices]=$devices;
    $info[classes]=$classes;

    return $info;
}
?>
