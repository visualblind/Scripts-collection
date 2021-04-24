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

// display overlaps between two customers - does the entire table
function searchOverlap($ds, &$w, $cust1, $cust2) {

   global $block;

   // dont trust variables
   $cust1=floor($cust1);
   $cust2=floor($cust2);
   $custdescrip1=$ds->GetCustomerDescrip($cust1);
   $custdescrip2=$ds->GetCustomerDescrip($cust2);

   // this query is not quick as indexes cannot be used!!!
   // must have first baseaddr called baseaddr else block pager
   // will not work - may break databases other than mysql
   $result=&$ds->ds->Execute("SELECT t1.baseaddr AS baseaddr,
                           t1.baseindex AS baseindex1,
                           t1.subnetsize AS subnetsize1,
                           t1.descrip AS descrip1,
                           t2.baseaddr AS baseaddr2,
                           t2.baseindex AS baseindex2,
                           t2.subnetsize AS subnetsize2,
                           t2.descrip AS descrip2
                        FROM base t1, base t2
                        WHERE ((t1.baseaddr BETWEEN t2.baseaddr AND
                                t2.baseaddr+t2.subnetsize-1) OR
                               (t1.baseaddr+t1.subnetsize-1
                                BETWEEN t2.baseaddr AND
                                        t2.baseaddr+t2.subnetsize-1) OR
                               (t1.baseaddr < t2.baseaddr AND
                                t1.baseaddr+t1.subnetsize >
                                t2.baseaddr+t2.subnetsize)) AND
                               t1.customer=$cust1 AND
                                t2.customer=$cust2
                        ORDER BY t1.baseaddr");

   $totcnt=0;
   $vars="";
   // fastforward till first record if not first block of data
   while ($block and $totcnt < $block*MAXTABLESIZE and
          $row = $result->FetchRow()) {
       $vars=DisplayBlock($w, $row, $totcnt, 
                            "&cust1[]=".$cust1.
                            "&cust2[]=".$cust2);
       $totcnt++;
   }
   insert($w,block("<p>"));

   $cnt=0;
   while($row = $result->FetchRow()) {

      // draw heading only if there are records to display
      if ($cnt==0) {
         // create a table
         insert($w,$t = table(array("cols"=>"8",
                                 "class"=>"outputtable")));
         // draw heading
         setdefault("cell",array("class"=>"heading"));
         insert($t,$c = cell(array("colspan"=>"4")));
         insert($c,block("<center>"));
         insert($c,text($custdescrip1));
         insert($c,block("</center>"));
         insert($t,$c = cell(array("colspan"=>"4")));
         insert($c,block("<center>"));
         insert($c,text($custdescrip2));
         insert($c,block("</center>"));

         insert($t,$c = cell());
         if (!empty($vars))
            insert($c,anchor($vars, "<<"));
         insert($c,text(my_("Base address")));
         insert($t,$c = cell());
         insert($c,text(my_("Subnet size")));
         insert($t,$c = cell());
         insert($c,text(my_("Subnet mask")));
         insert($t,$c = cell());
         insert($c,text(my_("Description")));

         insert($t,$c = cell());
         insert($c,text(my_("Base address")));
         insert($t,$c = cell());
         insert($c,text(my_("Subnet size")));
         insert($t,$c = cell());
         insert($c,text(my_("Subnet mask")));
         insert($t,$ck = cell());
         insert($ck,text(my_("Description")));

         setdefault("cell",array("class"=>color_flip_flop()));
      }

      // customer 1
      if ($row["subnetsize1"] == 1) {
          insert($t,$c = cell());
          insert($c,text(inet_ntoa($row["baseaddr"])));
      }
      else {
          insert($t,$c = cell());
          insert($c,anchor("displaysubnet.php?baseindex=".$row["baseindex1"],
                           inet_ntoa($row["baseaddr"])));
      }

      if ($row["subnetsize1"] == 1) {
          insert($t,$c = cell());
          insert($c,text("Host"));
      }
      else {
          insert($t,$c = cell());
          insert($c,text($row["subnetsize1"]));
      }

      insert($t,$c = cell());
      insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                   $row["subnetsize1"])."/".inet_bits($row["subnetsize1"])));

      insert($t,$c = cell());
      insert($c,text($row["descrip1"]));

      // customer 2
      if ($row["subnetsize2"] == 1) {
          insert($t,$c = cell());
          insert($c,text(inet_ntoa($row["baseaddr2"])));
      }
      else {
          insert($t,$c = cell());
          insert($c,anchor("displaysubnet.php?baseindex=".$row["baseindex2"],
                        inet_ntoa($row["baseaddr2"])));
      }

      if ($row["subnetsize2"] == 1) {
          insert($t,$c = cell());
          insert($c,text(my_("Host")));
      }
      else {
          insert($t,$c = cell());
          insert($c,text($row["subnetsize2"]));
      }

      insert($t,$c = cell());
      insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                   $row["subnetsize2"])."/".inet_bits($row["subnetsize2"])));

      insert($t,$c = cell());
      insert($c,text($row["descrip2"]));

      if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
         break;
      $cnt++;
      $totcnt++;
   }
   insert($w,block("<p>"));

   if ($cnt) {
       $vars="";
       $printed=0;
       while ($row = $result->FetchRow()) {
           $totcnt++;
           $vars=DisplayBlock($w, $row, $totcnt, 
                   "&cust1[]=".$cust1.
                   "&cust2[]=".$cust2);
           if (!empty($vars) and !$printed) {
               insert($ck,anchor($vars, ">>"));
               $printed=1;
           }

       }
   }

}



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

$title=my_("Results of your search");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust1, $cust2, $block) = myRegister("A:cust1 A:cust2 I:block");

// could be array!
//$cust1=floor($cust1);
//$cust2=floor($cust2);
if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

insert($w,heading(3, my_("Search for overlapping subnets between customers/autonomous systems")));

// reduce the two arrays to a single array, removing all duplicates
$arr=array_unique(array_merge($cust1, $cust2));
sort($arr);

if (count($arr) <= 1) {
   myError($w,$p, my_("Both customers selected are the same - all subnets will overlap!"));
}

// Loop through the list of customers doing an overlap search between
// the current customer and all of the following customers.

foreach ($arr as $ind1 => $id1) {
   foreach ($arr as $ind2 => $id2) {
      if ($id2 <= $id1) {
         continue;
      }
      searchOverlap($ds, $w, $id1, $id2);
   }
}

printhtml($p);

?>
