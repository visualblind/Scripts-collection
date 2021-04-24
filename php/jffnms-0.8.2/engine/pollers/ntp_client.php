<?
/* NTP (Network Time Protocol) poller, checks directy into each host. This file is part of JFFNMS
 * Copyright (C) <2004> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function poller_ntp_client ($data) {

	    $ntp_command = get_config_option ("ntpq_executable");
	    
	    if (file_exists($ntp_command)===true) { 
	    
		exec($ntp_command." -p ".$data["host_ip"]." 2>/dev/null",$raw_result);

		if (count($raw_result)>2) {
		    unset($raw_result[0]);    
		    unset($raw_result[1]);    
		
		    $statuses = array();
		    		    
		    foreach ($raw_result as $aux) {
			$status = substr($aux,0,1);
		    
			$aux = array_unique(explode (" ",substr($aux,1,strlen($aux))));
			unset ($aux[array_search("",$aux)]);
			$aux = array_values($aux);
			
			list ($peer, $reference, $stratum, $type, $when, $poll, $reach, $delay, $offset, $jitter) = $aux;
			
			if (($type != "l") or ($stratum == 0))
			    $statuses["$peer -> $reference, stratum $stratum"]=$status;
		    }
		    
		    if ($peer = array_search("*",$statuses))
			$status = "synchronized|with $peer";
		    else
			$status = "unsynchronized";
		}
	    }
	    return $status;
    }
?>
