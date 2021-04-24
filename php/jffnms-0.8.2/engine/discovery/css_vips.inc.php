<?
/* This file is part of JFFNMS
 * Copyright (C) <2002> Robert Bogdon
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_css_vips($ip,$rocommunity,$hostid,$param) {

        //print "<PRE>";
        //var_dump($ip);
        //var_dump($rocommunity);
        //var_dump($hostid);
        //var_dump($param);
        //print "</PRE>";

	$css_vips = array();

	if ($ip && $hostid && $rocommunity)  
	    $vipIndex = snmp_walk("$ip","$rocommunity",".1.3.6.1.4.1.2467.1.16.4.1.3");
    
	if (count($vipIndex) > 0) {
            $vipName = snmp_walk("$ip","$rocommunity",".1.3.6.1.4.1.2467.1.16.4.1.2");
            $vipEnabled = snmp_walk($ip, $rocommunity, ".1.3.6.1.4.1.2467.1.16.4.1.11");
            $vipStatus = snmp_walk($ip, $rocommunity, ".1.3.6.1.4.1.2467.1.16.4.1.41");
            $vipIPAddress = snmp_walk($ip, $rocommunity, ".1.3.6.1.4.1.2467.1.16.4.1.4");
            $vipOwner = snmp_walk($ip, $rocommunity, ".1.3.6.1.4.1.2467.1.16.4.1.1");
            	
   	    //print "<PRE>";
   	    //var_dump($vipName);
   	    //var_dump($vipEnabled);
   	    //var_dump($vipStatus);
   	    //var_dump($vipIPAddress);
   	    //var_dump($vipOwner);
   	    //print "</PRE>";

	    $statusCodes = array(0=>"down", 1=>"up", 4=>"up");
		
   	    for ($i=0; $i < count($vipIndex) ; $i++) 
		if ($vipIndex[$i]) {
		    
		    $vipInfo = array();
		    
		    list($aux, $vipIPAddress[$i]) = split(" ", $vipIPAddress[$i]);
		    
		    $vipName[$i] = str_replace("\"", "", $vipName[$i]);
		    $vipOwner[$i] = str_replace("\"", "", $vipOwner[$i]);
		    		    
		    $vipInfo["address"] = $vipIPAddress[$i];
		    $vipInfo["description"] = $vipOwner[$i];
		    $vipInfo["bandwidth"] = 1000000000;
		    $vipInfo["interface"] = $vipName[$i];
		    $vipInfo["admin"] = $statusCodes[$vipEnabled[$i]];
		    $vipInfo["oper"] = $statusCodes[$vipStatus[$i]];

		    foreach ($vipInfo as $key=>$value) $vipInfo[$key]=trim($value);

		    $css_vips[$vipIndex[$i]] = $vipInfo;
		}
	}

        //print "<PRE>";
        //var_dump($css_vips);
        //print "</PRE>";

	return $css_vips;
    }
?>
