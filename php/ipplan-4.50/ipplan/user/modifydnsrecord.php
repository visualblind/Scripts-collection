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

$title=my_("Zone Domain DNS Records");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($action, $domain, $cust, $host, $recordtype, $iphostname, $sortorder, $descrip, $expr, $block, $ipplanParanoid) = myRegister("S:action S:domain I:cust S:host S:recordtype S:iphostname S:sortorder S:descrip S:expr I:block I:ipplanParanoid");

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

$formerror="";
if ($action=="delete") {
    if (is_array($dataid)) {
        foreach($dataid as $key => $value) {
            $dataid[$key]=floor($value);
        }
    }
    else {
        $dataid=array(0=>$dataid);
    }
    // user hit submit without selecting anything!
    if (empty($dataid[0])) {
        $action="";
    }
}
else {
    $dataid=isset($dataid) ? floor($dataid) : 0;
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// CHECK Actions First

// ##################### Start OF DELETE ##############################
if ($action=="delete") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not delete dns records as you are not a member of the customers admin group"));
    } 

    // Log the Transaction.
    $ds->DbfTransactionStart();
    foreach ($dataid as $value) {
        $result = &$ds->ds->Execute("DELETE FROM fwdzonerec 
                WHERE customer=$cust AND recidx=$value") and
            $ds->AuditLog(array("event"=>120, "action"=>"delete zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "id"=>$value));
    }

    $ds->DbfTransactionEnd();

    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("Domain DNS Record Deleted.")));
        $zone="";
    } else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("DNS Record could not be deleted.")."\n";
    }
}
// ##################### END OF DELETE ##############################

