<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function satellite_poller ($params) { 
	
	$my_sat_id = $GLOBALS["my_sat_id"];
	
	if ((isset($params["interface_id"]) || isset($params["host_id"])) && isset($params["poller_pos"])) {
	
	    $mode = (isset($params["mode"]))?$params["mode"]:"pos"; //default mode is POS
		
	    switch ($mode) {
	        case "host": //store all the host polling plan in the session
			$buffer = &$GLOBALS["session_vars"]["poller_plan"];
		
			if (!is_array($buffer))
			    $buffer = poller_plan(array("host"=>$params["host_id"]));
		
		    	reset ($buffer["plan"]);
			break;
			
		case "interface": //store each interface polling plan in the session 
	    		$buffer = &$GLOBALS["session_vars"]["poller_plan"][$params["interface_id"]];
		
			if (!is_array($buffer))
			    $buffer = poller_plan(array("interface"=>$params["interface_id"]));
		    	
			reset ($buffer["plan"]);
			break;
		
		case "pos": //just query this position for this interface, don't store anything
			$buffer = poller_plan(array("interface"=>$params["interface_id"],"pos"=>$params["poller_pos"]));
			break;
	    }
		
	    while ($poller_data = poller_plan_next($buffer))
	        if (($poller_data["interface_id"]==$params["interface_id"]) &&  //find the specified position
	    	    ($poller_data["poller_pos"]==$params["poller_pos"])) {
	    
		    $backend_filename = get_config_option("jffnms_real_path")."/engine/backends/".$poller_data["backend_command"].".php";

		    if (file_exists($backend_filename)==true) {
	    	        include_once($backend_filename);
                        
		        $response["backend_result"] = call_user_func_array("backend_".$poller_data["backend_command"],array($poller_data,$params["poller_result"]));
		    } else 
		        $response["error"][$my_sat_id][]="ERROR: ".$poller_data["backend_command"]." Module not Found...";
		}//while
	}
	return $response;
    }
?>
