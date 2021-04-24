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
//include('../adodb/adodb-errorhandler.inc.php');
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../layout/class.layout");
require_once("../auth.php");

require_once("../class.templib.php");

// maximum time per record to allow for DNS queries
define("DNS_DELTA_TIME", "2");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Results of your search");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($baseindex, $block, $showactive, $showdns, $action) = myRegister("I:baseindex I:block I:showactive I:showdns S:action");
list($userfld) = myRegister("A:userfld");  // from modifyipform - need to add rest flds
list($hname) = myRegister("S:hname");  // from modifyipformmul - need to add rest flds
list($search, $expr) = myRegister("S:search S:expr");  // search fields
list($user, $location, $descrip, $telno, $macaddr) = myRegister("S:user S:location S:descrip S:telno S:macaddr");
list($request) = myRegister("I:request");  // from modifyipform - dummy variable entered 
                                           // from displayrequestip.php

$formerror="";
// $ip can be array or string or undefined!
if (!isset($ip)) $ip=0; 
if (is_array($ip)) {
    foreach($ip as $key => $value) {
        $ip[$key]=floor($value);
    }
}
else {
   $ip=floor($ip);
}

if (!$_GET and !$_POST) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

$ds=new IPplanDbf() or myError($w,$p, "Could not connect to database");

// get info from base table - do this first as safety check and because 
// we need this info later
$result=$ds->GetBaseFromIndex($baseindex);
if (!$row = $result->FetchRow()) {
    myError($w,$p, my_("Subnet cannot be found!"));
}
$maxcnt=$row["subnetsize"];
$baseaddr=$row["baseaddr"];
$cust=$row["customer"];

// script gets called back from modifyipform script so that user does
// not need to press back button
if ($_POST) {
    if ($grp=$ds->GetBaseGrp($baseindex)) {
        if (in_array($grp, $grps) or 
                $ds->TestCustomerGrp($baseindex, $_SERVER[AUTH_VAR])) {

            // ---------------- are first x IP addresses of subnet blocked? ---------------
            // ---------------- check that addresses are within subnet      ---------------

            // get lowest number of addresses in subnet that user is not allowed to
            // modify - normally zero. If user belongs to multiple groups, takes lowest value
            $limit = &$ds->ds->GetOne("SELECT min(resaddr) AS cnt FROM grp WHERE grp ".$ds->grpSQL($grps));
            foreach((array)$ip as $iptemp) {    // cast ip to array
                if ($iptemp-$baseaddr < $limit) {
                    myError($w,$p, sprintf("You may not modify the first %s subnet addresses", $limit));
                }
                if ($iptemp-$baseaddr < 0 or $iptemp-$baseaddr >= $maxcnt) {
                    myError($w,$p, "An address you are attempting to modify is outside of the subnet");
                }
            }
            // ---------------- end check ---------------

            if ($md5str!=$ds->GetMD5($ip, $baseindex))
                myError($w,$p,my_("Another user modified the information before you saved - restart"));

            $ds->DbfTransactionStart();

            // additional information will arrive as assoc array called template
            // this is serialized into the info blob field of the database

            // need to start class and verify data before inserting

            if ($action=="delete") {

                // loop through array returned from modifyipmulform.php
                foreach((array)$ip as $iptemp) { // cast to array if not array already 
                    // remove all attached files
                    RemoveAllFiles($ds, $baseindex, $iptemp);

                    $ds->DeleteIP($iptemp, $baseindex);
                }

                $ds->DbfTransactionEnd();
                insert($w,text(my_("IP address records deleted")));

            }
            else {
                $err=FALSE;
                // if a specific network template exists, use that, else use generic template
                $template=NULL;
                if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate-network.xml") and !TestBaseAddr($ip, $maxcnt)) {
                    $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate-network.xml");
                }
                else {
                    $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml");
                }
                // info field passed to ModifyIP must be "" if record is
                // to be deleted from ipaddradd table automatically to
                // conserve space - NB!
                $info="";
                if (is_object($template) and $template->is_error() == FALSE) {
                    // PROBLEM HERE: if template create suddenly returns error (template file
                    // permissions, xml error etc), then each submit thereafter will erase
                    // previous contents - this is not good
                    $template->Merge($userfld);
                    $err=$template->Verify($w);

                    if ($template->is_blank() == FALSE) {
                        $info=$template->encode();
                    }
                }

                // ----- verify template and insert data into tables ----------
                // ----- only insert if template verifies ok ------------------

                if (!empty($hname)) {
                    $formerror .= UpdateDNS($ds, $w, $cust, $hname, $ip);
                }

                // is an address linked to another address - used for NAT?
                if (!empty($lnk)) {
                    if (!testIP($lnk)) {
                        // substr required to strip space added with each submit if user is empty
                        // and also to ensure field does not overflow 80 characters
                        $user = substr(trim("LNK$lnk $user"), 0, 79);

                        UpdateLnk($ds, $w, $cust, $baseindex, $lnk, $ip);
                    }
                    else {
                        $formerror .= sprintf(my_("Invalid link address: %s"), $lnk)."\n";
                    }
                }

                // check if mac address is valid - all or nothing!
                if (!empty($macaddr)) {
                    $oldmacaddr=$macaddr;
                    $macaddr=str_replace(array(":", "-", " "), "", $macaddr);
                    if (strlen($macaddr)==12 and
                            preg_match("/[a-f0-9A-F]/", $macaddr)) {
                    }
                    else {
                        $formerror .= sprintf(my_("Invalid MAC address: %s"), $oldmacaddr)."\n";
                    }
                }

                if ($err==FALSE and $ds->ModifyIP($ip, $baseindex, $user, $location, 
                            $telno, $macaddr, $descrip, $hname, $info) == 0) {

                    // ok, we actioned an ip address request - delete the request record
                    if ($request) {
                        $ds->ds->Execute("DELETE FROM requestip
                                WHERE requestindex=$request") and
                            $ds->AuditLog(sprintf(my_("User %s actioned request %s"), 
                                        $_SERVER[AUTH_VAR], $request));
                    }
                    $ds->DbfTransactionEnd();
                    insert($w,textbr(my_("IP address details modified")));
                }
                else {
                    $formerror .= my_("IP address details could not be modified")."\n";
                }
            }
        }
        else {
            $formerror .= my_("You are not the owner of the subnet")."\n";
        }
    }
    else {
        $formerror .= my_("Could not find the owner of the subnet - subnet possibly deleted by another user")."\n";
        // this error is rare, but fatal. Do not bother trying to recover. SQL below will
        // generate errors due to missing subnet.
        myError($w,$p, $formerror);
    }
}

