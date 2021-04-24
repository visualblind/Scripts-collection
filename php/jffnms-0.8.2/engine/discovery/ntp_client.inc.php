<?
/* NTP (Network Time Protocol) discovery, checks directy into each host, This file is part of JFFNMS
 * Copyright (C) <2004> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_ntp_client ($ip,$rocommunity,$hostid,$param) {

	    $ntp_client = array();
	    $ntp_command = get_config_option ("ntpq_executable");
	    
	    list($ip) = explode(":",$ip); //remove :port from IP

	    if ((file_exists($ntp_command)===true) && (!empty($ip))) { 
	    
		exec($ntp_command." -p ".$ip." 2>/dev/null",$raw_result);
		
		if (count($raw_result)>0 && ($raw_result[0] != "No association ID's returned")) { 
		    unset($raw_result[0]);    
		    unset($raw_result[1]);    
		
		    $statuses = array();
		    
		    foreach ($raw_result as $aux) {
		    	$status = substr($aux,0,1);
		    
			$aux = array_unique(explode (" ",substr($aux,1,strlen($aux))));
			unset ($aux[array_search("",$aux)]);
			$aux = array_values($aux);
			
			list ($peer, $reference, $stratum, $type, $when, $poll, $reach, $delay, $offset, $jitter) = $aux;

			if ($type == "u")
			    $statuses[$peer]=$status;
		    }
		    
		    if ($peer = array_search("*",$statuses))
			$status = "synchronized";
		    else
			$status = "unsynchronized";
	    
		    $ntp_client[1]["interface"]="Time";
		    $ntp_client[1]["oper"]=$status;
		}
	    }
	    return $ntp_client;
    }
?>
