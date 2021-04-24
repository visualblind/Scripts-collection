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

$title=my_("Add / Edit  DNS Host");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $dataid, $zoneid, $action, $domain, $sortorder, $host, $recordtype, $iphostname) = myRegister("I:cust I:dataid I:zoneid S:action S:domain I:sortorder S:host S:recordtype S:iphostname");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

insert($w,heading(3, my_("Host Record for domain: ").$domain));

insert($w, $f = form(array("name"=>"ENTRY",
                           "method"=>"post",
                           "action"=>"modifydnsrecord.php")));

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("DNS record")));

// Use the same form for adding or editing.  Setup page & variables based on action.
if ($action=='add') {
    $host="";
    $RecordType="A";
    $iphostname="";
    insert($con,hidden(array("name"=>"action", "value"=>"add")));
    insert($con,hidden(array("name"=>"zoneid", "value"=>"$zoneid")));
    $myTitle="Add";
}
else {
    insert($con,hidden(array("name"=>"action", "value"=>"edit")));
    insert($con,hidden(array("name"=>"zoneid", "value"=>"$zoneid")));
    insert($con,hidden(array("name"=>"dataid", "value"=>"$dataid")));
    $myTitle="Edit";
}
insert($con,hidden(array("name"=>"domain", "value"=>"$domain")));
insert($con,hidden(array("name"=>"cust", "value"=>"$cust")));
   
myFocus($p, "ENTRY", "host");
insert($con,textbr(my_("Host Name")));
insert($con,block("<small><i>"));
insert($con,textbr(my_("Terminate Fully Qualified Domand Name's (FQDN) with a . eg. mywwwserver.com. to signify 'This domain'")));
insert($con,block("</small></i>"));
insert($con,input_text(array("name"=>"host",
                           "value"=>"$host",
                           "size"=>"40",
                           "maxlength"=>"253")));

insert($con,anchor("JavaScript:thisdomain()",
                     my_("This domain")));


// add some javascript magic to follow a link if field is completed
    insert($w, script('
function thisdomain() {

    document.ENTRY.host.value="'.$domain.'.";
} ', array("language"=>"JavaScript", "type"=>"text/javascript")));


insert($con,textbrbr(my_("Record Type")));
insert($con,selectbox(array("A"=>"A",
                          "CNAME"=>"CNAME",
                          "MX"=>"MX",
                          "TXT"=>"TXT",
                          "KEY"=>"KEY"),
                          array("name"=>"recordtype"), $recordtype));

insert($con,textbrbr(my_("IP / Hostname")));
insert($con,block("<small><i>"));
insert($con,textbr(my_("For MX records, format is \"preference hostname\", eg. \"10 mymailserver.com.\"")));
insert($con,block("</small></i>"));
insert($con,input_text(array("name"=>"iphostname",
                           "value"=>"$iphostname",
                           "size"=>"40",
                           "maxlength"=>"250")));

insert($con,textbrbr(my_("Sort Order")));
insert($con,input_text(array("name"=>"sortorder",
                           "value"=>"$sortorder",
                           "size"=>"6",
                           "maxlength"=>"6")));

insert($f,submit(array("value"=>my_("Save"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
