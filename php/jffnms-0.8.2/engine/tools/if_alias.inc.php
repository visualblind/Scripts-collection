<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function tool_if_alias_info() {
	return array ("type"=>"text","param"=>array("size"=>40));
    }

    function tool_if_alias_get($int) {
	$value = snmp_get($int["host_ip"],$int["host_rocommunity"],".1.3.6.1.2.1.31.1.1.1.18.".$int["interfacenumber"]);
	return $value;    
    }

    function tool_if_alias_set($int, $value) {
	$result = snmp_set($int["host_ip"],$int["host_rwcommunity"],".1.3.6.1.2.1.31.1.1.1.18.".$int["interfacenumber"],"s",$value);
	return $result;
    }

?>
