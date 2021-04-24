<?php
function versioninfo(){
	global $config;
	
	$result = @file("http://www.particlesoft.net/getlatest/particlewhois.txt");
	if (!$result){
		$txt = "Unable to get version information";
	} else {
		$version  = intval($result[0]);
		$tversion = intval($config["versionint"]);
		
		if ($version > $tversion){
			$txt = "There is a newer version of the script available";
		} elseif ($version == $tversion){
			$txt = "You are running the latest version";
		} else {
			$txt = "You appear to be running an unreleased version";
		}
	}
	
	return $txt;
}
?>