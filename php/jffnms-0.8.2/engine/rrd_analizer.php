<?
/* RRDTool File Analyzer. This file is part of JFFNMS
 * Copyright (C) <2002-2003> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");

    //FIXME what happens when you need to could all values for the average, event the 0, like for packetloss
    function get_average($data) {
	$cant = count ($data);
	$values = 0;
	$result = 0;
	
	for ($i = 0;$i < $cant ; $i++)
	    if ($data[$i]!=0) {		//avoid counting when there's a 0 there. (Don't know if its ok) FIXME
		$result += $data[$i]; 
		$values++;
	    }

	if ($values==0) $values = 1; //avoid divide by 0

	return round($result/$values);
    }

    function analyzer_fetch($interface_id,$from,$to,$dss) {	    
	
	$dss_names = array_keys($dss);

    	$values = rrdtool_fetch_ds($interface_id, $dss_names, "-$from", "-$to");

	if (is_array($values)) {

	    foreach ($values as $value_name=>$value_data)
		if ($value_name!="information")
		    $result[$value_name] = get_average($value_data); //FIXME how to handle Last Value Deltas and 95th Percentile 
	    
	    $result["information"]=$values["information"];
	    $result["information"]["measures"] = count ($values[current(array_keys($values))]);
	    
	    unset ($values);
	    return $result;
	}
	return false;
    }

    if (empty($interface_id)) $interface_id = $_SERVER["argv"][1];	//Filter by Interface ID

    $span = 30; //30 minutes (start time)
    $end = 10; //10 minutes (end time)
    
    $start_time = (($span-5)+$end)*60; 
    $end_time = ($end*60);
    
    //------------------------------------------> timeline
    //    |(start_time)--------|(end_time)    |(now)

    $query_rrd="
	SELECT
	    interfaces.id, interfaces.interface, interfaces.host, interfaces.sla, interfaces.type,
	    slas.info, slas.event_type,
	    alarm_states.description as state
	FROM 
	    interfaces, slas, alarm_states, hosts
	WHERE 
	    interfaces.sla = slas.id and interfaces.sla > 1 and slas.state = alarm_states.id and
	    interfaces.poll > 1 and interfaces.host = hosts.id and hosts.poll = 1
	    ".(($interface_id)?" and interfaces.id = $interface_id":"")."
	ORDER BY 
	    interfaces.id";

    //logger($query_rrd);
    
    $result_analyzer = db_query ($query_rrd) or die ("Query failed - S1 - ".db_error());

    $type_dss = array();
    while ($rec = db_fetch_array($result_analyzer)) {
	
	if (interface_is_up($rec["id"])) { //up 
	    
	    if (!isset($type_dss[$rec["type"]])) {
		$interface_data = interface_values($rec["id"],array("ftype"=>20));
		$type_dss[$rec["type"]] = $interface_data["values"][$rec["id"]];

		unset ($interface_data);
	    }
	    
	    $dss = &$type_dss[$rec["type"]];

	    $values = analyzer_fetch ($rec["id"], $start_time, $end_time, $dss);

	    if (is_array($values)) { 

		foreach ($dss as $ds=>$aux) 
		    if (isset($values[$ds]))
			$text[]=$ds."(".$values[$ds].")";
		
		logger("I".$rec["id"]." : ".str_repeat("=",90)."\n");
		logger("I".$rec["id"]." : "."Start: ".date("Y-m-d H:i:s",$values["information"]["start"]).
				"\tStop: ".date("Y-m-d H:i:s",$values["information"]["stop"]).
				"\tMeasures: ".$values["information"]["measures"]."\n");
		logger("I".$rec["id"]." : ".join(" ",$text)."\n");
		logger("I".$rec["id"]." : ".str_repeat("-",90)."\n");
		
		
		//Call the Analyzers
		
		$analyzers = array ("sla");
		
	        $function_data = array ($rec,&$values);	    
	
		foreach ($analyzers as $analyzer_function) {

		    $real_function = "analyzer_$analyzer_function";
		    $function_file = get_config_option("jffnms_real_path")."/engine/analyzers/$analyzer_function.inc.php";
		    if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file))) ) {
	
			if (function_exists($real_function)) {
			    $result = call_user_func_array($real_function,$function_data);
			} else 
			    logger("ERROR: Calling Function '$real_function' doesn't exists.\n");
		    } else 
			logger ("ERROR Loading file $function_file.\n");

		    //show result
		    if (is_array($result))
		    foreach ($result as $aux)
			logger("I".$rec["id"]." : $analyzer_function : $aux\n");
		    unset ($result);
		}
	    
		unset ($values);
		unset ($text);
		
	    } else 
		logger("I".$rec["id"]." : RRD File(s) not found.\n");

	} else 
	    logger("I".$rec["id"]." : is not UP.\n");
    } 
    db_close();

?>
