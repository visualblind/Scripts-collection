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
   $auth->authenticate();
}

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Modify IP address details (range)");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($baseindex, $block, $ip, $search, $expr, $ipplanParanoid) = myRegister("I:baseindex I:block A:ip S:search S:expr I:ipplanParanoid");
//$ip=array($ip);   // type array

if (!$_POST) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// save md5str for check in displaysubnet.php to see if info has
// been modified since start of edit
$md5str=$ds->GetMD5($ip, $baseindex);
 
insert($w,block("<h3>"));
insert($w,text(my_("IP Addresses to modify: ")));
foreach ($ip as $value) 
   insert($w,text(inet_ntoa($value)." "));
insert($w,block("<small>"));
if (isset($_SERVER['HTTP_REFERER']) and stristr($_SERVER['HTTP_REFERER'], "displaysubnet.php")) {
    insert($w,anchor($_SERVER['HTTP_REFERER'], my_("Back to subnet")));
}
insert($w,block("</small>"));
insert($w,block("</h3>"));

// start form
insert($w, $f = form(array("name"=>"MODIFY",
                           "method"=>"post",
                           "action"=>"displaysubnet.php")));

myFocus($p, "MODIFY", "user");
insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("User information")));
insert($con,textbr(my_("User")));
insert($con,input_text(array("name"=>"user",
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,block(" <a href='#' onclick='MODIFY.user.value=\"".
                    DHCPRESERVED."\";'>DHCP address</a>"));
insert($con,textbrbr(my_("Location")));
insert($con,input_text(array("name"=>"location",
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,textbrbr(my_("Device description")));
insert($con,input_text(array("name"=>"descrip",
                           "size"=>"80",
                           "maxlength"=>"80")));

insert($con,textbrbr(my_("Telephone number")));
insert($con,input_text(array("name"=>"telno",
                           "size"=>"15",
                           "maxlength"=>"15")));
 
insert($con,hidden(array("name"=>"baseindex",
                       "value"=>$baseindex)));
insert($con,hidden(array("name"=>"block",
                       "value"=>$block)));
insert($con,hidden(array("name"=>"search",
                       "value"=>$search)));
insert($con,hidden(array("name"=>"expr",
                      "value"=>"$expr")));
 
$cnt=0;
foreach ($ip as $value) {
    insert($con,hidden(array("name"=>"ip[".$cnt++."]",
                          "value"=>"$value")));
}
insert($con,hidden(array("name"=>"md5str",
                      "value"=>"$md5str")));

insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

// start form for delete
// all info will be blank, thus record will be deleted
$settings=array("name"=>"DELETE",
                "method"=>"post",
                "action"=>"displaysubnet.php");
if ($ipplanParanoid)
   $settings["onsubmit"]="return confirm('".my_("Are you sure?")."')";
insert($w, $f = form($settings));

insert($f,hidden(array("name"=>"baseindex",
                       "value"=>"$baseindex")));
insert($f,hidden(array("name"=>"block",
                       "value"=>"$block")));
insert($f,hidden(array("name"=>"search",
                       "value"=>$search)));
insert($con,hidden(array("name"=>"expr",
                      "value"=>"$expr")));
$cnt=0;
foreach ($ip as $value) {
    insert($f,hidden(array("name"=>"ip[".$cnt++."]",
                           "value"=>"$value")));
}
insert($f,hidden(array("name"=>"action",
                       "value"=>"delete")));
insert($f,hidden(array("name"=>"md5str",
                      "value"=>"$md5str")));

insert($f,submit(array("value"=>my_("Delete records"))));
insert($f,textbr(my_("WARNING: Deleting an entry does not preserve the last modified information as the record is completely removed from the database to conserve space.")));

printhtml($p);

?>
