<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $smidump_executable = "/usr/bin/smidump";

    function MIBParser_identifiers($mib) {
	global $smidump_executable;
	
	$command = "$smidump_executable $mib -f identifiers";
	exec($command,$output);

	if (is_array($output)) {
	    next ($output);
	    while (list(,$line) = each($output)) 
		if ($line) {
		    $data = explode(" ",$line);
		    //var_dump($data);
		    $list[$data[1]]=$data[count($data)-1];
		}
	}
	return $list;
    }

    function MIBParser_data($mib) {
	global $smidump_executable;

	$command = "$smidump_executable $mib -f sming";
	exec($command,$output);

	if (is_array($output)) {
	    next ($output);
	    while (list($key,$line) = each($output)) {
		$ok = true;
		$line=trim($line);
	
		if (!$line) $ok = false;
		if (strpos($line,"//")!==false) $ok = false;
				
		if ($ok) {
		    $aux = explode (" ",$line);
		    unset($aux2);
		    foreach ($aux as $aux1)
			if ($aux1) $aux2[]=$aux1;
		    
		    $output[$key]=join(" ",$aux2);
		    //var_dump($aux2);
		    //echo $output[$key]."\n";
		} else
		    unset ($output[$key]);
	    }
	}	
	
	return $output;
    }

    function MIBParser_Process($data,$idents,$result,$part) {
	
	while (list($key,$line) = each ($data)) {

	    if ($line[strlen($line)-1]=="{") {
		
		list($section,$name) = explode (" ",$line);
		
		if ($name=="{") {
		    $name = rand();
		}
		
		if ($name) {
		    if ($idents[$name])
			$result[$section][$name][oid]=$idents[$name];

		    unset ($part);
		    $part[]=$line;
		    MIBParser_Process(&$data,&$idents,&$result[$section][$name],&$part);
		    $aux = join(" ",$part);
		}
		
		switch ($section) {
		    case "table": 
			preg_match ("/description \"(\S.+)\";/",$aux,$parts);
			$result[$section][$name][description]=$parts[1];
			break;
		    case "row":
			preg_match ("/index \((\S.+)\);( status .+;|)( create ;|) description \"(\S.+)\";/",$aux,$parts);
			$result[$section][$name][index]=$parts[1];
			$result[$section][$name][description]=$parts[4];
			break;
		    case "scalar":
		    case "column":
			preg_match ("/type (\S.+ |\S.+)(\(\S.+\)|); access (\S+); (units \"(\S.+)\"; |)description \"(\S.+)\";/",$aux,$parts);
			$result[$section][$name][type]=trim($parts[1]);
			$result[$section][$name][rw]=($parts[3]=="readonly")?0:1;
			if ($parts[5]) $result[$section][$name][units]=$parts[5];
			$result[$section][$name][description]=$parts[6];

			$values = Array();
			if ($parts[2]) {
			    $val = substr($parts[2],1,strlen($parts[2])-2);
			    $val1 = explode (", ",$val);
			    foreach ($val1 as $val2){
				preg_match("/(\S.+)\((\N.+)\)/",$val2,$aux);
				//$values[]=$aux;				
			    }
			    $values = $val;
			    $result[$section][$name][values]=$values;
			}
			break;
		    case "module":
			preg_match ("/organization \"(\S.+)\"; contact \"( |)(\S.+)\"; description \"(\S.+)\";/",$aux,$parts);
			$result[$section][$name][organization]=$parts[1];
			$result[$section][$name][contact]=$parts[3];
			$result[$section][$name][description]=$parts[4];
			
			break;
		    case "revision":
			preg_match ("/date \"(\S.+)\"; description \"(\S.+)\";/",$aux,$parts);
			$result[$section][$name][date]=$parts[1];
			$result[$section][$name][description]=$parts[2];
			break;
		}
	    } else
		$part[]=$line;
	
	    if ($line=="};") return 0;
	}
    }   
    
    function MIBParser($mib) {
	$idents = MIBParser_identifiers($mib);
	$mib_data = MIBParser_data($mib);
	reset($mib_data);
	//var_dump($mib_data); die();
	
	$result = Array();
	MIBParser_Process(&$mib_data,&$idents,&$result,Array());
	$mib_name = key($result[module]);
	return Array(name=>$mib_name,mib=>$result[module][$mib_name]);
    }
    
    $mib_dir = "/usr/share/snmp/mibs/";
    
    if (!$mib_file) {
	$handle = opendir($mib_dir);
	while (false !== ($file = readdir($handle))) 
	    echo "<a href='$SCRIPT_NAME?mib_file=$file'>$file</a><br>";
    }
    
    if (!$mib_file) die();
    
    $mib = MIBParser ($mib_dir.$mib_file);
    
    //var_dump($mib);
    
    $ques=array(
	"[graph][0][0]"=>"Graph1",
	"[graph][0][1]"=>"Graph1",
	"[graph][1][0]"=>"Graph2",
	"[graph][1][1]"=>"Graph2",
	"[interface][name]"=>"Interface Name",
	"[interface][description]"=>"Interface Description",
	"[interface][number]"=>"Interface Number(index)",
	"[interface][speed]"=>"Interface Speed",
	"[interface][oper]"=>"Interface Operational Status",
	"[interface][admin]"=>"Interface Admin Status",
	"[alarm]"=>"Interface Status"
    );
    
    echo "<table border=1>\n";
    echo "<tr><td><H1>".$mib[name]."</H1></td></tr>\n";

    foreach ($mib[mib][table] as $table_name=>$table){
	echo "<tr><td>";
	echo "<table border=1>\n";
    	echo "<tr><td><H2>$table_name <small>(".$table[oid].")</small></H2></td></tr>\n";
	echo "<tr><td colspan=".(count($ques)+1)."><small>".$table[description]."</small></td></tr>\n";

	foreach ($table[row] as $row_name=>$row){
    	    echo "<tr><td><H3>$row_name</H3> <small>".$row[description]."</small></td>";
	    foreach ($ques as $aux)
		echo "<td align='center'>$aux</td>\n";
	    echo "</tr>\n";
	    
	    foreach ($row[column] as $col_name=>$column){
    		echo "<tr><td><H4>$col_name</H4> 
		    <small>
		    <u>Type:</u> ".$column[type]." (".(($column[rw]==1)?"Read/Write":"ReadOnly").")<br> ";
		
		if ($column[values]) echo "<u>Values:</u> ".$column[values]."<br>";
	    
		echo "
		    <u>Description:</u> ".$column[description]."
		    </small>
		    </td>\n";
		
		foreach (array_keys($ques) as $aux)
		    echo "<td align='center'><input type='radio' name='table[$table_name]$aux' value='$col_name'></td>\n";

		echo "</tr>";
	    }

	}
	echo "</td></tr>";
	echo "</table>\n";
    
    }
    echo "</table>\n";
?>