<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

//DEBUG
//-----------------------------------------

    function logger($text, $show_date = true) {
	global $sat_id, $method;

	$text = (($show_date==true)?date("H:i:s")." ":"").$text;

	if (get_config_option("jffnms_debug")==1) {

	    $file = str_replace(".php","",basename($GLOBALS["jffnms_logging_file"]));
	    $filename = get_config_option("log_path")."/".$file."-".date("Y-m-d").".log";

	    $log = fopen($filename,"a+");
	    fputs($log, $text);
	    fclose($log);
	}
	
	//if (!isset($sat_id) && !isset($method)) //don't show anything if we're on a satellite //FIXME
	    echo $text;
    }

    function debug($text) {
	echo "\n<PRE>";
	print_r($text);
	echo "</PRE>\n";
	flush();
    }

    function d($text) {
	echo "\n<PRE>";
	var_dump($text);
	echo "</PRE>\n";
	flush();
    }


    function vd_tab ($cant) {
	return @str_repeat("\t",$cant);
    }

    function vd($data,$pos = 1) {
	$result = vd_tab($pos-2).gettype($data)."(";
	if (is_array($data)) {
	    $result .= count($data).") { \n";
	    foreach ($data as $key=>$value) 
		$result.= vd_tab($pos)."[$key] => ".vd($value,$pos+1)."\n";
	    $result .= vd_tab($pos)."} \n";
	} else 
	    $result.= strlen(strval($data)).") \"$data\"";
	return $result;
    }

// TIME FUNCTIONS
//-----------------------------------------

    function time_usec() {
	$u_sec = 1000000; //in microsec usec
	$milli_sec = 1000; //in millisec msec
	$in_sec = 1; //in seconds
	
	$sec = $in_sec; //set to seconds
	$sec = $milli_sec; //set to milli seconds
		
	$a = gettimeofday();
	$b = ($a["sec"]+($a["usec"]/1000000))*$sec;
	return $b;
    }

    function time_usec_diff($b,$a=NULL) {
	if (!$a) $a = time_usec();
	$c = round ($a-$b,2);
	return $c;
    }


//CONFIGURATION
//------------------------------------------

    function get_config_option($option) { 
	return $GLOBALS["jffnms_configuration"][$option]["value"]; 
    }
    
    function save_configuration ($file, $config = array(), $really = false) {
	global $jffnms_configuration;

	$new_config_name = $file . "." . date("Y-m-d",time());
	
	foreach ($config as $key=>$value)
	    if ($value!=$jffnms_configuration[$key]["default"])
		$new_config .= $key." = ".$value."\n";

	$fp = fopen($new_config_name,"w+");
	@fputs($fp, $new_config);
	@fclose($fp);
    
	if (($really==true) && (file_exists($new_config_name))) 
	    copy($new_config_name, $file);
    }


