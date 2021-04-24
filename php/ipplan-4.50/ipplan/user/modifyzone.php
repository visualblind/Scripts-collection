<?php

// IPplan v4.50
// Aug 24, 2001
//
// Modified by Tony D. Koehn February 2003
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
require_once("../class.dnslib.php");
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

$title=my_("DNS Reverse Zones");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($action, $zoneid, $serialdate, $serialnum, $cust, $zone, $zoneip, $size, $hname, $responsiblemail, $ttl, $refresh, $retry, $expire, $minimum, $zonepath, $seczonepath, $slaveonly, $descrip, $block, $server, $expr, $ipplanParanoid) = myRegister("S:action I:zoneid I:serialdate I:serialnum I:cust S:zone S:zoneip I:size A:hname S:responsiblemail I:ttl I:refresh I:retry I:expire I:minimum S:zonepath S:seczonepath S:slaveonly S:descrip I:block S:server S:expr I:ipplanParanoid");

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

$formerror="";
if ($slaveonly == "on") {
    $slaveonly = "Y";
}
else if ($slaveonly != "Y" or $slaveonly != "N") {
    $slaveonly = "N";
}

//if (!$_GET) {
//   myError($w,$p, my_("You cannot reload or bookmark this page!"));
//}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new DNSrevZone() or myError($w,$p, my_("Could not connect to database"));

// CHECK Actions First

// ##################### Start OF DELETE ##############################
if ($action=="delete") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not delete a zone as you are not a member of the customers admin group"));
    } 

    // Log the Transaction.
    $ds->DbfTransactionStart();

    $result = $ds->RevDelete($cust, $zoneid, $zone);

    if ($result) {
        $ds->AuditLog(array("event"=>100, "action"=>"delete reverse zone", "cust"=>$cust,
                    "zone"=>$zone, "zoneip"=>$zoneip,
                    "user"=>$_SERVER[AUTH_VAR], "id"=>$zoneid));

        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("Zone deleted")));
        $zone="";
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= $ds->errstr;
        $formerror .= my_("Zone could not be deleted.")."\n";
    }
}
// ##################### END OF DELETE ##############################

// ##################### Start OF checks ##############################
if ($action=="add" or $action=="edit") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not add a zone as you are not a member of the customers admin group"));
    } 

    // Error Checks
    if (!$zone) {
        myError($w,$p, my_("Domain may not be blank"));
    }

    if ($action=="add") {
        $muldomains = split(";", $zone);
    }
    else {
        $muldomains = array($zone);
    }
    foreach($muldomains as $value) {
        if (!preg_match('/^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/', trim($value))) {
            myError($w,$p, sprintf(my_("Invalid domain name %s"), $value));
        }
    }

    if (!empty($server)) {
        if (testIP($server)==0) {
            // was an IP address
        }
        else if (preg_match("/[^ \t@()<>,]+\\.[^ \t()<>,.]+$/", $server)) {
            // was a hostname
        }
        else {
            myError($w,$p, sprintf(my_("Invalid hostname %s"), $server)."\n");
        }
    }

    if (!$zoneip)
        myError($w,$p, my_("IP address may not be blank"));
    else if (testIP($zoneip))
        myError($w,$p, my_("Invalid IP address"));
    else if (!$size)
        myError($w,$p, my_("Size may not be zero"));
    else if ($size > 1) {
        if (TestBaseAddr(inet_aton3($zoneip), $size)) {
            myError($w,$p, my_("Invalid base address!"));
        }
    }

    $zoneip = inet_aton($zoneip);

    $cnt=0;
    for ($i = 1; $i < 11; $i++) {
        if ($hname[$i] and
                !preg_match("/[^ \t@()<>,]+\\.[^ \t()<>,.]+$/", $hname[$i])) {
            myError($w,$p, sprintf(my_("Invalid hostname %u"), $i)."\n");
        }
        if ($hname[$i]) {
            $cnt++;
        }
    }
    if ($cnt < 2) {
        myError($w,$p, my_("Invalid zone - you need at least two nameservers"));
    }
    if (!is_numeric($ttl) or !is_numeric($refresh) or !is_numeric($retry) or
            !is_numeric($expire) or !is_numeric($minimum) or
            $ttl < 1 or $refresh < 1 or $retry < 1 or $expire < 1 or $minimum < 1) {
        myError($w,$p, my_("Invalid domain timeout values"));
    }

    if (!$serialdate) {
        myError($w,$p, my_("Serial Date can not be blank.  Use YYMMDD."));
    }

    // check email address - must be in hostname format for DNS zone file
    if (!preg_match('/^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/', $responsiblemail)) {
        myError($w,$p, my_("Invalid zone email address - no @ allowed, replace with ."));
    }

}
 
