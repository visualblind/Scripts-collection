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
require_once("swiplib.php");
require_once("../auth.php");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Registrar information sent");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($baseindex, $ntnameopt, $cust, $filename) = myRegister("A:baseindex I:ntnameopt I:cust S:filename");

// extra protection on filename passed!
$filename=basename($filename);

if (!$_POST) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}
if (empty($baseindex)) {
   myError($w,$p, my_("No registrar updates selected to send"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// check if user belongs to customer admin group
$result=$ds->GetCustomerGrp($cust);
// can only be one row - does not matter if nothing is 
// found as array search will return false
$row = $result->FetchRow();
if (!in_array($row["admingrp"], $grps)) {
    myError($w,$p, my_("You may not send a registrar update for this customer as you are not a member of the customers admin group"));
}

$formerror="";
$cnt=0;
foreach($baseindex as $key => $value) {
   $value=floor($value);   // dont trust values posted
   $result=$ds->GetBaseFromIndex($value);
   $row = $result->FetchRow();

   $baseip=inet_ntoa($row["baseaddr"]);
   $size=$row["subnetsize"];
   $swip=genSWIP($ds, $value, $baseip, 
                      inet_ntoa($row["baseaddr"]+$size-1), 
                      $cust, $row["descrip"], $filename);

   insert($w,block("<pre>"));
   insert($w,text($swip));
   insert($w,block("</pre><hr>"));
   
   $err=emailSWIP($swip);
   // on email error, fail
   if ($err) {
       $formerror .= my_("E-mail message was not sent")."\n";
       $formerror .= my_("Mailer Error: ") . $err;
       break;
   }

   $result=&$ds->ds->Execute("UPDATE base
                          SET swipmod=".$ds->ds->DBTimeStamp(time())."
                          WHERE baseindex=$value");

   $ds->AuditLog(array("event"=>190, "action"=>"send swip", 
                    "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>$baseip, "template"=>$filename,
                    "size"=>$size, "cust"=>$cust));

}

myError($w,$p, $formerror, FALSE);
 
insert($w,block("<p>"));

printhtml($p);

?>
