<?php
	/*
		AUTHOR: Jeremiah K. Jones
		COPYRIGHT: Jeremiah K. Jones - j.k.jones Co. 2003
		DISCLAIMER: This code may only be used with permission from
					Jeremiah K. Jones--the author, or from j.k.jones Co.
					
		DESCRIPTION: 
		This class is used to connect to and query a database.
		
		**This document should NEVER NEED TO BE ALTERED**
	*/

	class DAB
	{
		//Variables
		var $host;
		var $usr;
		var $passwd;
		var $db;
		var $mysql_link;
		
		
		//This is the constructor
		function DAB($host, $usr, $passwd, $db)
		{
			$this->host = $host;
			$this->usr = $usr;
			$this->passwd = $passwd;
			$this->db = $db;
			return true;
		}//end function DAB
		
		
		//This should be used to open the database connection
		function connect()
		{
			$this->mysql_link = mysql_connect($this->host, $this->usr, $this->passwd) or die (mysql_error());
			mysql_select_db($this->db) or die(mysql_error());
			return true;
		}//end connect
		
		
		//This should be used to close the database connection
		function close()
		{
			mysql_close($this->mysql_link);
			return true;
		}//end close
		
		
		//This should be used to make queries on the database
		function query($q)
		{
			$temp = mysql_query($q) or die(mysql_error());
			return $temp;
		}//end function query
	}//end class DAB
?>