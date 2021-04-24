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
//	Class holds file management functions (self-explanatory)
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Admin_File_IO
{
	var $handle;
	var $file;
	var $position;
	var $ERROR;

	function EP_Dev_Whois_Admin_File_IO($filename, &$error_handle)
	{
		$this->ERROR = $error_handle;
		$this->file = $filename ;
	}

	function open()
	{
		// clear all cached file sizes, etc
		clearstatcache();

		// stop those aweful magic quotes.
		ini_set("magic_quotes_runtime", "0");

		// Open up file for reading & writing (r+) and binary mode (b) for Windows compat
		$this->handle = fopen($this->file, "r+b")
			or $this->ERROR->stop("bad_permissions");

		// Lock file for writing (LOCK_EX) as we probably will be.
		flock($this->handle, LOCK_EX);
	}

	function read($size = 0)
	{
		// read $size bytes from file
		if (!$size)
			$size = filesize($this->file);

		$contents = fread($this->handle, $size)
			or $this->ERROR->stop("bad_permissions");

		return $contents;
	}

	function write($data)
	{
		// Write $data to file
		fwrite($this->handle, $data)
			or $this->ERROR->stop("bad_permissions");
	}

	function seek($pos)
	{
		// Move file pointer to $pos
		if(!fseek($this->handle, $pos))
			$this->position = $pos;
	}

	function writeNew($data)
	{
		// Place file pos at front of file.
		if (rewind($this->handle))
			$this->position = 0;
		
		// Truncate file to 0 bytes
		$this->truncate();

		// Write new file
		$this->write($data);
	}

	function truncate($size = 0)
	{
		// Truncate file to $size
		ftruncate($this->handle, $size)
			or $this->ERROR->stop("bad_permissions");
	}

	function close()
	{
		// Unlock (not needed)
		flock($this->handle, LOCK_UN);

		// Close file
		fclose($this->handle);

		// restore those superb magic quotes.
		ini_restore("magic_quotes_runtime");
	}

}