<?php

// IPplan v4.50
// Aug 24, 2001
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//

require_once("config.php");
require_once("schema.php");
require_once("ipplanlib.php");
require_once("layout/class.layout");

// check for latest variable added to config.php file, if not there
// user did not upgrade properly
if (!defined("DNSAUTOCREATE")) die("Your config.php file is inconsistent - you cannot use your old config.php file during upgrade");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

CheckSchema();

newhtml($p);
insert($p,block("<script type=\"text/javascript\">
</script>
<noscript>
<p><b>
<font size=4 color=\"#FF0000\">
Your browser must be JavaScript capable to use this application. Please turn JavaScript on.
</font>
</b>
</noscript>
"));

$w=myheading($p,"Main Menu");
insert($w,block("IPplan is a free (GPL), web based, multilingual, IP address management and tracking tool written in php 4, simplifying the administration of your IP address space. IPplan goes beyond 
IP address management including DNS administration, configuration file management, circuit management (customizable via templates) and storing of hardware information (customizable via templates). 
IPplan can handle a single network or cater for multiple networks and customers with overlapping address space.")); 

printhtml($p);
?> 
