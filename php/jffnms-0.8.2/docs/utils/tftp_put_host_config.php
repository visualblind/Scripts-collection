<?
/* CISCO running-config Uploader (via SNMP and TFTP) is part of JFFNMS
 * Copyright (C) <2002> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $functions_include="engine";
    include ("../../conf/config.php");

    $host_id = $_SERVER[argv][1];
    $filename= $_SERVER[argv][2];
    
    if ($host_id && $filename) {
	$host = current(hosts_list($host_id));

	if ($host[tftp_mode]=="") $host[tftp_mode]=0; //default

	if ($host[tftp_mode]==1) { //OLD-CISCO-SYS-MIB
	    $oid = ".1.3.6.1.4.1.9.2.1.53.$host[tftp]";
	    $aux = snmpset($host[ip],$host[rwcommunity],$oid,"s",$filename,60,0);
	    if ($aux==TRUE) $result = 2;
	}
	    
	if ($host[tftp_mode]==0) { //CISCO-CONFIG-COPY-MIB
	    $oid = ".1.3.6.1.4.1.9.9.96.1.1.1.1";
	    snmpset($host[ip],$host[rwcommunity],"$oid.14.999","i",6,60,0); //destroy
	    snmpset($host[ip],$host[rwcommunity],"$oid.14.999","i",5,60,0); //create and wait
	    snmpset($host[ip],$host[rwcommunity],"$oid.2.999","i","1",60,0); //tftp
	    snmpset($host[ip],$host[rwcommunity],"$oid.3.999","i","1",60,0); //running
	    snmpset($host[ip],$host[rwcommunity],"$oid.4.999","i","4",60,0); //network
	    snmpset($host[ip],$host[rwcommunity],"$oid.5.999","a",$host[tftp],60,0); //server
	    snmpset($host[ip],$host[rwcommunity],"$oid.6.999","s",$filename,60,0); //filename
	    snmpset($host[ip],$host[rwcommunity],"$oid.14.999","i",1,60,0); //activate
	    $result = snmp_get($host[ip],$host[rwcommunity],"$oid.10.999");
	}

	return $result;
    }
    
    echo "$result\n";
?>
