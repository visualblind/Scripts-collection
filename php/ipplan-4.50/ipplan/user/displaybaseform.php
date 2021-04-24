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

if (!ANONYMOUS) {
   $auth = new SQLAuthenticator(REALM, REALMERROR);

   // And now perform the authentication
   $grps=$auth->authenticate();
}

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Display subnet information");
newhtml($p);
$w=myheading($p, $title, true);

// display opening text
insert($w,heading(3, my_("Display subnets.")));

$ds= new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex) = myRegister("I:cust I:areaindex");

// start form
insert($w, $f1 = form(array("name"=>"THISFORM",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

// ugly kludge with global variable!
$displayall=TRUE;
$cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));
$areaindex=myAreaDropDown($ds, $f1, $cust, $areaindex);

insert($w, $f2 = form(array("name"=>"ENTRY",
                            "method"=>"get",
                            "action"=>"displaybase.php")));

// save customer name for actual post of data
insert($f2,hidden(array("name"=>"cust",
                        "value"=>"$cust")));
insert($f2,hidden(array("name"=>"areaindex",
                        "value"=>"$areaindex")));

myRangeDropDown($ds, $f2, $cust, $areaindex);
insert($f2, block("<p>"));

insert($f2, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Search criteria")));

myFocus($p, "ENTRY", "ipaddr");
insert($con,textbr(my_("Subnet network address (leave blank if range selected)")));
insert($con,span(my_("Partial subnet addresses can be used eg. 172.20"), array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"ipaddr",
                            // "value"=>"$ipaddr",
                            "size"=>"15",
                            "maxlength"=>"15")));

insert($con,textbr());
insert($con,checkbox(array("name"=>"searchin",
                "value"=>"1",
                "onchange"=>"document.ENTRY.jump.checked=document.ENTRY.searchin.checked;"),
                my_("Match any IP address in subnet")));
insert($con,checkbox(array("name"=>"jump",
                "value"=>"1"),
                my_("Jump to IP address record if found")));
insert($con,textbr());

insert($con,span(my_("Enter a complete ip address in above field and select the above options to go to the address record or subnet record"), array("class"=>"textSmall")));

if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql" or DBF_TYPE=="postgres7")
   insert($con,textbrbr(my_("Description (only display networks matching the regular expression)")));
else
   insert($con,textbrbr(my_("Description (only display networks containing)")));
insert($con,input_text(array("name"=>"descrip",
                            // "value"=>"$descrip",
                            "size"=>"80",
                            "maxlength"=>"80")));

insert($con,textbrbr(my_("Display subnets larger than")));
insert($con,selectbox(array("0"=>my_("Display all subnets"),
                          "1"=>"255.255.255.255/32 - host",
                          "2"=>"255.255.255.254/31 - 2 hosts",
                          "4"=>"255.255.255.252/30 - 4 hosts",
                          "8"=>"255.255.255.248/29 - 8 hosts",
                          "16"=>"255.255.255.240/28 - 16 hosts",
                          "32"=>"255.255.255.224/27 - 32 hosts",
                          "64"=>"255.255.255.192/26 - 64 hosts",
                          "128"=>"255.255.255.128/25 - 128 hosts",
                          "256"=>"255.255.255.0/24 - 256 hosts (class C)",
                          "512"=>"255.255.254.0/23 - 512 hosts",
                          "1024"=>"255.255.252.0/22 - 1k hosts",
                          "2048"=>"255.255.248.0/21 - 2k hosts",
                          "4096"=>"255.255.240.0/20 - 4k hosts",
                          "8192"=>"255.255.224.0/19 - 8k hosts",
                          "16384"=>"255.255.192.0/18 - 16k hosts",
                          "32768"=>"255.255.128.0/17 - 32k hosts",
                          "65536"=>"255.255.0.0/16 - 64k hosts (class B)",
                          "131072"=>"255.254.0.0/15 - 128k hosts",
                          "262144"=>"255.252.0.0/14 - 256k hosts"),
                    array("name"=>"size")));

insert($con,textbr());

insert($con,generic("br"));
insert($f2,submit(array("value"=>my_("Submit"))));
insert($f2,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
