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

$title=my_("Display customer/autonomous system information");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($search, $expr, $ipplanParanoid) = myRegister("S:search S:expr I:ipplanParanoid");

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// what is the additional search SQL?
$sql=$ds->mySearchSql("custdescrip", $expr, $search, FALSE);
$result=$ds->GetCustomer($sql);

insert($w,heading(3, my_("All customer/autonomous system info")));

// draw the search box
$srch = new mySearch($w, array(), $search, "search");
$srch->legend=my_("Refine Search on Description");
$srch->expr=$expr;
$srch->expr_disp=TRUE;
$srch->Search();  // draw the sucker!

insert($w,textbr());

// create a table
insert($w,$t = table(array("cols"=>"3",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
insert($c,text(my_("Customer description")));
insert($t,$c = cell());
insert($c,text(my_("Group name")));
insert($t,$c = cell());
insert($c,text(my_("Action")));


// do this here else will do extra queries for every customer
$adminuser=$ds->TestGrpsAdmin($grps);

$cnt=0;
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

   // strip out customers user may not see due to not being member
   // of customers admin group. $grps array could be empty if anonymous
   // access is allowed!
   if(!$adminuser) {
      if(!empty($grps)) {
         if(!in_array($row["admingrp"], $grps))
            continue;
      }
   }

   insert($t,$c = cell());
   insert($c,text($row["custdescrip"]));

   insert($t,$c = cell());
   insert($c,text($row["admingrp"]));

   insert($t,$c = cell());
   insert($c,block("<small>"));
   insert($c,anchor("deletecustomer.php?cust=".$row["customer"], 
                         my_("Delete customer/AS"),
                         $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
   insert($c,block(" | "));
   insert($c,anchor("modifycustomer.php?cust=".$row["customer"].
                         "&custdescrip=".urlencode($row["custdescrip"]).
                         "&grp=".urlencode($row["admingrp"]), 
                         my_("Modify customer/AS details")));
   insert($c,block(" | "));
   insert($c,anchor("exportdhcp.php?cust=".$row["customer"],
                         my_("Export DHCP details")));
   insert($c,block(" | "));
   insert($c,anchor("../admin/usermanager.php?action=groupeditform&grp=".urlencode($row["admingrp"]), 
                    my_("Group membership")));
   insert($c,block("</small>"));

   $cnt++;
}

insert($w,block("<p>"));
insert($w,textb(sprintf(my_("Total records: %u"), $cnt)));

$result->Close();
printhtml($p);

?>
