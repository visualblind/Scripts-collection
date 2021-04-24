<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    // Frontend SNMP Functions for Current code.
    
    define ("INCLUDE_OID_NONE", false);
    define ("INCLUDE_OID_ALL", true);
    define ("INCLUDE_OID_BASE", "10");
    define ("INCLUDE_OID_1", "11");
    define ("INCLUDE_OID_2", "12");
    define ("INCLUDE_OID_3", "13");
    
    function snmp_walk ($host, $comm, $oid, $include_oid = INCLUDE_OID_NONE, $retries = 2) {

	$result = snmp_wrapper("walk", $host, $comm, $oid, $include_oid, $retries);
	
	if (is_array($result)) {
	    while (list ($key, $entry) = each ($result))
		$result[$key] = snmp_fix_value ($entry);	
	    
	    if ($include_oid > INCLUDE_OID_BASE)	//if we're asked to reduce the table key
		$result = snmp_reduce_table_key ($result, $include_oid-INCLUDE_OID_BASE);

	    reset($result);
	}

	//logger ("\nsnmpwalk $host:$comm $oid = ".vd($result)."\n");
	return $result;
    }

    function snmp_get ($host, $comm, $oid, $retries = 2) { 

	$result = snmp_wrapper("get", $host, $comm, $oid, false, $retries);

	if ($result!==false)
	    $result = snmp_fix_value($result);

	//logger ("\nsnmpget $host:$comm $oid = $aux\n");
	return $result;
    }
    
    function snmp_set ($host, $comm, $oid, $type, $value, $timeout = 2) { 

	$result = snmp_wrapper("set", $host, $comm, $oid.":".$type.":".$value, false, 1, $timeout);

	//logger ("\nsnmpset $host:$comm $oid $type $value = ".vd($result)."\n");
	
	return ($result)?true:false;
    }

    // SNMP Wrapper Function
    function snmp_wrapper($action, $ip, $raw_community, $oid, $include_oid = false, $retries = 2, $timeout = 1) {

	if ($raw_community[2]!==":")			// default
	    $raw_community = "v1:".$raw_community;	// SNMPv1

	$parsed_comm = explode(":", $raw_community);
	list ($version, $community) = $parsed_comm;
	
	if (empty($community)) return false;

	$snmp_func = "jffnms_".(($version=="v1")?"snmp1":(($version=="v2")?"snmp2":(($version=="v3")?"snmp3":"")));
	
	if ($action=="set")
	    list ($oid, $set_type, $set_value) = explode (":", $oid);
	    
	$oid = parse_oid($oid, $version);

	$params = compact("action", "ip", "community", "oid", "include_oid", "retries", "timeout", "set_type", "set_value");
	
	//logger ("\nCalling $snmp_func ".vd($params)."\n");
	return call_user_func_array ($snmp_func, array($params));
    }

    // Real SNMP Functions

    function jffnms_snmp1 ($p) {

	$params = array_merge(
	    array($p["ip"], $p["community"], $p["oid"]), 
	    (($p["action"]=="set")
		?array($p["set_type"], $p["set_value"])
		:array()),
	    array($p["timeout"]*1000000,$p["retries"])); 

	return @call_user_func_array("snmp".$p["action"].((($p["action"]=="walk") && ($p["include_oid"]))?"oid":""), $params);
    }

    function jffnms_snmp2_internal ($p) {

        $params = array_merge(
	    array($p["ip"], $p["community"], $p["oid"]), 
	    (($p["action"]=="set")
		?array($p["set_type"], $p["set_value"])
		:array()),
	    array($p["timeout"]*1000000,$p["retries"])); 
	
	$result = @call_user_func_array("snmp2_".((($p["action"]=="walk") && ($p["include_oid"]))?"real_":"").$p["action"], $params);
       
        if (is_string($result) &&
	    (preg_match("/No Such (Object|Instance)/i", $result) || preg_match("/No more variables left/i", $result)))
	    $result = false;
				       
	return $result;
    }
    
    function jffnms_snmp2 ($p) {

	if (function_exists("snmp2_get"))	//if we have native SNMPv2 functions
	    return jffnms_snmp2_internal ($p);	//call the internal SNMPv2 functions 

	$func = "snmp".$p["action"]." -v2c ".(!$p["include_oid"]?"-Oqv":"")." -c '".$p["community"]."' -t ".$p["timeout"]." -r ".$p["retries"]." ".
		$p["ip"]." ".$p["oid"].
		(($p["action"]=="set")?" ".$p["set_type"]." ".$p["set_value"]:"");

	//logger ("Command ".$func."\n");
	@exec($func, $result, $aux);

	if ((count($result)==1) && 
	    (preg_match("/No Such (Object|Instance)/i", current($result)) ||
	     preg_match("/No more variables left/i", current($result))))
	    $new_result = false; 

	else {
	
	    if ($p["action"]=="get") $result = join("\n",$result);

	    if ($p["include_oid"])
		foreach ($result as $key=>$aux) {
		    if (strpos($aux,"=")!==false) 
			$key = substr($aux, 0, strpos($aux,"=")-1);
		    $new_result[$key]=$aux;
		}
	    else
		$new_result = $result;
	}

	//d($new_result);
	return $new_result;
    }

    function jffnms_snmp3 ($p) {
	list ($user, $level, $auth_protocol, $auth_key, $priv_proto, $priv_key) = explode("|", $p["community"]);

	if (empty($priv_key)) $priv_key = $auth_key;

	$params = array_merge(
	    array($p["ip"], $user, $level, $auth_protocol, $auth_key, $priv_proto, $priv_key, $p["oid"]), 
	    (($p["action"]=="set")
		?array($p["set_type"], $p["set_value"])
		:array()),
	    array($p["timeout"]*1000000,$p["retries"])); 

	return @call_user_func_array(
	    "snmp3_".
	    ((($p["action"]=="walk") && ($p["include_oid"]))?"real_":"").
	    $p["action"], 
	    $params);
    }

    // Aux SNMP Functions
    
    function get_snmp_counter ($ip,$community,$oid) {

	$aux = explode(":",@snmp_get($ip,$community,$oid));

	$result = (count($aux)==1)?$aux[0]:$aux[1];

	return $result;
    }
    
    function parse_oid ($oid, $version = "v1") {
	list ($oid_32, $oid_64) = explode (",",$oid);
	
	return (($version=="v1") || empty($oid_64))?$oid_32:$oid_64;
    }

    function snmp_fix_value ($value) {

	$value=preg_replace("/INTEGER: /","",$value);
	
	if (preg_match("/^\"(\S.+)\"$/",$value,$parts)) $value = $parts[1];
	if (preg_match("/STRING: \"(\S.+)\"/",$value,$parts)) $value = $parts[1];
	$value=preg_replace("/STRING: /","",$value);

	$value = preg_replace("/IpAddress: /","",$value);

	$value = preg_replace("/Gauge32: /","",$value);
	$value = preg_replace("/Counter32: /","",$value);
	$value = preg_replace("/Counter64: /","",$value);

	if (strpos($value,"=")!==false) 					// if it has = in the value
	    $value = substr($value, strpos($value,"=")+2, strlen($value));	// return only the data after the =
    
	$value = trim ($value);
	
	return $value;    
    }
    
    function snmp_reduce_table_key ($table, $important = 1) {

	if (is_array($table) && (count($table) > 0)) {

	    reset ($table);
	    $new_table = array();
	    while (list ($key, $value) = each ($table)) {

		$new_key = join (".",array_slice(explode (".",$key),-($important)));
		$new_table[$new_key] = $value;
	    }
	    
	    return $new_table;    
	} else
	    return $table;
    }

    function snmp_hex_to_string ($hex) {
	$value = trim($hex);
	if (substr($value,0,3)=="Hex") { 
	    $data = substr($value,4,strlen($value)-5);

	    for ($i=0; $i < strlen($data) ; $i++) 
		if (ord($data[$i])==10) $data[$i]=" ";
		
	    $data_array = explode(" ",$data);
	    $value = "";
	    foreach ($data_array as $aux) if ($aux!="00") $value .= chr(hexdec($aux));
	}
	return $value;
    }


