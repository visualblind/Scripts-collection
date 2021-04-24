<?
/* HOSTMIB Software Running Poller. This file is part of JFFNMS
 * Copyright (C) <2004> Anders Karlsson <anders.x.karlsson@songnetworks.se>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function poller_hostmib_apps ($options) {
	global $Apps;

	$oid = ".1.3.6.1.2.1.25.4.2.1.2"; //host.hrSWRun.hrSWRunTable.hrSWRunEntry.hrSWRunName
	$host_id = $options["host_id"];

        $i=0;
        while (!is_array($Apps[$host_id]) && ($i++ <= 2) && ($options["ro_community"])) //try 3 times to get the data 
	    $Apps[$host_id]["raw"] = snmp_walk($options["host_ip"],$options["ro_community"],$oid,1);
	
	if (is_array($Apps[$host_id]["raw"])) { //if we got something

    	    $instances=0;
    	    foreach ($Apps[$host_id]["raw"] as $key=>$service) { //go thru all 
	        
		$interface_in = trim(str_replace('"','',trim($service)));
		
	        if ( $interface_in == $options["interface"] ) { //until we find the interface we're looking for
        	    $instances++;
		
		    $pid = end(explode(".",$key));
		    $Apps[$host_id]["pids"][$interface_in][]=$pid;
		}	
	    }
	    
            $value="not running";
            if ( $instances > 0 ) 
		$value="running;$instances Instance(s)|$instances";
	    
	    return $value;
	}
    }
?>
