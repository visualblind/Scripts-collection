<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function satellites_action_update() {
	global $api, $description, $parent, $url, $sat_group, $sat_type;

	$old_data = current($api->get_data($_POST["actionid"]));

	$my_sat_id = $api->get_id($GLOBALS["jffnms_satellite_uri"]);

	//if local is not configured, configure it
	if (!$my_sat_id && ($_POST["actionid"]==1) && ($GLOBALS["jffnms_satellite_uri"]!="none") && (!$url) ) 
	    $url = $GLOBALS["jffnms_satellite_uri"]; 
	
	$data = compact("description","parent","url","sat_group","sat_type");
	debug ($data);	
	if (!$my_sat_id) $my_sat_id=1;
	
	$old_path = $api->get_paths($_POST["actionid"]);
	
	$api->update($_POST["actionid"],$data);

	if ($sat_type!=4)
	    $result = $api->triggered_update($my_sat_id, $_POST["actionid"], $old_path);

	if ($result["errors"] > 0) 
	    debug ($result);
    }

?>
