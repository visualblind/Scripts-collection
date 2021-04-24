<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function tool_if_admin_info() {
	return array ("type"=>"select","param"=>array(1=>"UP",2=>"DOWN"));
    }

    function tool_if_admin_get($int) {
	$value = snmp_get($int["host_ip"],$int["host_rocommunity"],".1.3.6.1.2.1.2.2.1.7.".$int["interfacenumber"]);
	$value = substr($value,strlen($value)-2,1);
	return $value;    
    }

    function tool_if_admin_set($int, $value) {
	$result = snmp_set($int["host_ip"],$int["host_rwcommunity"],".1.3.6.1.2.1.2.2.1.7.".$int["interfacenumber"],"i",$value);
	return $result;
    }

?>
