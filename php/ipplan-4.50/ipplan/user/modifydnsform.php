<?php

// IPplan v4.50
// Aug 24, 2001
//
// Modified by Tony D. Koehn Feburary 2003
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

if ($action=='add') {
    $title=my_("Create DNS Zones");
}
else {
    $title=my_("Edit DNS Zones");
}
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $dataid, $action, $domain, $responsiblemail, $serialdate, $serialnum, $ttl, $retry, $refresh, $expire, $minimum, $slaveonly, $zonepath, $seczonepath) = myRegister("I:cust I:dataid S:action S:domain S:responsiblemail I:serialdate I:serialnum I:ttl I:retry I:refresh I:expire I:minimum S:slaveonly S:zonepath S:seczonepath");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

$now = getdate();
$newserialdate = $now["year"] . str_pad($now["mon"], 2, '0', STR_PAD_LEFT) . str_pad( $now["mday"], 2, '0', STR_PAD_LEFT);
if ($serialdate=$newserialdate) {
   $serialnum++;
}else{
   $serialdate=$newserialdate;
   $serialnum=0;
}

insert($w, $f = form(array("name"=>"ENTRY",
                           "method"=>"post",
                           "action"=>"modifydns.php")));

// Use the same form for adding or editing.  Setup page & variables based on action.
if ($action=='add') {
    $zone="";

    $ttl=DNSTTL;
    $refresh=DNSREFRESH;
    $retry=DNSRETRY;
    $expire=DNSEXPIRE;
    $minimum=DNSMINTTL;   
    $slaveonly=DNSSLAVEONLY;
    $responsiblemail=REGADMINEMAIL;
    $zonepath="/var/named/test.zone";
    $seczonepath="";
    insert($f,hidden(array("name"=>"action", "value"=>"add")));
    $myTitle="Add";
}else{
   insert($f,hidden(array("name"=>"action", "value"=>"edit")));
   insert($f,hidden(array("name"=>"dataid", "value"=>"$dataid")));
   $myTitle="Edit";
}
// strip @ from email address if it exists
$responsiblemail=str_replace("@", ".", $responsiblemail);

insert($f,hidden(array("name"=>"cust", "value"=>"$cust")));
insert($f,hidden(array("name"=>"serialdate", "value"=>"$serialdate")));
insert($f,hidden(array("name"=>"serialnum", "value"=>"$serialnum")));

insert($f,heading(3, my_("$myTitle a Zone")));
insert($f,textbr(my_("Maintain forward zone SOA information.")));

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Forward zone information")));

insert($con,textbr(my_("Zone (Domain Name)")));
if ($action=="add") {
    insert($con,span(my_("Separate multiple domain names with ;"), array("class"=>"textSmall")));
}
myFocus($p, "ENTRY", "domain");
insert($con,input_text(array("name"=>"domain",
                           "value"=>"$domain",
                           "size"=>"30",
                           "maxlength"=>"253")));

insert($con,checkbox(array("name"=>"slaveonly"),
                   "Slave Zone?",
                   ($slaveonly == "Y" ? "on" : "")));

// if creating new zone, get dns servers from revdns table
if ($action=="add") {
    // give option of reading zone from existing DNS server via zone transfer
    insert($con,textbrbr(my_("Zone transfer from DNS server")));
    insert($con,span(my_("Blank for no zone transfer"), array("class"=>"textSmall")));
    insert($con,span(my_("Slave zones only import SOA information, not zone records"), array("class"=>"textSmall")));
    insert($con,input_text(array("name"=>"server",
                    "size"=>"30",
                    "maxlength"=>"30")));

    $result2=&$ds->ds->Execute("SELECT hname 
            FROM revdns
            WHERE customer=$cust");
}
else {
    $result2=&$ds->ds->Execute("SELECT hname 
            FROM fwddns
            WHERE id=$dataid");
}

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));

if ($action=="add") {
    insert($legend, text(my_("Zone SOA information if zone not created via zone transfer")));
}
else {
    insert($legend, text(my_("Zone SOA information")));
}
 
$i=1;
while($row2 = $result2->FetchRow()) {
   $hname[$i]=$row2["hname"];
   $i++;
}

// space for 10 reverse entries
for ($i=1; $i < 11; $i++) {
    insert($con,textbr(sprintf(my_("Name server %u:"), $i)));
    insert($con,input_text(array("name"=>"hname[".$i."]",
                               "value"=>isset($hname[$i]) ? $hname[$i] : "",
                               "size"=>"80",
                               "maxlength"=>"100")));
    insert($con,textbr());
}

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Forward zone SOA header information")));

insert($con,textbr(my_("Technical contact email address")));
insert($con,span(my_("No @ allowed - replace with ."), array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"responsiblemail",
                           "value"=>"$responsiblemail",
                           "size"=>"64",
                           "maxlength"=>"64")));
insert($con,textbrbr(my_("TTL")));
insert($con,input_text(array("name"=>"ttl",
                           "value"=>"$ttl",
                           "size"=>"10",
                           "maxlength"=>"10")));

insert($con,textbrbr(my_("Refresh")));
insert($con,input_text(array("name"=>"refresh",
                           "value"=>"$refresh",
                           "size"=>"5",
                           "maxlength"=>"10")));

insert($con,textbrbr(my_("Retry")));
insert($con,input_text(array("name"=>"retry",
                           "value"=>"$retry",
                           "size"=>"5",
                           "maxlength"=>"10")));

insert($con,textbrbr(my_("Expire")));
insert($con,input_text(array("name"=>"expire",
                           "value"=>"$expire",
                           "size"=>"5",
                           "maxlength"=>"10")));

insert($con,textbrbr(my_("Minimum TTL")));
insert($con,input_text(array("name"=>"minimum",
                           "value"=>"$minimum",
                           "size"=>"5",
                           "maxlength"=>"10")));

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Forward zone location")));

insert($con,textbr(my_("Zone File Path")));
insert($con,span(my_("The path where the zone file will be written once exported and processed. Examples:"), array("class"=>"textSmall")));
insert($con,span(my_("ftp://myhost.com/var/named/test.zone - if you want to transfer the zone using ncftput"), array("class"=>"textSmall")));
insert($con,span(my_("user@myhost.com:/var/named/test.zone - if you want to transfer the zone using scp"), array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"zonepath",
                           "value"=>"$zonepath",
                           "size"=>"80",
                           "maxlength"=>"254")));

insert($con,textbrbr(my_("Secondary Zone File Path")));
insert($con,input_text(array("name"=>"seczonepath",
                           "value"=>"$seczonepath",
                           "size"=>"80",
                           "maxlength"=>"254")));

insert($f,submit(array("value"=>my_("Save"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
