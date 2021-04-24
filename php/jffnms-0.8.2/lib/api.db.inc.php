<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function get_db_list($tables,$ids = NULL,$fields=NULL, $where= NULL, $order= NULL, $index = "", $groups = NULL, $limit_init = NULL, $limit_span = NULL) {

	if (!$tables) return FALSE;
	
	if (!$fields) $fields = "*";

	if (!is_array($ids)) $ids=array($ids);
	if (!is_array($tables)) $tables=array($tables);
	if (!is_array($fields)) $fields = array($fields);
	if (!is_array($order)) $order = array();
	if (!is_array($where)) $where = array();
	
	if ($groups) 
	    if (!is_array($groups)) $groups = array($groups);

	$where_array=array();
	$order_array=array();
	
	//debug($where);
	
	if ($index) $fields["aux_table_index"]=$index;

	foreach ($tables as $as=>$table)
	    if ($table) //if table is not null
	    if (is_numeric($as)) $tables_array[]=$table;
		else $tables_array[]="$table as $as";

	foreach ($fields as $as=>$field)
	    if (is_numeric($as)) $fields_array[]=$field;
		else $fields_array[]="$field as $as";
	
	foreach ($where as $type=>$aux) 
	    if ($aux) {
		if (!is_array($aux)) $aux=array($aux); //if its not an array create one
		if (is_numeric($type)) $where_array[]="and ".join (" ",$aux);
		    else $where_array[]=$type." ".join (" ",$aux);
	    }

	foreach ($order as $aux) $order_array[]=join (" ",$aux);

	if (count($ids) > 0) {
	
	    if ($index) $index_ids = $index;
	        else $index_ids = $tables[0].".id";
	    
            if (!isset($where_ids_aux)) $where_ids_aux = "";
            if (!isset($index_ids)) $index_ids = ""; 

	    foreach ($ids as $id) if ($id) $where_ids_aux .= " or ($index_ids = '$id')";     

	    if ($where_ids_aux) $where_array[] = "and ((1=2)".$where_ids_aux.")";
	}

        if (!isset($tables_text)) $tables_text = "";
        if (!isset($fields_text)) $fields_text = ""; 
	if (!isset($where_text)) $where_text = ""; 
    
	$tables_text .= join (", ",$tables_array);
	$fields_text .= join (", \n\t",$fields_array);
	$where_text  .= join (" \n\t",$where_array);
    
    	if (count($order_array) > 0) $order_text  = "order by ".join (", ",$order_array);

	if (count($groups) > 0) $group_text = "group by ".join(", ",$groups);

	if (!$limit_init) $limit_init = 0;
	if ($limit_span > 0) $limit_text = " LIMIT $limit_init,$limit_span";

        if (!isset($limit_text)) $limit_text = "";
        if (!isset($order_text)) $order_text = "";
        if (!isset($group_text)) $group_text = "";

	$query = "SELECT /*! HIGH_PRIORITY */ /* get_db_list() */ \n\t$fields_text \nFROM $tables_text \nWHERE (1=1) \n\t$where_text \n$group_text \n$order_text\n$limit_text\n";
	//debug ($query);
	$res = db_query($query) or die ("Query Failed - get_db_list() - $query - ".db_error());
	$info = array();

	while ($reg = db_fetch_array($res)) 
	    if ($index) $info[$reg["aux_table_index"]]=$reg; 
		else $info[]=$reg;

	return $info;
    }

    function db_insert ($table,$values) {
    
	if (is_array($values) && (count ($values) > 0)) {
	    $original_values = $values;
    
	    foreach ($values as $key=>$val) { 
		$fields[]=$key;
	        $values[$key]="'$val'";
	    }

	    $fields_text = join(",",$fields);
	    $values_text = join(",",$values);
	}
	
	$query = "insert into $table ($fields_text) VALUES ($values_text)";
	$result = db_query($query);

	if (!$result) 
	    logger ("Query Failed - table_insert($table) - $query - ".db_error());	
	else 
	    if (isset($original_values["id"]))
		$id = $original_values["id"];
	    else
		$id = db_insert_id();

	return $id;
    }

    function db_update( $table, $id, $table_data) { 
    
	if ($table && ($id >=0)) {
	    $query="Update $table set";
	
	    if (is_array($table_data))
		foreach ($table_data as $field => $value) 
		    $query_aux[]= "$field = '$value'";
	
	    $query_options = join($query_aux,",");
		    
	    $query .= " $query_options where $table.id = '$id'";
	    //debug($table_data);
	    //debug($query);
	    $result = db_query ($query) or die ("Query failed - db_update($table) - $query - ".db_error());
	}
	
	$result = (is_resource($result))?true:$result;
	return $result;
    }

    function db_delete ($table,$id,$field = "id") {

	$query="delete from $table where $field = '$id'";
	if (($id) && ($table)) $result = db_query ($query) or die ("Query failed - db_delete($table) - $query - ".db_error());
	return $result;
    }

