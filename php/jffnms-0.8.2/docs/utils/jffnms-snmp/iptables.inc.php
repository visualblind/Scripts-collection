<?
/* This file is part of JFFNMS
 * Copyright (C) <2004> Hans Peter Dittler <hpdittler@braintec-consult.de>
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function tree_iptables () {

    $table_names_file = "/proc/net/ip_tables_names";
    $iptables="/usr/sbin/iptables";

    if (file_exists($iptables)!==true)
	$iptables = "/sbin/iptables";

    $tables_names = file($table_names_file);	// read the names of iptables from proc
    $table_id = 1;

    $chain_id = 1;
    $dyn_chain_id = 1001;
    //$rule_id = 1;

    
    foreach ($tables_names as $table) {		// dump now each table
	
	$table = trim($table);

	$tables[$table_id]["index"]=$table_id;
	$tables[$table_id]["name"]=$table;	// insert table index and table name into array tables

	unset ($result);
	exec($iptables." --line-numbers -xvnL -t ".$table, $result);	//dump chains and rules for each table

	$pos = 0;
	
	foreach ($result as $data) {
	    $data = trim($data);

	    if ($pos==0) { // first line of a chain defines name
		
		// this is a built-in chain: Chain OUTPUT (policy ACCEPT 1 packets, 32 bytes)
		if (preg_match ("/^Chain (\S+) \(policy (\S+) (\d+) packets, (\d+) bytes\)/", $data, $parts)) { 

		    $chains[$chain_id]["index"]	= $chain_id;
		    $chains[$chain_id]["table"]	= $table_id;
		    $chains[$chain_id]["name"]	= $parts[1];
		    $chains[$chain_id]["policy"]= $parts[2];
		    $chains[$chain_id]["packets"]=$parts[3];
		    $chains[$chain_id]["bytes"]	= $parts[4];

		    truncate_counter($chains[$chain_id]["packets"]);
		    truncate_counter($chains[$chain_id]["bytes"]);

		    $chain_id++;
		}		

		// this is a dynamic chain: Chain forward_dmz (1 references)
		if (preg_match ("/^Chain ([\S\.]+) \((\S+) references\)/", $data, $parts)) {

		    $chains[$dyn_chain_id]["index"] = $chain_id;
		    $chains[$dyn_chain_id]["table"] = $table_id;
		    $chains[$dyn_chain_id]["name"]  = $parts[1];
		    $chains[$dyn_chain_id]["policy"]= "dynamic";

		    // dynamic chains have no counters, must be added manually
		    $chains[$dyn_chain_id]["packets"]= 0;
		    $chains[$dyn_chain_id]["bytes"]  = 0;
	
		    $dyn_chain_id++;
		}
	    }

	    //RULES DISABLED
		// match a rule line of format 
		// line bytes packets rule proto opt  ifin ifout  source      dest              options
		//  7     0      0     LOG  all  --    *      *   0.0.0.0/0  217.160.132.152    LOG flags 6 level 4 prefix `SuSE-FW ON '
	    /*
	    if (($pos>1)  && is_array($chains[$chain_id]) &&
		preg_match ("/^(\d+)\s+(\d+)\s+(\d+)\s+([\S\.]+)\s+(\S.+)/",$data,$parts)) {

		$rules[$rule_id][index] = 	str_pad($table_id,2,"0",STR_PAD_LEFT).
						str_pad($chain_id,3,"0",STR_PAD_LEFT).
						str_pad($parts[1],4,"0",STR_PAD_LEFT);

		$rules[$rule_id][chain]=$chain_id;
		$rules[$rule_id][target]=$parts[4];
		$rules[$rule_id][description]=$parts[5];

		$rules[$rule_id][packets]=$parts[2];
		$rules[$rule_id][bytes]=$parts[3];

	        truncate_counter($rules[$rule_id][packets]);
	        truncate_counter($rules[$rule_id][bytes]);
		    
		for ($i = 0; $i < 10 ; $i++)
		    $rules[$rule_id][description] = trim(str_replace("  "," ",$rules[$rule_id]["description"]));
		
		$rule_id++;
	    }
	    */
	    
	    $pos++;

	    if (empty($data)) { // an empty line indicates end of chain
		$pos = 0;
		//$chain_id++;
	    }
	}
	
	$table_id++;
    }
    
    $info["tables"]=$tables;
    $info["chains"]=$chains;
    //$info[rules]=$rules;

   return $info;
}
?>