//MISC
//---------------------------------------------

    function dec2hex($dec) {
	$hex=dechex($dec);
	if (strlen($hex)==1) $hex="0$hex";
	return $hex;
    }

    function str_encode($str,$decode = 0) {
	$from = "ab'cdefghij1:234567890kl=mnozABCDE<FGHI}JKLM;NOPQRSTUV>WXY{Zpqrstuvwxy";
	$to   = "nopq34'56tuvwxyr;sWX2zaTU:VY01789=ZABCDEFbcde<fghijkl{m>NOPQRS}GHIJKLM";

	if ($decode==1)	return strtr($str, $to, $from);
	else return strtr($str, $from, $to);
    }

    /*
	Function:      object2array
	Purpose:       Convert an object to an array recursively: 
    	               all object children will be converted to arrays too
    */
    function object2array ( $object ) {
	if ( !is_object ( $object ) && !is_array($object) ) // if $object is not an object nor an array
    	    return $object;	// return it as is
	
	$ret = array ();	// create return array

	if (is_array($object))
	    $v = $object;	//take it as an array
	else
	    $v = get_object_vars ( $object ); // retrieve all object properties and values
	
	while ( list ( $prop, $value ) = each ( $v ) )  // create key=>value pairs for all $prop=>value pairs
    	    $ret [ $prop ] = object2array ( $value );
	
	return $ret;
    }

    function satellize($data_to_send,$capabilities = NULL) {
	if (isset($data_to_send)) {	

	    if (!$capabilities) $capabilities = unsatellize(); //default
	    if (strlen($capabilities)==1) $only_one = TRUE; else $only_one = FALSE;
	    
	    if (strpos($capabilities,"V")!==FALSE) {
		if (!$only_one) $data_header .= "V";
		$data_to_send = vd($data_to_send);
	    }

	    if (strpos($capabilities,"S")!==FALSE) {
		if (!$only_one) $data_header .= "S";
		$data_to_send = serialize($data_to_send);
	    }

	    if (strpos($capabilities,"W")!==FALSE) 
		if (strpos($capabilities,"S")===FALSE) { //not using Serialize
		    if (!$only_one) $data_header .= "W";	//only if other capabilties are support, add the tag
		    $data_to_send = wddx_serialize_value($data_to_send);
		}

	    if (strpos($capabilities,"R")!==FALSE)
	    if (is_string($data_to_send)) {
		if (!$only_one) $data_header .= "R";
	        $data_to_send = str_encode($data_to_send);
	    }

	    if (strpos($capabilities,"O")!==FALSE) { //soap
		if (!$only_one) $data_header .= "O";

		//create SOAP Response
		require_once 'SOAP/Server.php';
		$server = new SOAP_Server;

    		$return_val = $server->buildResult($data_to_send, $a);
		$qn =& new QName($GLOBALS["method"].'Response',"urn:JFFNMS");
		$methodValue =& new SOAP_Value($qn->fqn(), 'Struct', $return_val);

		header("Content-Type: text/xml; charset=UTF-8");
		$data_to_send = $server->_makeEnvelope($methodValue, $header_results, "UTF-8");

		unset($server);
	    }
	    
	    if ($data_header) $data_ready = $data_header."|";
	    
	    $data_ready .= $data_to_send;
	}
	return $data_ready;
    }
    
    function unsatellize($data = NULL, $capabilities = NULL) {
	
	if (($data) && (strpos(substr($data,0,10),"|")===FALSE)) { //if no header recived add the default capabilties, probably only one is there like W
	    if (!$capabilities) $capabilities = unsatellize();
	    $header = $capabilities;
	    $data_to_recv = $data;
	} else {
	    $pos = strpos($data,"|");
	    $header = substr($data,0,$pos);
	    $data_to_recv = substr($data,$pos+1,strlen($data)-$pos);
	}

	for ($i=strlen($header); $i >= 0 ; $i--) //des satellize in reverse order 
	    switch ($header[$i]) {
		case "S":	
				$data_to_recv = unserialize(stripslashes($data_to_recv));
				break;

		case "W":	
				$data_to_recv = wddx_deserialize(stripslashes($data_to_recv));
				break;

		case "R":	
				$data_to_recv = str_encode($data_to_recv,1);
				break;
		
		case "O":	if (is_string($data_to_recv)) { //because it may be already decoded

				    //SOAP Server Request Decoding    
				    require_once 'SOAP/Server.php'; 
				    $server = new SOAP_Server;
				
				    $parser =& new SOAP_Parser($data_to_recv,"UTF-8",$attachments);
				    $data_to_recv = $server->_decode($parser->getResponse()); 
				    $data_to_recv = object2array($data_to_recv);
	
				    unset($server);
				}
				break;

	    }
	$data_ready = $data_to_recv;

	if (!$data) { //send capabilties
	    $data_ready = "S"; 	
	    if (extension_loaded("wddx")) $data_ready.="W";
	    //$data_ready .= "R";
	}
	return $data_ready;
    }

    function unsatellize_headers ($raw_headers, $capabilities) {

	$headers = array();
	for ($i=strlen($capabilities); $i >= 0 ; $i--) //des satellize in reverse order 
	    switch ($capabilities[$i]) {
		case "O": //SOAP
			    $data = unsatellize($raw_headers,$capabilities);
			    $raw_headers = preg_replace("/(\r|\n|\(\?\#.*\))/", "", $raw_headers); //take the \r\n's out
			    
			    $headers["sat_id"] = $data["sat_id"];
			    $headers["class"] = $data["class"];
			    
			    if (preg_match("/<SOAP-ENV:Body>(\s*|)<\S+:(\S+)(>| xmlns)/",$raw_headers,$parts)) 
				$headers["method"] = $parts[2];
			    
			    $headers["session"] = $data["session"];
			    $headers["params"] = $data["params"];

			    unset($data);
			    break;
	
		case "W": //WDDX
			    if ($raw_headers!==NULL) {
				$headers = unsatellize($raw_headers,$capabilities);
				
				$headers["params"] = satellize ($headers["params"],$capabilities); //Re-satellize parameters
			    }    
			    break;
		default :	
			    //FIXME get data from _SERVER
			    //OR do Nothing, because the values will be already decoded
			    break;
	    }

	return $headers;
    }	

    function array_copy_value_to_key($array){ 
	foreach($array as $value) $result[$value]=$value;
	return $result;
    }

    function ad_set_default($var,$value) {
	if (!isset($var)) $var = $value;
    }

    function is_process_running ($process_name = NULL, $number_of_instances = 1) {
	
	if (!isset($process_name))			//if process name is not set
	    $process_name = $_SERVER["PHP_SELF"];	//use the current process name

	$process_name_len = strlen($process_name);
	$found = 0;
	
	if ($process_name_len > 1)			//if name is rigth
	if (get_config_option ("os_type")=="unix") {	//if we are on a Unix OS
	
	    exec("ps axo args",$ps_list); //call 'ps'

	    if (count($ps_list) > 0)
		foreach ($ps_list as $process) {
		    $pos = strpos($process,$process_name);
		    if (($pos!==false) && (($pos+$process_name_len)==strlen($process))) //if proc_name is at the end of the process string
			$found++;

		    if ($found >= $number_of_instances) //if we have found enogh instances
	    		return true;
		}
	}
	return false;
    }

    function create_command_line ($command_line) {
	if (get_config_option("os_type")=="windows") 
	    $open = "start /MIN $command_line";
	else 
	    $open = $command_line." &";

	return $open;
    }
    
    function jffnms_shared ($module) {
	return get_config_option("jffnms_real_path")."/engine/shared/".$module.".inc.php";
    }

    function spawn ($command = false, $parameters = "", $max_instances = 2) {
	if (!$command) $command = get_config_option("php_executable")." -q ".$_SERVER["argv"][0];
	
	$command_line = "$command $parameters";
			
        if (is_process_running($command_line,$max_instances) === false) {

	    $open = create_command_line($command_line);    
	    echo "Executing: $open\n";
		    
	    $p = popen($open,"w");
	} else 
	    logger ($command_line." is already running $max_instances times.\n");
    }

    function array_key_sort($arr, $keys) {
        reset ($arr);
        while (list($key, $row) = each ($arr))
            foreach ($keys as $sortk=>$sort_type)
                $aux[$sortk][$key] = $row[$sortk];

        foreach ($keys as $sortk=>$sort_type) {
            $params[]=$aux[$sortk];
            $params[]=$sort_type;
        }
        $params[]=&$arr;

        call_user_func_array("array_multisort",$params);
    }

    function convert_sql_sort ($fields, $sort) {
	$result = array();

	foreach ($sort as $aux) {
	    list ($key, $order) = $aux;
	    $new_key = array_search($key, $fields);
	    
	    $field_name = is_numeric($new_key)?end(explode(".",$key)):$new_key;
	    $order = ($order=="desc")?SORT_DESC:SORT_ASC;
	    
	    if ($field_name=="interface") $order = SORT_NUMERIC;

	    $result[$field_name]=$order;
    	}
	
	//debug ($result);
	return $result;    
    }

    function array_rekey($array, $key, $old_key_name = false) {
    
	reset($array);
	
	while (list($old_key,$data) = each ($array)) {
	    $new_key = $data[$key];
	    $new[$new_key]=$data;

	    if ($old_key_name!==false) 
		$new[$new_key][$old_key_name]=$old_key;
	}
	
	return $new;
    }

    function array_search_partial($search, $array_in) {

	foreach ($array_in as $key => $value)
	     if (strpos($value, $search) !== false)
		return $key;
    
	return false;
    }					    
    
    function arristr($haystack='', $needle=array()) {

        foreach($needle as $n)
	    if (stristr($haystack, $n) !== false)
		return true;
	 
	return false;
    }

    function time_hms () {
	//Find the first numeric parameter
	$args = func_get_args();
	while (($unixtime = current($args)) && !is_numeric($unixtime) && ($aux = next($args)));

	return str_pad(floor($unixtime/(60*60)),2,"0",STR_PAD_LEFT).date(":i:s",$unixtime);
    }

    function array_record_search ($rows, $needle_field, $needle_value) {
	$result = array();
	
	if (is_array($rows)) {
	    reset($rows);

	    while (list ($id, $row) = each ($rows))
		if ($row[$needle_field] == $needle_value)
		    $result[$id]=$row;
	}
	
	return $result;
    }    
    
    function byte_format($input, $dec = 0) {
	$prefix_arr = array("", "K", "M", "G", "T");
        $value = round($input, $dec);

	while ($value > 1024) {
	    $value /= 1024;
	    $i++;
	}
	
	$return_str = round($value, $dec)." ".$prefix_arr[$i];
	return $return_str;
    }
    
    function detach() {
	if (function_exists("pcntl_fork") && ($GLOBALS["start_debug"]!=1)) {
	    if (($launcher_forkpid = pcntl_fork()) == -1) 
    		die("could not fork\n");
	    else 
		if ($launcher_forkpid) // we are the parent
		    exit();
    
	    return true;
	}
	
	return false;
    }

?>