myError($w,$p, $formerror, FALSE);
    
// what is the additional search SQL?
$sql=$ds->mySearchSql("descrip", $expr, $search);
// get detail from ipaddr table - could be nothing!
$result=$ds->GetSubnetDetails($baseindex, $sql);

// need number of rows - if none due to search, display message
// emulate for databases that do not have RecordCount
if (empty($search)) {
    // no search, count recs without network and broadcast addr
    $recs=$ds->ds->GetOne("SELECT count(*) AS cnt
                           FROM ipaddr
                           WHERE baseindex=$baseindex AND 
                           ipaddr!=$baseaddr AND 
                           ipaddr!=$baseaddr+$maxcnt-1");
}
else {
    $recs=$result->PO_RecordCount("ipaddr", "baseindex=$baseindex $sql");
}
if (!$recs) {
    if ($search) {  // only display error if searching and no records
        myError($w,$p, my_("Search found no matching entries"));
    }
}

// sanity check if MAXTABLESIZE in config.php is modified on the fly
// and person has maybe bookmarked paged
if ($baseaddr+$block*MAXTABLESIZE >= $baseaddr+$maxcnt) {
   myError($w,$p, my_("This page was bookmarked and contains invalid information which cannot be displayed anymore - restart from main menu"));
}

insert($w,block("<h3>"));
insert($w,text(my_("Subnet:")." ".
                  inet_ntoa($baseaddr)." ".my_("Mask:")." ".
                  inet_ntoa(inet_aton(ALLNETS)+1 -
                    $maxcnt)."/".inet_bits($maxcnt)));
insert($w,textbr());
insert($w,text(my_("Description:")." ".$row["descrip"]));
insert($w,block("</h3>"));

if ($showactive) {
   // increase time limit for scans - will have no effect if safe mode is on
   @set_time_limit(90);
}
else {
   insert($w,anchor($_SERVER["PHP_SELF"]."?baseindex=".$baseindex."&showactive=1&block=".$block,
                    my_("Show used addresses")));
 
   insert($w,textbr(my_(" This can take a while as each address is polled.  Green is active, Red is inactive")));
}
if ($showdns) {
   // increase time limit for dns query - will have no effect in safe mode is on
   @set_time_limit(90);
}
else {
   insert($w,anchor($_SERVER["PHP_SELF"]."?baseindex=".$baseindex."&showdns=1&block=".$block,
                    my_("Show DNS changes")));
 
   insert($w,textbr(my_(" Show descriptions that do not match DNS reverse entries. Red is new DNS value")));
}

insert($w,block("<p>"));

// only display stats for networks with more than 1 host
if ($maxcnt > 1) {
    insert($w,$tbig = table(array("cols"=>"3")));
    insert($tbig,$c = cell());

    // start form for drop down list
    insert($c, $f = form(array("name"=>"MODIFYMULTIPLE",
                    "method"=>"post",
                    "action"=>"modifyipformmul.php")));

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend,textbr(my_("Select multiple addresses to do a bulk change")));
    insert($con,textbr(my_("Ideal for reserving DHCP ranges")));

    // placeholder for select box
    insert($con, $consel=container("div"));

    insert($con,hidden(array("name"=>"baseindex",
                    "value"=>$baseindex)));
    insert($con,hidden(array("name"=>"block",
                    "value"=>$block)));
    insert($con,hidden(array("name"=>"search",
                    "value"=>$search)));
    insert($con,hidden(array("name"=>"expr",
                    "value"=>$expr)));

    insert($con,textbr());
    insert($con,submit(array("value"=>my_("Submit"))));
    insert($con,freset(array("value"=>my_("Clear"))));

    // draw the search box
    $srch = new mySearch($w, array("baseindex"=>$baseindex, "block"=>$block, "showactive"=>$showactive), $search, "search");
    $srch->legend=my_("Refine Search on Description");
    $srch->expr=$expr;
    $srch->expr_disp=TRUE;
    $srch->Search();  // draw the sucker!

    // placeholder for pager blocks
    insert($w, $cblk = container("div"));

    // start form for "Use next address" button
    insert($w,text("| "));
    insert($w,anchor("modifyipform.php?baseindex=$baseindex&baseaddr=$baseaddr&block=$block&expr=$expr&search=".urlencode($search),
            my_("Use next available address")));
    insert($w,text(" | "));
    insert($w,anchor("modifyipform.php?baseindex=$baseindex&baseaddr=$baseaddr&block=$block&probe=1&expr=$expr&search=".urlencode($search),
            my_("Use next available address and probe network if active")));
    insert($w,textbr(" |"));

    // three cells for better spacing
    insert($tbig,$c = cell(array("width"=>"5%")));
    // create stats cell for later use
    insert($tbig,$cstats = cell(array("valign"=>"top")));
}

