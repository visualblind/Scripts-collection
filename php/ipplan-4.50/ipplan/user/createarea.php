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
// Modify capabilities added by Denes Magyar (fat@poison.hu) 22/02/05

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

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex, $ipaddr, $action, $descrip) = myRegister("I:cust I:areaindex S:ipaddr S:action S:descrip");

$formerror="";
if ($action=="modify") {
    $title=my_("Modify a network area");
}
else {
    $title=my_("Create a new network area");
}
newhtml($p);
$w=myheading($p, $title, true);

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {
   // save the last customer used
   // must set path else Netscape gets confused!
   setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

   $descrip=trim($descrip);

   if (strlen($descrip) == 0) {
      $formerror .= my_("You need to enter a description for the area")."\n";
   }

   if (!$ipaddr)
      $formerror .= my_("Area address may not be blank")."\n";
   else if (testIP($ipaddr, TRUE))
      $formerror .= my_("Invalid area address - it must be the same format as an IP address")."\n";

   if (!$formerror) {

      $base=inet_aton($ipaddr);

      // check if user belongs to customer admin group
      $result=$ds->GetCustomerGrp($cust);
      // can only be one row - does not matter if nothing is 
      // found as array search will return false
      $row = $result->FetchRow();
      if (!in_array($row["admingrp"], $grps)) {
         myError($w,$p, my_("You may not create/modify an area for this customer as you are not a member of the customers admin group"));
      } 

      $ds->DbfTransactionStart();
      if ($action=="modify") {
          $result=&$ds->ds->Execute("UPDATE area SET areaaddr=$base, 
                  descrip=".$ds->ds->qstr($descrip)." WHERE areaindex=$areaindex;") and
          $ds->AuditLog(array("event"=>151, "action"=>"modify area", 
                    "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "area"=>$ipaddr,
                    "cust"=>$cust));
      }
      else {
          $result=&$ds->ds->Execute("INSERT INTO area
                  (areaaddr, descrip, customer)
                  VALUES
                  ($base, ".$ds->ds->qstr($descrip).", $cust)") and
          $ds->AuditLog(array("event"=>150, "action"=>"create area", 
                    "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "area"=>$ipaddr,
                    "cust"=>$cust));
      }
  
      if ($result) {
          $ds->DbfTransactionEnd();
          if ($action=="modify") {
              Header("Location: ".location_uri("modifyarearange.php?cust=$cust"));
              //insert($w,textbr(my_("Area modified")));
              //printhtml($p);
              exit;
          }
          else {
              insert($w,textbr(my_("Area created")));
          }
          $ipaddr=""; $descrip="";
      }
      else {
         $ds->DbfTransactionRollback();
         $formerror .= my_("Area could not be created/modified - probably a duplicate name")."\n";
      }
   }
}

myError($w,$p, $formerror, FALSE);

// display opening text
insert($w,heading(3, "$title."));

if ($action!="modify") {
    insert($w,textbrbr(my_("Create a new network area by entering a unique identifier address for the area. The identifier has the same format as IP addresses, but has no relation to existing IP address records. Areas usually define geographic or administrative boundaries. Areas can also contain multiple ranges of address space, as in many cases the address space is not contiguous - there may be a mix of private or public address space used.")));
}

// start form
insert($w, $f = form(array("method"=>"post",
                           "action"=>$_SERVER["PHP_SELF"])));

if ($action=="modify") {
       insert($f,hidden(array("name"=>"cust",
                          "value"=>"$cust")));
       insert($f,hidden(array("name"=>"action",
                          "value"=>"modify")));
       insert($f,hidden(array("name"=>"areaindex",
                          "value"=>$areaindex)));
}
else {
    // ugly kludge with global variable!
    $displayall=TRUE;
    $cust=myCustomerDropDown($ds, $f, $cust, $grps, FALSE) or myError($w,$p, my_("No customers"));
}

insert($f,textbrbr(my_("Area address")));

insert($f,input_text(array("name"=>"ipaddr",
                           "value"=>"$ipaddr",
                           "size"=>"15",
                           "maxlength"=>"15")));

insert($f,textbrbr(my_("Description")));
insert($f,input_text(array("name"=>"descrip",
                           "value"=>"$descrip",
                           "size"=>"80",
                           "maxlength"=>"80")));

insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
