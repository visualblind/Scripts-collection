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
list($cust, $areaindex, $rangeindex, $searchin, $jump, $block, $descrip, $expr, $size, $subnetsize) = myRegister("I:cust I:areaindex I:rangeindex I:searchin I:jump I:block S:descrip S:expr I:size I:subnetsize");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds = new Base() or myError($w,$p, my_("Could not connect to database"));

$ds->SetGrps($grps);
$ds->SetIPaddr($ipaddr);
$ds->SetSubnetSize($subnetsize);  // set from findfree.php
$ds->SetSearchIn($searchin);
$ds->SetDescrip($descrip);

// set search type
if (empty($expr) and !empty($descrip)) $expr="RLIKE";  // first run?
$ds->expr=$expr;
$ds->size=$size;
$result = $ds->FetchBase($cust, $areaindex, $rangeindex);
if (!$result) {
   myError($w,$p, $ds->errstr);
}

// for "all" customer, $cust may have changed in class
$cust=$ds->cust;

// if searching for address only and not all customer and we found some data, then go directly to
// modifyipform page
if ($searchin and $cust > 0) {
    // does subnet exist? is jump set? then jump to ip record, else fall through and display subnet
    if ($jump and $row = $result->FetchRow()) {
        header("Location: ".location_uri("modifyipform.php?ip=".inet_aton($ipaddr)."&baseindex=".$row["baseindex"]));
        exit;
    }
}

if ($areaindex and !$rangeindex) {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between multiple ranges for customer '%s'"), $ds->custdescrip)));
}
else {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between %s and %s %s for customer '%s'"), $ds->start, $ds->end, $ds->site, $ds->custdescrip)));
}

if ($ipaddr) {
   insert($w,textb(my_("IP address filter: ")));
   insert($w,textbr($ipaddr));
}
if ($descrip) {
   insert($w,textb(my_("Description filter: ")));
   insert($w,textbr($descrip));
}
if ($size > 0) {
   insert($w,textb(my_("Subnet size filter: Subnets larger than ")));
   insert($w,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                    $size)."/".inet_bits($size)));
}

$srch = new mySearch($w, $_GET, $descrip, "descrip");
$srch->expr=$expr;
$srch->expr_disp=TRUE;
$srch->Search();  // draw the sucker!

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, 
                        "&cust=$cust&areaindex=$areaindex".
                        "&rangeindex=$rangeindex&ipaddr=$ipaddr&expr=$expr&size=$size".
                        "&descrip=".urlencode($descrip));
    $totcnt++;
}
insert($w,block("<p>"));

// create a table
if (REGENABLED) {
   insert($w,$t = table(array("cols"=>"7",
                              "class"=>"outputtable")));
}
else {
   insert($w,$t = table(array("cols"=>"6",
                              "class"=>"outputtable")));
}

// draw heading
setdefault("cell",array("class"=>"heading"));
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
insert($c,text(my_("Last modified")));
insert($t,$ck = cell());
insert($ck,text(my_("Changed by")));
if (REGENABLED) {
   insert($t,$ck = cell());
   insert($ck,text(my_("Update sent")));
}


$cnt=0;
$prevrow="";
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

    // customer is 0, display all customers with customer description
    // on customer change
    if ($cust == 0 and $row["custdescrip"] != $prevrow) {
        if (REGENABLED) {
           insert($t,$c = cell(array("colspan"=>"7")));
        }
        else {
           insert($t,$c = cell(array("colspan"=>"6")));
        }

        insert($c,generic("b"));
        insert($c,anchor($_SERVER["PHP_SELF"]."?cust=".$row["customer"]."&areaindex=&rangeindex=&ipaddr=$ipaddr&descrip=".urlencode($descrip)."&expr=$expr&size=$size", 
                         $row["custdescrip"]));
        $prevrow=$row["custdescrip"];
    }

    insert($t,$c = cell());
    insert($c,anchor("displaysubnet.php?baseindex=".$row["baseindex"], 
                     inet_ntoa($row["baseaddr"])));

    if ($row["subnetsize"] == 1) {
        insert($t,$c = cell());
        insert($c,text(my_("Host")));
    }
    else {
        insert($t,$c = cell());
        insert($c,text($row["subnetsize"]));
    }

    insert($t,$c = cell());
    insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                    $row["subnetsize"])."/".inet_bits($row["subnetsize"])));

    insert($t,$c = cell());
    insert($c,text($row["descrip"]));
    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,block($result->UserTimeStamp($row["lastmod"], "M d Y H:i:s")));
    insert($c,block("</small>"));
    insert($t,$c = cell());
    insert($c,text($row["userid"]));
    if (REGENABLED) {
       insert($t,$c = cell());
       insert($c,block("<small>"));
       insert($c,block($result->UserTimeStamp($row["swipmod"], "M d Y H:i:s")));
       insert($c,block("</small>"));
    }

    if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
       break;
    $cnt++;
    $totcnt++;
}
insert($w,block("<p>"));

if (!$cnt) {
   myError($w,$p, my_("Search found no matching entries"));
}

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, 
                        "&cust=$cust&areaindex=$areaindex".
                        "&rangeindex=$rangeindex&ipaddr=$ipaddr&expr=$expr&size=$size".
                        "&descrip=".urlencode($descrip));
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

$result->Close();
printhtml($p);

?>
