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

$title=my_("Find free address space/Statistics");
newhtml($p);
$w=myheading($p, $title, true);

// display opening text
insert($w,heading(3, "$title."));

insert($w,text(my_("Display free address space shows blocks or holes that are available for potential assignment as networks. The search will not display free space if the search only covers unallocated address space.")));
insert($w,block("<p>"));
insert($w,textbr(my_("Subnets with a description of 'free' or 'spare' will also be shown.")));
insert($w,block("<p>"));
insert($w,span(my_("This function consumes large amounts of memory on the server. If you get server errors, blank pages or nothing happens when you submit, you may need to reduce the range of your search or you may need to increase the amount of memory allocated to PHP on the server."), 
                        array("class"=>"textError")));


$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

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
                            "action"=>"findfree.php")));

// save customer name for actual post of data
insert($f2,hidden(array("name"=>"cust",
                        "value"=>"$cust")));

myRangeDropDown($ds, $f2, $cust, $areaindex);
insert($f2, block("<p>"));

insert($f2, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Search criteria")));

insert($con,textbr(my_("IP range start (leave blank if range selected)")));
insert($con,input_text(array("name"=>"start",
                            "size"=>"15",
                            "maxlength"=>"15")));

insert($con,textbrbr(my_("IP range end (leave blank if range selected)")));
insert($con,input_text(array("name"=>"end",
                            "size"=>"15",
                            "maxlength"=>"15")));

insert($con,textbrbr(my_("Display only subnets between these sizes")));
insert($con,span(my_("Minimum"), array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"size_from",
                            "size"=>"5",
                            "maxlength"=>"6")));

insert($con,span(my_("Maximum"), array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"size_to",
                            "size"=>"5",
                            "maxlength"=>"6")));

insert($con,textbrbr(my_("Show filter")));
insert($con,radio(array("name"=>"showused",
                         "value"=>"0"),
                         my_("Free and Unassigned")));
insert($con,radio(array("name"=>"showused",
                         "value"=>"2"),
                         my_("Unassigned only")));
insert($con,radio(array("name"=>"showused",
                         "value"=>"1"),
                         my_("All"), "checked"));

insert($con,generic("br"));
insert($f2,submit(array("value"=>my_("Submit"))));
insert($f2,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
