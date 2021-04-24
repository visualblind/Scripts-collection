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
//	EP-Dev Whois Admin Display Class
//	Contains all output related functions.
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Admin_Display
{

	var $defaults;
	var $MENU;

	/* ------------------------------------------------------------------ */
	//	Our constructor loads up basic stuff / variables needed.
	/* ------------------------------------------------------------------ */

	function EP_Dev_Whois_Admin_Display($title)
	{
		$this->defaults['title_text'] = $title;
		$this->MENU = new EP_Dev_Whois_Admin_Menu_Bar();
		$this->load_Default_Menu();
	}


	/* ------------------------------------------------------------------ */
	//	loads default menu
	/* ------------------------------------------------------------------ */
	
	function load_Default_Menu()
	{
		$this->MENU->add("<div align=\"center\" style=\"font-weight: bold;\">Main Menu</div>", "", 1);
		$this->MENU->add("Main", "index.php", 1);
		$this->MENU->add("Admin Settings", "index.php?page=AdminSettings", 1);
		$this->MENU->add("Script Settings", "index.php?page=ScriptSettings", 1);
		$this->MENU->add("Edit Templates", "index.php?page=TemplateSettings", 1);
		$this->MENU->add("Error Settings", "index.php?page=ErrorSettings", 1);
		$this->MENU->add("Logout", "index.php?page=goLogout", 1);

		$this->MENU->add("<div align=\"center\" style=\"font-weight: bold;\">Nameservers</div>", "", 2);
		$this->MENU->add("Add Nameserver", "index.php?page=AddNameserver", 2);
		$this->MENU->add("Edit Nameservers", "index.php?page=NameserverSettings", 2);
		$this->MENU->add("NS Validator", "index.php?page=NSValidator", 2);

		$this->MENU->add("<div align=\"center\" style=\"font-weight: bold;\">Buy Mode</div>", "", 3);
		$this->MENU->add("Buy Mode Settings", "index.php?page=BuyModeSettings", 3);
		$this->MENU->add("Edit TLD Prices", "index.php?page=TLDSettings", 3);

		$this->MENU->add("<div align=\"center\" style=\"font-weight: bold;\">Other</div>", "", 4);
		$this->MENU->add("Troubleshooting", "index.php?page=FAQ", 4);
		$this->MENU->add("Check For Update", "index.php?page=CheckForUpdate", 4);
		$this->MENU->add("Make a Donation", "http://www.ep-dev.com/donate.php?name=EP-Dev Whois Script", 4);
		$this->MENU->add("Visit EP-Dev.com", "http://www.ep-dev.com", 4);
		$this->MENU->add("Get Support", "http://www.dev-forums.com", 4);
		$this->MENU->add("Contact Author", "mailto: patiek@ep-dev.com", 4);
	}

	
	/* ------------------------------------------------------------------ */
	//	Displays header.
	/* ------------------------------------------------------------------ */
	
	function show_Header($extra = "")
	{
		?>
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<HTML>
		<HEAD>
		<TITLE>EP-Dev Whois Admin Panel :: <? 
				
				// strip title of any tags
				// Display title
				echo preg_replace("/<[^>]+>/", "", $this->defaults['title_text']);
				
					?></TITLE>
		<META NAME="Author" CONTENT="Patrick Brown">
		<?

				// Display extra header
				echo $extra;
					
					?>
		<style type="text/css">

		BODY
		{
			font-family: Verdana, sans-serif;
			font-size: 10pt;
			color: black;
		}

		TD
		{
			font-size: 10pt;
			color: black;
		}


		HR
		{
			height: 4px;
			width: 90%;
			background: #268CFE;
		}


		INPUT
		{
			background: white;
			border: 2px solid #268CFE;
		}

		SELECT
		{
			background: white;
			border: 2px solid #268CFE;
		}

		</style>
		<SCRIPT LANGUAGE="JavaScript" TYPE="text/javascript">
			function newWindow(url, container, extra)
			{
				var newWin = window.open(url, container, extra);
			}
		</SCRIPT>
		</HEAD>

		<BODY>
		<div align="center">
		<div style="width: 768px;">
		<div style="margin-bottom: 20px;">
			<table cellpadding="0" cellspacing="0" style="width: 100%;">
				<tr>
					<td valign="top" style="width: 56px;"><img src="images/header-top-left.png"></td>
					<td style="background: #EDEDED url('images/header-top-mid-bg.png') repeat-x; text-align: center;"><img src="images/header-top-logo.gif"></td>
					<td valign="top" style="width: 50px;"><img src="images/header-top-right.png"></td>
				</tr>
			</table>
			<table cellpadding="0" cellspacing="0" style="width: 100%;">
				<tr>
					<td valign="top" style="width: 79px;"><img src="images/header-bottom-left.png"></td>
					<td style="background: #FFFFFF url('images/header-bottom-mid-bg.png') repeat-x; z-index:-1; text-align: center;"><div style="position: relative; left: 0px; z-index: 1"><a href="http://www.ep-dev.com" target="_blank"><img src="images/header-bottom-ep-dev.png" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="http://www.dev-forums.com" target="_blank"><img src="images/header-bottom-dev-forums.png" border="0"></a></div></td>
					<td valign="top" style="width: 76px;"><div style="position: relative; left: 0px;"><img src="images/header-bottom-right.png"></div></td>
				</tr>
			</table>
		</div>
		<?
	}

	
	/* ------------------------------------------------------------------ */
	//	Displays footer.
	/* ------------------------------------------------------------------ */
	
	function show_Footer($extra = "")
	{
		// Display $extra first.
		echo $extra;

		?>
		</div>
		</div>
		</BODY>
		</HTML>
		<?
	}

	
	/* ------------------------------------------------------------------ */
	//	Displays bulk of page.
	/* ------------------------------------------------------------------ */

	function show_Content($content)
	{
		?>
		<div style="width: 100%;">
			<table cellpadding="0" cellspacing="0" style="width: 100%;">
				<tr>
					<td valign="top" style="width: 51px;"><img src="images/body-table-top-left.png"></td>
					<td style="background: #EDEDED url('images/body-table-top-mid-bg.png') repeat-x; text-align: center;">&nbsp;</td>
					<td valign="top" style="width: 51px;"><img src="images/body-table-top-right.png"></td>
				</tr>
			</table>

			<table cellpadding="0" cellspacing="0" style="width: 100%;">
				<tr>
					<td style="background: #EDEDED url('images/body-table-middle-left-bg.png') repeat-y; text-align: center; width: 14px;">&nbsp;
					</td><?

								// only display if menu available
								if ($this->MENU->available())
								{
									?>
								<td valign="top" style="width: 160px; background-color: #EDEDED;">
									<div style="margin-right: 10px; position: relative; top: -10px;">
								<?

										// Display Menu
										$this->MENU->show();

								?>
									</div>
								</td>
								<?
								} // end if menu available

								?>
								<td valign="top" style="text-align; center; background-color: #EDEDED;">
									<div style="position: relative; top: -10px; text-align: center;">

										<table cellpadding="0" cellspacing="0" style="width: 100%;">
											<tr>
												<td valign="bottom" style="width: 36px; height: 19px;"><img src="images/body-content-top-left.png"></td>
												<td valign="bottom" style="background: #EDEDED url('images/body-content-top-mid-bg.png') repeat-x bottom center; text-align: center; height: 19px;">&nbsp;</td>
												<td valign="bottom" style="width: 36px; height: 19px;"><img src="images/body-content-top-right.png"></td>
											</tr>
										</table>

										<table cellpadding="0" cellspacing="0" style="width: 100%;">
											<tr>
												<td valign="top" style="background: #FFFFFF url('images/body-content-middle-left-bg.png') repeat-y; text-align: center; width: 3px;">&nbsp;</td>
												<td valign="top" style="background-color: #FFFFFF;"><div style="font-weight: bold; font-size: 14pt; text-align: center;">:: <? 

													// Display page title
													echo $this->defaults['title_text']; 

													?> ::</div>
													<div><?
				
														// Display content
														echo $content; 
														
														?></div></td>
												<td valign="top" style="background: #FFFFFF url('images/body-content-middle-right-bg.png') repeat-y top right; text-align: center; width: 3px;">&nbsp;</td>
											</tr>
										</table>

										<table cellpadding="0" cellspacing="0" style="width: 100%;">
											<tr>
												<td valign="top" style="width: 34px;"><img src="images/body-content-bottom-left.png"></td>
												<td valign="top" style="background: #EDEDED url('images/body-content-bottom-mid-bg.png') repeat-x; text-align: center;">&nbsp;</td>
												<td valign="top" style="width: 34px;"><img src="images/body-content-bottom-right.png"></td>
											</tr>
										</table>

									</div>
								</td>

					<td style="background: #EDEDED url('images/body-table-middle-right-bg.png') repeat-y top right; text-align: center; width: 14px;">&nbsp;</td>
				</tr>
			</table>

			<table cellpadding="0" cellspacing="0" style="width: 100%;">
				<tr>
					<td valign="top" style="width: 49;"><img src="images/body-table-bottom-left.png"></td>
					<td style="background: #FFFFFF url('images/body-table-bottom-mid-bg.png') repeat-x; z-index: 0; text-align: center;"><div style="position: relative; left: 0px; z-index: 0;"><img src="images/body-table-bottom-copyright.png"></div></td>
					<td valign="top" style="width: 49;"><div style="position: relative; left: 0px;"><img src="images/body-table-bottom-right.png"></div></td>
				</tr>
			</table>
		</div>
		<?
	}

	
	/* ------------------------------------------------------------------ */
	//	Construct form input in table row
	/* ------------------------------------------------------------------ */
	
	function constructTableVariable($name, $description, $var_type, $var_name, $var_value="", $size=null, $helpcode=null, $extra="")
	{
		// table within table
		$row .= "<tr>\n<td>\n<table style='width: 100%;'>\n";

		// Construct name/description/help part
		$row .= "<tr>\n<td align='top'><div><strong>{$name}</strong></div>\n<div>{$description}</div>\n";
		
		if (!empty($helpcode))
			$row .= "<div><a href=\"javascript:newWindow('?page=FAQ&amp;topic={$helpcode}&amp;small=1', 'feature_window', 'toolbar=no,status=no,height=300,width=475,resizable=yes,scrollbars=yes,top=100,left=100');\">More Information</a></div>\n";

		// close column
		$row .= "</td>\n";

		// Construct variable

		switch($var_type)
		{
			case "text" :
				$row .= "<td align='right'>{$extra}<input type='text' name='{$var_name}' value=\"" . htmlentities($var_value) . "\"" . (!empty($size) ? " size='{$size}'" : "") . " ID='" . str_replace(".", "___", $var_name) . "'></td>\n";
			break;

			case "textarea" :
				$row .= "</tr>\n</table>\n</td>\n</tr>\n<tr>\n<td>\n<table>\n<tr>\n";

				$row .= "<td align='center'><div align='left'>{$extra}</div><textarea name='{$var_name}'" 
					. (!empty($size) ? (!empty($size['rows']) ? "rows='" . $size['rows'] . "'" : "")
					. (!empty($size['cols']) ? "cols='" . $size['cols'] . "'" : "") : "")
					." wrap='off' ID='" . str_replace(".", "___", $var_name) . "'>" . htmlentities($var_value) . "</textarea></td>\n";
			break;

			case "select" :
				$row .= "<td align='right'>{$extra}<select name='{$var_name}' ID='" . str_replace(".", "___", $var_name) . "'>\n";
				foreach($var_value['options'] as $name_of_var => $value_of_var)
				{
					$row .= "<option value='{$value_of_var}'" . ($var_value['selected'] == $name_of_var ? "selected" : "")
					. ">{$name_of_var}</option>\n";
				}
				$row .= "</select></td>\n";
			break;
		}

		// close row
		$row .= "</tr>\n";

		// close table
		$row .= "</table>\n</td>\n</tr>";

		return $row;
	}


	/* ------------------------------------------------------------------ */
	//	Construct Output of particular format
	/* ------------------------------------------------------------------ */
	
	function constructOutput($output, $indent=0)
	{
		return "<div style='margin-left:{$indent}; font-family: verdana, sans-serif; font-size: 10pt;'>" . $output . "</div>";
	}


	/* ------------------------------------------------------------------ */
	//	Construct start of form
	/* ------------------------------------------------------------------ */
	
	function constructStartForm($page, $name="adminpanelForm", $method="POST", $url=null, $preSubmitAction=null)
	{
		if (!empty($preSubmitAction))
			$preSubmitAction = " onSubmit='" . $preSubmitAction . "'";

		if (empty($url))
			$url = basename($_SERVER['PHP_SELF']);

		return "<form name='{$name}' action='{$url}' method='{$method}'{$preSubmitAction}>\n"
				. "<input type='hidden' name='page' value='{$page}'>\n";
	}


	/* ------------------------------------------------------------------ */
	//	Construct end of form with buttons
	/* ------------------------------------------------------------------ */
	
	function constructEndForm($submitButton = "Submit", $resetButton = "")
	{
		if (!empty($submitButton))
			$subBut = "<input type='submit' value='{$submitButton}'>\n";

		if (!empty($resetButton))
			$resBut = "<input type='reset' value='{$resetButton}'>\n";

		return "{$subBut}&nbsp;&nbsp;{$resBut}</form>\n";
	}


	/* ------------------------------------------------------------------ */
	//	Displays page in one easy function so you don't have to call each
	//  function individually. Adds menu if not present.
	/* ------------------------------------------------------------------ */

	function displayPage($content, $title = NULL, $menu = NULL, $header_extra = "", $footer_extra = "")
	{
		// If menu, assign.
		if (!empty($menu))
			$this->MENU = $menu;

		// if title, assign to obj
		if (!empty($title))
			$this->defaults['title_text'] = $title ;

		// Continue to construct page.
		$this->show_Header($header_extra);
		$this->show_Content($content);
		$this->show_Footer($footer_extra);
	}

}


