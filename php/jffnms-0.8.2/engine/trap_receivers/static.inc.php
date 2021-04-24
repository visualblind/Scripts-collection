<?
/* This file is part of JFFNMS
 * Copyright (C) <2005> Erno Rigo <mcree@tricon.hu>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 *
 * Trap sink receiver. Meant to be used in conjunction with the 'event' backend plugin.
 *
 * Parameters:
 *	alarm_state,[interface_index_field],[interface_index_varbind]
 *
 * Where:
 *	alarm_state - alarm state to send to backend
 *	interface_index_field   - interface index field name (eg. "index"),
 *	interface_index_varbind - interface index value SNMP Varbind number
 *
 */

    function trap_receiver_static ($params) {

	$res = array();
	    
	list ($res["status"], $interface_index_field, $interface_index_varbind) = explode(",", $params["receiver_parameters"]);

	// Match interface (name and id) by index field
	if (($interface_index_field !== "") && ($interface_index_varbind !== "")) {
	    $int_data = interfaces_get_by_field_value ($params["host_id"], $params["interface_type"], 
		$interface_index_field, $params["trap_vars"][$interface_index_varbind]);

	    if (is_numeric($int_data["interface_id"])) {
	        $res["interface"] = $int_data["interface"];		// for event backend
		$res["interface_id"] = $int_data["interface_id"];	// for alarm backend
	    }
	}

	// for event or alarm backend
        $res["date"] = date("Y-m-d H:i:s", $params["trap"]["date"]);	
	$res["referer"] = $params["trap"]["id"];
        
	return array(true, $res);
    }
?>
