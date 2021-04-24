<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

//uses CISCO-PING-MIB
//Check if your IOS version supports it in: http://tools.cisco.com/ITDIT/MIBS/servlet/com.cisco.itdit.mibs.mainServlet

function poller_cisco_snmp_ping_start ($options) {
	extract($options);

	$cant_pings = $options["pings"];

	$result = -5;
	$oid = ".1.3.6.1.4.1.9.9.16.1.1.1";
	$is_up = interface_is_up($interface_id);

	if (($peer) && ($host_ip) && ($rw_community) && ($is_up) && ($cant_pings > 0)) {

	    $hex = "";
	    $add = explode(".",$peer);
	    foreach ($add as $add1) $hex.=dec2hex($add1);
    	
	    //echo $hex;
	    //$hex=dec2hex($add1);
    	    //$hex.=dec2hex($add[1]);
    	    //$hex.=dec2hex($add[2]);
    	    //$hex.=dec2hex($add[3]);

	    //$test = snmp_set($host_ip,$rw_community,"$oid.16.$random$interface_id","i","6"); //destroy
	    //var_dump($test);

	    if (snmp_set($host_ip,$rw_community,"$oid.16.$random$interface_id","i","6")) //destroy
	     if (count(snmp_set($host_ip,$rw_community,"$oid.16.$random$interface_id","i","5"))==1) //create
	      if (count(snmp_set($host_ip,$rw_community,"$oid.15.$random$interface_id","s","PING-$interface_id"))==1) //name
	       if (count(snmp_set($host_ip,$rw_community,"$oid.2.$random$interface_id","i",1))==1) //tipo ip
	        if (count(snmp_set($host_ip,$rw_community,"$oid.3.$random$interface_id","x",$hex))==1) //ip en hex
 	         if (count(snmp_set($host_ip,$rw_community,"$oid.4.$random$interface_id","i",$cant_pings))==1)  //cant
	          if (count(snmp_set($host_ip,$rw_community,"$oid.5.$random$interface_id","i",64))==1)  //size
		    if (($result = snmp_get($host_ip,$rw_community,"$oid.16.$random$interface_id"))==2) //2 si esta listo
			snmp_set($host_ip,$rw_community,"$oid.16.$random$interface_id","i",1); 	//activarlo	
		    else  logger( "ERROR: Ping not Ready",0);
	    
	    
	    return $result;
	} else 
	    return -1;
}
?>
