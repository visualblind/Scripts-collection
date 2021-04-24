<?
/* TACACS+ Consoliator is part of JFFNMS
 * Copyright (C) <2002> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

	$query_tipos="Select types.id as id_tipos from types where description = 'Command'"; //esto esta muy MAL!!!!BAD
    	$result_tipos = db_query ($query_tipos) or die ("Query failed - TAC0 - ".db_error());
	//logger( "TACACS SQL: $query_tipos\n");    

	if (db_num_rows ($result_tipos) > 0) { 
	    $registro_tipos = db_fetch_array($result_tipos);
    	    extract($registro_tipos);
	        
	    $query_tacacs = "
		SELECT 	acct.id as id_tacacs, acct.date,acct.usern as value_user, acct.c_name as source_ip,
			acct.elapsed_time, acct.type, acct.cmd as command, hosts.id as id_host
		FROM 	acct, hosts 
		WHERE 	(hosts.ip_tacacs = acct.s_name OR hosts.ip = acct.s_name) AND analized = 0 
		ORDER BY acct.id asc";

    	    $result_tacacs = db_query ($query_tacacs) or die ("Query failed - TAC1");

	    //logger( "TACACS SQL: $query_tacacs\n");    
	
	    logger( "TACACS+ Events to Process: ".db_num_rows($result_tacacs)."\n");

	    while ($registro_tacacs = db_fetch_array($result_tacacs)) {
		extract($registro_tacacs);
		logger( "TACACS+ Event: ID: $id_tacacs // date: $date // host: $id_host // user: $value_user // origin: $source_ip // time: $elapsed_time // type: $type // cmd: $command\n");
		
    		$value_interface = "command";
	
		if ($command == "") {
		    if ($type == "START") 	$value_info = "Session Start from $source_ip";
		    if ($type == "STOP") 	$value_info = "Session Finished $elapsed_time sec, $source_ip";
		    if ($type == "REJECT") 	$value_info = "Rejected Password, connection from $source_ip";
	
		    $value_state = strtolower($type);
		} else {
		    $command = str_replace(array("limit","'","offset"),"",$command);
		    $command = addslashes ($command); //check for ' in the command
		    $value_info = $command;
		    $value_state = "active";
		}
		
		insert_event($date, $id_tipos, $id_host, $value_interface, $value_state, $value_user, $value_info, $id_tacacs);  

		tacacs_analized($id_tacacs);
	    }     
	}    
?>
