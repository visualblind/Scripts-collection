<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function find_file ($file, $dirs) {
	while ( (list(,$dir) = each($dirs)) && 
		($new_file = $dir."/".$file) && 
		(false === ($result = file_exists($new_file))));

	return ($result)?$new_file:false;
    }

    function parse_config_file ($file, $base = array()) {
	$data = file($file);
	$config = $base;
	
	while (list(,$line) = each ($data)) 
	    if (!empty($line) && preg_match("/([^:\t\s]+)(:(\S+))?(\s)*=(\s)*(.+)$/", $line, $parts)) {
		$variable = trim($parts[1]);
		$field = (!empty($parts[3])?trim($parts[3]):"value");
		$value = trim($parts[6]);
		
		$config[$variable][$field] = $value;

		if (($field=="default") && (!isset($config[$variable]["value"])))
		    $config[$variable]["value"] = $value;
	    } 

	return $config;
    }
?>