// create a table
insert($w,$t = table(array("cols"=>"8",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$ck1 = cell());
// display preceding cell later
insert($t,$c = cell());
insert($c,text(my_("User")));
insert($t,$c = cell());
insert($c,text(my_("Location")));
insert($t,$c = cell());
insert($c,text(my_("Device description")));
insert($t,$c = cell());
insert($c,text(my_("Telephone Number")));
insert($t,$c = cell());
insert($c,textbr(my_("P")));
insert($c,textbr(my_("o")));
insert($c,text(my_("l")));
insert($t,$c = cell());
insert($c,text(my_("Last modified")));
insert($t,$ck2 = cell());
insert($ck2,text(my_("Changed by")));

$rr=new myFetchRow($result, $baseaddr, $maxcnt, empty($search) ? FALSE : TRUE);

$totcnt=0;
$vars=""; $anc="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
        $row = $rr->FetchRow()) {
    if ($totcnt % MAXTABLESIZE == 0) {
        $anc=inet_ntoa($row["ipaddr"])." - ";
    }
    else if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1) {
        $vars=$_SERVER["PHP_SELF"]."?baseindex=".$baseindex."&block=".$totcnt/MAXTABLESIZE."&showactive=".$showactive."&expr=$expr&search=".urlencode($search);
        insert($cblk,block(" | "));
        insert($cblk,anchor($vars, $anc.inet_ntoa($row["ipaddr"])));
    }
    $totcnt++;
}