/* ------------------------------------------------------------------ */
//	EP-Dev Whois Admin Menu Class
//	Contains all menu construction and display related functions
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Admin_Menu_Bar
{

	/* ------------------------------------------------------------------ */
	//	Our constructor loads up default stuff.
	/* ------------------------------------------------------------------ */

	function EP_Dev_Whois_Admin_Menu_Bar()
	{
		// nada
	}

	
	/* ------------------------------------------------------------------ */
	//	Add Item to Menu
	/* ------------------------------------------------------------------ */
	
	function add($text, $url = "", $menu_id = 1)
	{
		// Add on text part to MenuData
		$this->MenuData[$menu_id]['item'][count($this->MenuData[$menu_id]['item'])] = $text;

		// Add on url part to MenuData
		$this->MenuData[$menu_id]['url'][count($this->MenuData[$menu_id]['url'])] = $url;
	}


	/* ------------------------------------------------------------------ */
	//	Remove item from menu
	/* ------------------------------------------------------------------ */
	
	function remove($key = false, $text = false, $url = false, $menu_id = 1)
	{

		// Check if searching by text
		if ($text)
		{
			$key = array_search($text, $this->MenuData[$menu_id]['item']);
		}

		// Check if searching by url
		if ($url)
		{
			$key = array_search($url, $this->MenuData[$menu_id]['url']);
		}

		// remove key
		if ($key !== false)
		{
			unset($this->MenuData[$menu_id]['item'][$key]);
			unset($this->MenuData[$menu_id]['url'][$key]);
		}

	}

	
	/* ------------------------------------------------------------------ */
	//	Remove all menus
	/* ------------------------------------------------------------------ */
	
	function remove_all()
	{
		// Remove all menus
		unset($this->MenuData);
	}


	/* ------------------------------------------------------------------ */
	//	Display Menu
	/* ------------------------------------------------------------------ */
	
	function show($menu_id = 0)
	{
		if ($this->available())
		{
			// Do a loop to display either all ids (if menu_id = 0), or one id ($menu_id).
			for ($i = ($menu_id ? $menu_id : 1); $i < ($menu_id ? ($menu_id + 1) : (count($this->MenuData)+1)); $i++)
			{

				?>
				<div style="width: 150px;"><img src="images/body-menu-top.png"></div>
								<div style="background: #EDEDED url('images/body-menu-mid-bg.png') repeat-y; text-align: left; width: 150px;"><div style="margin-left: 5px;"><?
					
				// Cycle through all entries for this menu.
				for ($j=0; $j < count($this->MenuData[$i]['item']); $j++)
				{
				
					// If a url for item exists, then make item a link
					if (!empty($this->MenuData[$i]['url'][$j]))
					{
						echo "- <a href=\"".$this->MenuData[$i]['url'][$j]."\">".$this->MenuData[$i]['item'][$j]."</a>";
					}

					// Else make it a Menu Header / Category
					else
					{
						echo $this->MenuData[$i]['item'][$j];
					}

					echo "<br>";
				}
			
				?></div></div>
								<div style="width: 150px;"><img src="images/body-menu-bottom.png"></div><br>
				<?

			}
		}
	}


	/* ------------------------------------------------------------------ */
	//	Create blank menu
	/* ------------------------------------------------------------------ */
	
	function blank($title = "Login")
	{
		// Remove all other menus
		$this->remove_all();

		// Make custom menu
		//$this->add($title, "");
	}


	/* ------------------------------------------------------------------ */
	//	Check if any menu available
	/* ------------------------------------------------------------------ */
	
	function available()
	{
		return (!empty($this->MenuData));
	}
}


