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

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Display subnet information obtained from a routing table");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust) = myRegister("I:cust");

// display opening text
insert($w,heading(3, "$title."));

insert($w,text(my_("Display subnet information obtained from a routing table will show the routing table information on the left of the screen and the corresponding entries in the database on the right. If there are entries on both sides of the table, the subnet exists in the routing table and the database. If there are only entries on the left, the subnet only exists in the routing table. The same is true for the right hand side. If you click on the left, you can add the subnet to the database. If you click on the right, you can view the existing database information.")));

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// start form
insert($w, $f = form(array("method"=>"post",
                           "action"=>"displayrouter.php")));

$cust=myCustomerDropDown($ds, $f, $cust, $grps, FALSE) or myError($w,$p, my_("No customers"));

insert($f,textbrbr(my_("IP address of device to query")));
insert($f,span(my_("The device must be SNMP capable"), array("class"=>"textSmall")));

insert($f,input_text(array("name"=>"ipaddr",
                           "size"=>"15",
                           "maxlength"=>"15")));

insert($f,textbrbr(my_("Community string")));
$community=(SNMP_COMMUNITY=="") ? "public" : SNMP_COMMUNITY;
insert($f,password(array("name"=>"community",
                           "value"=>$community,
                           "size"=>"20",
                           "maxlength"=>"20")));
insert($f,textbrbr(my_("Router type")));
insert($f,span(my_("Type 'Generic' will work for most routers"), array("class"=>"textSmall")));
$lst=array("generic"=>"Generic",
           "riverstone"=>"RiverStone",
           "juniper"=>"Juniper");
insert($f,selectbox($lst,
       array("name"=>"rtrtype")));


insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