// ##################### Start OF add ##############################
if ($action=="add") {

    // loop through array - each element is a domain to add
    foreach($muldomains as $domain) {
        $zone=trim($domain);

        $ds->SetForm($cust, $zoneid, $zone, $zoneip, $size);
        $ds->SetSOA($hname, $ttl, $refresh, $retry, $expire, $minimum, 
                $responsiblemail, $slaveonly, $zonepath, $seczonepath);

        $ds->DbfTransactionStart();
        $result=$ds->RevAdd($cust, $zone, $server);

        // could be non fatal errors
        $formerror .= $ds->errstr;

        // no error
        if ($result == 0) {
            $ds->AuditLog(array("event"=>101, "action"=>"add reverse zone", "cust"=>$cust,
                        "user"=>$_SERVER[AUTH_VAR], "id"=>$zoneid, "zone"=>$zone, "zoneip"=>inet_ntoa($zoneip)));

            $ds->DbfTransactionEnd();
            insert($w,textbr(sprintf(my_("DNS Zone created %s"), $ds->zone)));
        }
        else {
            // negative error failure will fail transaction
            $ds->DbfTransactionRollback();
            $formerror .= sprintf(my_("DNS Zone %s could not be created")."\n", $ds->zone);
            // error greater than 0 will terminate
            if ($result > 0) {
                break;
            }
        }
    }

}
// ##################### END OF Add ##############################

// ##################### Start OF Edit ##############################
if ($action=="edit") {

    // Updated DB here.
    // Log the Transaction.

    $ds->SetForm($cust, $zoneid, $zone, $zoneip, $size);
    $ds->SetSOA($hname, $ttl, $refresh, $retry, $expire, $minimum, 
            $responsiblemail, $slaveonly, $zonepath, $seczonepath);
    // work out new serial number
    $ds->SetSerial($serialdate, $serialnum);

    $ds->DbfTransactionStart();
    $result=$ds->RevUpdateSOA($cust, $zoneid, $zone, $zoneip, $size);

    // could be non fatal errors
    $formerror .= $ds->errstr;
    
    if ($result) {
        $ds->AuditLog(array("event"=>102, "action"=>"modify reverse zone", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "id"=>$zoneid, "zone"=>$zone, "zoneip"=>inet_ntoa($zoneip)));

        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("DNS Zone Modified")));
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("DNS Zone could not be modifed. Try again.")."\n";
    }

}
// ##################### END OF Edit ##############################

// ##################### Start OF Export Zone  ##############################
if ($action=="export") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not add a zone as you are not a member of the customers admin group"));
    } 

    $ds->SetSerial($serialdate, $serialnum);
    // dont really need customer, but required for now
    $ds->cust=$cust;

    $ds->DbfTransactionStart();

    $tmpfname=$ds->RevZoneExport($cust, $zoneid);

    if ($tmpfname) {
        $ds->AuditLog(array("event"=>103, "action"=>"export reverse zone", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "id"=>$zoneid, "zone"=>$zone, "zoneip"=>$zoneip,
                    "tmpfname"=>$tmpfname));

        $ds->DbfTransactionEnd();

        insert($w,textbr(sprintf(my_("Sent update to Backend Processor as file %s"), $tmpfname)));

    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("Zone could not be exported.  Try again.")."\n";
    }

}
// ##################### END OF Export Zone  ##############################

// Now Setup Page...
myError($w,$p, $formerror, FALSE);

insert($w,heading(3, "$title."));
insert($w,textbr("Create and maintain reverse DNS zones. Reverse zone records are extracted from the host field of subnets created for this customer."));

// start form
insert($w, $f1 = form(array("name"=>"THISFORM",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

// ugly kludge with global variable!
$displayall=FALSE;
$cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));

// get info from base table
// what is the additional search SQL?
$search=$ds->mySearchSql("zone", $expr, $descrip);
$result = &$ds->ds->Execute("SELECT * FROM zones 
                             WHERE customer=$cust 
                             $search
                             ORDER BY zone");

$arr=$_GET;
$arr["descrip"]=$descrip;
$arr["cust"]=$cust;
$arr["action"]="";
$srch = new mySearch($w, $arr, $descrip, "descrip");
$srch->legend=my_("Refine Search on Zone");
$srch->expr=$expr;
$srch->expr_disp=TRUE;
$srch->Search();  // draw the sucker!

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, "&zone=".urlencode($zone)."&cust=".$cust, "zone");
    $totcnt++;
}
insert($w,block("<p>"));

