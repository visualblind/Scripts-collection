<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    class jffnms_satellites	extends internal_base_standard 	{ 
	var $jffnms_class = "satellites"; 
	var $jffnms_insert = array(description=>"New Satellite"); 
	
	//get data about satellites
        function get_all()		{ $params = func_get_args(); return call_user_func_array("satellites_list",$params); }
        function get_id()		{ $params = func_get_args(); return call_user_func_array("satellite_get_id",$params); }
        function get_data()		{ $params = func_get_args(); return call_user_func_array("satellite_get",$params); }
        function get_peers()		{ $params = func_get_args(); return call_user_func_array("satellite_get_peers",$params); }
	    
	//remote functions for query, relay and functions
        function send_ping()		{ $params = func_get_args(); return call_user_func_array("satellite_send_ping",$params); }
        function callback()		{ $params = func_get_args(); return call_user_func_array("satellite_callback",$params); }
        function decide_mode()		{ $params = func_get_args(); return call_user_func_array("satellite_decide_mode",$params); }
        function elect_one()		{ $params = func_get_args(); return call_user_func_array("satellite_elect_one",$params); }
        function query()		{ $params = func_get_args(); return call_user_func_array("satellite_query",$params); }
        function distribute()		{ $params = func_get_args(); return call_user_func_array("satellite_distribute",$params); }
        function triggered_update()	{ $params = func_get_args(); return call_user_func_array("satellite_triggered_update",$params); }

	//paths information
        function get_paths()		{ $params = func_get_args(); return call_user_func_array("satellite_get_paths",$params); }
        function clean_distribution_path(){ $params = func_get_args(); return call_user_func_array("satellite_clean_distribution_path",$params); }
        function get_last_distribution_path(){ $params = func_get_args(); return call_user_func_array("satellite_get_last_distribution_path",$params); }
    }

    function satellite_get_id ($url) { //get the id of a satellite based on an URI
	if ($url!="") {
	    $result = db_query("select id from satellites where url='$url';") or die("Query Failed - satellite_get_id($url) - ".db_error());
	    $num_rows = db_num_rows($result);
	    if ($num_rows==1) {
		$data = db_fetch_array($result);
		return $data["id"];
	    } else 
		if ($num_rows > 1) die ("More than one satellite with the same url");
	}
	return NULL;
    }

    function satellite_get ($id) { //get the DB record for a Satellite ID
	$data = Array();
    	if ($id > 0) {
	    $result = db_query("select * from satellites where id='$id' or (1 != '$id' and sat_group='$id') order by id asc;") or die("Query Failed - satellite_get($id) - ".db_error());
	    while ($aux= db_fetch_array($result))
		$data[$aux["id"]]=$aux;
	} 
	return $data;
    }

    function satellite_get_by_parent ($id,$group) { //get all satellites which parent is this ID or group
	$data = Array();
    	if ($id > 0) {
	    if ($group > 1) $group_filter = "or satellites.parent='$group'";

	    $result = db_query("
		select * from satellites where satellites.parent = '$id' $group_filter order by satellites.id asc;") or die("Query Failed - satellite_get_by_parent($id) - ".db_error());
	    while ($aux= db_fetch_array($result))
		if ($aux["id"]!=$id)
		    $data[$aux["id"]]=$aux;
	} 
	return $data;
    }

    function satellite_get_masters ($my_sat_id = NULL) { //get a list of all satellites marked as masters
	$data = Array();

	$query = "
	    SELECT id,url 
	    FROM satellites 
	    WHERE (sat_type = 1 or sat_type = 2)".

	    //if I'm a Local Master
	    (($my_sat_id!=NULL)?" or (id = $my_sat_id and sat_type = 5)":"")."
	
	    ORDER BY satellites.id asc";
	
	$result = db_query($query) or die("Query Failed - satellite_get_masters() - ".db_error());
	
	while ($aux= db_fetch_array($result))
	    $data[$aux["id"]]=$aux;

	return $data;
    }

    function satellites_list ($ids = NULL, $only_groups = 0) { //ge ta lists of satellites (to show)

	if ($only_groups == 1) {
	    $filter .= " and satellites.sat_type = 3";
	    $data[]=array(id=>1,description=>"(none)");
	}

	if ($only_groups == 2)
	    $filter .= " and satellites.sat_type != 4";
	
	if ($ids) {
	    if (!is_array($ids)) $ids = Array($ids);
	    $filter .= " and (1=2 or satellites.id = ".join(" or satellites.id = ",$ids).")";
	}
	    
	$result = db_query(
	    "select satellites.*, parents.description as parent_description, groups.description as group_description 
	    from satellites, satellites as parents, satellites as groups
	    where satellites.parent = parents.id and satellites.sat_group = groups.id 
	    $filter
	    order by satellites.id asc;") or die("Query Failed - satellite_get($id) - ".db_error());
	
	while ($aux = db_fetch_array($result)) {

	    if (!$ids) { //avoid loop
	    	$aux1 = current(satellites_list($aux["parent"]));
		$aux["parent_description"] = $aux1["description"];
	    }

	    if ($aux["sat_group"]==1) $aux["group_description"]="(none)";
	    else $aux["group_description"] = "Cluster ".$aux["group_description"];
	    
	    if ($aux["sat_type"]==3) 
	        $aux["description"]="Cluster ".$aux["description"];

	    if ($aux["id"]==1)
		$aux["parent_description"] = "(none)";

	    $data[$aux["id"]]=$aux;
	}
	return $data;
    }

    function satellite_get_peers ($sat_id) { //get all peers of a satellite (up and down the tree)
	if ($sat_id > 0) {

	    $sat = satellite_get($sat_id);

	    if (count($sat)==1) if ($sat[$sat_id][parent]!=$sat_id) $result[$sat[$sat_id][parent]]=$sat[$sat_id][parent];
	    else 
		foreach ($sat as $aux)
		    if ($aux[parent]!=$sat_id)
			$result[$aux[id]]=$aux[id];

	    $sat = satellite_get_by_parent($sat_id,$sat[$sat_id][sat_group]);
	    foreach ($sat as $aux)
		if ($aux[id]!=$sat_id)
		    $result[$aux[id]]=$aux[id];
	
	    if (is_array($result))
	    foreach ($result as $peer) {
		$sat = satellite_get($peer);
		
		if (count($sat) > 1) {
		    unset ($sat[$peer]); //group
		    unset ($result[$peer]);
		    foreach ($sat as $aux) $result[$aux[id]]=$aux[id];
		}
	    }
		
	}
	return $result;
    }

    function satellite_get_paths ($sat_id, $filter = NULL, $only_parents = 0, $deep=0) { //get all the paths leading to sat_id
	if ($sat_id > 0) {

	    $peers[]=$sat_id;
	    $i = 0;
	    
	    while (($search_id = current($peers)) && ($i++<5)) {
		
		$filter[] = $search_id;
		//echo "DEEP $deep: Searching sat $search_id, Filter ".join("-",$filter)."\n";
		
		if (!$path) { 
		    $sat = satellite_get($search_id);
		    if (count($sat)==1) 
			$path[simple][]=$sat[$search_id][id];
		    else 
			foreach($sat as $aux) $peers[$aux[id]]=$aux[id];
		} 
		
		if ($path) {
		    if ($only_parents==0) { 
			if (!($peers = satellite_get_peers($search_id))) break; //add peers
	
		    } else { //add only parents as peers
			if (!($sat = satellite_get($search_id))) break; //get satellite info

			foreach ($sat as $sat_data) {
			    $parent_id = $sat_data[parent]; //get its parent 
			    $parent_data = satellite_get($parent_id); //get parent information
			    if (count($parent_data) > 1) unset ($parent_data[$parent_id]); //for groups
			    
			    foreach ($parent_data as $pid=>$aux1) //for each parent (in a group)
				$peers[$pid]="$pid";	//add it as a peer
			}
		    }
		}
		
		foreach ($peers as $key=>$peer) //filter
		    if (in_array($peer,$filter)) unset($peers[$key]);
		reset($peers);
		
		//echo "DEEP $deep: Peers of $search_id:\n"; var_dump($peers);
		//echo "DEEP $deep: Path so Far $search_id:\n"; var_dump($path);

		if (count($peers) == 1) { 
		    $path[simple][]=current($peers);
		    //echo "DEEP $deep: Path (in_simple) so Far $search_id:\n"; var_dump($path);
		} else if (count($peers) > 1)
		    foreach ($peers as $id=>$peer) {
			//echo "DEEP $deep: Going to search for $id...\n";
			$new_path = satellite_get_paths($id,$filter,$only_parents,++$deep);
			//echo "DEEP $deep: New Path for $id:\n"; var_dump($new_path);

			if (count($new_path)==1) //only one new path, merge them 
			    $path[] = array_merge($path[simple],$new_path[simple]);
			else 
			    foreach ($new_path as $aux) // multiple new paths merge each with the simple we got
				$path[] = array_merge($path[simple],$aux);
		    
		    //echo "DEEP $deep: Path so Far(2)  $search_id:\n"; var_dump($path);
		    }
	    }
	    if (count($path) > 1) unset($path[simple]);
	    //echo "DEEP $deep: Finial Path\n"; var_dump($path);
	}
	return $path;
    }

    function satellite_clean_distribution_path ($paths, $my_sat_id) {
	if (is_array($paths))
	foreach ($paths as $path) 
	    if ((!$pos = array_search($my_sat_id,$path)) or //I'm not on the path
		($path[0]==$my_sat_id))	//i'm the last step
		    unset($path);
	    else {
		$path = array_slice($path,0,$pos); //take the path from me (pos) to the destination (0)
		$i++;
		foreach ($path as $step) 
		    $new_path[$i][]=$step; 
	    }
	return $new_path;
    }

    function satellite_clean_poller_path ($paths, $my_sat_id) {
	if (is_array($paths))
	foreach ($paths as $key=>$path) {
	    $pos = array_search($my_sat_id,$path);
	    if (($pos > 0) || ($pos===0)) //i'm in the path
		$new_path[$key] = array_slice($path,0,$pos); //get the path from the destination (0) to me (pos)
	}
	return $new_path;
    }

    function satellite_get_last_distribution_path ($paths) {
	if (is_array($paths))
	    foreach ($paths as $key=>$path) 
		$new_path[$key]=$path[count($path)-1]; //return the last step from every path
	return array_unique($new_path);
    }

    function satellite_get_first_distribution_path ($paths) {
	if (is_array($paths))
	    foreach ($paths as $key=>$path) 
		$new_path[$key]=$path[0]; //return the last step from every path
	return array_unique($new_path);
    }

    function satellite_distribute($sat_id,$host_ids = NULL,$to_sat_id = NULL, $debug = 0) {

	$info = Array();
	
	if (($host_ids) && (!is_array($host_ids))) $host_ids=Array($host_ids);
	if (!$to_sat_id) $to_sat_id = $sat_id; //if the destination is another satellite (triggered updates)
	
	$satellite_slave = satellite_get($sat_id);
	
	$my_sat_id = $GLOBALS[my_sat_id];

	if (count($satellite_slave)==1) {
	    $info[total_errors]=0;
	    $satellite_slave = current($satellite_slave);
	
	    $jffnms = new jffnms(0); //new jffnms object broker

	    $time_dist_total = time_usec();
    
	    //general data
	    $distribution_plan = Array (
    		"zones"=>NULL,
	        "hosts"=>NULL,
	        "pollers"=>NULL,
		"pollers_groups"=>NULL,
	        "pollers_backend"=>NULL,
		"pollers_poller_groups"=>NULL,
		"interface_types"=>NULL,
		"interface_types_fields"=>NULL,
		"interface_types_field_types"=>NULL,
		"clients"=>NULL,
		"slas"=>NULL
	    );
	    
	    //interface specific data
	    if (is_array($host_ids))
	    foreach ($host_ids as $host_id) {
		$distribution_plan["interfaces:$host_id"]=Array(host=>$host_id);
		$distribution_plan["interfaces_values:$host_id"]=array(
		    "add_tables"=>"interfaces",
		    "interfaces.id"=>"interfaces_values.interface",
		    "interfaces.host"=>$host_id);
	    }
	    
	    $distribution_plan["satellites"]=NULL;
	    $capabilities = unsatellize();
	    
	    foreach ($distribution_plan as $data_type_orig=>$filter) 
		if ($data_type_orig) {
		    list ($data_type,) = explode (":",$data_type_orig);
		    
		    $time_dist_export = time_usec();
		
		    $obj = $jffnms->get($data_type);
		    $data = $obj->export($filter);

		    $message = array(
			sat_id=>$to_sat_id,
			method=>"distribution",
			capabilities=>$capabilities,
			params=>array(	//only one parameter,
			    array(  	//an array with this values
			    data_class=>$data_type,
			    data=>$data,
			    filter=>$filter
			))
		    );
		    $time_dist_send = time_usec();
		    //$debug = true;
    
    		    if (!$debug) {
    			list ( $result, $result_raw ) = satellite_query ($satellite_slave[url],$message,"$my_sat_id",8);
			//$result = satellite_query ($satellite_slave[url],$message,"$my_sat_id",0);
			//debug ($result_raw);		
		    } else {
			//$message["params"]["data"][16]=array("id"=>9999,"zone"=>"adasda55666666655");
		    	//unset ($message["params"]["data"][16]);
			include_once ("/opt/jffnms/engine/satellite/distribution.inc.php");
			$result = satellite_distribution($message["params"]);
		    }
		    //debug ($result);
		    //die();

		    $time_dist_send = time_usec_diff($time_dist_send);
		    
		    //counters
		    $info[data][$data_type_orig][time_send]=$time_dist_send;
	
		    $info[data][$data_type_orig][sent]=count($data);
		    $info[total_sent] += $info[data][$data_type_orig][sent];

		    if (is_array($result)) { //if result is valid
			//pass stats from response
			$info["data"][$data_type_orig]["added"]=$result["added"];
			$info["data"][$data_type_orig]["modified"]=$result["modified"];
			$info["data"][$data_type_orig]["recv"]=$result["items"]-$result["deleted"];
			$info["data"][$data_type_orig]["deleted"]=$result["deleted"];
		    } else { //if response is invalid
			//record the raw_result for debug, and increase the error counter
			$info["data"][$data_type_orig]["error"]=$result_raw;
			$info["total_errors"]++;
			$info["data"][$data_type_orig]["added"]=0;
			$info["data"][$data_type_orig]["modified"]=0;
			$info["data"][$data_type_orig]["recv"]=0;
			$info["data"][$data_type_orig]["deleted"]=0;
		    }
	
		    $info["total_add"]  += $info["data"][$data_type_orig]["added"];
		    $info["total_mod"]  += $info["data"][$data_type_orig]["modified"];
		    $info["total_recv"] += $info["data"][$data_type_orig]["recv"];
		    $info["total_del"]  += $info["data"][$data_type_orig]["deleted"];
		    //break;
		}
	
    	    $info[total_time]= time_usec_diff($time_dist_total);

	    $info[traceroute]=$result[traceroute];
	    $info[items]=count($info[data]);
	    //$info[plan]=$distribution_plan;
	    $info[url]=$satellite_slave[url];
	}
	return $info;
    }

    function satellite_send_ping ($parent_rec,$sat_id,$session = "get", $comment = NULL) {
	$message = Array(
	    sat_id=>$sat_id,
	    method=>"ping",
	    session=>$session
	);

	$aux = satellite_query($parent_rec[url],$message,"$comment-ping",0);
	if (!is_Array($aux)) $aux = Array(result=>false,session=>"");
	
	return Array(result=>$aux[result],session=>$aux[session]);
    }

    function satellite_callback($method,$params = NULL, $class = NULL,$response = NULL) {
	
	$my_sat_id = $GLOBALS[my_sat_id];
	
	if ($class=="none") unset ($class);
	
	if ($class) $real_function = $class."_".$method;
	else $real_function=$method;

	if ((!function_exists($real_function)) && ($class)) { //try to load it
	    $function_file = get_config_option("jffnms_real_path")."/engine/$class/$method.inc.php";
	    
	    if (file_exists($function_file)) include_once($function_file);
	}
    	
	unset ($aux);
	
	if (function_exists($real_function))
	    $aux = call_user_func_array($real_function,$params); //FIXME call thru jffnms object
	else { //try object broker
	    $jffnms = &$GLOBALS["jffnms"];
	    $aux = $jffnms->proxy($class,$method,$params);
	} //FIXME detect errors
	    //$response[error][$my_sat_id]="ERROR: Function '$real_function' doesn't exists.";
	
	if (is_array($aux) && is_array($response)) $response = $response + $aux; //this way we keep the keys
	else $response = $aux;
	
	return $response;
    }

    function satellite_elect_one ($satellite_destinations,$my_sat_id,$sat_id) {
	if (is_array($satellite_destinations)) { //some valid source/destination
	    foreach ($satellite_destinations as $parent_sat_id=>$satellite_parent) { //ping to see if parent can reach the satellite
		$ping = satellite_send_ping(array(id=>$parent_sat_id,url=>$satellite_parent[url]),$sat_id,"get","$my_sat_id-elect_one");
		if ($ping[result]==false)
		    unset($satellite_destinations[$parent_sat_id]); //delete if it cant
		else { 
		    $satellite_destinations[$parent_sat_id][session]=$ping[session]; //save session data
		    $working_paths[$sat_id][count($satellite_parent[path])][$parent_sat_id]=$satellite_destinations[$parent_sat_id];
		}
	    }
	    
	    $cant = count($satellite_destinations);

	    if ($cant > 1)  //we dont want to amplify the backend, send this only once
	        $pos = rand (0,$cant-1);	//pick one random path  //FIXME select shorter
	    else 
	        $pos = 0;
		    
	    $keys = array_keys($satellite_destinations);
	    $satellite_destination = Array($keys[$pos]=>$satellite_destinations[$keys[$pos]]); //select only one satellite				
	    return $satellite_destination;
	}
    }	

    function satellite_decide_mode ($my_sat_id,$sat_id,$from_sat_id) { //find out if relay or direct
	
	$paths = satellite_get_paths ($sat_id);
	
	if (is_array($paths))
	foreach ($paths as $path) {
	    $pos = array_search ($my_sat_id,$path);

	    if  (($pos > 0) || ($pos===0))  	//i'm on the path
		$new_paths[]=array( 		
		    source_sat=>current(satellite_get($path[$pos-1])),
		    destination_sat=>current(satellite_get($path[$pos+1])),
		    path=>$path);
	}
	
	$mode = 0;

	if (is_array($new_paths)) { 	
	    $sat_host = $_SERVER["REMOTE_ADDR"];
	    
	    foreach ($new_paths as $path) { //verify valid source
	
		preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $path[source_sat][url],$aux); 	$src_host  = $aux[2];
		preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $path[destination_sat][url],$aux);	$dest_host = $aux[2];

		if ($sat_host == gethostbyname($src_host)) 	$src_host_ok 	= 1;	else $src_host_ok  = 0;
		if ($sat_host == gethostbyname($dest_host)) 	$dest_host_ok	= 1; 	else $dest_host_ok = 0;
		
		if (($src_host_ok) || ($dest_host_ok)) { //permited source or destination
	    	    if ($my_sat_id == $sat_id ) 	//the message is to me
		        $mode = 1;			//then direct
		    else { 
		        if ($sat_id == $path[destination_sat][id]) { //message to my peer (destination)
			    $satellite_destinations[$path[destination_sat][id]]=Array(url=>$path[destination_sat][url],path=>$path[path]); //for election in relay
			    $mode = 2; //for relay 
			} 
			
			if ($sat_id == $path[source_sat][id]) { //message to my peer (source)
			    $satellite_destinations[$path[source_sat][id]]=Array(url=>$path[source_sat][url],path=>$path[path]); //for election in relay
			    $mode = 2; //for relay
			} 

			if ($mode != 2) { //if relay has not been selected yet
			    if ($src_host_ok && $path[destination_sat] && ($path[destination_sat][id]!=$from_sat_id)) { //has source (means i'm in the middle)
			        $satellite_destinations[$path[destination_sat][id]]=Array(url=>$path[destination_sat][url],path=>$path[path]); //for election in relay
			        $mode = 2; //for relay
	    		    }
			    
			    if ($dest_host_ok && $path[source_sat] && ($path[source_sat][id]!=$from_sat_id)) { //has source (means i'm in the middle)
			        $satellite_destinations[$path[source_sat][id]]=Array(url=>$path[source_sat][url],path=>$path[path]); //for election in relay
			        $mode = 2; //for relay
			    }
			} 
			if ($mode==2) $valid_paths[]=$path[path];
		    } //not direct
		}//source or dest ok
	    }//foreach
	}//has paths

	if  (					//this is to take care of the first data distribution to a fresh satellite
	    ($mode==0) &&			//it will get an error if we dont do something,
	    (count(satellites_list()==1)) && 	//there are not satellites defined or only one (I still can be the only master)
	    ($my_sat_id=="")			//I have not been identified in the satellites I'm not the only satellite defined
	    ) $mode = 1;			//so Allow direct connection, I assume this is for distribution

//	$mode = 0;
	switch ($mode) {
	    case 0: $sat_mode = "error"; $error = "Connection from IP ".$_SERVER[REMOTE_ADDR]." claiming to be $from_sat_id to Satellite $sat_id is Not Allowed to go by me (Satellite $my_sat_id)".
				"\n".vd($paths).  //debug
				"\n".vd($new_paths).  //debug
				"\n".vd($satellite_destinations).  //debug
				""; break;
	    case 1: $sat_mode = "direct"; break;
	    case 2: $sat_mode = "relay"; break;
	}
	
	return Array(
	    mode=>$sat_mode,destinations=>$satellite_destinations,error=>$error,
	    my_sat_id=>$my_sat_id,sat_id=>$sat_id,valid_paths=>$valid_paths);
    }

    function satellite_triggered_update ($my_sat_id,$mod_sat_,$old_path) {
	$new_path = satellite_get_paths($mod_sat);


	if ($old_path = satellite_clean_distribution_path($old_path,$my_sat_id)) 
	    $dist_path1 = satellite_get_last_distribution_path($old_path);

	if ($new_path = satellite_clean_distribution_path($new_path,$my_sat_id)) 
	    $dist_path2 = satellite_get_last_distribution_path($new_path);

	//debug($old_path);
	//debug($new_path);
	//debug($dist_path2);
	//debug($dist_path1);

	if (is_array($dist_path2)) 
	foreach ($dist_path2 as $path_id=>$peer) 
	    foreach ($new_path[$path_id] as $next_step)
		$triggered[$next_step]=array($peer,$next_step);

	if (is_array($dist_path1)) 
	foreach ($dist_path1 as $path_id=>$peer) 
	    foreach ($old_path[$path_id] as $next_step)
		$triggered[$next_step]=array($peer,$next_step);

	//debug ($triggered);
	$info[errors]=0;
	if (is_array($triggered))
	foreach ($triggered as $aux) {
	    list ($next_step,$to_sat_id) = $aux;

	    if ($to_sat_id!=$my_sat_id) {
		//debug("sending triggered update to $next_step for $to_sat_id...");

		$result = satellite_distribute($next_step,NULL,$to_sat_id); //FIXME list of hosts with the satellite
		
		unset ($result[data]);
		unset ($result[traceroute]);
	        $info[$to_sat_id]=$result;
		if ($result[total_errors] > 0) $info[errors]++;
		//debug ($result);
	    }
	    //break;
	} 
	return $info;
    }

    //Get My Satellite ID, and cache it
    function satellite_my_id () {
    
	if (!isset($GLOBALS["my_sat_id"])) {
	
	    //satellite
	    $jffnms_satellite_uri = get_config_option("jffnms_satellite_uri");
	    if ($jffnms_satellite_uri=="none") 
		$my_sat_id = 1; //Only Master Configuration, no satellites
	    else 
		$my_sat_id = satellite_get_id($jffnms_satellite_uri);
	    
	    if (!is_numeric($my_sat_id)) $my_sat_id = 1;
	    $GLOBALS["my_sat_id"]=$my_sat_id;
	}
	
	return $GLOBALS["my_sat_id"];
    }

?>