// ##################### START OF RENUMBER ##############################
else if ($action=="renumber") {
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not delete dns records as you are not a member of the customers admin group"));
    } 

    // could do this in one hit, but requires funky update syntax only available in mysql 4.x
    // need to be able to use ORDER BY in update
    //
    // set @t1=0;
    // update fwdzonerec set sortorder=@t1:=@t1+5 where customer=1 and data_id=73 order by sortorder;

    // Log the Transaction.
    $ds->DbfTransactionStart();
    $result = &$ds->ds->Execute("SELECT fwdzonerec.recidx, fwdzonerec.sortorder 
            FROM fwdzone, fwdzonerec
            WHERE fwdzone.customer=$cust AND 
            fwdzone.domain=".$ds->ds->qstr($domain)." AND
            fwdzone.data_id=fwdzonerec.data_id
            ORDER by fwdzonerec.sortorder");

    // ok, now get all records and renumber
    if ($result) {
        $i=5;
        while($row = $result->FetchRow()) {
            $recidx=$row["recidx"];
            $result1 = &$ds->ds->Execute("UPDATE fwdzonerec
                    SET sortorder=$i
                    WHERE recidx=$recidx");
            $i=$i+5;
        }
        $ds->AuditLog(array("event"=>123, "action"=>"renumber zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain));
        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("Domain Records Renumbered.")));
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("DNS Records could not be renumbered.")."\n";
    }

}
// ##################### END OF RENUMBER ##############################

// ##################### Start OF Add ##############################
if ($action=="add" or $action=="edit") {
    $updateiprec=0;
    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not add a record as you are not a member of the customers admin group"));
    } 

    // convert shortcuts to FQDN
    if ($host === "@") {
        $formerror .= my_("Bind @ shortcut converted to Fully Qualified Domain Name (FQDN)")."\n";
        $host=$domain.".";
    }

    // Error Checks
    if ($recordtype=="MX") {   // MX could have no hostname
        if ($host and !preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $host)) {
            myError($w,$p, my_("Invalid hostname"));
        }
    } else {
        if (!$host)
            myError($w,$p, my_("Host may not be blank"));
        if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $host))
            myError($w,$p, my_("Invalid hostname"));
    }
    if (!$recordtype)
        myError($w,$p, my_("Record Type may not be blank."));
    if (!$sortorder or $sortorder < 1)
        $sortorder=9999;
    if (!$iphostname)
        myError($w,$p, my_("IP / Hostname may not be blank."));
    if ($recordtype=="MX") {
        // format should be "preference hostname"
        list($preference, $iphost) = explode(" ", $iphostname, 2);
        // is it correct format?
        if (is_numeric($preference) and $preference >= 0) {
            if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $iphost)) {
                myError($w,$p, my_("Invalid IP/ Hostname"));
            }
        }
        // no just a hostname? then add a default preference of 10.
        else {
            if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $iphostname)) {
                myError($w,$p, my_("Invalid IP/ Hostname"));
            }
            $iphostname="10 ".$iphostname;
        }
    } else if ($recordtype=="TXT") {
      // this can be any text string.
    } else if ($recordtype=="KEY") {
       // this can be any text string.
    } else {
        if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $iphostname)) {
            myError($w,$p, my_("Invalid IP/ Hostname"));
        }
    }
    // add . after record - don't understand thinking here? User should determine if
    // qualified or not?
    /*
       if(preg_match("/[a-z]/i",$iphostname) && substr($iphostname,-1) != '.') {
       $iphostname .= '.';
       }
     */
    // iphostname must be IP address
    if ($recordtype=="A" and testIP($iphostname))
        myError($w,$p, my_("For A type, IP / Hostname must be an IP address"));
    // need to check for valid host
    if ($recordtype=="CNAME") {
        if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?\.?$/', $iphostname))
            myError($w,$p, my_("Invalid IP/ Hostname"));
    }

    // everything looks ok, now check that there are no duplicates
    // could use database key for this, but would require huge indexes

    // cannot check much else as records could be outside of this zone
    // bind has no issues with CNAME's or MX records pointing to non-existent
    // records, so don't bother checking those either
    $result = &$ds->ds->Execute("SELECT customer 
                                FROM fwdzonerec 
                                WHERE customer=$cust AND data_id=$zoneid AND
            host=".$ds->ds->qstr($host)." AND
            recordtype=".$ds->ds->qstr($recordtype)." AND 
            ip_hostname=".$ds->ds->qstr($iphostname));

    $recs=$result->PO_RecordCount("fwdzonerec", "customer=$cust AND data_id=$zoneid AND
            host=".$ds->ds->qstr($host)." AND
            recordtype=".$ds->ds->qstr($recordtype)." AND 
            ip_hostname=".$ds->ds->qstr($iphostname));
    if($recs > 0) {
        myError($w,$p, my_("Cannot create duplicate records"));
    }

    // check if there is only one A record for this customer across all its domains
    // then update ipaddr record
    if ($recordtype=="A") {
        // cannot do a simple three way join on ipaddr, base and fwdzonerec as the
        // field types are different
        $result = &$ds->ds->Execute("SELECT ip_hostname 
                FROM fwdzonerec 
                WHERE customer=$cust AND
                recordtype=".$ds->ds->qstr("A")." AND 
                ip_hostname=".$ds->ds->qstr($iphostname));

        $recs=$result->PO_RecordCount("fwdzonerec", "customer=$cust AND
                recordtype=".$ds->ds->qstr("A")." AND 
                ip_hostname=".$ds->ds->qstr($iphostname));
        if($recs == 1) {
            $updateiprec=1;
        }
    }

    
}

// ##################### START OF Add ##############################
if ($action=="add") {

    // Add to DB here.
    // Log the Transaction.
    $ds->DbfTransactionStart();

    // do update of ip record with hostname as part of transaction
    if ($updateiprec) {
        $fqdn=substr($host, -1, 1) == "." ? substr($host, 0, -1) : "$host.$domain";
        $result=$ds->GetBaseFromIP(inet_aton($iphostname), $cust);
        if ($row=$result->FetchRow()) {
            $baseindex=$row["baseindex"];
            $ds->ModifyIP(array(inet_aton($iphostname)), $baseindex, "", "", "", "", "", $fqdn, "");
            // not really an error, but a warning?
            $formerror .= my_("Subnet IP record updated with hostname: ")."$fqdn\n";
        }
    }

    $result = &$ds->ds->Execute("INSERT into fwdzonerec 
            (customer, data_id, sortorder, lastmod, host, 
             recordtype, userid, ip_hostname) ".
            "VALUES ($cust, $zoneid, ". $sortorder.",".
            $ds->ds->DBTimeStamp(time()).",".
            $ds->ds->qstr($host).",".
            $ds->ds->qstr($recordtype).",".
            $ds->ds->qstr($_SERVER[AUTH_VAR]).",".
            $ds->ds->qstr($iphostname).")" ) and
        $ds->AuditLog(array("event"=>121, "action"=>"add zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "host"=>$host,
                    "recordtype"=>$recordtype, "iphostname"=>$iphostname));

    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("Host record added.")));
        $zone="";
    } else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("Host record could not be added.")."\n";
    }
}
// ##################### END OF Add ##############################

