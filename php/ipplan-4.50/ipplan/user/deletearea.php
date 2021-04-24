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

$title=my_("Delete a network area");

newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex) = myRegister("I:cust I:areaindex");

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_GET) {
   // save the last customer used
   // must set path else Netscape gets confused!
   setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

   // check if user belongs to customer admin group
   $result=$ds->GetCustomerGrp($cust);
   // can only be one row - does not matter if nothing is 
   // found as array search will return false
   $row = $result->FetchRow();
   if (!in_array($row["admingrp"], $grps)) {
      myError($w,$p, my_("You may not delete an area for this customer as you are not a member of the customers admin group"));
   } 
 
   if ($areaindex > 0) {
      $result=$ds->GetArea($cust, $areaindex);
      $row = $result->FetchRow();
      $areaip=inet_ntoa($row["areaaddr"]);
 
      $ds->DbfTransactionStart();
      $result=&$ds->ds->Execute("DELETE FROM area
                              WHERE areaindex=$areaindex") and
      $ds->AuditLog(array("event"=>152, "action"=>"delete area", 
                    "area"=>$areaip, "user"=>$_SERVER[AUTH_VAR],
                    "cust"=>$cust));
 
      if ($result) {
         $ds->DbfTransactionEnd();
         Header("Location: ".location_uri("modifyarearange.php?cust=$cust"));
         exit;
         //insert($w,text(my_("Area deleted")));
      }
      else {
         insert($w,text(my_("Area could not be deleted")));
      }
   }
   else {
      insert($w,text("Area index is invalid"));
   }
}

printhtml($p);

?>