// create a table
insert($w,$t = table(array("cols"=>"12",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
if (!empty($vars))
    insert($c,anchor($vars, "<<"));
insert($c,text(my_("Zone")));
insert($t,$c = cell());
insert($c,text(my_("Primary NS")));
insert($t,$c = cell());
insert($c,text(my_("Secondary NS")));
insert($t,$c = cell());
insert($c,text(my_("SerialDate")));
insert($t,$c = cell());
insert($c,text(my_("TTL")));
insert($t,$c = cell());
insert($c,text(my_("Refresh")));
insert($t,$c = cell());
insert($c,text(my_("Retry")));
insert($t,$c = cell());
insert($c,text(my_("Expire")));
insert($t,$c = cell());
insert($c,text(my_("Min. TTL")));
insert($t,$c = cell());
insert($c,text(my_("Last modified")));
insert($t,$c = cell());
insert($c,text(my_("Changed by")));
insert($t,$ck = cell());
insert($ck,text(my_("Action")));

$cnt=0;
while($row = $result->FetchRow()) {
    setdefault("cell",array("class"=>color_flip_flop()));

    insert($t,$c = cell());
    insert($c,text($row["zone"]));
    insert($c,textbr());
    insert($c,block("<small><i>"));
    if ($row["slaveonly"] == "Y") {
        insert($c,text(my_("Slave zone")));
        insert($c,textbr());
    }
    insert($c,anchor("findfree.php?cust=$cust&showused=1".
                "&start=".inet_ntoa($row["zoneip"]).
                "&end=".inet_ntoa($row["zoneip"]+$row["zonesize"]-1),
                inet_ntoa($row["zoneip"])."/".inet_bits($row["zonesize"])));
    insert($c,block("</i></small>"));


    $result1 = &$ds->ds->Execute("SELECT hname FROM zonedns
            WHERE id=".$row["id"]."
            ORDER BY horder");

    insert($t,$c = cell());
    $row1 = $result1->FetchRow();
    insert($c,text($row1["hname"]));

    insert($t,$c = cell());
    $row1 = $result1->FetchRow();
    insert($c,text($row1["hname"]));

    insert($t,$c = cell());
    insert($c,text($row["serialdate"].str_pad($row["serialnum"], 2, '0', STR_PAD_LEFT)));

    insert($t,$c = cell());
    insert($c,text($row["ttl"]));

    insert($t,$c = cell());
    insert($c,text($row["refresh"]));

    insert($t,$c = cell());
    insert($c,text($row["retry"]));

    insert($t,$c = cell());
    insert($c,text($row["expire"]));

    insert($t,$c = cell());
    insert($c,text($row["minimum"]));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,block($result->UserTimeStamp($row["lastmod"], "M d Y H:i:s")));
    insert($c,block("</small>"));

    insert($t,$c = cell());
    insert($c,text($row["userid"]));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,anchor($_SERVER["PHP_SELF"]."?cust=$cust&zoneid=".$row["id"].
                "&zoneip=".inet_ntoa($row["zoneip"]).
                "&zone=".urlencode($row["zone"]).
                "&action=delete", my_("Delete Zone"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block(" | "));
    insert($c,anchor("modifyzoneform.php?cust=$cust&zoneid=".$row["id"].
                "&action=edit".
                "&zone=".urlencode($row["zone"]).
                "&zoneip=".$row["zoneip"].
                "&responsiblemail=".urlencode($row["responsiblemail"]).
                "&size=".$row["zonesize"].
                "&serialdate=".$row["serialdate"].
                "&serialnum=".$row["serialnum"].
                "&ttl=".$row["ttl"].
                "&retry=".$row["retry"].
                "&refresh=".$row["refresh"].
                "&expire=".$row["expire"].
                "&minimum=".$row["minimum"].
                "&slaveonly=".$row["slaveonly"].
                "&zonepath=".urlencode($row["zonefilepath1"]).
                "&seczonepath=".urlencode($row["zonefilepath2"]), my_("Edit Zone")));
    insert($c,block(" | "));
    insert($c,anchor($_SERVER["PHP_SELF"]."?cust=$cust&zoneid=".$row["id"]."&action=export".
                "&zoneip=".inet_ntoa($row["zoneip"]).
                "&zone=".urlencode($row["zone"]).
                "&serialdate=".$row["serialdate"].
                "&serialnum=".$row["serialnum"],
                my_("Export Zone"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block("</small>"));

    if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
        break;
    $cnt++;
    $totcnt++;
}

insert($w,block("<p>"));

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, "&zone=".urlencode($zone)."&cust=".$cust, "zone" );
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

if (!$cnt) {
    myError($w,$p, my_("Search found no Zone entries")."\n", FALSE);
}

insert($w, $f = form(array("method"=>"post",
                           "action"=>"modifyzoneform.php?cust=$cust&action=add")));
insert($f,submit(array("value"=>my_("Add a Zone"))));

$result->Close();
printhtml($p);

?>
