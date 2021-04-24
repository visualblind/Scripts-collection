<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_tcp_port_content ($options) {

    if ($options["check_content"]==1) {

	$buffer = &$GLOBALS["session_vars"]["poller_buffer"];

	//URL Parsing
	//-----------
	$tcp_data = &$buffer[$options["poller_parameters"]."-".$options["interface_id"]];

	if (!empty($options["check_url"])) //we have a URL to check
	    $url = $options["check_url"];
	else 
	    if (empty($tcp_data)) { //if didn't have data directly from TCP
	
		$allowed_protos = array("http","ftp","https","ftps"); //protos we can handle

		list ($proto, $param) = explode ("|",$options["description"]);
		$proto_token = strpos($proto,"://");

	        if ($proto_token===FALSE) 
	    	    $proto_type = $proto;
		else
		    $proto_type = substr($proto,0,$proto_token);
	    
		if (in_array($proto_type, $allowed_protos))
		    $url = (($proto_token===FALSE)?"$proto_type://":$proto).$options["host_ip"].":".$options["port"].$param;
	    } 

	//Data Gathering
	//--------------
	
	if (!empty($url)) { 
	    if (!isset($buffer["tcp_port_content"][$url]))
		$buffer["tcp_port_content"][$url]= file($url);
	
	    $data = $buffer["tcp_port_content"][$url];

	    if (is_array($data)) $data = implode("",$data);
	} else
	    $data = $tcp_data; //if we didn't have a URL then use the tcp data;

	
	//Analisis
	//--------
	
	$valid = false;
	
	if ($data!==false) { //if we didn't had an error
	
	    if (!empty($options["check_regexp"])) { //if we have a regular expression set, use it.
		
		if (strpos($options["check_regexp"],"\\")!==false) //if the user escaped its regexp take it like it is.
		    $regexp = $options["check_regexp"];
		else //if he didn't then take it as a simple regexp (without grab) and escape it 
		    $regexp = preg_quote($options["check_regexp"]);    

		$regexp = "/$regexp/i";
		echo "REGEXP: $regexp\nDATA: $data\n"; //DEBUG
		
		if (preg_match($regexp,$data,$parts)==true) {
		    var_dump($parts); //DEBUG
		
		    $valid = true;
		
		    if (count($parts) > 1)  //more parts means with grab, so take all the parts except the first one as the result
			$data = join(" ",array_slice($parts,1,count($parts)));
		}
	    } else
		if (strlen($data) >= 60) // if we didn't have a Regular Expression to check, just check if its longer than 60 characters
		    $valid = true;
	}

	if ($valid == true)  
	    return "valid|".substr(trim(strip_tags($data)),0,40); //return part of the valid data
	else
	    return "invalid"; //has URL or TCP data, but data is invalid
    } else 
	return "valid|Not Checked"; //didn't have check_content=1, or didn't have an allowed proto (because it didn't have a check_url)
}

?>
