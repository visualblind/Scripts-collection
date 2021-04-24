<?
/* HostMIB client implementation as part of JFFNMS
 * Copyright (C) <2003> Anders Karlsson <anders.x.karlsson@songnetworks.se>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_hostmib_apps($ip,$community, $host_id, $param) {
	$services_table = array();

	$SWRunName_oid = ".1.3.6.1.2.1.25.4.2.1.2"; 
	$SWRunPath_oid = ".1.3.6.1.2.1.25.4.2.1.4"; 

	if ($ip && $community && $host_id) { //check for required values
            $services = snmp_walk($ip,$community,$SWRunName_oid);
            $paths = snmp_walk($ip,$community,$SWRunPath_oid);
	    
	    if (is_array($services)) //verify if the array has something
        	foreach ( $services as $key=>$service ) {
		    $service=trim(str_replace('"','',$service));
		    $path=trim(str_replace('"','',$paths[$key]));
		
		    if (!isset($services_table[$service]))
            		$services_table[$service]=array(
			    "interface"=>$service,
		    	    "process_name"=>$service,
		    	    "description"=>"Application $path",
			    "instances"=>1,
		    	    "oper"=>"running"
			);
		    else
        		$services_table[$service]["instances"]++; //add one more instance
    		}
	}

	return $services_table;
    }
?>
