<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //Send eMail

    function action_email ($data) {
	extract($data);
	//debug ($data);

	if (!function_exists("mail")) {
	    logger("Mail function does not exists.\n");
	    return 0;
	}

	$from = $parameters[from];
	$to = $parameters[to];
	$subject = $parameters[subject];
	$short = (isset($parameters["short"])?true:false);

	if (!$short) $content[hello] = "Hello ".$user[fullname].":\n";
	
	//$content[introduction] = "\tJFFNMS Trigger, condition.\n";
	
	if (!$short) $signature =  "---------------------------------------------------------------------\nJFFNMS - Just for Fun Network Management System\n";

	if (is_array($alarm)) {
	    $content[alarm]=	"Alarm Time:\t".$alarm[date_start];
	    
	    if ($alarm[alarm_state]==ALARM_UP)
		$content[alarm] .= " To ".$alarm[date_stop];
		
	    $content[alarm] .=  "\n".
				"Alarm Type:\t".$alarm[type_description]." ".
				$alarm[state_description]." ".
				($short?"":"\n");
	}
	
	if (is_array($interface)) 
	    $content["interface"]=	"Interface:\t".
					$interface[type_descripton]." ".
					$interface[host_name]." ".
					$interface[zone_shortname]." ".
					$interface["interface"]." ".
					$interface[client_name]." ".
					$interface[description]." ".
					"\n";

	if (is_array($event) && !$short) //FIXME
	//if (is_array($event) && !is_array($alarm)) 
	    foreach ($event as $key=>$event)
		$content["event-$key"]=	"Event:\t".
					$event[date]." ".
					$event[type]." ".
					$event[host_name]." ".
					$event[zone]."\n".
					"Event:\t".events_replace_vars($event,$event[text])." ".
					"\n";
					
	$all_content = join($content,"\n");
	
	if ($parameters[comment] && !$short) 
	    $all_content .= "\nComment: ".$parameters[comment]."\n";

	$headers =  "From: JFFNMS@".get_config_option("jffnms_site")." <$from>\r\n".
		    "X-Mailer: JFFNMS ".get_config_option("jffnms_version")." ( http://www.jffnms.org )\r\n";
	
	$body = "$all_content \n$signature";
	
	if ($short) $body = str_replace("\t"," ",$body);

	if ((strpos($to,"@") > 1) && $subject && $body && $headers)
	    $result = mail($to,$subject,$body,$headers,"-f$from");
	    //debug (array($to,$subject,$body,$headers,"-f$from"));
	else 
	    $result = 0;
	    
	return $result;
    }

?>