/* ------------------------------------------------------------------ */
//	EP-Dev Whois Admin Error Handle Class
//	Contains all error output related functions.
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Admin_Error_Handle
{
	/* ------------------------------------------------------------------ */
	//	Stop with $code
	//  Dies with error ouput
	/* ------------------------------------------------------------------ */

	function stop($code)
	{
		$this->kill($this->go($code));
	}


	/* ------------------------------------------------------------------ */
	//	Go $code
	//  Returns textual error based on $code
	/* ------------------------------------------------------------------ */
	
	function go($code, $extra = NULL)
	{
		switch ($code)
		{
			case "mysql_connect_error" : 
				$return = "Error connecting to mysql database with username and password specified.";
			break;

			case "mysql_db_error" : 
				$return = "Error connecting to specified database name.";
			break;

			case "invalid_number" : 
				$return = "ERROR: Invalid number specified for " . $extra;
			break;

			case "invalid_bool" : 
				$return = "ERROR: Invalid value specified for " . $extra;
			break;

			case "bad_permissions" : 
				$return = "ERROR: Could not open or write to file the new settings. Check file permissions section of trouble shooting.";
			break;

			case "bad_login" :
				$return = "Please enter correct username and password!";
			break;

			case "panel_disabled" :
				$return = "The administration panel has been disabled from within the configuration file.";
			break;

			case "nameserver_exists" :
				$return = "The nameserver specified already exists! Please use the edit nameservers page to modify it.";
			break;

			case "bad_nameserver" :
				$return = "You did not specify an address for this nameserver.";
			break;

			default : $return = "An unknown error occurred!";
		}

		return $return;
	}


	/* ------------------------------------------------------------------ */
	//	Kill with $error
	//  dies with textual $error
	/* ------------------------------------------------------------------ */
	
	function kill($error)
	{
		// new display obj
		$display = new EP_Dev_Whois_Admin_Display("ERROR");

		// display page
		$display->displayPage($error, "ERROR -- " . $error);

		die();
	}
}