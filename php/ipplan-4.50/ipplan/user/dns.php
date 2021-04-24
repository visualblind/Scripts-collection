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

require_once("../ipplanlib.php");
require_once("../config.php");
require_once("../layout/class.layout");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));

$title=my_("DNS results");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($ip) = myRegister("S:ip");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

if (testIP($ip)) {
   myError($w,$p, my_("Invalid IP address"));
}

$result=gethostbyaddr($ip);
insert($w,text($result));
if ($result==$ip)
   insert($w,textb(my_(" No DNS reverse record found")));

printhtml($p);

?>
