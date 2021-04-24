<?php
class Whois{

	// set up such things as server / extention list
	function Whois(){
	
		// globalise variables
		global $db, $dbprefix;
		
		$sql = "SELECT * FROM " . $dbprefix . "servers WHERE status = 1";
		$slist = $db->execute($sql);
		if ($slist->rows > 0){
			do {
			
				// loop through and set info
				$this->servers[$slist->fields["extention"]] = $slist->fields["server"];
				$this->errorsv[$slist->fields["extention"]] = $slist->fields["errormsg"];
			
			} while ($slist->loop());
		}
	
	}

	// check to see if domains are available
	function RunCheck($target, $type){
	
		// make sure it isn't too short
		if (strlen($target) < 3){
			$msg = "The domain you searched for was too short. It must be at least 3 characters.";
			return $msg;
		} elseif (strlen($target) > 63){
			$msg = "The domain you searched for was too long.";
			return $msg;
		}
		
		// check for invalid characters
		if(ereg("^-|-$", $target)){
			$msg = "Your search was invalid as it began or ended with a hyphen or contained a double hyphen";
			return $msg;
		}
		
		// check for invalid characters
		if(!ereg("([a-z]|[A-Z]|[0-9]|-){" . strlen($target) . "}", $target)){
			$msg = "Your search contained invalid characters";
			return $msg;
		}
		
		// ok, begin building results
		$result = "<ul>\n";
		
		// process each of the requests here
		if ($type == "all" || $type == "com"){
			$domain = $target . ".com";
			$loopupval = $this->Lookup($domain);
			$result .= "<li>" . $domain . " is " . $loopupval . "</li>\n";
		}
		
		if ($type == "all" || $type == "net"){
			$domain = $target . ".net";
			$loopupval = $this->Lookup($domain);
			$result .= "<li>" . $domain . " is " . $loopupval . "</li>\n";
		}
		
		if ($type == "all" || $type == "org"){
			$domain = $target . ".org";
			$loopupval = $this->Lookup($domain);
			$result .= "<li>" . $domain . " is " . $loopupval . "</li>\n";
		}
		
		if ($type == "all" || $type == "info"){
			$domain = $target . ".info";
			$loopupval = $this->Lookup($domain);
			$result .= "<li>" . $domain . " is " . $loopupval . "</li>\n";
		}
		
		if ($type == "all" || $type == "biz"){
			$domain = $target . ".biz";
			$loopupval = $this->Lookup($domain);
			$result .= "<li>" . $domain . " is " . $loopupval . "</li>\n";
		}
		
		// finish results
		$result .= "</ul>\n";
		
		// and return it
		return $result;
	}
	
	// function for opening connection and gaining result
	function Lookup($target, $full = 0){
		
		// globalise variables
		global $config;
		
		// set the variables
		$result = "";
		$serverex = explode(".", $target); $serverex = $serverex[1];
		
		// run the check
		$ns = fsockopen($this->servers[$serverex], $config["serverport"]);
		if (!$ns){ die("Error opening data connection"); }
		fputs($ns, $target . "\r\n");
		while(!feof($ns)) $result .= fgets($ns, 128);
		fclose($ns);
		
		// finalise result
		if (eregi($this->errorsv[$serverex], $result)) {
			if ($full == 1){
				$resulttext = nl2br($result);
			} else {
				$resulttext = "<strong>available</strong>";
				$resultnum = 1;
			}
		} else {
			if ($full == 1){
				$resulttext = nl2br($result);
			} else {
				$resulttext = "unavailable [ <a href=\"whois.php?domain=" . $target . "\">whois</a> | <a href=\"http://" . $target . "\">visit</a> ]";
				$resultnum = 0;
			}
		}
		
		// should this result be logged?
		if ($config["logresults"] == "1"){
			// log this result in the database
			$this->LogResult($target, $resultnum);
		}
		
		// return the result
		return $resulttext;
	}
	
	// for logging the results in the db
	function LogResult($domain, $result){
	
		// globalise variables
		global $db, $dbprefix;
		
		$sql = "SELECT * FROM " . $dbprefix . "results WHERE domain = '" . dbSecure($domain) . "'";
		$exists = $db->execute($sql);
		if ($exists->rows < 1){
			// first time search, log this result
			$sql = "INSERT INTO " . $dbprefix . "results (domain, available, postdate)";
			$sql .= " VALUES ('" . dbSecure($domain) . "', " . dbSecure(intval($result));
			$sql .= ", " . time() . ")";
		} else {
			// already logged, this is an update job
			$sql = "UPDATE " . $dbprefix . "results SET available = " . dbSecure(intval($result));
			$sql .= ", postdate = " . time() . " WHERE ID = " . $exists->fields["ID"];
		}
		
		// execute the command
		$db->execute($sql);
	}

}
?>