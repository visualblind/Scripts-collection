<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    include("../../conf/config.php");

    $data = file ($_SERVER["argv"][1]);

    function sql_values ($values) {
	$len = strlen($values);
	$parsed = array();
	$string = false;
	$data = "";
	
	for ($i = 0; $i < $len; $i++) {
	    $char = $values[$i];
	
	    if ($char=="`") $char = "'";
	    
	    if ($char=="'") //string start
		$string = !$string;
	
	    if (($char==",") && !$string) {
		$parsed[]=trim($data);
		$data = "";
		$string = false;
	    } else
		$data.= $char;
	}
	if (!empty($data) || ($data==="0")) $parsed[]=trim($data);
	
	return $parsed;
    }

    function next_value($table) {
	return current(db_fetch_array(db_query("SELECT MAX(id) FROM ".$table)))+1;
    }
    
    function regen_sql ($table, $rec) {
	
	foreach ($rec as $field=>$value) {
	    $fields[]="`".$field."`";
	    $values[]=$value;
	}
	
	$fields = join(", ",$fields);
	$values = join(", ",$values);
	
	$query = "INSERT INTO `".$table."` (".$fields.") VALUES (".$values.");";
	
	return $query;
    }

    function new_value (&$records, &$rec, $field, $lookup_table) {
	$orig_value = str_replace("'","",$rec[$field]);
	
	if ($orig_value > 10000) {
	    $new_value = $records[$lookup_table][$orig_value]["_new_id"];
    
	    if (!is_numeric($orig_value))
		logger ("Error $field (".$rec["id"]."): orig error = ".$orig_value."\n");
	    elseif (!is_numeric($new_value))
		logger ("Error $field (".$rec["id"]."): new error = ".$new_value."\n");
	    else
		$rec[$field] = $new_value;
	}
    }
    foreach ($data as $line)
	switch (true) {
	    case (preg_match("/INSERT INTO (\S+) \((.+)\) VALUES \((.+)\)/i", $line, $matches)):
		list (,$table, $fields, $values) = $matches;

	        $table = str_replace("`", "", $table);
	        $fields = sql_values($fields);
	        $values = sql_values($values);
		
		for ($i=0; $i < count($fields); $i++)
		    $rec[str_replace("'","",$fields[$i])]=$values[$i]; 

	        if (!is_numeric($new_ids[$table]))
	    	    $new_ids[$table] = next_value($table);
		
		$rec["_new_id"] = $new_ids[$table]++;
		
		$records[$table][$rec["id"]] = $rec;
		unset ($rec);
	    break;
	
	    default:
		echo $line."\n";
	} 

    foreach ($records as $table=>$recs) 
	foreach ($recs as $old_id=>$aux) {
	    $rec = &$records[$table][$old_id];

	    switch ($table) {
		case "interface_types":
		    new_value ($records, $rec, "autodiscovery_default_poller", "pollers_groups");
		    new_value ($records, $rec, "graph_default", "graph_types");
		    new_value ($records, $rec, "sla_default", "slas");
		break;

		case "interface_types_fields":
		    new_value ($records, $rec, "itype", "interface_types");
		break;

		case "graph_types":
		    new_value ($records, $rec, "type", "interface_types");
		break;

		case "syslog_types":
		    new_value ($records, $rec, "type", "types");
		break;

		case "types":
		    new_value ($records, $rec, "alarm_up", "types");
		break;

		case "pollers_groups":
		    new_value ($records, $rec, "interface_type", "interface_types");
		break;

		case "pollers_backend":
		    if ($rec["command"]=="'alarm'")
			new_value ($records, $rec, "parameters", "types");
		break;

		case "pollers_poller_groups":
		    new_value ($records, $rec, "poller", "pollers");
		    new_value ($records, $rec, "backend", "pollers_backend");
		    new_value ($records, $rec, "poller_group", "pollers_groups");
		break;
	    }	    
	    unset($rec);
	} 

    foreach ($records as $table=>$recs) 
	foreach ($recs as $old_id=>$rec) {
	    $new_id = $rec["_new_id"];
	    unset ($rec["_new_id"]);
	    
	    $rec["id"] = $new_id;
	    echo regen_sql($table, $rec)."\n";
	}
?>