$ipscan=array();
if ($showactive and NMAP != "") {
    $nmapstart=inet_ntoa($baseaddr+($block*MAXTABLESIZE));
    if ($maxcnt > MAXTABLESIZE) {
        $nmapend=inet_ntoa($baseaddr+($block*MAXTABLESIZE)+MAXTABLESIZE-1);
    }
    else {
        $nmapend=inet_ntoa($baseaddr+$maxcnt-1);
    }
    $ipscan = NmapScan(NmapRange($nmapstart, $nmapend));
    // nmap had error due to safe mode?
    if ($ipscan === FALSE) {
        $showactive=0;
    }
}

$pollcnt=array("d"=>0, "w"=>0, "m"=>0, "y"=>0);
$cnt=0;
$lst=array();
while($row = $rr->FetchRow()) {
    setdefault("cell",array("class"=>color_flip_flop()));

    // work out inet_ntoa once as it is slow!
    $ip=inet_ntoa($row["ipaddr"]);

    $polled=0;
    // did user select to scan if address is active?
    if ($showactive) {
        if (NMAP=="") {
            if (ScanHost($ip, 1)) {
                insert($t,$c = cell(array("class"=>"greencell")));
                // should be transaction here!
                $ds->UpdateIPPoll($baseindex, $row["ipaddr"]);
                $polled=1;
            }
            else {
                insert($t,$c = cell(array("class"=>"redcell")));
            }
        }
        else {
            if (isset($ipscan[$ip])) {
                insert($t,$c = cell(array("class"=>"greencell")));
                // should be transaction here!
                $ds->UpdateIPPoll($baseindex, $row["ipaddr"]);
                $polled=1;
            }
            else {
                insert($t,$c = cell(array("class"=>"redcell")));
            }
        }
    }
    else {
        insert($t,$c = cell());
    }

    // strange! brackets must be there in php 4.0.4p1, else code wrong!
    insert($c,anchor("modifyipform.php?ip=".($row["ipaddr"]).
                "&baseindex=".$baseindex."&block=".$block."&expr=$expr&search=".urlencode($search),
                $ip));

    insert($t,$c = cell());
    // network address
    if ($row["ipaddr"] == $baseaddr) {
        insert($c,text(my_("Reserved - network address"), 
                    array("color"=>"#FF0000")));
        insert($c,textbr());
    }
    // broadcast address
    else if ($row["ipaddr"] == $baseaddr+$maxcnt-1) {
        insert($c,text(my_("Reserved - broadcast address"), 
                    array("color"=>"#FF0000")));
        insert($c,textbr());
    }
    else {
        // add to select drop down list
        $col=$row["ipaddr"];
        $lst["$col"]=$ip;
    }

    // check if userinf field has an encoded linked address in format of LNKx.x.x.x
    // where x.x.x.x is an ip address
    $lnk="";
    $userinf=$row["userinf"];
    if (preg_match("/^LNK[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}/", $userinf)) {
        list($lnk, $userinf) = preg_split("/[\s]+/", $userinf, 2);
        $lnk=substr($lnk, 3);
    }
    insert($c,textbr($userinf));
    if (!empty($lnk)) {
        insert($c,block("<small><i>"));
        insert($c,anchor("displaybase.php?ipaddr=$lnk&cust=$cust&searchin=1&jump=1",
                    my_(sprintf("Follow link to %s", $lnk))));
        insert($c,block("</i></small>"));
    }

    insert($t,$c = cell());
    insert($c,text($row["location"]));
    insert($t,$c = cell());
    insert($c,text($row["descrip"]));
    if ($showdns) {
        // gethostbyaddr returns ip address back if no DNS entry
        // this will probably fail on windows!
        $tmp=time();
        $dnsdescrip=gethostbyaddr($ip);

        // are DNS queries taking too long?
        if (time()-$tmp > DNS_DELTA_TIME) {
            $showdns=0;   // stop doing DNS queries
            myError($w,$p, 
                sprintf(my_("DNS queries taking too long - stopped doing queries at %s, time taken for last query was %s seconds"), $ip, time()-$tmp), FALSE);
        }
        if ($dnsdescrip != $ip and $dnsdescrip != $row["hname"]) {
            if (!empty($row["descrip"])) {
                insert($c,textbr());
            }
            insert($c,text($dnsdescrip, array("color"=>"#FF0000")));
        }
        else if ($dnsdescrip == $ip and !empty($row["hname"])) {
            if (!empty($row["descrip"])) {
                insert($c,textbr());
            }
            insert($c,text(my_("No DNS entry defined"), array("color"=>"#FF0000")));
        }
    }
    if (!empty($row["hname"])) {
        insert($c,textbr());
        insert($c,block("<small><i>"));
        insert($c,text($row["hname"]));
        insert($c,block("</i></small>"));
    }
    insert($t,$c = cell());
    insert($c,text($row["telno"]));

    // display info about when last device was polled
    insert($t,$c = cell());
    if ($polled or $result->UnixDate($row["lastpol"]) > time()-(3600*24)) {
        insert($c,text("D"));
        $pollcnt["d"]++;
    }
    else if ($result->UnixDate($row["lastpol"]) > time()-(3600*24*7)) {
        insert($c,text("W"));
        $pollcnt["w"]++;
    }
    else if ($result->UnixDate($row["lastpol"]) > time()-(3600*24*30)) {
        insert($c,text("M"));
        $pollcnt["m"]++;
    }
    else if ($result->UnixDate($row["lastpol"]) > time()-(3600*24*365)) {
        insert($c,text("Y"));
        $pollcnt["y"]++;
    }

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,block($result->UserTimeStamp($row["lastmod"], "M d Y H:i:s")));
    insert($c,block("</small>"));
    insert($t,$c = cell());
    insert($c,text($row["userid"]));

    if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
        break;
    $cnt++;
    $totcnt++;

}

