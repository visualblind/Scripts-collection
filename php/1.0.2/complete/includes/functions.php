<?php
// include other functions files
include("functions_admin.php");

function dbSecure($code){
	// check for needing encoding
	if (!get_magic_quotes_gpc()){
		$code = addslashes($code);
	}
	
	// return the value
	return $code;
}

// start session, can be called after sign out
function StartSession(){
	// process session ID if required
	ini_set('url_rewriter.tags', '');
	session_start();
}

// create a key for the email confirmation
function GenerateKey(){
	$salt = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
	srand((double)microtime()*1000000);  
    $i = 0;
    while ($i < 25) {  // change for other length
        $num = rand() % 33;
        $tmp = substr($salt, $num, 1);
        $pass = $pass . $tmp;
        $i++;
    }
    
    return $pass;
}

function SkinList($defaultvalue){
	
	// globalise variables
	global $config;
	
	// Open a known directory, and proceed to read its contents
	$codelist = "<select id=c_defaultskin name=c_defaultskin>\n";
	$tdir = $config["root"] . "skins/";
	$tdir = "skins/";
	if (is_dir($tdir)) {
		if ($dh = opendir($tdir)) {
			while (($file = readdir($dh)) !== false) {
				if ($file <> "." && $file <> ".." && filetype($tdir . $file) == "dir"){
					//echo "filename: $file : filetype: " . filetype($tdir . $file) . "<br />";
					$extracode = ($file == $config["defaultskin"]) ? " selected" : "";
					$codelist .= "		<option value=\"" . $file . "\"" . $extracode . ">" . $file . "</option>\n";
				}
			}
			closedir($dh);
		}
	}
	
	// finish the list
	$codelist .= "	</selected>";
	
	// return the list
	return $codelist;
}

function DoAlert($msg){
	// do nothing
}
?>