<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    function swap (&$r,$old,$new) {
        $o = $GLOBALS["old_r"];
        $r[$new]=$o[$old];
    }

    include("../../conf/config.php");

    if ($argv[1]=="release") $db="jffnms-upgrade";
    
    $query = "select * from interfaces where id > 1 and type > 1 order by type,id";
    
    $result = db_query($query);

    echo "\nConverting OLD interface table fields to the NEW interface_values table...\n";
    
    while ($old_r = db_fetch_array($result)) if (isset($old_r["interfacenumber"])) {
	$old_id = $old_r["id"];

	echo "\nConverting Interface $old_id, Type ".$old_r["type"]."\n";
	unset ($new_r);
	
	//make changes

	swap ($new_r,"description","description");
	
	switch ($old_r["type"]) {
	    
		//host information
	    case 12:	//Win
	    case 11:	//UCD
	    case 10:	//Solaris
	    case 3:	//Cisco
		swap($new_r,"bandwidthin","cpu_num");
		swap($new_r,"interfacenumber","index");
		break;	

	    case 2: //tcp port
		swap($new_r,"interfacenumber","port");
		break;
	    
	    case 8: //storage
		swap ($new_r,"interfacenumber","index");
		swap ($new_r,"bandwidthin","size");
		
		$a = strpos($new_r["description"]," ");
		
		if ($a === false) {
		    $new_r["storage_type"] = $new_r["description"];
		    unset ($new_r["description"]);
		} else {
		    $new_r["storage_type"] = substr($new_r["description"],0,$a);
		    $new_r["description"] = substr($new_r["description"],$a+1,strlen($new_r["description"]));
		}
		
		break;
	
	    case 14: //smokeping
		swap ($new_r,"interfacenumber","index");
		break;
	    
	    
	    case 20: //reachable
		swap ($new_r,"interfacenumber","index");
		break;
	    
	    case 4: //physical interfaces
		//do nothing
		$new_r = $old_r;
		break;
    
	    case 21: //TC
		swap ($new_r,"bandwidthin","rate");
		swap ($new_r,"bandwidthout","ceil");
		swap ($new_r,"interfacenumber","index");
		break;
    
	    case 9: //CSS VIPs
		swap ($new_r,"interfacenumber","index");
		swap ($new_r,"bandwidthin","bandwidth");
		swap ($new_r,"description","owner");
		break;
	    
		//Cisco ENVMIB
	    case 16: //Power Supply
	    case 17: //Temp
	    case 18: //Voltage
		//description is implicit
		swap ($new_r,"interfacenumber","index");
		break;	    

	    case 19: //SA Agent
		swap ($new_r,"interfacenumber","index");
		break;

	    case 13: //MAC Accounting
		swap ($new_r,"bandwidthin","ifindex");
		swap ($new_r,"peer","mac");
		swap ($new_r,"interfacenumber","index");
		break;
    
	    case 6: //BGP
		swap ($new_r,"interfacenumber","index");
		swap ($new_r,"peer","remote");
		swap ($new_r,"address","local");
		swap ($new_r,"description","asn");
		unset ($new_r["description"]);
		break;	

	    case 15: //Applications
		swap ($new_r,"interfacenumber","index");
		swap ($new_r,"bandwidthin","instanses");
		break;

	}
	
	foreach ($new_r as $field=>$value)
	    if (trim($value)==="") unset ($new_r[$field]);
	
	$not_update = array ("noerrors","id","type","host","sla","client","interface","poll","make_sound","show_rootmap","rrd_mode",
	    "creation_date","modification_date","last_poll_date");

	foreach ($not_update as $aux) {
	    unset ($new_r[$aux]);
	    unset ($old_r[$aux]);
	}
	
	echo "OLD Fields: ".join(",",array_keys($old_r))." = ".join(",",$old_r)."\n";
	echo "NEW Fields: ".join(",",array_keys($new_r))." = ".join(",",$new_r)."\n";
	
	$res = adm_interfaces_update($old_id,$new_r);
	$new_id = db_insert_id();
	echo "Result: $new_id - $res.\n";
    }

    echo "\n\nDroping OLD interface table fields...\n";

    $drops=array("description","address","peer","interfacenumber","noerrors","bandwidthin","bandwidthout","flipinout");

    foreach ($drops as $drop) {
    
	$sql = "ALTER TABLE interfaces DROP COLUMN $drop";
	echo "Deleting OLD $drop field from the interfaces table..."; 
	$result = db_query ($sql);
	echo " $result\n";
    }
    
?>