insert($w,block("<p>"));

// only display stats for networks with more than 1 host
if ($maxcnt > 1 and empty($search)) {
    // display stats
    insert($cstats,textb(my_("Subnet Summary")));
    insert($cstats,block("<p>"));
    insert($cstats,textbr(my_("Total addresses:")." ".$maxcnt));
    insert($cstats,textbr(my_("Used addresses:")." ".($recs+2).my_(" (Including network and broadcast)")));
    insert($cstats,textbr(my_("Free addresses:")." ".($maxcnt-$recs-2)));
    insert($cstats,textbr(my_("Active polled (D/W/M/Y):")." ".
        sprintf("%d/%d/%d/%d", $pollcnt["d"],$pollcnt["w"],$pollcnt["m"],$pollcnt["y"])));
    insert($cstats,textbr(my_("Utilization:")." ".(round(($recs+2)/$maxcnt*100,2))."%"));
    insert($cstats,textbr(my_("Efficiency:")." ".(round(($recs)/$maxcnt*100,2))."%"));
}

// display various blocks of subnet
$vars="";
$printed=0;
while ($row = $rr->FetchRow()) {
    $totcnt++;
    if ($totcnt % MAXTABLESIZE == 0) {
        $vars=$_SERVER["PHP_SELF"]."?baseindex=".$baseindex."&block=".$totcnt/MAXTABLESIZE."&showactive=".$showactive."&expr=$expr&search=".urlencode($search);
        insert($cblk,block(" | "));
        insert($cblk,anchor($vars,
                    inet_ntoa($row["ipaddr"])." - ".inet_ntoa($baseaddr+$totcnt+MAXTABLESIZE-1)));
    }
    if (!empty($vars) and !$printed) {
        insert($ck2,anchor($vars, ">>"));
        $printed=1;
    }
}
// $cblk will not exist if only a host - stats area not drawn
if ($maxcnt > 1) {
    //if ($maxcnt > MAXTABLESIZE) {
    if ($printed or $totcnt/MAXTABLESIZE > 1) {
        insert($cblk,block(" |"));
    }
    insert($cblk,block("<p>"));

    // draw select box
    insert($consel,selectbox($lst,
                array("name"=>"ip[]", 
                    "multiple size"=>"5")));

}

if ($block > 0) {
    $vars=$_SERVER["PHP_SELF"]."?baseindex=".$baseindex."&block=".($block-1)."&showactive=".$showactive."&expr=$expr&search=".urlencode($search);
    insert($ck1,anchor($vars, "<<"));
}
insert($ck1,textb(my_("IP address")));

$result->Close();
printhtml($p);


// myFetchRow class - special FetchRow to fill in missing records from subnet
// required for pager to work as records are expected in sequence - this just completes
// sequence
class myFetchRow {

    var $result;
    var $baseaddr;
    var $subnetsize;

