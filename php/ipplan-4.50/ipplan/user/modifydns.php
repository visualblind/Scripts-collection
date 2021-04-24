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

$title=my_("DNS Domain Zones");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($action, $dataid, $cust, $serialdate, $serialnum, $domain, $hname, $responsiblemail, $ttl, $refresh, $retry, $expire, $minimum, $zonepath, $seczonepath, $descrip, $slaveonly, $block, $server, $expr, $ipplanParanoid) = myRegister("S:action I:dataid I:cust I:serialdate I:serialnum S:domain A:hname S:responsiblemail I:ttl I:refresh I:retry I:expire I:minimum S:zonepath S:seczonepath S:descrip S:slaveonly I:block S:server S:expri I:ipplanParanoid");

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

$formerror="";
$muldomains="";
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
$ds=new DNSfwdZone() or myError($w,$p, my_("Could not connect to database"));

// CHECK Actions First

// ##################### Start OF DELETE ##############################
if ($action=="delete") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not delete a DNS zone as you are not a member of the customers admin group"));
    } 

    // Log the Transaction.
    $ds->DbfTransactionStart();

    $result = $ds->FwdDelete($cust, $dataid, $domain);

    if ($result) {
        $ds->AuditLog(array("event"=>110, "action"=>"delete forward zone", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "id"=>$dataid));

        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("DNS Zone deleted")));
        $zone="";
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= $ds->errstr;
        $formerror .= my_("DNS Zone could not be deleted")."\n";
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
    if (!$domain) {
        myError($w,$p, my_("Domain may not be blank"));
    }

    if ($action=="add") {
        $muldomains = split(";", $domain);
    }
    else {
        $muldomains = array($domain);
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

    // will get error message if doing zone axfr and no nameservers given
    // this is ok as bulk zone axfr could result in some zones failing
    // import, thus need something to put in database
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
        myError($w,$p, my_("Serial Date can not be blank. Use YYYYMMDD."));
    }

    // check email address - must be in hostname format for DNS zone file
    if (!preg_match('/^([a-zA-Z0-9]([a-zA-Z0-9\-]{0,61}[a-zA-Z0-9])?\.)+[a-zA-Z]{2,6}$/', $responsiblemail)) {
        myError($w,$p, my_("Invalid zone email address - no @ allowed, replace with ."));
    }

}

// ##################### Start OF Add ##############################
if ($action=="add") {

    // loop through array - each element is a domain to add
    foreach($muldomains as $domain) {
        $domain=trim($domain);

        $ds->SetForm($cust, $dataid, $domain);
        $ds->SetSOA($hname, $ttl, $refresh, $retry, $expire, $minimum, 
                $responsiblemail, $slaveonly, $zonepath, $seczonepath);

        $ds->DbfTransactionStart();
        $result=$ds->FwdAdd($cust, $domain, $server);

        // could be non fatal errors
        $formerror .= $ds->errstr;

        // no error
        if ($result == 0) {
            $ds->AuditLog(array("event"=>111, "action"=>"add forward zone", "cust"=>$cust,
                        "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "id"=>$dataid));

            $ds->DbfTransactionEnd();
            insert($w,textbr(sprintf(my_("DNS Zone created %s"), $ds->domain)));
        }
        else {
            // negative error failure will fail transaction
            $ds->DbfTransactionRollback();
            $formerror .= sprintf(my_("DNS Zone %s could not be created")."\n", $ds->domain);
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

    $ds->SetForm($cust, $dataid, $domain);
    $ds->SetSOA($hname, $ttl, $refresh, $retry, $expire, $minimum, 
            $responsiblemail, $slaveonly, $zonepath, $seczonepath);
    // work out new serial number
    $ds->SetSerial($serialdate, $serialnum);

    $ds->DbfTransactionStart();
    $result=$ds->FwdUpdateSOA($cust, $dataid);

    // could be non fatal errors
    $formerror .= $ds->errstr;
    
    if ($result) {
        $ds->AuditLog(array("event"=>112, "action"=>"modify forward zone", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "id"=>$dataid));

        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("DNS Zone Modified")));
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("DNS Zone could not be modifed. Try again.")."\n";
    }
}
// ##################### END OF Edit ##############################

// ##################### Start OF EXPORT DNS Servers  ##############################
if ($action=="export") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not export a zone as you are not a member of the customers admin group"));
    } 

    $ds->SetSerial($serialdate, $serialnum);
    // dont really need customer, but required for now
    $ds->cust=$cust;

    $ds->DbfTransactionStart();

    $tmpfname=$ds->FwdZoneExport($cust, $dataid);

    if ($tmpfname) {
        $ds->AuditLog(array("event"=>113, "action"=>"export forward zone", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "id"=>$dataid,
                    "tmpfname"=>$tmpfname));

        $ds->DbfTransactionEnd();

        insert($w,textbr(sprintf(my_("Sent update to Backend Processor as file %s"), $tmpfname)));

    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("Zone could not be exported.  Try again.")."\n";
    }

}
// ##################### END OF Update DNS Servers  ##############################
// Now Setup Page...