// ##################### Start OF Edit ##############################
if ($action=="edit") {

    // Updated DB here.
    // Log the Transaction.
    $ds->DbfTransactionStart();

    // do update of ip record with hostname as part of transaction
    if ($updateiprec) {
        $fqdn=substr($host, -1, 1) == "." ? substr($host,0, -1) : "$host.$domain";
        $result=$ds->GetBaseFromIP(inet_aton($iphostname), $cust);
        if ($row=$result->FetchRow()) {
            $baseindex=$row["baseindex"];
            $ds->ModifyIP(array(inet_aton($iphostname)), $baseindex, "", "", "", "", "", $fqdn, "");
            // not really an error, but a warning?
            $formerror .= my_("Subnet IP record updated with hostname: ")."$fqdn\n";
        }
    }

    $result = &$ds->ds->Execute("UPDATE fwdzonerec SET sortorder=".$sortorder.
            ", host=".$ds->ds->qstr($host).
            ", lastmod=".$ds->ds->DBTimeStamp(time()).
            ", recordtype=".$ds->ds->qstr($recordtype).
            ", userid=".$ds->ds->qstr($_SERVER[AUTH_VAR]).
            ", ip_hostname=".$ds->ds->qstr($iphostname).
            "WHERE customer=$cust AND recidx=".$dataid ) and
        $ds->AuditLog(array("event"=>122, "action"=>"modified zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "host"=>$host,
                    "recordtype"=>$recordtype, "iphostname"=>$iphostname));

    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("Host Record Modified")));
        $zone="";
    }
    else {
        $ds->DbfTransactionRollback();
        $formerror .= my_("Host record could not be modifed. Try again.")."\n";
    }
}
// ##################### END OF Edit ##############################

myError($w,$p, $formerror, FALSE);

insert($w,heading(3, "$title."));
insert($w,textbr("Maintain forward zone domain records."));


