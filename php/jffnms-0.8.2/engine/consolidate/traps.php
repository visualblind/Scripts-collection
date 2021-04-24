<?
/* SNMP Trap Consolidator is part of JFFNMS
 * Copyright (C) <2002-2003> Javier Szyszlican <javier@szysz.com>
 * Copyright (C) <2005> Erno Rigo <mcree@tricon.hu>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 *
 * 2005-04-01 Extensive rewrite to support trap_receiver plugins by Erno Rigo <mcree@tricon.hu>
 * 2005-04-06 Re-wrote again, implementing receiver positions following directions from Javier - Erno Rigo <mcree@tricon.hu>
 */

    function consolidate_traps () {

	$query_traps = "SELECT id, date, ip, trap_oid FROM traps WHERE analized = 0 ORDER BY id asc";
	$result_traps = db_query ($query_traps) or die ("Query failed - TA2 - ".db_error());

	logger( "SNMP Traps to Process: ".db_num_rows($result_traps)."\n");

	while ($trap = db_fetch_array($result_traps)) {

	    $matched = false;
	    // d ($trap);

	    // Get Host ID
	    $query_host="SELECT id FROM hosts WHERE hosts.ip = '".$trap["ip"]."' OR hosts.name = '".$trap["ip"]."'"; 
	    $result_host = db_query ($query_host) or die ("Query failed - TA5 - ".db_error());
	    $host_id = (db_num_rows ($result_host) > 0)?current(db_fetch_array($result_host)):1; //if not host is found use 1 (unknown)
	    
    	    $query_varbinds = "SELECT trap_oid, value, oidid FROM traps_varbinds WHERE trapid = ".$trap["id"]." ORDER BY oidid";
	    $result_varbinds = db_query($query_varbinds) or die ("Query failed (".$query_varbinds.") - get varbinds - ".db_error());

	    //save all varbinds with key and value
	    $trap_vars = array();
	    $trap_vars_oid = array();
	    if (db_num_rows ($result_varbinds) != 0) 
		while ($rows_varbinds = db_fetch_array($result_varbinds)) {
    		    $trap_vars[$rows_varbinds["oidid"]] = $rows_varbinds["value"];		// indexed by VarBind ID (reception order)
    		    $trap_vars_oid[$rows_varbinds["trap_oid"]] = $rows_varbinds["value"];	// indexed by VarBind OID
		}
		
	    $query_receiver = "
		SELECT 
		    tr.match_oid,
		    tr.position,
		    tr.interface_type,
		    tr.stop_if_matches,
		    tr.command 		as receiver_command, 
		    tr.parameters 	as receiver_parameters, 
		    rb.command 		as backend_command, 
		    rb.parameters 	as backend_parameters 
		
		FROM trap_receivers tr, pollers_backend rb 
	        WHERE rb.id = tr.backend 
	        ORDER BY tr.position";

	    $result_receiver = db_query($query_receiver) or die ("Query failed (".$query_receiver.") - get trap receiver - ".db_error());

	    while ($record = db_fetch_array($result_receiver))
		if (preg_match("/".$record["match_oid"]."/", $trap["trap_oid"]) && !$matched) {		// if this trap regexp matches the trap OID

		    $receiver_command = $record["receiver_command"];
		    $receiver_filename = get_config_option("jffnms_real_path")."/engine/trap_receivers/".$receiver_command.".inc.php";

		    $backend_command = $record["backend_command"];
		    $backend_filename = get_config_option("jffnms_real_path")."/engine/backends/".$backend_command.".php";
		
		    if (file_exists($receiver_filename) && file_exists($backend_filename)) {
		
			include_once($backend_filename);
		        include_once($receiver_filename);

			$parameters = $record;
		        $parameters["trap"] = $trap;
		        $parameters["trap_vars"] = $trap_vars;
		        $parameters["trap_vars_oid"] = $trap_vars_oid;
		        $parameters["host_id"] = $host_id;
			$parameters["host_ip"] = $trap["ip"];
				
		        list($receiver_matched, $receiver_result) = call_user_func_array("trap_receiver_".$receiver_command, array($parameters));
	
			if ($receiver_matched) {
			
			    $backend_parameters = array_merge ($parameters, $receiver_result);

			    $backend_result = call_user_func_array("backend_".$backend_command, array($backend_parameters, NULL));

			    logger( 
				"T ".$trap["id"].":= Recevier ".$receiver_command."(".vd($parameters).") => ".
	    			"Backend ".$backend_command." (".vd($receiver_result).") => ".$backend_result."\n");
		    
			    if ($record["stop_if_matches"]==1) 	//if we have to stop processing after this trap matches
				$matched = true;		// do not try other receivers
			} else
		    	    logger( "T ".$trap["id"].":= Receiver ".$receiver_command." did not match.\n");	    
		    } else
		    	logger( "T ".$trap["id"].":= ERROR: Receiver '".$receiver_command."' or Backend '".$backend_command."' does not exists.\n");	    
		}
	    
	    if (!$matched)
		logger( "T ".$trap["id"].":= Did not match any receiver.\n");	    
		
	    traps_analized($trap["id"]); //mark trap as analized
	}
    }
?>
