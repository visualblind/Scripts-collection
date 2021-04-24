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
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../layout/class.layout");
require_once("../auth.php");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Export IP details data");
newhtml($p);
$w=myheading($p, $title);

// display opening text
insert($w,heading(3, "$title."));
insert($w,textbrbr(my_("Export IP details data to flat ascii files.  The file will contain six columns each delimited by TAB. The first column contains the IP address, the second the user, the third the location, the fourth the description, fifth the hostname and the sixth the telephone number.")));

insert($w,block("<p>"));
insert($w,text(my_("The user defined fields defined in the iptemplate.xml file will be appended as additional columns to the above in the order specified in the template.")));
insert($w,block("<p>"));

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// start form
insert($w, $f = form(array("method"=>"post",
                           "action"=>"exportip.php")));

$cust=myCustomerDropDown($ds, $f, 0, 0, FALSE) or myError($w,$p, my_("No customers"));

insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
