<?php
// --------------------------------------------
// | EP-Dev Whois        
// |                                           
// | Copyright (c) 2003-2005 Patrick Brown as EP-Dev.com           
// | This program is free software; you can redistribute it and/or modify
// | it under the terms of the GNU General Public License as published by
// | the Free Software Foundation; either version 2 of the License, or
// | (at your option) any later version.              
// | 
// | This program is distributed in the hope that it will be useful,
// | but WITHOUT ANY WARRANTY; without even the implied warranty of
// | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// | GNU General Public License for more details.
// --------------------------------------------


/* ------------------------------------------------------------------ */
//	Upgrade Core Class
//  Contains upgrade functions related to upgrading configuration of 
//	the script.
/* ------------------------------------------------------------------ */

class UpgradeCore
{
	var $adminPanel;

	function UpgradeCore($adminPanel)
	{
		$this->adminPanel = $adminPanel;
	}


	function navigate($old_version, $new_version)
	{
		switch($_REQUEST['page'])
		{
			// +------------------------------
			//	UPGRADE PROCESS
			// +------------------------------

			case "goUpgrade" :
				$this->upgradeProcess($_REQUEST['type'], $new_version);
				$this->adminPanel->DISPLAY->MENU->blank();
				$this->adminPanel->page_Message("Upgrade Complete", $this->adminPanel->DISPLAY->constructOutput("The upgrade has completed. NOTE: Your absolute path has been reset.<br><br>Please <a href='" . basename($_SERVER['PHP_SELF']) . "'> continue to the admin panel</a>."));
			break;

			
			// +------------------------------
			//	Main Upgrader Page
			// +------------------------------
			
			default : 
			switch($old_version)
			{
				case "2.0" :
				case "2.01" :
					$type = "2.01";
					$this->defaultUpgradePage($old_version, $new_version, $type);
				break;

				case "2.1" :
				case "2.10" :
					$type = "2.1";
					$this->defaultUpgradePage($old_version, $new_version, $type);
				break;

				default : "No Upgrade Found.";
			}
		}
	}



	/* ------------------------------------------------------------------ */
	//	Default Upgrade Page
	//	Displays generic upgrade page from $old_version to $new_version.
	/* ------------------------------------------------------------------ */
	
	function defaultUpgradePage($old_version, $new_version, $type)
	{
		$formURL = basename($_SERVER['PHP_SELF']);

		// default upgrade page.
			$this->adminPanel->DISPLAY->MENU->blank();
			$message = $this->adminPanel->DISPLAY->constructOutput("You are about to begin the process of upgrading from version {$old_version}
			to version {$new_version}. Please follow any on-screen instructions.<br><br>
			<form name='upgradeForm' action='{$formURL}' method='post'>
				<input type='hidden' name='page' value='goUpgrade'>
				<input type='hidden' name='type' value='{$type}'>
				<div align='center'><input type='submit' value='Continue Upgrade'></div>
			</form>
			");

			$this->adminPanel->page_Message("UPGRADE :: From version {$old_version} to version {$new_version}", $message);
	}


	/* ------------------------------------------------------------------ */
	//	Upgrade Process
	//	The part of this script that actually modifies the files (upgrades).
	/* ------------------------------------------------------------------ */
	
	function upgradeProcess($old_version, $new_version)
	{
		$current = $old_version;

		$this->clearAbsolutePath();

		while ($current != $new_version)
		{
			switch($current)
			{



				// +------------------------------
				//	Version 2.0x -> 2.1
				// +------------------------------

				case "2.01" :
				// +------------------------------
				//	Add new configuration
				// +------------------------------

				$addConfigArray = array();
				// begin new data info
				$addConfigArray["TEMPLATES__multiple_tlds"] = "[[header]]
<div align=\"center\">Please enter the full domains that you want to check, one per line.</div>
<div align=\"center\"><form name='whois_search' method='POST' action='[[site-url]]whois.php'>
			<input type='hidden' name='page' value='WhoisSearch'>
			<input type='hidden' name='skip_additional' value='1'>
				<table>
					<tr>
					<td>http://www.</td><td><textarea rows='10' cols='40' name='domain'>[[user-domain]]</textarea></td>
					</tr>
				</table>
			<input type='submit' id='Submit' value='Check Availability'> 
</form></div>
[[footer]]";

				// format into expected output
				$addConfigArray['adminpanel_filename'] = "../config/template.php:::"
												. "TEMPLATES__multiple_tlds";

				// designate special search string (we will use nameserver string)
				$addConfigArray['adminpanel_replace_string'] = "\$this->TEMPLATES['header'] = ";

				$this->adminPanel->AddConfig($addConfigArray);

				// +------------------------------
				//	Modify Version Number to reflect new version
				// +------------------------------
				$this->modifyVersion("2.1");
				$current = "2.1";

				break;



				// +------------------------------
				//	Version 2.1 -> 2.11
				// +------------------------------

				case "2.1" :
					// +------------------------------
					//	Modify Version Number to reflect new version
					// +------------------------------
					$this->modifyVersion("2.11");
					$current = "2.11";
				break;



			}
		}
	}


	/* ------------------------------------------------------------------ */
	//	Modify Version
	//	Updates configuration file's version to $new_version
	/* ------------------------------------------------------------------ */

	function modifyVersion($new_version)
	{
		$modifyConfigArray = array();

		$modifyConfigArray['adminpanel_filename'] = "../config/config.php:::SCRIPT__version";
		$modifyConfigArray['adminpanel_class'] = "CONFIG";
		$modifyConfigArray['SCRIPT__version'] = $new_version;
		$modifyConfigArray['adminpanel_rules'] = "SCRIPT__version,string";

		$this->adminPanel->ModifyConfig($modifyConfigArray);
	}


	function clearAbsolutePath()
	{
		$modifyConfigArray = array();

		$modifyConfigArray['adminpanel_filename'] = "../config/config.php:::SCRIPT__absolute_path";
		$modifyConfigArray['adminpanel_class'] = "CONFIG";
		$modifyConfigArray['SCRIPT__absolute_path'] = "";
		$modifyConfigArray['adminpanel_rules'] = "SCRIPT__absolute_path,string";

		$this->adminPanel->ModifyConfig($modifyConfigArray);
	}
}