function db_open() {
    global $dbhost,$dbuser,$dbpass,$db,$db_type;

    switch ($db_type) {
	case 'mysql' :	$result = @mysql_connect ($dbhost, $dbuser, $dbpass); //try to connect
			if (is_resource($result)) //if its a valid connection
			    mysql_select_db($db) or die ("Could not select DB - CON2".mysql_error($result)); //try to change the DB
			break;
			
	case 'pg':	$result = pg_connect("host=$dbhost dbname=$db user=$dbuser password=$dbpass");
			break;
    }

    if (!is_resource($result)) die ("DB($db_type): Could not connect to the Database.\n"); //print a message if we couldn't connect to the DB
    
    if ($result) { 
	$db_conn = array();
	$db_conn["handle"]=$result;
	$db_conn["type"]=$db_type;
    } else 
	$db_conn = NULL;

    return $db_conn;
}

function db_test() {
    global $dbhost,$dbuser,$dbpass,$db,$db_type;

    switch ($db_type) {
	case 'mysql' :	if (extension_loaded("mysql")) $result = @mysql_connect($dbhost, $dbuser, $dbpass);
			break;
			
	case 'pg':	if (extension_loaded("pgsql")) $result = @pg_connect("host=$dbhost dbname=$db user=$dbuser password=$dbpass");
			break;
    }
    return $result;
}

function db_set_handle($handle = NULL) {

    $GLOBALS["conexion"] = $handle;
}

function db_get_handle($auto_create = 1) {
    
    if ((!isset($GLOBALS["conexion"]) || !is_resource($GLOBALS["conexion"]["handle"])) && ($auto_create==1)) 
	$GLOBALS["conexion"] = db_open();
    
    return $GLOBALS["conexion"];
}

function db_close ($db_conn = NULL) {

    if (!isset($db_conn)) $db_conn = db_get_handle(0);
    
    if (is_resource($db_conn["handle"])) { 
	switch ($db_conn["type"]) {
	    case 'mysql':	$result = mysql_close($db_conn["handle"]);
				break;
				
	    case 'pg':		$result = pg_close($db_conn["handle"]);
				break;
	}
	db_set_handle(NULL);
	unset($db_conn);
	$db_conn=NULL;
    }
    return $db_conn;
}

    //Do the Real DB Query, but without reconnection logic
    function db_query_simple ($db_conn,$query) {

	switch ($db_conn["type"]) {
	    case "mysql":	
			$result = @mysql_query ($query,$db_conn["handle"]);
			
			break;
	
	    case "pg":	//postgres exeptions
			
			//limit
			if ($pos = stristr ($query," LIMIT")) { //FIXME when limit is a part of the query like in some tacacs messages
			    $limit_old = substr($query,strlen($query)-strlen($pos),strlen($query));
			    $limit_new = str_replace ("LIMIT","OFFSET",$limit_old);
			    $limit_new = str_replace (","," LIMIT ",$limit_new);
			    $query = str_replace ($limit_old,$limit_new,$query);
			}
			
			//insert
			if ($pos = stristr ($query,"INSERT INTO")) {
			    $insert_old = substr($query,12,strlen($query));
			    $table = substr($insert_old,0,strpos($insert_old," "));
			    $GLOBALS["conexion"]["insert_table"] = $table; //FIXME
			}
			
			$result = @pg_exec($db_conn["handle"],$query);

			break;
	}
	return $result;
    }


    //Calls the real DB Query, but includes a reconnection logic
    function db_query ($query) {
    
	$db_conn = db_get_handle();
	$try = 0;
	$max_tries = 5;
	
	//$db_query_time = time_usec();
	//echo "\n$query\n";

	$result = db_query_simple ($db_conn,$query);
    
	while (($result===false) && ($try++ < $max_tries)) { //if result is an error, try this 3 times
	    sleep(1); //wait
            db_ping($db_conn); //try to reconnect
            $result = db_query_simple ($db_conn,$query); //query again
	} 

	//$db_query_time = time_usec_diff($db_query_time);
	//echo "TIME: $db_query_time msec\n";

	return $result;
    } 

function db_fetch_array ($rs) {

    $db_conn = db_get_handle();

    switch ($db_conn['type']) {
	case 'mysql':	$result = mysql_fetch_array ($rs,MYSQL_ASSOC);
			break;
	case 'pg': 	$result = pg_fetch_array($rs,NULL,PGSQL_ASSOC);
			break;
    }
    return $result;
} 

