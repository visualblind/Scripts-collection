<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $filter["triggered"]="0"; //not already triggered and action
    $filter["alarm_state"]="1"; //state is down

    $alarms = alarms_list(0,$filter);

    logger("Active Alarms for Triggers: ".count($alarms)."\n");
    
    foreach ( $alarms as $alarm ) {

	logger( "A ".$alarm["id"].":= @".$alarm["date_start"]." - state: ".$alarm["alarm_state"]." (".$alarm["state_description"].")".
		" - int: ".$alarm["interface"]." - type: ".$alarm["type"]."\n");

	trigger_analize("alarm",$alarm);
    }

?>
