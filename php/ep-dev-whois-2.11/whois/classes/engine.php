<?php
// --------------------------------------------
// | The EP-Dev Whois script        
// |                                           
// | Copyright (c) 2003-2005 EP-Dev.com :           
// | This program is distributed as free       
// | software under the GNU General Public     
// | License as published by the Free Software 
// | Foundation. You may freely redistribute     
// | and/or modify this program.               
// |                                           
// --------------------------------------------


/* ------------------------------------------------------------------ */
//	EP-Dev Whois Engine Class
//	Contains on functions related to single domain query. Acts as query
//	object for each domain search.
//	Date: 3/29/2005
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Engine
{
	var $CORE;


	var $domain;
	var $ext;
	var $server;
	var $server_id;

	var $available;
	var $whoisData;


	function EP_Dev_Whois_Engine($domain, $ext, &$global)
	{
		$this->reloadCore($global);

		$this->domain = $domain;

		if ($ext{0} == ".")
			$this->ext = substr($ext, 1);
		else
			$this->ext = $ext;

		// find server
		$this->server = $this->getServer();

		// server id
		$this->server_id = 0;
	}


	/* ------------------------------------------------------------------ */
	//	Reload Core
	//	Reloads the $global core object with updated links.
	/* ------------------------------------------------------------------ */
	
	function reloadCore(&$global)
	{
		$this->CORE = $global;
	}


	/* ------------------------------------------------------------------ */
	//	Lookup Domain
	//	Looks up domain by connecting to its server and downloading whois.
	//
	//	Parameters: 
	//		$full_whois = true will force download of whois report.
	//	
	//	return:
	//		true: if successful in getting report
	//		false: unsuccessful (caused by error)
	/* ------------------------------------------------------------------ */
	
	function lookup($full_whois = false)
	{
		// connect to server
		$whoisSocket = @fsockopen($this->server,43, $errno, $errstr, $this->CORE->CONFIG->NAMESERVERS[$this->server]['timeout']);

		// check if connected
		if ($whoisSocket)
		{
			// if not full whois and limit bypass enabled and limit format is set
			if ($this->CORE->CONFIG->SCRIPT['limit_bypass'] && !$full_whois
				&& !empty($this->CORE->CONFIG->NAMESERVERS[$this->server]['limit_format']))
			{
				$used_limit = true;
				$request = $this->CORE->CONFIG->NAMESERVERS[$this->server]['limit_format'] . "\015\012";
			}
			
			// use normal format
			else
			{
				$used_limit = false;
				$request = $this->CORE->CONFIG->NAMESERVERS[$this->server]['format'] . "\015\012";
			}

			// replace templates with actual data
			$request = str_replace("[[DOMAIN]]", $this->domain, $request);
			$request = str_replace("[[EXT]]", $this->ext, $request);

			
			// +------------------------------
			//	Send domain data and get report
			// +------------------------------

			fputs($whoisSocket, $request);

			while(!feof($whoisSocket))
				$this->whoisData .= fgets($whoisSocket, 128);

			fclose($whoisSocket);


			// determine if available
			if (eregi($this->CORE->CONFIG->NAMESERVERS[$this->server][($used_limit ? "limit_keyword" : "keyword")], $this->whoisData))
				$this->available = true;
			else
				$this->available = false;

			$status = true;

			// convert new lines to <br>
			$this->whoisData = nl2br($this->whoisData);


			

			//echo $this->whoisData;
		}
		
		elseif ($server = $this->getServer())
		{
			// use backup server
			$this->server = $server;
			$status = $this->lookup($full_whois);
		}

		// else error with no server available
		else
		{
			$status = false;
		}

		return $status;
	}


	function getServerName()
	{
		if (!empty($this->server))
			return $this->server;
		else
			return $this->CORE->DOMAINS->getServer($this->ext, 0);
	}

	function getAllServerNames()
	{
		$i = 0;
		while($this->CORE->DOMAINS->getServer($this->ext, $i) != false)
		{
			$allServers[] = $this->CORE->DOMAINS->getServer($this->ext, $i);
			$i++;
		}

		return $allServers;
	}


	function getServer()
	{

		if ($this->CORE->DOMAINS->getServer($this->ext, $this->server_id) != false)
		{
			$server = $this->CORE->DOMAINS->getServer($this->ext, $this->server_id);
			$this->server_id++;
		}
		
		else
		{
			$server = false;
		}

		return $server;
	}


	function isAvailable()
	{
		return $this->available;
	}


	function getWhoisReport()
	{
		return $this->whoisData;
	}


	function getDomain()
	{
		return $this->domain;
	}


	function getExt()
	{
		return $this->ext;
	}


	function getPrice()
	{
		return $this->CORE->DOMAINS->getPrice($this->getExt());
	}
}