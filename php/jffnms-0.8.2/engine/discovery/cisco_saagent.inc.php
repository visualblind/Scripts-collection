<?
/* Cisco SA-AGENT MIB Client Implementation as part of JFFNMS
 * Copyright (C) <2004> Anders Karlsson <anders.x.karlsson@songnetworks.se>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_cisco_saagent($ip, $community, $host_id, $param) {
         
	$saagent = Array();
	
        $CiscoSaAgentOid=".1.3.6.1.4.1.9.9.42.1.5.2.1.1";

	if ($ip && $community && $host_id) { //check for required values
            $saagent_list = snmp_walk($ip,$community,$CiscoSaAgentOid,1);
	    
            if (is_array($saagent_list))
            foreach ($saagent_list as $key=>$entry) {
        	$key=explode(".",$key);
        	$key=$key[count($key)-1];
        	
		$description = str_replace('"','', snmp_get($ip, $community, "1.3.6.1.4.1.9.9.42.1.2.1.1.3.".$key));

        	$saagent[$key]["interface"] = "SAAgent".$key;
    		$saagent[$key]["description"] = "SAA ".$key." ".$description; 
        	$saagent[$key]["admin"] = "ok"; 
    		$saagent[$key]["oper"] = "up"; //FIXME verify state
	    }
	}
	return $saagent;
    }
?>
