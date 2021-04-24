<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //error_reporting(8);
    
    function sql_values ($values) {
	$len = strlen($values);
	$parsed = array();
	$string = false;
	$data = "";
	
	for ($i = 0; $i < $len; $i++) {
	    $char = $values[$i];
	
	    if ($char=="'") //string start
		if ($string==true) $string = false;
		else $string = true;
	
	    if (($char==",") && ($string==false)) {
		$parsed[]=$data;
		$data = "";
		$string = false;
	    } else
		$data.= $char;
	}
	if (!empty($data) || ($data==="0")) $parsed[]=$data;
	
	return $parsed;
    }

    $file = $_SERVER["argv"][1];
    if (!$file) $file = "php://stdin";
    
    $in = fopen($file,"r");
    $i=0;    
    while ($data = fgets($in)) 
	if (($data[0]=="+") || ($data[0]=="-")) 
	    $diffs[]=$data;
    fclose($in);
    
    $records = array();
    foreach ($diffs as $diff) {
	preg_match("/(\S)INSERT INTO (\S+) \((\S.+)\) VALUES \((\S.+)\);/",$diff,$parts);
	$table = $parts[2];
	$fields = explode(",",$parts[3]);
	$values = explode(",",$parts[4]);
	$values = sql_values($parts[4]);
	
	$type=$parts[1];
	
	if ($table) {
	    $records[$i]=compact("type","table","fields","values");
	    $records[$i++]["id"]=$values[0];
	}
    }
    unset($diffs);
    //var_dump($records);

    $diffs = array();
    if (is_array($records))
    foreach ($records as $rec) {
	$diffs[$rec["table"]]["fields"]=$rec["fields"];
	$diffs[$rec["table"]]["records"][$rec["id"]][$rec["type"]]=$rec["values"];
    }
    unset ($records);
    
    if (is_array($diffs))
    foreach ($diffs as $table=>$data) {

	$records = $data["records"];
	$fields = $data["fields"];

	foreach ($records as $id=>$record) {
	    $mods = array();
	    for ($i=0; $i < count($fields); $i++) 
		if ($record["-"][$i]!=$record["+"][$i]) 
		    if (isset($record["+"][$i])) $mods[$i]=$record["+"][$i];

	    unset($upd);

	    if (count($mods) == 0) {
		$sql = "DELETE FROM $table where id = $id;";
	    } else if (count($mods) == count($fields)) { //all fields insert
		    $sql = "DELETE FROM $table where id = $id; \nINSERT INTO $table (".join(", ",$fields).") VALUES (".join(", ",$record["+"]).");\n";
		} else { //some fields update
		    foreach ($mods as $field=>$data) $upd[]=trim($fields[$field]." = $data");
	    	    $sql = "UPDATE $table SET ".join(", ",$upd)." WHERE id = $id;";
		}
	    echo "$sql\n";
	}
    }
?>