// start form
insert($w, $f1 = form(array("name"=>"THISFORM",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

// ugly kludge with global variable!
$displayall=FALSE;
$cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));

//
// Get a List of Domains from the fwdzone table.
//

$result = &$ds->ds->Execute("SELECT domain, data_id FROM fwdzone 
                            WHERE customer=$cust AND 
                            slaveonly=".$ds->ds->qstr("N")."
                            ORDER BY domain");
if (!$result) {
   myError($w,$p, my_("No domains found. Create some domains and try again."));
}

insert($w, $f2 = form(array("name"=>"DomainSelect", 
                            "method"=>"post", 
                            "action"=>"modifydnsrecord.php?cust=".$cust)));

insert($f2,textbrbr(my_("Domain")));
insert($f2,span(my_("Master domains only"), array("class"=>"textSmall")));
insert($f2,block("<SELECT NAME='domain' ONCHANGE='submit()'>"."\n"));
$cnt=0;
while($row = $result->FetchRow()) {
   $data=$row["domain"];
   $cnt++;
   // set domain to first record if domain has not been selected prviously
   if ($cnt==1 and empty($domain)) {
        $domain=$data;
   }
   // save data_id for later for the "Add" button
   if ($data==$domain) {
       $zoneid=$row["data_id"];
       insert($f2,block("<OPTION VALUE= '".$data."' SELECTED>".$data."\n"));
   }
   else {
       insert($f2,block("<OPTION VALUE= '".$data."'>".$data."\n"));
   }
} 
insert($f2,block("</SELECT>\n"));
insert($f2,generic("br"));
//insert($f2,submit(array("value"=>my_("Select Domain"))));

// Now Setup Page...
// get info from base table

if ($domain) {
    /*
       $result = &$ds->ds->Execute("SELECT data_id FROM fwdzone
       WHERE customer=$cust AND domain='$domain'");
       $row = $result->FetchRow();
       $zoneid=$row["data_id"];
     */

    // what is the additional search SQL?
    $search=$ds->mySearchSql("host", $expr, $descrip);
    $result = &$ds->ds->Execute("SELECT *
            FROM fwdzonerec
            WHERE customer=$cust AND data_id=$zoneid
            $search
            ORDER by sortorder");

    $arr=$_GET;
    $arr["domain"]=$domain;
    $arr["action"]="";
    $srch = new mySearch($w, $arr, $descrip, "descrip");
    $srch->legend=my_("Refine Search on Host");
    $srch->expr=$expr;
    $srch->expr_disp=TRUE;
    $srch->Search();  // draw the sucker!

}

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, "&domain=".urlencode($domain)."&cust=".$cust, "sortorder");
    $totcnt++;
}
insert($w,block("<p>"));
insert($w,textb($domain));

insert($w, $f = form(array("name"=>"deleterecords",
                           "method"=>"post",
                           "action"=>$_SERVER["PHP_SELF"])));

// create a table
insert($f,$t = table(array("cols"=>"7",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
if (!empty($vars))
    insert($c,anchor($vars, "<<"));
insert($c,text(my_("Sort-Order")));
insert($t,$c = cell());
insert($c,text(my_("Host")));
insert($t,$c = cell());
insert($c,text(my_("Record Type")));
insert($t,$c = cell());
insert($c,text(my_("IP/Hostname")));
insert($t,$c = cell());
insert($c,text(my_("Last modified")));
insert($t,$c = cell());
insert($c,text(my_("Changed by")));
insert($t,$ck = cell());
insert($ck,text(my_("Action")));


$cnt=0;
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

    $temphost=$row["host"];
    $tempiphostname=$row["ip_hostname"];

/*
    if ($row["recordtype"]=="MX") {
        $tempiphostname=$temphost . " " . $tempiphostname;
        $temphost="";
    }
    if ($row["recordtype"]=="@") {
        $temphost="";
    }
    */
    insert($t,$c = cell());
    insert($c,text($row["sortorder"]));

    insert($t,$c = cell());
    insert($c,text($temphost));

    insert($t,$c = cell());
    insert($c,text($row["recordtype"]));

    insert($t,$c = cell());
    insert($c,text($tempiphostname));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,block($result->UserTimeStamp($row["lastmod"], "M d Y H:i:s")));
    insert($c,block("</small>"));

    insert($t,$c = cell());
    insert($c,text($row["userid"]));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,checkbox(array("name"=>"dataid[]",
                      "value"=>$row["recidx"]), ""));

    insert($c,anchor($_SERVER["PHP_SELF"]."?cust=$cust&dataid=".$row["recidx"]."&action=delete&domain=".urlencode($domain), my_("Delete Record"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block(" | "));
    insert($c,anchor("modifydnsrecordform.php?cust=$cust&dataid=".$row["recidx"].
                "&action=edit".
                "&domain=".urlencode($domain).
                "&sortorder=".$row["sortorder"].
                "&host=".urlencode($row["host"]).
                "&recordtype=".$row["recordtype"].
                "&iphostname=".urlencode($row["ip_hostname"]), my_("Edit Record")));
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
   insert($f,hidden(array("name"=>"domain",
                           "value"=>"$domain")));
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
      if (al.elements[i].name==\'dataid[]\') {
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
   insert($f,submit(array("value"=>my_("Delete multiple"))));
}

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, "&domain=".urlencode($domain)."&cust=".$cust, "sortorder" );
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

if ($domain) {
   insert($w, $f = form(array("method"=>"post", "action"=>"modifydnsrecordform.php?cust=$cust&action=add&domain=".urlencode($domain)."&zoneid=".$zoneid)));
   insert($f,submit(array("value"=>my_("Add a Host"))));
}

if (!$cnt) {
   myError($w,$p, my_("No Records found.  Please choose a domain and try again."));
}
// if there are some records, give option to renumber
else {
    insert($f,anchor($_SERVER["PHP_SELF"]."?cust=$cust&action=renumber&domain=".urlencode($domain)."&block=$block", my_("Renumber SortOrder"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
}
   
$result->Close();
printhtml($p);

?>
