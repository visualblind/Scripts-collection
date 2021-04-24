<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //CISCO-STACK-MIB Configuration Downloader Implementation for CatOS (tested on 5513)
    //from: http://www.cisco.com/warp/public/477/SNMP/move_files_images_snmp.html
    //thanks to Paul Stewart from Nexicom for let me use his hardware.
    //tftpResult Values: (1) : inProgress, (2) : success, >= 3 Errors
     
    function config_cisco_catos_get ($ip, $rwcommunity, $server, $filename) {

	if ($ip && $rwcommunity && $server && $filename) {
	    $tftpHostOID   = ".1.3.6.1.4.1.9.5.1.5.1.0";
	    $tftpFileOID   = ".1.3.6.1.4.1.9.5.1.5.2.0";
	    $tftpModuleOID = ".1.3.6.1.4.1.9.5.1.5.3.0";
	    $tftpActionOID = ".1.3.6.1.4.1.9.5.1.5.4.0";
	    $tftpResultOID = ".1.3.6.1.4.1.9.5.1.5.5.0";

	    $resultHost = snmp_set($ip,$rwcommunity,$tftpHostOID,"s",$server); //set the TFTP Server

	    if ($resultHost==true)
		$resultFile = snmp_set($ip,$rwcommunity,$tftpFileOID,"s",$filename); //set the Filename
		
	    if ($resultFile==true)
	        $resultModule = snmp_set($ip,$rwcommunity,$tftpModuleOID,"i",2); //set Supervisor Module (FIXME this could change)
	    
	    if ($resultModule==true)
	        $resultAction = snmp_set($ip,$rwcommunity,$tftpActionOID,"i",3); //set the action to Upload
	    
	    if ($resultAction==true)
		$result = snmp_get($ip,$rwcommunity,$tftpResultOID); //get Status of the transfer
	    
	    if ($result < 3) return true; 
	}
	return false;
    }

    function config_cisco_catos_wait ($ip, $rwcommunity, $server, $filename) {
        $i = 1;
        $result = 1;
	$tftpResultOID = ".1.3.6.1.4.1.9.5.1.5.5.0";
        while (($result == 1) and ($i++ < 30)) { 
	    $result = snmp_get($ip,$rwcommunity,$tftpResultOID);
	    sleep(2); 
	}
	if ($result == 2) return true; 
	return false;
    }
?>
