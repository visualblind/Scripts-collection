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

$title=my_("Results of your search");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex, $rangeindex, $ipaddr, $descrip, $filename, $ntnameopt) = myRegister("I:cust I:areaindex I:rangeindex S:ipaddr S:descrip S:filename I:ntnameopt");

// extra protection on filename passed!
$filename=basename($filename);

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
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

// set start and end address according to range
$site="";
if ($rangeindex) {
    // should only return one row here!
    $result=$ds->GetRange($cust, $rangeindex);
    $row = $result->FetchRow();
 
    $start=inet_ntoa($row["rangeaddr"]);
    $end=inet_ntoa($row["rangeaddr"]+$row["rangesize"]-1);
    $site=" (".$row["descrip"].")";
}
else {
    if ($ipaddr) {
       $start = completeIP($ipaddr, 1);
       $end = completeIP($ipaddr, 2);

       if (testIP($start) or testIP($end)) {
          myError($w,$p, my_("Invalid IP address!"));
       }
    }
    else {
       $start=DEFAULTROUTE;
       $end=ALLNETS;
    }
}

$startnum=inet_aton($start);
$endnum=inet_aton($end);

$custdescrip=$ds->GetCustomerDescrip($cust);

if ($areaindex and !$rangeindex) {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between multiple ranges for customer '%s'"), $custdescrip)));
   $result = $ds->GetBaseFromArea($areaindex, $descrip, $cust);
}
else {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between %s and %s %s for customer '%s'"), $start, $end, $site, $custdescrip)));
   $result = $ds->GetBase($startnum, $endnum, $descrip, $cust);
}
if ($ipaddr) {
   insert($w,textb(my_("IP address filter: ")));
   insert($w,textbr($ipaddr));
}
if ($descrip) {
   insert($w,textb(my_("Description filter: ")));
   insert($w,textbr($descrip));
}

insert($w, $f = form(array("name"=>"swiptosend",
                           "method"=>"post",
                           "action"=>"emailswip.php")));

$cnt=0;
while($row = $result->FetchRow()) {

    $swip=genSWIP($ds, $row["baseindex"], inet_ntoa($row["baseaddr"]), 
            inet_ntoa($row["baseaddr"]+$row["subnetsize"]-1), 
            $cust, $row["descrip"], $filename);
    if ($swip == FALSE)
        myError($w,$p, my_("Error reading template!"));

    insert($f,block("<pre>"));
    insert($f,text($swip));
    insert($f,block("</pre>"));

    $ind=$row["baseindex"];
    insert($f,checkbox(array("name"=>"baseindex[]",
                    "value"=>"$ind"),
                my_("E-mail this entry?")));
    if ($row["swipmod"]) {
        insert($f,text(" ".my_("Previously sent:")." "));
        insert($f,block($result->UserTimeStamp($row["swipmod"], "M d Y H:i:s")));
    }

    insert($f,block("<hr>"));

    $cnt++;
}

insert($f,block("<p>"));

if ($cnt) {
   // save customer name for actual post of data
   insert($f,hidden(array("name"=>"ntnameopt",
                           "value"=>"$ntnameopt")));
   insert($f,hidden(array("name"=>"cust",
                           "value"=>"$cust")));
   insert($f,hidden(array("name"=>"filename",
                           "value"=>"$filename")));

// code to select all buttons on form named swiptosend
// checkbox array variable is named baseindex[]
        insert($f,block('
<script language="JavaScript" type="text/javascript">
<!--
function checkAll(val) {
   al=document.swiptosend;
   len = al.elements.length;
   var i=0;
   for( i=0 ; i<len ; i++) {
      if (al.elements[i].name==\'baseindex[]\') {
         al.elements[i].checked=val;
      }
   }
}
//-->
</script>
'));

   insert($f,anchor("javascript:checkAll(1)", my_("Check all")));
   insert($f,block(" | "));
   insert($f,anchor("javascript:checkAll(0)", my_("Clear all")));

   insert($f,block("<p>"));
   insert($f,submit(array("value"=>my_("Submit"))));
   // insert($f,freset(array("value"=>my_("Clear"))));
}
else {
   myError($w,$p, my_("Search found no matching entries"));
}

$result->Close();
printhtml($p);

?>