myError($w,$p, $formerror, FALSE);

insert($w,heading(3, "$title."));
insert($w,textbr(my_("Create (manually and via a zone transfer) and maintain forward DNS zones.")));

// start form
insert($w, $f1 = form(array("name"=>"THISFORM",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

// ugly kludge with global variable!
$displayall=FALSE;
$cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));

// get info from base table
// what is the additional search SQL?
$search=$ds->mySearchSql("domain", $expr, $descrip);
$result = &$ds->ds->Execute("SELECT * FROM fwdzone 
                             WHERE customer=$cust 
                             $search
                             ORDER BY domain ");

$arr=$_GET;
$arr["domain"]=$domain;
$arr["cust"]=$cust;
$arr["action"]="";
$srch = new mySearch($w, $arr, $descrip, "descrip");
$srch->legend=my_("Refine Search on Domain");
$srch->expr=$expr;
$srch->expr_disp=TRUE;
$srch->Search();  // draw the sucker!

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, "&domain=".urlencode($domain)."&cust=".$cust, "domain");
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
insert($c,text(my_("Domain")));
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
    insert($c,text($row["domain"]));
    if ($row["slaveonly"] == "Y") {
        insert($c,span(my_("Slave zone"), array("class"=>"textSmall")));
    }

    $result1 = &$ds->ds->Execute("SELECT hname FROM fwddns
                                  WHERE id=".$row["data_id"]."
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
    insert($c,anchor($_SERVER["PHP_SELF"]."?cust=$cust&dataid=".$row["data_id"]."&action=delete&domain=".urlencode($row["domain"]), my_("Delete DNS Zone"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block(" | "));
    insert($c,anchor("modifydnsform.php?cust=$cust&dataid=".$row["data_id"].
                "&action=edit".
                "&domain=".urlencode($row["domain"]).
                "&responsiblemail=".urlencode($row["responsiblemail"]).
                "&serialdate=".$row["serialdate"].
                "&serialnum=".$row["serialnum"].
                "&ttl=".$row["ttl"].
                "&retry=".$row["retry"].
                "&refresh=".$row["refresh"].
                "&expire=".$row["expire"].
                "&minimum=".$row["minimum"].
                "&slaveonly=".$row["slaveonly"].
                "&zonepath=".urlencode($row["zonefilepath1"]).
                "&seczonepath=".urlencode($row["zonefilepath2"]),
                my_("Edit DNS Zone")));
    insert($c,block(" | "));
    insert($c,anchor($_SERVER["PHP_SELF"]."?cust=$cust&dataid=".$row["data_id"].
                "&action=export".
                "&domain=".urlencode($row["domain"]).
                "&responsiblemail=".urlencode($row["responsiblemail"]).
                "&serialdate=".$row["serialdate"].
                "&serialnum=".$row["serialnum"].
                "&ttl=".$row["ttl"].
                "&retry=".$row["retry"].
                "&refresh=".$row["refresh"].
                "&expire=".$row["expire"].
                "&minimum=".$row["minimum"].
                "&slaveonly=".$row["slaveonly"].
                "&zonepath=".urlencode($row["zonefilepath1"]).
                "&seczonepath=".urlencode($row["zonefilepath2"]),
                my_("Export DNS Zone"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure to Export?")."')") : FALSE));
    insert($c,block(" | "));
    insert($c,anchor("whois.php?lookup=".urlencode($row["domain"]),
                my_("Whois")));

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
    $vars=DisplayBlock($w, $row, $totcnt, "&domain=".urlencode($domain)."&cust=".$cust, "domain" );
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

if (!$cnt) {
    myError($w,$p, my_("Search found no DNS Zone entries"), FALSE);
}

insert($w, $f = form(array("method"=>"post",
                           "action"=>"modifydnsform.php?cust=$cust&action=add")));
insert($f,submit(array("value"=>my_("Add a DNS Zone"))));


$result->Close();
printhtml($p);

?>
