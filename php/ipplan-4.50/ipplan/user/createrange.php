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


// when ranges or aggregates are created, should we test for overlaps within customer?
// RANGETEST=0 - no overlaps allowed at all
// RANGETEST=1 - overlaps within areas allowed
// RANGETEST=2 - any type of overlap allowed

// upgraded versions of IPplan before 4.47 will require a database ALTER TABLE
// to remove UNIQUE index on range field. New installations to not require the ALTER TABLE:
// DROP INDEX rangeaddr ON range;
// ALTER TABLE range ADD  INDEX range_rangeaddr  (rangeaddr, customer);


// test if ranges overlap
function TestDuplicateRange($ds, $rangeaddr, $rangesize, $cust) {

    // full test, no form of overlap allowed
    if (RANGETEST==0) {
        $result=&$ds->ds->Execute("SELECT rangeaddr
                FROM range
                WHERE (($rangeaddr BETWEEN rangeaddr AND 
                        rangeaddr + rangesize - 1) OR
                    ($rangeaddr < rangeaddr AND 
                     $rangeaddr+$rangesize > 
                     rangeaddr + rangesize - 1)) AND
                customer=$cust");
    }
    // only exact duplicates are rejected - no UNIQUE index for all three conditions
    else if (RANGETEST==1) {
        $result=&$ds->ds->Execute("SELECT rangeaddr
                FROM range
                WHERE rangeaddr = $rangeaddr AND rangesize = $rangesize AND customer=$cust");
    }
    // do no checks at all - allows overlaps across areas and within areas
    else {
        return 0;
    }
    
    if ($result->FetchRow()) {
        return 1;
    }

}

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
list($cust, $areaindex, $rangeindex, $action, $size, $ipaddr, $descrip) = myRegister("I:cust I:areaindex I:rangeindex S:action I:size S:ipaddr S:descrip");
$formerror="";

if ($action=="modify") {
    $title=my_("Modify a range or supernet/summary");
}
else {
    $title=my_("Create a new range or supernet/summary");
}
newhtml($p);
$w=myheading($p, $title, true);

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {
    // save the last customer used
    // must set path else Netscape gets confused!
    setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

    if ($action=="modify") {
        $result=$ds->GetRange($cust, $rangeindex);
        if (!$row = $result->FetchRow()) {
            myError($w,$p, my_("Range cannot be found!"));
        }
    }

    $descrip=trim($descrip);

    if (strlen($descrip) == 0) {
        $formerror .= my_("You need to enter a description for the range")."\n";
    }

    $base=inet_aton($ipaddr);

    if (!$ipaddr)
        $formerror .= my_("Range address may not be blank")."\n";
    else if (testIP($ipaddr))
        $formerror .= my_("Invalid range address")."\n";
    else if (!$size)
        $formerror .= my_("Size may not be zero")."<br>";
    else if (TestDuplicateRange($ds, $base, $size, $cust)) {
        if ($action=="modify") {
            // ok if just changing description
            if($row["rangeaddr"]==$base and $row["rangesize"]==$size) {
            }
            // ok if making smaller
            else if($row["rangeaddr"]==$base and $size<$row["rangesize"]) {
            }
            // ok if allowed to overlap
            else if(RANGETEST >= 2) {
            }
            else {
                $formerror .= my_("Range cannot be modified - overlaps with existing range or overlaps with self if trying to change size. Try moving the range out of the way first before resizing.")."\n";
            }
        }
        else {
            $formerror .= my_("Range cannot be created - overlaps with existing range")."\n";
        }
    }

    if ($size > 1) {
        if (TestBaseAddr(inet_aton3($ipaddr), $size)) {
            $formerror .= my_("Invalid base address")."\n";
        }
    }

    if (!$formerror) {
        // check if user belongs to customer admin group
        $result=$ds->GetCustomerGrp($cust);
        // can only be one row - does not matter if nothing is 
        // found as array search will return false
        $row = $result->FetchRow();
        if (!in_array($row["admingrp"], $grps)) {
            myError($w,$p, my_("You may not create/modify a range for this customer as you are not a member of the customers admin group"));
        } 

        // cast type correctly to prevent blank area!
        $areaindex=(int)$areaindex;

        $ds->DbfTransactionStart();
        // the fact that the range is unique prevents the range
        // being added to more than one area!
        if ($action=="modify") {

            $result=&$ds->ds->Execute("UPDATE range SET areaindex=$areaindex, 
                    descrip=".$ds->ds->qstr($descrip).",
                    rangeaddr=$base, rangesize=$size
                    WHERE rangeindex=$rangeindex") and
                $ds->AuditLog(array("event"=>161, "action"=>"modify range", 
                            "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "areaindex"=>$areaindex,
                            "baseaddr"=>$ipaddr, "size"=>$size, "cust"=>$cust));
        }
        else {
            $result=&$ds->ds->Execute("INSERT INTO range
                    (rangeaddr, rangesize, areaindex, descrip,
                     customer)
                    VALUES
                    ($base, $size, $areaindex,
                     ".$ds->ds->qstr($descrip).",
                     $cust)") and
                    $ds->AuditLog(array("event"=>160, "action"=>"create range", 
                                "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "areaindex"=>$areaindex,
                                "baseaddr"=>$ipaddr, "size"=>$size, "cust"=>$cust));
        }

        if ($result) {
            $ds->DbfTransactionEnd();
            if ($action=="modify") {
                Header("Location: ".location_uri("modifyarearange.php?cust=$cust"));
                //insert($w,textbr(my_("Range modified")));
                //printhtml($p);
                exit;
            }
            else {
                insert($w,textbr(my_("Range created")));
            }
            $ipaddr=""; $descrip="";
        }
        else {
            $ds->DbfTransactionRollback();
            $formerror .= my_("Range could not be created/modified - probably duplicate name")."\n";
        }
    }
}

myError($w,$p, $formerror, FALSE);
 
// display opening text
insert($w,heading(3, "$title."));

if ($action=="modify") {
    insert($w,textbrbr(my_("Modify a range supernet/summary. Changing the range address or size to overlap with the currently defined range and size is not supported. Move the range out of the way first.")));
}
else {
    insert($w,textbrbr(my_("Create a new range or supernet/summary by entering the base (network) address. A range is an aggregation of a number of subnets which can ultimately be used to reduce the number of routing entries in routing tables. Ranges are essentially the same as a normal subnet, just bigger with a wider view.")));
}

// start form
insert($w, $f1 = form(array("name"=>"THISFORM",
                "method"=>"get",
                "action"=>$_SERVER["PHP_SELF"])));

if ($action=="modify") {
    insert($f1,hidden(array("name"=>"action",
                    "value"=>"modify")));
    insert($f1,hidden(array("name"=>"cust",
                    "value"=>"$cust")));
    insert($f1,hidden(array("name"=>"ipaddr",
                    "value"=>"$ipaddr")));
    insert($f1,hidden(array("name"=>"descrip",
                    "value"=>"$descrip")));
    insert($f1,hidden(array("name"=>"size",
                    "value"=>"$size")));
    insert($f1,hidden(array("name"=>"rangeindex",
                    "value"=>"$rangeindex")));
}
else {
    // ugly kludge with global variable!
    $displayall=TRUE;
    $cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));
}
// show all areas, even ones with no ranges - need for create page
$areaindex=myAreaDropDown($ds, $f1, $cust, $areaindex, TRUE);

insert($w, $f2 = form(array("name"=>"ENTRY",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

// save customer name for actual post of data
insert($f2,hidden(array("name"=>"cust",
                        "value"=>"$cust")));
// save area index for actual post of data
insert($f2,hidden(array("name"=>"areaindex",
                        "value"=>"$areaindex")));
if ($action=="modify") {
    insert($f2,hidden(array("name"=>"rangeindex",
                    "value"=>"$rangeindex")));
    insert($f2,hidden(array("name"=>"action",
                    "value"=>"modify")));
}

insert($f2,textbrbr(my_("Range address")));

insert($f2,input_text(array("name"=>"ipaddr",
                           "value"=>"$ipaddr",
                           "size"=>"15",
                           "maxlength"=>"15")));

insert($f2,textbrbr(my_("Description")));
insert($f2,input_text(array("name"=>"descrip",
                            "value"=>"$descrip",
                            "size"=>"80",
                            "maxlength"=>"80")));
insert($f2,textbrbr(my_("Range size/mask")));

insert($f2,selectbox(array("4"=>"255.255.255.252/30 - 4 hosts",
                           "8"=>"255.255.255.248/29 - 8 hosts",
                           "16"=>"255.255.255.240/28 - 16 hosts",
                           "32"=>"255.255.255.224/27 - 32 hosts",
                           "64"=>"255.255.255.192/26 - 64 hosts",
                           "128"=>"255.255.255.128/25 - 128 hosts",
                           "256"=>"255.255.255.0/24 - 256 hosts (class C)",
                           "512"=>"255.255.254.0/23 - 512 hosts",
                           "1024"=>"255.255.252.0/22 - 1k hosts",
                           "2048"=>"255.255.248.0/21 - 2k hosts",
                           "4096"=>"255.255.240.0/20 - 4k hosts",
                           "8192"=>"255.255.224.0/19 - 8k hosts",
                           "16384"=>"255.255.192.0/18 - 16k hosts",
                           "32768"=>"255.255.128.0/17 - 32k hosts",
                           "65536"=>"255.255.0.0/16 - 64k hosts (class B)",
                           "131072"=>"255.254.0.0/15 - 128k hosts",
                           "262144"=>"255.252.0.0/14 - 256k hosts",
                           "524288"=>"255.248.0.0/13",
                           "1048576"=>"255.240.0.0/12",
                           "2097152"=>"255.224.0.0/11",
                           "4194304"=>"255.192.0.0/10",
                           "8388608"=>"255.128.0.0/9",
                           "16777216"=>"255.0.0.0/8 (class A)"),
                     array("name"=>"size"),
                     $size));

insert($f2,generic("br"));
insert($f2,submit(array("value"=>my_("Submit"))));
insert($f2,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