//MISC
//--------------------------------------------------------

    function http_post_message ($url,$vars,$raw_data = "", $debug = 0,$comment = NULL, $HTTP_MODE = "1.0") {

	unset($comment);    
	if ($comment) $url.="?method=".$vars[method]."&from=$comment";

	preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $url,$match);
	list(,$proto,$host,$port,$path) = $match;  

	if (!$port) $port = 80; 
	
	if ($proto=="https://") {
	    $host = "ssl://".$host;
	    $port = 443;
	}
	
	$user_agent = "JFFNMS";

	$urlencoded = "";
	while (list($key,$value) = each($vars))
	    if (!is_array($value))
		$urlencoded.= "$key=$value&";
	    else 
		$urlencoded.= "$key=".str_replace("&","%26",satellize($value))."&";


	$urlencoded = substr($urlencoded,0,-1);	

	$content_length = strlen($urlencoded);

	//Changed to HTTP/1.0 without KeepAlive
	$headers =	"POST $path HTTP/".$HTTP_MODE."\r\n".
			"Host: $host\r\n".
			(($HTTP_MODE=="1.1")?"Connection: close\r\n":"").
			"Content-Type: application/x-www-form-urlencoded\r\n".
			"User-Agent: $user_agent\r\n".
			"Content-Length: $content_length\r\n".
			"\r\n$raw_data";
	
	$fp = @fsockopen($host, $port, $errno, $errstr,4);
	if (!$fp) return false;

	$time_send = time_usec();

	$a = fputs($fp, $headers.$urlencoded);
	
	$time_send = time_usec_diff($time_send);
	if ($debug == 1) echo "time send: $time_send \n";
	
	if ($debug == 2) var_dump($headers.$urlencoded);

	$time_recv = time_usec();

	$ret = "";
	while (!feof($fp))
		$ret.= fgets($fp, 1024);
    	fclose($fp);

	$time_recv = time_usec_diff($time_recv);
	if ($debug == 1) echo "time recv: $time_recv \n";

	$init = strpos($ret,"\r\n\r\n");
	$data1 = substr($ret,$init+4,strlen($ret)-$init);
	
	if ($HTTP_MODE=="1.1") {
	    $init = strpos($data1,"\r\n")+2;
	    $len = strrpos($data1,"\r\n")-$init-4;
	} else {
	    $init = strpos($data1,"\r\n");
	    $len = strlen($data1)-$init;
	}	
	$data = trim(substr($data1,$init,$len));

	return $data;
    }

    function https_post_message ($url,$vars,$raw_data = "", $debug = 0,$comment = NULL) {

        unset($comment);
        if ($comment) $url.="?method=".$vars["method"]."&from=$comment";

        $user_agent = "JFFNMS";

        $urlencoded = "";
        while (list($key,$value) = each($vars))
            if (!is_array($value))
                $urlencoded.= "$key=$value&";
            else
                $urlencoded.= "$key=".str_replace("&","%26",satellize($value))."&";

        $urlencoded = substr($urlencoded,0,-1);

        $ch = curl_init();
        curl_setopt ($ch, CURLOPT_URL, $url);
        curl_setopt ($ch, CURLOPT_USERAGENT, $user_agent);
        curl_setopt ($ch, CURLOPT_SSL_VERIFYHOST,  2);
        curl_setopt ($ch, CURLOPT_HEADER, 0);
        curl_setopt ($ch, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt ($ch, CURLOPT_SSL_VERIFYPEER,  0);
        curl_setopt ($ch,CURLOPT_POST,1);
        curl_setopt ($ch, CURLOPT_POSTFIELDS,$urlencoded);

        $data = curl_exec ($ch);
        curl_close ($ch);

        return $data;
    }

    function soap_post_message ($url, $vars, $debug = 0,$comment = NULL) {
	
	require_once "SOAP/Client.php";

	$url = str_replace("soap://","http://",$url);
    	$options = array('namespace' => 'urn:JFFNMS', 'trace' => 1);
	$soapclient = new SOAP_Client("$url?capabilities=O");
	
	$method = $vars["method"];
	unset($vars["method"]);
	unset($vars["capabilities"]);
	$ret = $soapclient->call($method,$vars,$options);
	unset($soapclient);
	
	$ret = object2array($ret);

	if (is_array($ret["item"])) {
	    $aux = $ret["item"];
	    unset ($ret["item"]);
	    $ret = array_merge ($ret,$aux);
	}
	
	return $ret;
    }

    function wddx_post_message ($url,$vars,$raw_data = "", $debug = 0,$comment = NULL) {

	preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $url,$match);
	list(,,$host,$port,$path) = $match;  
	if (!$port) $port = 5000; 

	$send = satellize ($vars,"W");	

	$fp = fsockopen($host, $port, $errno, $errstr);
	if (!$fp) return false;

	fputs($fp, $send);

	$ret = "";
	while (!feof($fp))
		$ret.= fgets($fp, 1024);
    	fclose($fp);

	return $ret;
    }

    function satellite_query ($satellite_url,$message,$comment = NULL,$debug = 0) {
	//debug = 1, debug the transport
	//debug = 2, debug the RAW reply
	//debug = 4, debug the reply
	//debug = 8, return Result and Raw Result
    
	if (!$message["capabilities"] && ($message["session"]=="get")) //set capabilities when establishing a session
	    $message["capabilities"] = unsatellize();
    
	$message["from_sat_id"]=$GLOBALS["my_sat_id"]; //add my sat id as from
	
	preg_match("/^(.*:\/\/)?([^:\/]+):?([0-9]+)?(.*)/", $satellite_url,$match);
	$proto = $match[1];

	$result_raw = NULL;    

	switch ($proto) {
	    
	    case "https://" : 	$result_raw = https_post_message ($satellite_url,$message,"",$debug,$comment);
				break;

	    case "http://" : 	$result_raw = http_post_message ($satellite_url,$message,"",$debug,$comment);
				break;

	    case "soap://" : 	$result = soap_post_message ($satellite_url,$message,$debug,$comment); //no need to unsatellize
				break;

	    case "wddx://" : 	$result_raw = wddx_post_message ($satellite_url,$message,$debug,$comment);
				break;

	}

	if ($debug==2) var_dump($result_raw);
	
	if ($result_raw) $result = unsatellize($result_raw);

	if ($debug==4) var_dump($result);
	
	if ($debug==8) $result = array($result,$result_raw);
	
	return $result;
    }
    
    function satellite_call ($sat_id, $class, $method, $params = NULL) {

        $sat_url = current(satellite_get ($sat_id));
        $sat_url = $sat_url["url"];
	
	if (!is_array($params)) $params = array ($params);
	
	$message = array(
	    "sat_id"=>$sat_id,
	    "class"=>$class,
	    "method"=>$method,
	    "params"=>$params
	);
	
	$result = satellite_query ($sat_url, $message);
	
	return $result;
    }

    function extract_ip ($text) {
	
	$num= "(2[0-5]{2}|1\d\d|[0-9]{2}|[0-9])";

	if (preg_match("/$num\.$num\.$num\.$num/", $text, $matches))
	    return join(".", array_slice($matches,1));
	else
	    return $text;
    }
?>
