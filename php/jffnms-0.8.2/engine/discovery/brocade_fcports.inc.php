<?php
/* Brocade FC Ports. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

define(swFCPortIndex,     '1.3.6.1.4.1.1588.2.1.1.1.6.2.1.1');
define(swFCPortPhyState,  '1.3.6.1.4.1.1588.2.1.1.1.6.2.1.3');
define(swFCPortOpStatus,  '1.3.6.1.4.1.1588.2.1.1.1.6.2.1.4');
define(swFCPortAdmStatus, '1.3.6.1.4.1.1588.2.1.1.1.6.2.1.5');

function discovery_brocade_fcports($ip, $community, $hostid, $param) {
    $fcports = array();

    if ($ip && $community && $hostid) {
        $indexes = snmp_walk($ip, $community, swFCPortIndex);
        // Bomb out now if no sensors
        if ($indexes === FALSE) return FALSE;
        $phys = snmp_walk($ip, $community, swFCPortPhyState);
        $opers = snmp_walk($ip, $community, swFCPortOpStatus);
        $admins = snmp_walk($ip, $community, swFCPortAdmStatus);
        foreach($indexes as $key => $index) {
            $fcports["$index"] = array(
                'interface' => "Port ".($index-1),
                'oper' => brocade_fcport_oper($opers["$key"]),
                'admin' => brocade_fcport_admin($admins["$key"]),
                'phy' => brocade_fcport_phy($phys["$key"]),
            );
         }
    }
    return $fcports;
}

function brocade_fcport_oper($status)
{
    if ($status == '1') return 'up'; #online
    if ($status == '3') return 'testing'; # testing
    return 'down';
}

function brocade_fcport_admin($status)
{
    if ($status == '1') return 'up'; #online
    if ($status == '3') return 'testing'; # testing
    return 'down';
}

function brocade_fcport_phy($status)
{
    if ($status == '6') return 'up'; #inSync
    return 'down';
}
// vim:et:sw=4:ts=4:
?>
