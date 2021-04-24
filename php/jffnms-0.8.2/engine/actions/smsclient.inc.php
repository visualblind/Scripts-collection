<?
/* Send SMS Message via smsclient using modem as part of JFFNMS
 * Copyright (C) <2004> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function action_smsclient ($data) {

    $smsclient = get_config_option ("smsclient_executable");
    $smsname = $data['parameters']['smsname'];

    if (($smsname != '') && (file_exists($smsclient)===TRUE)) {

	$alarm = $data['alarm'];
	$events = $data['event'];
	$interface = $data['interface'];
	
	$message = "JFFNMS ";
	
	if (is_array($alarm))
	    $message .= "Alarm: ".$alarm["type_description"]." ".$alarm["state_description"];

	if (is_array($events) && !is_array($alarm))
    	    foreach ($events as $key=>$event)
    		$message .= " Event: ".$event["date"]." ".$event["type"]." ".$event["host_name"]." ".$event["zone"]." ".events_replace_vars($event,$event["text"])." ||";

	if (is_array($interface))
	    $message .= " Interface: ".$interface["host_name"]." ".$interface["interface"]." ".$interface["description"];
    
	$message = substr ($message,0,140);

	$command = "$smsclient $smsname \"$message\"";

	return exec($command);
    } else 
	return "Profile Option SMS Alias not set or smsclient executable ($smsclient) not found.";
}
?>