    var $pointer=-1;
    var $saverow;
    var $search;

    function myFetchRow(&$result, $baseaddr, $subnetsize, $search=FALSE) {

        $this->result=$result;
        $this->baseaddr=$baseaddr;
        $this->subnetsize=$subnetsize;
        $this->search=$search;

    }

    function FetchRow() {

        if ($this->search) return $this->__MoveNext();

        if ($this->pointer==-1) {  // get first row
            $this->__MoveNext();
            $this->pointer++;
        }

        // row just read matches current expected record, so return it
        // saverow will be FALSE if eof
        if ($this->saverow AND $this->saverow["ipaddr"]==$this->baseaddr+$this->pointer) {
            $this->pointer++;
            $tmp=$this->saverow;
            $this->__MoveNext();
            return $tmp;
        }
        // row just read is much bigger than expected row, so return blank row
        else {
            if ($this->baseaddr+$this->pointer > $this->baseaddr+$this->subnetsize-1) {
                return FALSE;
            }

            $this->pointer++;
            return array("userinf"=>"", "location"=>"", "telno"=>"", "descrip"=>"",
                    "hname"=>"", "ipaddr"=>$this->baseaddr+$this->pointer-1,
                    "lastmod"=>NULL, "userid"=>"", "lastpol"=>NULL);

        }

    }

    function __MoveNext() {
        // get row using adodb class
        $this->saverow=$this->result->FetchRow();
        return $this->saverow;
    }

}

