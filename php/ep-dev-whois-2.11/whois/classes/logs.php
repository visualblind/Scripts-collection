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
//	EP-Dev Whois Logs Class
//	Contains functions used for logging information.
//	Date: 3/29/2005
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Logs
{
	var $CORE;

	function EP_Dev_Whois_Logs(&$global)
	{
		$this->reloadCore($global);
	}


	/* ------------------------------------------------------------------ */
	//	Reload Core
	//	Reloads the $global core object with updated links.
	/* ------------------------------------------------------------------ */
	
	function reloadCore(&$global)
	{
		$this->CORE = $global;
	}


	function parseTemplate($domain, $extensions, $template, $filename)
	{
		$log_output = "";

		// construct search array
		$search = array (
				"/\[\[MONTH\]\]/",
				"/\[\[DAY\]\]/",
				"/\[\[YEAR\]\]/",
				"/\[\[TIME\]\]/",
				"/\[\[DOMAIN\]\]/",
				"/\[\[EXT\]\]/",
				"/\[\[IP\]\]/"
			);

		// +------------------------------
		//	Construct replace array.
		//	NOTICE: extension is missing and will be added later in loop.
		// +------------------------------
		$replace = array (
				"month" => date("m"),
				"day" => date("d"),
				"year" => date("Y"),
				"time" => time(),
				"domain" => $domain,
				"extension" => "",
				"ip" => $this->CORE->USER->getIP()
			);

		foreach($extensions as $ext)
		{
			// +------------------------------
			//	Detect for multiple files.
			//	If extension is specified in filename then the script
			//	is going to have to create multiple files due to change
			//	in the log filenames.
			//
			//	Each extension will have its own file.
			// +------------------------------
			if (strstr("[EXT]", $filename) !== false)
				$log_filename[$ext] = preg_replace($search, $replace, $filename);
			else if ($count == 0)
				$log_filename['all_extensions'] = preg_replace($search, $replace, $filename);

			// update replace with extension
			$replace['extension'] = $ext;

			// perform actual search and replace
			$log_data = preg_replace($search, $replace, $template);

			$log_output[$ext] = $log_data;
		}

		return array (
				"data" => $log_output,
				"filename" => $log_filename
				);
	}


	function update($domain, $extensions)
	{
		// convert to array if not array
		if (!is_array($extensions))
		{
			$ext = $extensions;
			unset($extensions);
			$extensions = array($ext);
			unset($ext);
		}

		// detect template type
		if ($this->CORE->CONFIG->SCRIPT['LOGS']['type'] == "long")
			$template = $this->CORE->CONFIG->SCRIPT['LOGS']['long_format'];
		else
			$template = $this->CORE->CONFIG->SCRIPT['LOGS']['short_format'];


		$parsed_data = $this->parseTemplate($domain, $extensions, $template, $this->CORE->CONFIG->SCRIPT['LOGS']['file']);

		foreach($parsed_data['filename'] as $ext => $filename)
		{
			if ($ext == "all_extensions")
			{
				$this->writeLog(implode("", $parsed_data['data']), $filename);
				break;
			}
			else
			{
				$this->writeLog($parsed_data['data'][$ext], $filename);
			}
		}
	}


	function writeLog($data, $filename)
	{
		$log_handle = @fopen($filename, 'ab');
		@fwrite($log_handle, $data);
		@fclose($log_handle);
	}



}




