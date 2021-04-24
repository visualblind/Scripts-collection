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

$title=my_("Search for user info");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex) = myRegister("I:cust I:areaindex");

// display opening text
insert($w,heading(3, "$title."));

insert($w,textbrbr(my_("Search for user info searches the individual IP address records.")));

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

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
                            "action"=>"searchall.php")));

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

insert($con,textbr(my_("Field to search")));

$lst=array("userinf"=>my_("User"),
           "location"=>my_("Location"),
           "descrip"=>my_("Description"),
           "hname"=>my_("Host Name"),
           "telno"=>my_("Telephone Number"),
           "template"=>my_("Search in Template"));

insert($con,selectbox($lst,
                 array("name"=>"field")));

insert($con,textbrbr(my_("Date to search from")));
insert($con,text(my_("Day")));
insert($con,selectbox(array("0"=>my_("Any"),
                           "1"=>"1",
                           "2"=>"2",
                           "3"=>"3",
                           "4"=>"4",
                           "5"=>"5",
                           "6"=>"6",
                           "7"=>"7",
                           "8"=>"8",
                           "9"=>"9",
                           "10"=>"10",
                           "11"=>"11",
                           "12"=>"12",
                           "13"=>"13",
                           "14"=>"14",
                           "15"=>"15",
                           "16"=>"16",
                           "17"=>"17",
                           "18"=>"18",
                           "19"=>"19",
                           "20"=>"20",
                           "21"=>"21",
                           "22"=>"22",
                           "23"=>"23",
                           "24"=>"24",
                           "25"=>"25",
                           "26"=>"26",
                           "27"=>"27",
                           "28"=>"28",
                           "29"=>"29",
                           "30"=>"30",
                           "31"=>"31"),
                 array("name"=>"day")));

insert($con,text(my_("Month")));
insert($con,selectbox(array("0"=>my_("Any"),
                           "1"=>my_("January"),
                           "2"=>my_("February"),
                           "3"=>my_("March"),
                           "4"=>my_("April"),
                           "5"=>my_("May"),
                           "6"=>my_("June"),
                           "7"=>my_("July"),
                           "8"=>my_("August"),
                           "9"=>my_("September"),
                           "10"=>my_("October"),
                           "11"=>my_("November"),
                           "12"=>my_("December")),
                 array("name"=>"month")));

insert($con,text(my_("Year")));
insert($con,selectbox(array("0"=>my_("Any"),
                           "1995"=>"1995",
                           "1996"=>"1996",
                           "1997"=>"1997",
                           "1998"=>"1998",
                           "1999"=>"1999",
                           "2000"=>"2000",
                           "2001"=>"2001",
                           "2002"=>"2002",
                           "2003"=>"2003",
                           "2004"=>"2004",
                           "2005"=>"2005",
                           "2006"=>"2006",
                           "2007"=>"2007"),
                 array("name"=>"year")));

if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql" or DBF_TYPE=="postgres7")
   insert($con,textbrbr(my_("Search criteria (only display records matching the regular expression)")));
else
   insert($con,textbrbr(my_("Search criteria (only display records containing)")));
insert($con,input_text(array("name"=>"search",
                           "size"=>"80",
                           "maxlength"=>"80")));

insert($con,generic("br"));
insert($f2,submit(array("value"=>my_("Submit"))));
insert($f2,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