function db_error ($db_conn = NULL) {

    if (!isset($db_conn)) $db_conn = db_get_handle(0);

    switch ($db_conn['type']) {
	case 'mysql':	$result = mysql_error($db_conn['handle']);
			break;

	case 'pg':	$result = pg_errormessage($db_conn['handle']);
			break;
    }
    return $result;
} 

function db_num_rows ($rs) {

    $db_conn = db_get_handle();

    switch ($db_conn['type']) {
	case 'mysql':	$result = mysql_num_rows($rs);
			break;

	case 'pg':	$result = pg_numrows($rs);
			break;
    }
    return $result;
} 

function db_free($rs) {

	$db_conn = db_get_handle();

	switch ($db_conn["type"]) {
		case "mysql":   $result = mysql_free_result ($rs);
				break;
		case "pg":      $result = pg_free_result($rs);
				break;
	}
	return $result;
}

function db_insert_id ($db_conn = NULL) {

    if (!$db_conn) $db_conn = db_get_handle();

    switch ($db_conn['type']) {
	case 'mysql':	$result = mysql_insert_id($db_conn['handle']);
			break;

	case 'pg':	
			$result = db_query("SELECT CURRVAL ('".$db_conn["insert_table"]."_id_seq')") or die ("db_insert_id(pg) - ".db_error()); //Ugly HACK
			list($result) = pg_fetch_array($result);
			break;
    }
    return $result;
} 

function db_affected_rows ($db_conn = NULL) {

    if (!$db_conn) $db_conn = db_get_handle();

    switch ($db_conn['type']) {
	case 'mysql':	$result = mysql_affected_rows($db_conn['handle']);
			break;

	case 'pg':	$result = pg_affected_rows($db_conn['handle']);
			break;
    }
    return $result;
} 

function db_copy_table ($from,$to,$cant = NULL) {

    if (!$db_conn) $db_conn = db_get_handle();

    if ($cant > 0) $limit = " LIMIT 0,$cant";

    switch ($db_conn['type']) {
	case 'mysql': 	$query="TRUNCATE TABLE $to";
			$result = db_query($query) or die("db_copy_table($from,$to,$cant) Error :".mysql_error());
			
			$query="REPLACE INTO $to SELECT * FROM $from order by id desc $limit;";
			$result = db_query($query);
			break;

	case 'pg':	$query="TRUNCATE TABLE $to; ".
			       "INSERT INTO $to SELECT * FROM $from order by id desc $limit;";
			if (is_resource(db_query($query))) $result = 1;
			    else $result = 0;
			break;
    }
    
    return $result;
} 

    function db_repair ($table) {

	$db_conn = db_get_handle();

	switch ($db_conn['type']) {
	    case 'mysql': 	
			$query="REPAIR TABLE $table";
			$result1 = db_query($query) or die("repair($table) Error :".mysql_error());
			
			$query="OPTIMIZE TABLE $table";
			$result2 = db_query($query) or die("optimize($table) Error :".mysql_error());
			
			$query="ALTER TABLE ".$table." AUTO_INCREMENT = 1;";
			$result3 = db_query($query) or die("auto_increment($table) Error :".mysql_error());
			
			$result1 = db_fetch_array($result1);
			$result2 = db_fetch_array($result2);
			
			$result = $result1["Msg_text"]."/".$result2["Msg_text"]."/".$result3;
			
			break;


	    case 'pg':	
			$query="VACUUM FULL VERBOSE ANALYZE $table;";
			$result1 = db_query($query) or die("vacuum($table) Error :".mysql_error());
                        if (is_resource($result1)) $result1 = "OK";

                        $query="REINDEX TABLE $table;";
                        $result2 = db_query($query) or die("reindex($table) Error :".mysql_error());
                        if (is_resource($result2)) $result2 = "OK";

                        $result = $result1."/".$result2;
			break;
	}
    
	return $result;
    } 


    //Checks the DB Connection status, and tries to reconnect
    function db_ping ($db_conn) {

	$result = true;

	switch ($db_conn["type"]) {
	    case "mysql": 	if (function_exists("mysql_ping"))
				    $result = mysql_ping ($db_conn["handle"]);
				break;

	    case "pgsql":	if (function_exists("pg_ping"))
				    $result = pg_ping($db_conn["handle"]);
				break;
	}

	if ($result===true) 
	    logger("db_ping(".$db_conn["type"].") Connection to DB Restored...\n");
	else
	    logger("db_ping(".$db_conn["type"].") Connection to DB Lost...\n");

	return $result;
    }

?>
