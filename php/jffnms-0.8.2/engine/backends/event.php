<?
/* This file is part of JFFNMS
 * Copyright (C) <2005> Erno Rigo <mcree@tricon.hu>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 *
 * Unconditionally inserts an event based on parameters.
 */

    function backend_event($params, $aux) { 	// $aux is only to conform with pollers_backend API

        $event_type_id = $params["backend_parameters"];

	if ($params["host_id"] == 1) $params["info"] .= " From: ".$params["host_ip"]; //record the HostIP in the info field

	if (empty($params["username"])) $params["username"] = $params["receiver_command"];
    
	$event_id = insert_event($params["date"], $event_type_id, $params["host_id"], $params["interface"], $params["status"], 
	    $params["username"], $params["info"], $params["referer"], 1);
    
	return "Inserted Event ID ".$event_id;
    }

?>
