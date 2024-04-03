<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    error_reporting(7);
/*

ALTER TABLE interface_types CHANGE COLUMN autodiscovery_parameters autodiscovery_parameters varchar(200) NOT NULL default ''; # was varchar(40) NOT NULL default ''


ALTER TABLE interface_types ADD COLUMN autodiscovery_parameters_new varchar(200) default ''; 
UPDATE interface_types set autodiscovery_parameters_new = autodiscovery_parameters;
ALTER TABLE interface_types DROP COLUMN autodiscovery_parameters;
ALTER TABLE interface_types RENAME COLUMN autodiscovery_parameters_new to autodiscovery_parameters;

*/

    $types["tinyint(1)"]="int2";
    $types["tinyint(3)"]="int2";
    $types["tinyint(10)"]="int2";
    $types["int(5)"]="int2";
    $types["int(6)"]="int2";
    $types["int(10)"]="int4";
    $types["decimal(12,2)"]="float8";
    $types["char(10)"]="varchar(10)";
    $types["char(60)"]="varchar(60)";
    $types["char(100)"]="varchar(100)";
    $types["varchar(30)"]="varchar(30)";
    $types["char(250)"]="varchar(250)";
    $types["longtext"]="text";    
    $types["varchar(100)"]="varchar(100)";

    $fp = fopen("php://stdin","r");
    
    while ($line = fgets($fp)) {
	$new_sql="";
	//echo $line;
	
	//CHANGE
	if (	preg_match("/ALTER TABLE (\S+) CHANGE COLUMN (\S+) (\S+) (\S.+) NOT NULL default (\S+);/",$line,$parts) ||
		preg_match("/ALTER TABLE (\S+) CHANGE COLUMN (\S+) (\S+) (\S.+) DEFAULT (\S+) NOT NULL;/",$line,$parts)	||
		preg_match("/ALTER TABLE (\S+) CHANGE COLUMN (\S+) (\S+) (\S.+) NOT NULL;/",$line,$parts)
		) {
	    //var_dump($parts);
	
	    $table = $parts[1];
	    $old_field = $parts[2];
	    $new_field = $parts[3];
	    $type = $parts[4];
	    $def = $parts[5];
	    
	    $type = $types[str_replace(" ","",strtolower($type))];
	    
	    if ($type!=NULL) {
		$temp_field = $new_field."_new_convert";

		$new_sql .=	"ALTER TABLE $table ADD COLUMN $temp_field $type; \n";
	        if (!empty($def)) $new_sql .=	"ALTER TABLE $table ALTER COLUMN $temp_field SET DEFAULT $def;\n";
		$new_sql .=	"UPDATE $table set $temp_field = $old_field;\n";
	        $new_sql .=	"ALTER TABLE $table DROP COLUMN $old_field CASCADE;\n";
	        $new_sql .=	"ALTER TABLE $table RENAME COLUMN $temp_field to $new_field;\n";
	    }
	}

	//ADD
	if (preg_match("/ALTER TABLE (\S+) ADD COLUMN (\S+) (\S.+) NOT NULL default (\S+);/",$line,$parts) || 
	    preg_match("/ALTER TABLE (\S+) ADD (\S+) (\S.+) DEFAULT (\S+) NOT NULL ;/",$line,$parts)    ) {

	    $table = $parts[1];
	    $new_field = $parts[2];
	    $type = $parts[3];
	    $def = $parts[4];

	    $type = $types[str_replace(" ","",strtolower($type))];
	    
	    $new_sql .=	"ALTER TABLE $table ADD COLUMN $new_field $type;\n";
	    $new_sql .=	"UPDATE $table SET $new_field = $def;\n";
	    $new_sql .=	"ALTER TABLE $table ALTER COLUMN $new_field SET DEFAULT $def;\n";
	}

	//ADD INDEX
	if (preg_match("/ALTER TABLE (\S+) add index (\S+) \((\S.+)\);/i",$line,$parts)) {
	    //var_dump($parts);
	
	    $table = $parts[1];
	    $field = $parts[2];
	    $fields = $parts[3];

	    $new_sql .=	"CREATE INDEX $field"."_".$table."_index on $table ($fields);\n";
	}

	//DROP INDEX
	if (preg_match("/ALTER TABLE (\S+) drop index (\S+);/",$line,$parts)) {
	    //var_dump($parts);
	
	    $table = $parts[1];
	    $field = $parts[2];

	    $new_sql .=	"DROP INDEX $field"."_".$table."_index;\n";
	}

	//CREATE TABLE - omit it 
	if (preg_match("/CREATE TABLE (\S.+)/",$line,$parts)) 
	    $new_sql = "";

	//ONLY FOR PG
	if (preg_match("/--- PG --- (\S.+)/",$line,$parts)) {
	    //var_dump($parts);
	
	    $new_sql .=	$parts[1]."\n";
	}

        //ONLY FOR MY - OMIT IT
        if (preg_match("/--- MY ---/",$line,$parts)) {
            //var_dump($parts);

    	    unset($new_sql);
        }

	//DROP TABLE
	if (preg_match("/DROP TABLE (\S+);/",$line,$parts)) {
	    $table = $parts[1];

	    $new_sql .=	"DROP TABLE $table CASCADE;\n";
	}

	//SET AUTONUMERIC
	//SELECT SETVAL('pollers_poller_groups_id_seq',(select case when max(id)>1000 then max(id) else 1000 end from pollers_poller_groups));
	//ALTER TABLE profiles_values AUTO_INCREMENT = 300;
	if (preg_match("/ALTER TABLE (\S+) AUTO_INCREMENT = (\d+);/",$line,$parts)) {
	    //var_dump($parts);
	
	    $table = $parts[1];
	    $value = $parts[2]-1;

	    $new_sql .=	"SELECT SETVAL('".$table."_id_seq',(select case when max(id)>$value then max(id) else $value end from ".$table."));\n";
	}
	
	if (isset($new_sql)) {
	    if (empty($new_sql)) 
		$new_sql = $line; //if it was not converted show the old line, no parsing required
	    echo $new_sql;	
	}
    }
    fclose ($fp);
?>
