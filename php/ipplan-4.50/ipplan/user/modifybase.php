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

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Results of your search for subnet to modify");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex, $rangeindex, $ipaddr, $descrip, $action, $block, $ipplanParanoid) = myRegister("I:cust I:areaindex I:rangeindex S:ipaddr S:descrip S:action I:block I:ipplanParanoid");

// delete could be an array if user selected multiple!
if ($action=="delete") {
    if (is_array($baseindex)) {
        foreach($baseindex as $key => $value) {
            $baseindex[$key]=floor($value);
        }
    }
    else {
        $baseindex=array(0=>$baseindex);
    }
    // user hit submit without selecting anything!
    if (empty($baseindex[0])) {
        $action="";
    }
}
else {
    $baseindex=isset($baseindex) ? floor($baseindex) : 0;
}

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($action=="delete") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not delete a subnet for this customer as you are not a member of the customers admin group"));
    } 

    // $baseindex for delete was converted to array
    foreach ($baseindex as $baseindextmp) {
        // get info from base table
        $result=$ds->GetBaseFromIndex($baseindextmp);

        $row = $result->FetchRow();
        // record probably already deleted by another instance/user
        if (!$row) {
            continue;
        }
        $size=$row["subnetsize"];
        $base=$row["baseaddr"];
        $baseip=inet_ntoa($row["baseaddr"]);

        // test if subnet to delete is within bounds
        foreach ($grps as $value) {
            if ($extst = $ds->TestBounds($base, $size, $value)) {
                // got an overlap, allowed to delete
                break;
            } 
        }
        // could not find new subnet within any of the defined bounds
        // so do not delete
        if (!$extst) { 
            myError($w,$p,sprintf(my_("Subnet %s not deleted - out of defined authority boundary"), $baseip)."\n");
        }

        $ds->DbfTransactionStart();
        // check for attached files
        $result=&$ds->ds->Execute("SELECT ipaddr
                FROM ipaddradd
                WHERE baseindex=$baseindextmp AND infobin!=".$ds->ds->qstr(""));

        $files=0;
        while ($rowadd = $result->FetchRow()) {
            insert($w,textbr(sprintf(my_("IP address %s has files attached"), inet_ntoa($rowadd["ipaddr"]))));
        $files++;
        }
        // only delete if there are no files attached
        if ($files==0) {
            if ($ds->DeleteSubnet($baseindextmp)) {
                $ds->AuditLog(array("event"=>172, "action"=>"delete subnet", 
                    "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>$baseip,
                    "size"=>$size, "cust"=>$cust));

                $ds->DbfTransactionEnd();
                insert($w,textbr(sprintf(my_("Subnet %s deleted"), $baseip)));
            }
            else {
                insert($w,textbr(sprintf(my_("Subnet %s could not be deleted"), $baseip)));
            }
        }
        else {
            insert($w,textbr(sprintf(my_("Subnet %s could not be deleted - there are files attached"), $baseip)));
        }
    }
}
else if ($action=="split" or $action=="join") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not split or join a subnet for this customer as you are not a member of the customers admin group"));
    } 

    // get info from base table
    $result=$ds->GetBaseFromIndex($baseindex);
    if (!$row = $result->FetchRow()) {
       myError($w,$p, my_("Subnet cannot be found!"));
    }
    $size=$row["subnetsize"];
    $base=$row["baseaddr"];
    $descriptmp=$row["descrip"];
    $baseip=inet_ntoa($row["baseaddr"]);
    $admingrp=$ds->GetBaseGrp($baseindex);

    // test if subnet to delete is within bounds
    foreach ($grps as $value) {
        if ($extst = $ds->TestBounds($base, $size, $value)) {
            // got an overlap, allowed to delete
            break;
        } 
    }
    // could not find new subnet within any of the defined bounds
    // so do not delete
    if (!$extst) { 
        myError($w,$p,sprintf(my_("Subnet %s not split or joined - out of defined authority boundary"), $baseip)."\n");
    }

    $ds->DbfTransactionStart();
    // this code is not safe if transactions are not used
    // another user could have added a new subnet that causes an overlap
    // during the split and the create will thus fail. very unlikely though
    if ($action=="join") {
        // additional checks for join

        // check if subnet size * 2 is valid?
        if (TestBaseAddr(inet_aton3(inet_ntoa($base)), $size*2)) {
            myError($w,$p, my_("Subnets cannot be joined - Invalid base address!"));
        }

        // check if there is another subnet close by
        $result=$ds->GetDuplicateSubnet($base+$size, $size, $cust);
        if ($row = $result->FetchRow()) {
            // now check if there is exactly one subnet of the same size
            if ($row["subnetsize"]==$size) {
                // delete old one
                $basetmp=$row["baseindex"];
                // found adjacent subnet, so delete it
                $ds->ds->Execute("DELETE FROM base
                        WHERE baseindex=$basetmp");
                $ds->ds->Execute("DELETE FROM baseadd
                        WHERE baseindex=$basetmp");
                // ... and link its ip records to the bigger subnet
                // files attached to ip records will travel with
                $ds->ds->Execute("UPDATE ipaddr
                        SET baseindex=$baseindex
                        WHERE baseindex=$basetmp");
            }
            else {
                myError($w,$p, my_("Subnets cannot be joined - not the same size!"));
            }
        }
        else if ($size*2 > 262144) {
            myError($w,$p, my_("Subnets cannot be joined - subnet created would be too big!"));
        }
        // none found overlapping, so can extend subnet!
        // or overlapping subnet was already deleted
        $result=&$ds->ds->Execute("UPDATE base
                SET subnetsize=$size*2,
                lastmod=".$ds->ds->DBTimeStamp(time()).",
                userid=".$ds->ds->qstr($_SERVER[AUTH_VAR])."
                WHERE baseindex=$baseindex");

        $ds->AuditLog(array("event"=>173, "action"=>"join subnet", 
                    "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>$baseip,
                    "size"=>$size*2, "cust"=>$cust));
    }
    else if ($action=="split") {
        // user may have pressed browser reload, so check size again
        if ($size < 2) {
            myError($w,$p, my_("Subnets cannot be split - host network!"));
        }
        // halve size of subnet
        $result=&$ds->ds->Execute("UPDATE base
                SET subnetsize=$size/2,
                lastmod=".$ds->ds->DBTimeStamp(time()).",
                userid=".$ds->ds->qstr($_SERVER[AUTH_VAR])."
                WHERE baseindex=$baseindex");
        // ... and create new subnet
        $basetmp=$ds->CreateSubnet(($base+($size/2)), $size/2, 
                ($descriptmp." - ".time()), 
                $cust, 0, $admingrp);
        // ... and then link half of ip records to new subnet
        if ($basetmp) {
            $ds->ds->Execute("UPDATE ipaddr
                    SET baseindex=$basetmp
                    WHERE baseindex=$baseindex AND
                    ipaddr >= ".($base+($size/2))." AND
                    ipaddr <= ".($base+$size-1));
        }

        $ds->AuditLog(array("event"=>174, "action"=>"split subnet", 
                    "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>$baseip,
                    "size"=>$size/2, "cust"=>$cust));

    }
    $ds->DbfTransactionEnd();
    insert($w,textbr(my_("Subnet split or joined")));
}

// set start and end address according to range
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

$site="";
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

$srch = new mySearch($w, $_GET, $descrip, "descrip");
$srch->Search();  // draw the sucker!

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, 
                        "&cust=".$cust."&areaindex=".$areaindex.
                        "&rangeindex=".$rangeindex."&ipaddr=".$ipaddr.
                        "&descrip=".urlencode($descrip));
    $totcnt++;
}
insert($w,block("<p>"));

insert($w, $f = form(array("name"=>"deleterecords",
                           "method"=>"get",
                           "action"=>$_SERVER["PHP_SELF"])));

// create a table
insert($f,$t = table(array("cols"=>"6",
                           "class"=>"outputtable")));
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
insert($c,text(my_("Admin group")));
insert($t,$ck = cell());
insert($ck,text(my_("Action")));

 
$cnt=0;
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

    insert($t,$c = cell());
    insert($c,anchor("displaysubnet.php?baseindex=".$row["baseindex"]."&cust=".$cust, 
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
    insert($c,anchor("../admin/usermanager.php?action=groupeditform&grp=".urlencode($row["admingrp"]), 
                     $row["admingrp"]));
    insert($c,block("</small>"));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,checkbox(array("name"=>"baseindex[]",
                  "value"=>$row["baseindex"]), ""));

    insert($c,anchor($_SERVER["PHP_SELF"]."?baseindex=".$row["baseindex"]."&cust=".$cust.
                     "&areaindex=".$areaindex."&rangeindex=".$rangeindex.
                     "&descrip=".urlencode($descrip)."&block=".$block.
                     "&ipaddr=".$ipaddr."&action=delete", 
                     my_("Delete Subnet"),
                     $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block(" | "));
    insert($c,anchor("modifysubnet.php?baseindex=".$row["baseindex"].
                     "&areaindex=".$areaindex."&rangeindex=".$rangeindex.
                     "&cust=".$cust."&descrip=".urlencode($row["descrip"]).
                     "&ipaddr=".urlencode($ipaddr)."&search=".urlencode($descrip).
                     "&grp=".urlencode($row["admingrp"]), 
                     my_("Modify/Copy/Move subnet details")));
    insert($c,block(" | "));
    insert($c,anchor($_SERVER["PHP_SELF"]."?baseindex=".$row["baseindex"]."&cust=".$cust.
                "&areaindex=".$areaindex."&rangeindex=".$rangeindex.
                "&descrip=".urlencode($descrip)."&block=".$block.
                "&ipaddr=".$ipaddr."&action=join", 
                my_("Join Subnet"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    if($row["subnetsize"] > 1) {
        insert($c,block(" | "));
        insert($c,anchor($_SERVER["PHP_SELF"]."?baseindex=".$row["baseindex"]."&cust=".$cust.
                    "&areaindex=".$areaindex."&rangeindex=".$rangeindex.
                    "&descrip=".urlencode($descrip)."&block=".$block.
                    "&ipaddr=".$ipaddr."&action=split", 
                    my_("Split Subnet"),
                    $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    }

    insert($c,block("</small>"));

   if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
      break;
   $cnt++;
   $totcnt++;
}
insert($w,block("<p>"));

if ($cnt) {
   // save customer name for actual post of data
   insert($f,hidden(array("name"=>"cust",
                           "value"=>"$cust")));
   insert($f,hidden(array("name"=>"areaindex",
                          "value"=>"$areaindex")));
   insert($f,hidden(array("name"=>"rangeindex",
                           "value"=>"$rangeindex")));
   insert($f,hidden(array("name"=>"descrip",
                           "value"=>"$descrip")));
   insert($f,hidden(array("name"=>"block",
                           "value"=>"$block")));
   insert($f,hidden(array("name"=>"ipaddr",
                           "value"=>"$ipaddr")));
   insert($f,hidden(array("name"=>"action",
                           "value"=>"delete")));

// code to select all buttons on form named swiptosend
// checkbox array variable is named baseindex[]
        insert($f,block('
<script language="JavaScript" type="text/javascript">
<!--
function checkAll(val) {
   al=document.deleterecords;
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

// think this is too dangerous!
//   insert($f,anchor("javascript:checkAll(1)", my_("Check all")));
   insert($f,anchor("javascript:checkAll(0)", my_("Clear all")));

   insert($f,block("<p>"));
   insert($f,submit(array("value"=>my_("Delete multiple"))));
}

if (!$cnt) {
   myError($w,$p, my_("Search found no matching entries"));
}

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, 
            "&cust=".$cust."&areaindex=".$areaindex.
            "&rangeindex=".$rangeindex."&ipaddr=".$ipaddr.
            "&descrip=".urlencode($descrip));
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

$result->Close();
printhtml($p);

?>
