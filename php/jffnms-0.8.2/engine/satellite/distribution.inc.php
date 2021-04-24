<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //imports object data from parent (and master) satellites
    function satellite_distribution ($params) {

	$jffnms = $GLOBALS["jffnms"]; //object broker
	$my_sat_id = $GLOBALS["my_sat_id"];
	$response = array();
	
	$masters = array_keys(satellite_get_masters());

	if (!in_array($my_sat_id,$masters)) { //Master don't accept disitribution
	    
	    if (is_array($params)) extract($params);

	    if ($data_class && is_array($data)) { 
		$response["added"]=0;
		$response["deleted"]=0;
		$response["modified"]=0;
		$response["items"]=0;
		
		$obj = $jffnms->get($data_class);
	
		//get all the ids we have for this data type
		$data_old = $obj->export($filter); 
	
		$pos_ids = array_unique(array_merge(array_keys($data),array_keys($data_old)));

		foreach ($pos_ids as $pos_id) {

		    $result = $obj->import($data[$pos_id],$data_old[$pos_id]);  //import the data

		    if (isset($result["add"])) 
			$response["added"]++;

		    if (isset($result["del"])) 
			$response["deleted"]++;

		    if ($result["mod"]==1)
			$response["modified"]++;

		    $response["items"]++;
		}
		unset($data_old);
	    }
	}
	return $response;
    }

?>
