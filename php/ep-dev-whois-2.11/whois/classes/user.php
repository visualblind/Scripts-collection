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
//	EP-Dev Whois User Class
//	Class that contains all user-related functions.
//	Date: 3/29/2005
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_User
{
	var $key_prefix;

	var $ip_address;

	var $CORE;

	function EP_Dev_Whois_User(&$global, $prefix)
	{
		// load core
		$this->reloadCore($global);

		// start session
		@session_start();

		$this->key_prefix = $prefix;

		$this->ip_address = $this->discoverIP();

		if ($this->getValue("queries") === false)
			$this->setValue("queries", array());
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
	//	get User IP
	//	RETURN: user ip address.
	/* ------------------------------------------------------------------ */

	function getIP()
	{
		return $this->ip_address;
	}

	
	/* ------------------------------------------------------------------ */
	//	Discover user ip
	//	Discovers user ip and stores.
	/* ------------------------------------------------------------------ */
	
	function discoverIP()
	{
		if (isset($_SERVER))
		{
			if (isset($_SERVER["HTTP_X_FORWARDED_FOR"]))
				$ip = $_SERVER["HTTP_X_FORWARDED_FOR"];
			elseif(isset($_SERVER["HTTP_CLIENT_IP"]))
				$ip = $_SERVER["HTTP_CLIENT_IP"];
			else
			   $ip = $_SERVER["REMOTE_ADDR"];
		}
		else
		{
			if (getenv('HTTP_X_FORWARDED_FOR'))
				$ip = getenv('HTTP_X_FORWARDED_FOR');
			elseif (getenv('HTTP_CLIENT_IP'))
				$ip = getenv('HTTP_CLIENT_IP');
			else
				$ip = getenv('REMOTE_ADDR');
		}
		
		return $ip;
	}


	/* ------------------------------------------------------------------ */
	//	Add Query
	//	Adds session domain query data of $domain and $ext.
	/* ------------------------------------------------------------------ */
	
	function addQuery($domain, $ext)
	{
		$query = $this->getValue("queries");
		$index = count($query);

		$query[$index]['domain'] = $domain;
		$query[$index]['ext'] = $ext;
		$query[$index]['time'] = time();

		$this->setValue("queries", $query);
	}


	/* ------------------------------------------------------------------ */
	//	Get Query Number
	//	RETURN: number of domain queries currently stored.
	/* ------------------------------------------------------------------ */
	
	function getQueryNum()
	{
		return count($this->getValue("queries"));
	}


	/* ------------------------------------------------------------------ */
	//	get Query data
	//	Fetches $query associated to $id.
	//	RETURN: $query or FALSE (on failure)
	/* ------------------------------------------------------------------ */
	
	function getQuery($id)
	{
		$query = $this->getValue("queries");

		if (isset($query[$id]))
			return $query[$id];
		else
			return false;
	}


	/* ------------------------------------------------------------------ */
	//	Get session value of $key
	//	Returns session value of $key
	/* ------------------------------------------------------------------ */
	
	function getValue($key)
	{
		if (isset($_SESSION[$this->key_prefix . $key]))
			return $_SESSION[$this->key_prefix . $key];
		else
			return false;
	}


	/* ------------------------------------------------------------------ */
	//	Set session value of $key to $value
	/* ------------------------------------------------------------------ */
	
	function setValue($key, $value)
	{
		$_SESSION[$this->key_prefix . $key] = $value;
	}

}