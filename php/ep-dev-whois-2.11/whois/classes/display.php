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
//	EP-Dev Whois Display Class
//	Contains all output-related functions.
//	Date: 3/29/2005
/* ------------------------------------------------------------------ */

class EP_Dev_Whois_Display
{
	var $CORE;

	var $title;
	var $template;
	var $content;

	var $copyright;


	function EP_Dev_Whois_Display(&$global)
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


	/* ------------------------------------------------------------------ */
	//	Load template data
	//	Loads designated $page_id template.
	/* ------------------------------------------------------------------ */
	
	function loadTemplate($page_id)
	{
		$this->content = $this->CORE->TEMPLATES[$page_id];
	}


	/* ------------------------------------------------------------------ */
	//	Construct Page
	//	Create basic page output and store.
	/* ------------------------------------------------------------------ */
	
	function constructPage($page_id, $content = "", $title = "")
	{
		// load template
		$this->loadTemplate($page_id);

		if (!empty($content))
			$this->content = $content;

		if (!empty($title))
			$this->title = $title;
	}

	
	/* ------------------------------------------------------------------ */
	//	Display Page
	//	Display stored page output.
	/* ------------------------------------------------------------------ */

	function displayPage()
	{
		$this->parseAll();
		echo $this->content;
	}


	/* ------------------------------------------------------------------ */
	//	Parse All
	//	Parses all global template data.
	/* ------------------------------------------------------------------ */
	
	function parseAll()
	{
		$this->parsePage();
		$this->parseSearchBar();
		$this->parsePriceTable();
		$this->parsePage();
	}


	/* ------------------------------------------------------------------ */
	//	Parse Domains
	//	Parses template of $template_id with $domain_queries data.
	/* ------------------------------------------------------------------ */
	
	function parseDomains($domain_queries, $template_id)
	{
		preg_match("/\[repeat\](.*?)\[\/repeat\]/is", $this->CORE->TEMPLATES[$template_id], $available_template);

		$search = array (
			"/\[\[domain\]\]/",
			"/\[\[ext\]\]/",
			"/\[\[price\]\]/",
			"/\[\[whois-reporturl\]\]/"
			);

		// create blank display for repeats
		$repeat_display = "";

		// for each available domain
		foreach($domain_queries as $current_domain)
		{
			// replace array for current domain
			$replace = array (
				$current_domain->getDomain(),
				$current_domain->getExt(),
				str_replace("\$", "\\\$", $current_domain->getPrice()),
				"whois.php?page=WhoisReport&amp;domain=" . $current_domain->getDomain() . "&amp;ext=" . $current_domain->getExt()
				);

			// replace tags with current domain tags and add template onto $repeat_display
			$repeat_display .= preg_replace($search, $replace, $available_template[1]);
		};

		if (count($domain_queries))
		{
			// return original template with new replacement data replacing repeat tags
			return str_replace($available_template[0], $repeat_display, $this->CORE->TEMPLATES[$template_id]);
		}
		else
		{
			return "";
		}
	}


	/* ------------------------------------------------------------------ */
	//	Parse available domains
	//	Parses for available domains of $domain_queries and then parses
	//	page content.
	/* ------------------------------------------------------------------ */
	
	function parseAvailableDomains($domain_queries)
	{
		$available_display = $this->parseDomains($domain_queries, "availabledomains");
		$this->customParse("availabledomains", $available_display);
	}


	/* ------------------------------------------------------------------ */
	//	Parse unavailable domains
	//	Parses for unavailable domains of $domain_queries and then parses
	//	page content.
	/* ------------------------------------------------------------------ */
	
	function parseUnavailableDomains($domain_queries)
	{
		$unavailable_display = $this->parseDomains($domain_queries, "unavailabledomains");
		$this->customParse("unavailabledomains", $unavailable_display);
	}


	/* ------------------------------------------------------------------ */
	//	Custom Parse
	//	Performs custom parse, finding $find in template context and replacing
	//	with $replace data.
	/* ------------------------------------------------------------------ */
	
	function customParse($find, $replace)
	{
		$this->content = str_replace("[[{$find}]]", $replace, $this->content);
	}


	/* ------------------------------------------------------------------ */
	//	Parse page
	//	Parses page for general tags.
	/* ------------------------------------------------------------------ */
	
	function parsePage()
	{
		$copyright = "<div align='center'><small>Generated by EP-Dev.com <a href=\"http://www.ep-dev.com\" target=\"_blank\">Whois script</a>.</small></div>";

		if ($this->CORE->CONFIG->SCRIPT['copyright'] && strpos($this->content, "[[footer]]") === false && !$this->copyright)
		{
			$this->copyright = true;
			$this->content .= $copyright;
		}

		$search = array (
			"/\[\[header\]\]/",
			"/\[\[footer\]\]/",
			"/\[\[copyright\]\]/"
			);

		$replace = array (
			$this->CORE->TEMPLATES['header'],
			($this->CORE->CONFIG->SCRIPT['copyright'] && !$this->copyright ? $copyright : "") . $this->CORE->TEMPLATES['footer'],
			$copyright
		);

		// perform search & replace of above arrays
		$this->content = preg_replace($search, $replace, $this->content);
		$this->copyright = true;

		// match all site called configs
		$number_matched = preg_match_all("/\[\[site-([a-zA-Z0-9]+)\]\]/", $this->content, $matches);

		// replace with config variable
		for($i=0; $i<$number_matched; $i++)
		{
			// only if variable exists
			if (isset($this->CORE->CONFIG->SCRIPT['SITE'][$matches[1][$i]]))
			{
				$this->content = str_replace("[[site-{$matches[1][$i]}]]", $this->CORE->CONFIG->SCRIPT['SITE'][$matches[1][$i]], $this->content);
			}
		}

		// match all site called configs
		$number_matched = preg_match_all("/\[\[user-([a-zA-Z0-9]+)\]\]/", $this->content, $matches);

		// replace with config variable
		for($i=0; $i<$number_matched; $i++)
		{
			$domain = $this->CORE->USER->getValue($matches[1][$i]);
			
			$this->content = str_replace("[[user-{$matches[1][$i]}]]", $this->CORE->USER->getValue($matches[1][$i]), $this->content);
		}
	}

	
	/* ------------------------------------------------------------------ */
	//	Parse Search Bar
	//	Parses search bar for related tags.
	/* ------------------------------------------------------------------ */

