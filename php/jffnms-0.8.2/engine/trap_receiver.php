<?
/* PHP Database Abstrated Trap Receiver (from snmptrapd). This file is part of JFFNMS
 * Copyright (C) <2004> Aaron Daubman <daubman@ll.mit.edu>
 * Copyright (C) <2003>	Craig Small <csmall@small.dropbear.id.au>
 * Copyright (C) <2002> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

/* NOTES - To receive traps:
 * snmptrapd.conf:
 * 	traphandle default cd /opt/jffnms/engine && php -q trap_receiver.php
 * command-line:
 *	snmptrapd -c /etc/snmp/snmptrapd.conf -f -P -On -n
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");


    function trap_duplicate ($current_oid, $span = 5) {
	$query = "SELECT id FROM traps WHERE trap_oid = '".$current_oid."' AND date > ".(time()-$span)." ORDER BY id desc";
	$rs = db_query($query);
	
	return (db_num_rows($rs) > 0)?true:false;
    }
    
    $stdin = fopen('php://stdin', 'r');

    $hostname = trim(fgets($stdin,4096)) or die("Could not get hostname");
    $ipaddr = trim(fgets($stdin,4096)) or die("Could not get IP");

    $ipaddr = extract_ip($ipaddr);	// ipaddr may be UDP: [1.1.1.1]
    
    if ((ip2long($ipaddr) == -1) || (ip2long($ipaddr) == false)) // if its not an IP address, it may be a hostname
	$ipaddr = gethostbyname($ipaddr);			 // resolve it using DNS

    $uptime = trim(fgets($stdin,4096)) or die("Could not get uptime");

    $trapoid = fgets($stdin,4096) or die("Could not get trapoid");

    $trapoid = preg_replace("/^\S+\s+(\S+)\s*$/", "$1", $trapoid);

    $output =  "------\nIP: ".$ipaddr."\nUptime: $uptime\nTrap OID: $trapoid\n";

    if (!trap_duplicate($trapoid)) {

	//prevent warnings:
        $varbinds = array();

	while($line=trim(fgets($stdin,4096)))
	    if (preg_match ("/^(\S+)\s+=?\s?\"?([^\" \t]+)\"?$/", $line, $matches)) 
		$varbinds[$matches[1]] = $matches[2];
	    else
		$output .= "Not Matched: $line\n";
    
	foreach ($varbinds as $key=>$var)
	    $output .= "Line ".(++$varnum)." is: ".$key." ==> ".$var."\n";


	// Insert into database:
	$trap_id = db_insert ("traps",array("date"=>time(), "ip"=>$ipaddr, "trap_oid"=>$trapoid));
    
	$oidid = 1;
	foreach ($varbinds as $key=>$var)
	    db_insert("traps_varbinds",array("trapid"=>$trap_id, "oidid"=>$oidid++, "trap_oid"=>$key, "value"=>$var));

	$output .= "New Trap ID: ".$trap_id."\n\n\n";
    } else
	$output .= "Duplicate Trap\n";
    
    db_close();

    logger ($output);
    fclose($stdin);
    exit(0);
?>
