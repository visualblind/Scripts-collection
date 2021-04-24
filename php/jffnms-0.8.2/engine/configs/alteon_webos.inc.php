<?php
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

// agGeneral .1.3.6.1.4.1.1872.2.1.2.1
define(agTftpServer, '.1.3.6.1.4.1.1872.2.1.2.1.18.0');
define(agTftpCfgFileName, '.1.3.6.1.4.1.1872.2.1.2.1.19.0');
define(agTftpAction, '.1.3.6.1.4.1.1872.2.1.2.1.21.0');
define(cfg-get, '3');
define(agTftpLastActionStatus, '.1.3.6.1.4.1.1872.2.1.2.1.22.0');

function config_alteon_webos_get($ip, $community, $server, $filename) {

    if ($ip && $community && $server && $filename) {
        if (
            snmp_set($ip, $community, agTftpServer, 's', $server) !== FALSE 
         && snmp_set($ip, $community, agTftpCfgFileName, 's', $filename) !== FALSE
         && snmp_set($ip, $community, agTftpAction, 'i', 4) ) {
            $status = snmp_get($ip, $community, agTftpLastActionStatus);
	    if (!preg_match('/Success"$/',$status)) {
	      logger(" : H ???  : $ip : config_alteon_webos_get(): $status\n");
	      return false;
	    }
	    return true;
        }
    }
    return false;
}

    function config_alteon_webos_wait($ip, $rwcommunity, $server, $filename) {
    	sleep(2);
	return true;
    }

// vim:et:sw=4:ts=4:
?>
