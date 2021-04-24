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

$title=my_("Display overlapping address space between customers/autonomous systems");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust) = myRegister("I:cust");

// display opening text
insert($w,textbr());
insert($w,text("$title."));
insert($w,block("<p>"));
insert($w,span(my_("This function consumes large amounts of memory on the server. If you get server errors, blank pages or nothing happens when you submit, you may need to reduce the range of your search or you may need to increase the amount of memory allocated to PHP on the server."), 
                        array("class"=>"textError")));



$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// start form
insert($w, $f = form(array("method"=>"get",
                           "action"=>"displayoverlap.php")));

insert($f,textbrbr(my_("Customer/autonomous system 1 - select multiple")));

$result=$ds->GetCustomerGrp(0);
$lst=array();
while($row = $result->FetchRow()) {
   if (strtolower($row["custdescrip"])=="all")
      continue;

   // strip out customers user may not see due to not being member
   // of customers admin group. $grps array could be empty if anonymous
   // access is allowed!
   if(!empty($grps)) {
      if(!in_array($row["admingrp"], $grps))
         continue;
   }

   $col=$row["customer"];
   // make customer first customer in database
   if (!$cust) {
      $cust=$col;
      $custset=1;    // remember that customer was blank
   }
   // only make customer same as cookie if customer actually
   // still exists in database, else will cause loop!
   if ($custset) {
       if ($col == $ipplanCustomer) {
           // dont trust cookie
           $cust=floor($ipplanCustomer);
       }
   }
   $lst["$col"]=$row["custdescrip"];
}

insert($f,selectbox($lst,
                 array("name"=>"cust1[]", "multiple size"=>5),
                 $cust));

insert($f,textbrbr(my_("Customer/autonomous system 2 - select multiple")));

$result=$ds->GetCustomerGrp(0);
$lst=array();
while($row = $result->FetchRow()) {
   if (strtolower($row["custdescrip"])=="all")
      continue;

   // strip out customers user may not see due to not being member
   // of customers admin group. $grps array could be empty if anonymous
   // access is allowed!
   if(!empty($grps)) {
      if(!$ds->TestGrpsAdmin($grps)) {
         if(!in_array($row["admingrp"], $grps))
            continue;
      }
   }

   $col=$row["customer"];
   $lst["$col"]=$row["custdescrip"];
}

insert($f,selectbox($lst,
                 array("name"=>"cust2[]", "multiple size"=>5)));

insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

$result->Close();
printhtml($p);

?>
