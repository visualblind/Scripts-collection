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

$title=my_("Delete customer/autonomous system results");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust) = myRegister("I:cust");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if (!$ds->TestCustomerCreate($_SERVER[AUTH_VAR])) {
   myError($w,$p, my_("You may not delete customers as you are not a member a group that can delete customers"));
}

// check if customer has subnets assigned
$result=&$ds->ds->SelectLimit("SELECT baseaddr, descrip
                           FROM base
                           WHERE customer=$cust
                           ORDER BY baseaddr", 100);
if ($row=$result->FetchRow()) {
   insert($w,text(my_("Cannot delete customer because the following subnets are assigned to the customer (limited to first 100):")));
   insert($w,block("<p>"));

   // create a table
   insert($w,$t = table(array("cols"=>"2",
                              "class"=>"outputtable")));
   // draw heading
   setdefault("cell",array("class"=>"heading"));
   insert($t,$c = cell());
   insert($c,text(my_("Base address")));
   insert($t,$c = cell());
   insert($c,text(my_("Subnet description")));


   do {
   setdefault("cell",array("class"=>color_flip_flop()));

      insert($t,$c = cell());
      insert($c,text(inet_ntoa($row["baseaddr"])));
 
      insert($t,$c = cell());
      insert($c,text($row["descrip"]));
   } while($row = $result->FetchRow());
   insert($w,block("<p>"));

   printhtml($p);
   exit;
} 

// check if customer has DNS information (forward zone)
$result=&$ds->ds->SelectLimit("SELECT customer
                           FROM fwdzone
                           WHERE customer=$cust", 1);
if ($row=$result->FetchRow()) {
   insert($w,text(my_("Cannot delete customer because customer has DNS zones defined")));
   insert($w,block("<p>"));

   printhtml($p);
   exit;
}

// check if customer has DNS information (reverse zone)
$result=&$ds->ds->SelectLimit("SELECT customer
                           FROM zones
                           WHERE customer=$cust", 1);
if ($row=$result->FetchRow()) {
   insert($w,text(my_("Cannot delete customer because customer has reverse DNS zones defined")));
   insert($w,block("<p>"));

   printhtml($p);
   exit;
}

$ds->DbfTransactionStart();
$result=&$ds->ds->Execute("DELETE FROM customer
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM custinfo
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM custadd
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM revdns
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM area
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM range
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM fwdzone
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM fwdzonerec
                        WHERE customer=$cust") and
$result=&$ds->ds->Execute("DELETE FROM zones
                        WHERE customer=$cust") and
$ds->AuditLog(array("event"=>182, "action"=>"delete customer", 
                    "user"=>$_SERVER[AUTH_VAR], "cust"=>$cust));
  
if ($result) {
   $ds->DbfTransactionEnd();
   insert($w,text(my_("Customer deleted")));
}
else {
   insert($w,text(my_("Customer could not be deleted")));
}

printhtml($p);

?>