// check to see if hostname field is valid, then try to update existing, unique
// DNS A record, else optionally create a new A record in a unique zone matching
// the domain name portion of the hostname
function UpdateDNS($ds, $w, $cust, $hname, $ip) {

    $formerror = "";

    if (!preg_match('/^(([\w][\w\-\.]*)\.)?([\w][\w\-]+)(\.([\w][\w\.]*))?$/', $hname)) {

        $formerror .= sprintf(my_("Invalid hostname: %s %s"), inet_ntoa($ip), 
                $hname)."\n";
    }
    else {
        // check if there are A records for this customers domains?
        $result = &$ds->ds->Execute("SELECT fwdzone.domain, fwdzonerec.host, 
                fwdzonerec.ip_hostname 
                FROM fwdzone, fwdzonerec 
                WHERE fwdzone.data_id=fwdzonerec.data_id AND
                fwdzone.customer=$cust AND
                fwdzonerec.recordtype=".$ds->ds->qstr("A")." AND 
                fwdzonerec.ip_hostname=".$ds->ds->qstr(inet_ntoa($ip)));

        $recs=$result->PO_RecordCount("fwdzone, fwdzonerec", 
                "fwdzone.data_id=fwdzonerec.data_id AND fwdzone.customer=$cust AND
                fwdzonerec.recordtype=".$ds->ds->qstr("A")." AND 
                fwdzonerec.ip_hostname=".$ds->ds->qstr(inet_ntoa($ip)));
        // must be exactly one A record on one domain else cannot update
        if($recs == 1) {
            // does domain name of record match ip records hostname?
            $row=$result->FetchRow();
            $domain=$row["domain"];

            $cnt=0;
            $hnametmp=$hname;
            // does ip record domain name match zone name?
            if (preg_match("/\.$domain$/i", $hnametmp)) {
                // cant use php5.1's count parameter on preg_replace!
                $hnametmp=preg_replace("/\.$domain$/i", "", $hnametmp, 1);
            }
            else {
                $hnametmp.=".";    // no matching domain, so make FQDN
            }

            insert($w,textbr(my_("IP hostname field in DNS forward zone modified")));
            $ds->ds->Execute("UPDATE fwdzonerec SET host=".$ds->ds->qstr($hnametmp).",
                    lastmod=".$ds->ds->DBTimeStamp(time()).",
                    userid=".$ds->ds->qstr($_SERVER[AUTH_VAR])."
                    WHERE customer=$cust AND
                    recordtype=".$ds->ds->qstr("A")." AND 
                    ip_hostname=".$ds->ds->qstr(inet_ntoa($ip)));
        $ds->AuditLog(array("event"=>122, "action"=>"modified zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "host"=>$hnametmp,
                    "recordtype"=>"A", "iphostname"=>inet_ntoa($ip)));

        }
        else if($recs > 1) {
            $formerror .= my_("DNS forward A record not updated - multiple A records for this customer")."\n";
            while($row = $result->FetchRow()) {
                $formerror .= sprintf(my_("Hostname: %s IP address: %s\n"), $row["host"], $row["ip_hostname"]);
            }

        }
        // no matching A records to update, now look for a zone to create a 
        // new A record in - only supported on MySQL and Postgres (databases that support
        // regex searches
        else if (DNSAUTOCREATE and 
            (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql" or DBF_TYPE=="postgres7") and 
            $recs==0) {
            
            $regex = "RLIKE";
            if (DBF_TYPE=="postgres7") {
                $regex = "~";
            }

            $result = &$ds->ds->Execute("SELECT data_id, domain
                    FROM fwdzone
                    WHERE customer=$cust AND
                    ".$ds->ds->qstr($hname."$")." $regex domain");

            $recs=$result->PO_RecordCount("fwdzone", 
                    "fwdzone.customer=$cust AND
                    ".$ds->ds->qstr($hname."$")." $regex domain");

            // must be exactly one matching zone only
            if ($recs==1) {
                $row=$result->FetchRow();
                $domain=$row["domain"];
                $dataid=$row["data_id"];
                $hnametmp=preg_replace("/\.$domain$/i", "", $hname, 1);

                $result = $ds->ds->Execute("INSERT into fwdzonerec 
                        (customer, data_id, sortorder, lastmod, host, 
                         recordtype, userid, ip_hostname) ".
                        "VALUES ($cust, $dataid, 9999,".
                        $ds->ds->DBTimeStamp(time()).",".
                        $ds->ds->qstr($hnametmp).",".
                        $ds->ds->qstr("A").",".
                        $ds->ds->qstr($_SERVER[AUTH_VAR]).",".
                        $ds->ds->qstr(inet_ntoa($ip)).")" );
        $ds->AuditLog(array("event"=>121, "action"=>"add zone record", "cust"=>$cust,
                    "user"=>$_SERVER[AUTH_VAR], "domain"=>$domain, "host"=>$hnametmp,
                    "recordtype"=>"A", "iphostname"=>inet_ntoa($ip)));

                insert($w,textbr(my_("A record created in DNS forward zone")));
            }
            else {
                $formerror .= my_("DNS forward A record not created - could not find matching zone to create record in")."\n";
            }

        }

    }

    return $formerror;

}


// check to see if there is a detination linked address and subnet, if not
// create the destination address record
function UpdateLnk($ds, $w, $cust, $baseindex, $lnk, $ip) {

/*
    // got link address, see if there is a subnet for this link
    // if no subnet found, do nothing
    $result=$ds->GetBaseFromIndex($baseindex);
    $row = $result->FetchRow();
    $cust=$row["customer"];
    */

    $result=$ds->GetBaseFromIP(inet_aton($lnk), $cust);
    // yep found one, now see if a record exists
    if ($row=$result->FetchRow()) {
        $lnkidx=$row["baseindex"];
        if(!$result=$ds->GetIPDetails($lnkidx, inet_aton($lnk))) {
            // no row in subnet, then add one
            $ds->ModifyIP(inet_aton($lnk), $lnkidx, "", "", 
                    "", "", "Linked address from ".inet_ntoa($ip), "", "");
            insert($w,textbr(sprintf(my_("Destination linked address %s IP record created"), $lnk)));
        }
    }

}

// delete all attached file on an ip record
function RemoveAllFiles($ds, $baseindex, $iptemp) {

    // remove all attached files
    $result=&$ds->ds->Execute("SELECT infobin
            FROM ipaddradd
            WHERE ipaddr=$iptemp AND baseindex=$baseindex");

    if ($result) {   // guard against SQL error
        $rowadd = $result->FetchRow();
        if (!empty($rowadd["infobin"])) {
            $files=unserialize($rowadd["infobin"]);
            // if dbf field is empty, unserialize returns FALSE
            if ($files!=FALSE) {
                foreach($files as $key => $value) {
                    is_file(UPLOADDIRECTORY."/".basename($files[$key]["tmp_name"])) &&
                        unlink(UPLOADDIRECTORY."/".basename($files[$key]["tmp_name"]));
                }
            }
        }
    }
    else {
        return FALSE;    // some error, maybe table does not exist?
    }

    return TRUE;

}

?>
