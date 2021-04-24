<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    header("Content-Type: text/plain");
    include_once ("../../conf/config.php");
    include_once ("sat_session.inc.php");

    //critical errors
    if ($jffnms_satellite_uri=="none") die("Satellite not configured.\n"); //we are not configured to be a satellite
    
    $headers = unsatellize_headers ($HTTP_RAW_POST_DATA, $capabilities);

    if (is_array($headers))
	extract ($headers,EXTR_SKIP); //Extract Headers, but don't overwrite already-set headers

    if (!$method) die("Method not Specified.\n"); 
    if (!$sat_id) die("Destination Satellite not Specified.\n"); 
    $time_total = time_usec();

    //session stuff
    if (isset($session)) { //session to be used 
	$response = array();

	if ($session=="get") {
	    $session = uniqid(""); //start new session 
	    $response["session"]=$session; //only send session if it was the first request
	}

	$num_sess_vars = sat_session_start($session);

	//variables we want to save in the session
	if ($num_sess_varts == 0)
	    sat_session_register ("my_sat_id","satellite","session_vars","satellite_destination","capabilities","jffnms","old_sat_id","old_from_sat_id","decide");
    }

    if (!isset($satellite)) 	$satellite = $jffnms->get("satellites");
    if (!isset($my_sat_id))	$my_sat_id = $satellite->get_id($jffnms_satellite_uri);
    if (!isset($session_vars))	$session_vars = array();

    if (!isset($class)) 	$class = "satellite"; //default class
    if (!empty($params)) 	$params = unsatellize($params,$capabilities);

    // Everything is ready to go

    if ($sat_profiling) $time_mode = time_usec(); //profile execution time

    if (($old_sat_id != $sat_id) || ($old_from_sat_id!=$from_sat_id)) //if source or dest are not the same as earlier in this session
	$decide = $satellite->decide_mode ($my_sat_id,$sat_id,$from_sat_id); //decide execution mode (relay,direct,error)
    //if they are the same, just leave the session decide var

    //store this decide variables for the next call
    if (!isset($old_sat_id))	  $old_sat_id = $sat_id;
    if (!isset($old_from_sat_id)) $old_from_sat_id = $from_sat_id;

    if ($decide["mode"]=="error") $response=$decide["error"];
    
    if (($decide["mode"]=="direct") && ($method!="none")) //try to call the method
	$response = $satellite->callback($method,$params,$class,$response);

    if ($decide["mode"]=="relay") { //relay message
	if ($ttl=="") $ttl = 10;
	
	if ( $ttl > 0 ) { //if TimeToLive > 0 means we can relay
	    $satellite_destinations = $decide[destinations];

	    if (!is_array($satellite_destination)) 
		$satellite_destination = $satellite->elect_one($satellite_destinations,$my_sat_id,$sat_id);
	
	    if (is_array($satellite_destination)) {
		foreach ($satellite_destination as $parent_sat_id=>$satellite_parent) {
		    $comment = "$my_sat_id-relay";

		    $message=Array(
			sat_id=>$sat_id,
			session=>$satellite_parent[session],
		        ttl=>--$ttl, //decrease TTL to send it
			"class"=>$class,
			method=>$method,
			params=>$params,
		    );	

		    if ($session_destroy) $message["session_destroy"]=$session_destroy; //relay the destroy message

		    $result = $satellite->query($satellite_parent["url"],$message,$comment,0); //FIXME change to GUI or general
		}
	    } else 
		$response[error][$my_sat_id][]="Source IP ".$_SERVER["REMOTE_ADDR"]." Relay not allowed.";

	    if (is_array($result)) {
		unset ($result["session"]); //dont mix session information
		$response = array_merge($result,$response);
	    } else
		$response = $result;
	} else //TTL
	    $response[error][$my_sat_id][]="TTL Excedded";
//	    $response[error]="TTL Excedded";
    } //if relay

    if ($sat_profiling) $time_mode = time_usec_diff($time_mode);

    if ($sat_profiling) $time_sess = time_usec();
    
    if (isset($session)) //session to be used 
	list ($time_ser, $time_save) = sat_session_close();


    if ($session_destroy==1) { //destroy session data (frees memory)
	$aux = $my_sat_id; //save my_sat_id
	$aux1 = $capabilities; //save capabilties
    	$response["session_destroy"]=$result["session_destroy"]; //pass data

    	$response["session_destroy"][$aux]=(bool)sat_session_destroy();
	$capabilities = $aux1;
    }
    
    if ($sat_profiling) $time_sess = time_usec_diff ($time_sess);

    if (is_array($response)) {
	$response[traceroute][]=Array(
			    my_sat_id=>$my_sat_id,
			    mode=>$decide[mode],
			    to_sat_id=>$sat_id,
			    dest=>$satellite_destination
			    );
	$response[times][$decide[mode]][$my_sat_id]=$time_mode;
	$response[times][real_total][$my_sat_id]=time_usec_diff($time_total);
	$response[times][step_total][$my_sat_id]=$response[times][real_total][$my_sat_id]-$response[times][real_total][$parent_sat_id];

        unset ($response[traceroute]); //dont send traceroute data
	unset ($response[times]); //dont send profiling data
    }

    if ($sat_profiling) $time_sat = time_usec();

    $final_response = satellize($response,$capabilities);
    if ($sat_embedded!==true) echo $final_response;

    if ($sat_profiling) $time_sat = time_usec_diff($time_sat);
?>
