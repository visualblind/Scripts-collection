<?php
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

define(ifDescr, '.1.3.6.1.2.1.2.2.1.2');
define(ipInterfaceTableMax,'.1.3.6.1.4.1.1872.2.1.3.1.0');
define(agPortCurCfgPortName,'.1.3.6.1.4.1.1872.2.1.2.3.2.1.15');

# Returns true if this is a WebOS host
    function is_webos ($ip, $comm) {
      $system_name = snmp_get($ip, $comm, '.1.3.6.1.2.1.1.1.0');
      if (strpos($system_name, 'Alteon AD3') !== FALSE)
        return TRUE;
      return FALSE;
    }

    function webos_info($ip, $comm, $ifIndex) {

        $ifDescrs = snmp_walk($ip,$comm,ifDescr);
        $ipIntMax = snmp_get($ip,$comm,ipInterfaceTableMax);
        $PortNames = snmp_walk($ip,$comm,agPortCurCfgPortName);
        if (!$ipIntMax) return $ifDescrs;

        foreach($ifIndex as $key => $index) {
            if ($index > $ipIntMax) {
                $ifDescrs["$key"] = "Port ".intval($index-$ipIntMax);
                $ifAliases["$key"] = $PortNames[$index-$ipIntMax-1];
            }
          }

        return array($ifDescrs,$ifAliases);
    }


// vim:et:sw=4:ts=4:
?>
