<?
/* Cisco Enviorment MIB implementation as part of JFFNMS
 * Copyright (C) <2004> Anders Karlsson <anders.x.karlsson@songnetworks.se>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_cisco_envmib($ip,$community, $host_id, $param) {
         
	$envinfo = Array();
	
        $CiscoEnvMibOid=".1.3.6.1.4.1.9.9.13.1";

        list ($interface_basename, $list_oid, $status_oid) = explode(",",$param);
	$oid_list  = "$CiscoEnvMibOid.$list_oid";
        $oid_status= "$CiscoEnvMibOid.$status_oid";
	
	if ($ip && $community && $host_id) { //check for required values
            $envmon_list = snmp_walk($ip,$community,$oid_list,1);
            $envmon_status = snmp_walk($ip,$community,$oid_status,1);

            if (is_array($envmon_list) && (count($envmon_list)==count($envmon_status)))
            while (list ($key, $entry) 		= each ($envmon_list)) { 
		list ($key_aux ,$entry_status)  = each ($envmon_status); //keep tracking the status entries 
	
		$key_array = explode (".",$key);
		$key = $key_array[count($key_array)-1];
		
		$entry=str_replace('"','',$entry);

		$interface_name = $interface_basename.$key;

		if ($entry_status==1) $status = "up"; //if status is 1 is up
		else $status = "down";
    		
        	$envinfo[$key]["interface"] = $interface_name; 
    		$envinfo[$key]["description"] = $entry; 
        	$envinfo[$key]["admin"] = $status; 
		$envinfo[$key]["oper"] = $status; 
	    }
	}
	return $envinfo;
    }
?>