	function parseSearchBar()
	{
		$all_extensions = $this->CORE->DOMAINS->getDisplayExtensions();

		$user_extensions = $this->CORE->USER->getValue("extensions");

		if (is_array($user_extensions))
			$default_domains = $user_extensions;
		else
			$default_domains = $this->CORE->DOMAINS->getAutoSearchExtensions();

		if (strpos($this->CORE->TEMPLATES['searchbar'], "[[tld-checkboxes]]") !== false)
		{
			$i=0;
			$rows = 0;
			$cols = 0;

			$searchbar = "<table class=\"whoisSearchTable\">\n<tr>\n";

			foreach($all_extensions as $ext)
			{
				if (($this->CORE->CONFIG->SCRIPT['TLD_DISPLAY']['num_rows'] - $rows > 1) || ($rows < $this->CORE->CONFIG->SCRIPT['TLD_DISPLAY']['num_rows'] && $cols < $this->CORE->CONFIG->SCRIPT['TLD_DISPLAY']['num_columns']))
				{
					if ($cols >= $this->CORE->CONFIG->SCRIPT['TLD_DISPLAY']['num_columns'])
					{
						$searchbar .= "</tr>\n<tr>\n";
						$cols = 1;
						$rows++;
					}
					else
					{
						$cols++;
					}

					$searchbar .= "<td class=\"whoisSearchTable\"><input type=\"checkbox\" name=\"ext{$i}\" id=\"ext{$i}\" value=\"{$ext}\"" . (in_array($ext, $default_domains) ? " checked" : "") . ">.{$ext}</td>\n";
					$i++;
				}
			}

			$searchbar .= "</tr>\n</table>\n";

			$final_searchbar = str_replace("[[tld-checkboxes]]", $searchbar, $this->CORE->TEMPLATES['searchbar']);
		}
		else if (strpos($this->CORE->TEMPLATES['searchbar'], "[[tld-dropbox]]") !== false)
		{
			$searchbar .= "<select name=\"ext0\">\n";

			// get user's extension
			$user_extension = $this->CORE->USER->getValue("extension");

			// check if user specified extension
			if (!empty($user_extension))
				$selected = $user_extension;
			else
				$selected = 0;

			$i=0;
			foreach($all_extensions as $ext)
			{
				// decide on what is default selected
				if ($i === $selected || $selected === $ext)
					$selected_text = " selected";
				else
					$selected_text = "";

				$searchbar .= "<option value=\"{$ext}\"{$selected_text}>.{$ext}</option>\n";
				$i++;
			}

			$searchbar .= "</select>\n";

			$final_searchbar = str_replace("[[tld-dropbox]]", $searchbar, $this->CORE->TEMPLATES['searchbar']);
		}

		$this->customParse("searchbar", $final_searchbar);
	}


	/* ------------------------------------------------------------------ */
	//	Parse Price Table
	//	Parses price table template for related tags.
	/* ------------------------------------------------------------------ */
	
	function parsePriceTable()
	{
		if ($this->CORE->CONFIG->BUYMODE['PRICETABLE']['enable'])
		{
			$all_extensions = $this->CORE->DOMAINS->getPriceTableExtensions();

			$i=0;
			$rows = 0;
			$cols = 0;

			$pricetable = "<table class=\"whoisPriceTable\">\n<tr>\n";

			foreach($all_extensions as $ext)
			{
				if (($this->CORE->CONFIG->BUYMODE['PRICETABLE']['num_rows'] - $rows > 1) || ($rows < $this->CORE->CONFIG->BUYMODE['PRICETABLE']['num_rows'] && $cols < $this->CORE->CONFIG->BUYMODE['PRICETABLE']['num_columns']))
				{
					if ($cols >= $this->CORE->CONFIG->BUYMODE['PRICETABLE']['num_columns'])
					{
						$pricetable .= "</tr>\n<tr>\n";
						$cols = 1;
						$rows++;
					}
					else
					{
						$cols++;
					}

					$pricetable .= "<td class=\"whoisPriceTable_ext\">.{$ext}:</td><td class=\"whoisPriceTable_price\">" . $this->CORE->DOMAINS->getPrice($ext) . "</td>\n";
				}
			}

			$pricetable .= "</tr>\n</table>\n";
		}
		else
		{
			$pricetable = "";
		}

		$this->customParse("pricetable", $pricetable);
	}


}