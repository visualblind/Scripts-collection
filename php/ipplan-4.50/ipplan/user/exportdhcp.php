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
require_once("../auth.php");

// Changed [FE] - Begin
require_once("../class.templib.php");
require_once("../layout/class.layout");
// Changed [FE] - End

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Export DHCP subnet details");
newhtml($p);
$w=myheading($p, $title, true);

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// basic sequence is connect, search, interpret search
// result, close connection

// explicitly cast variables as security measure against SQL injection
list($cust) = myRegister("I:cust");

$ds=new IPplanDbf() or die(my_("Could not connect to database"));

// check if user belongs to customer admin group
$result=$ds->GetCustomerGrp($cust);

// can only be one row - does not matter if nothing is 
// found as array search will return false
$row = $result->FetchRow();
if (!in_array($row["admingrp"], $grps)) {
    myError($w,$p, my_("You may not export DHCP subnets as you are not a member of the customers admin group"));
} 

$startnum=inet_aton(DEFAULTROUTE);
$endnum=inet_aton(ALLNETS);


// if a specific network template exists, use that, else use generic template
$template=NULL;
$err=TRUE;
if (is_readable("../user/basetemplate.xml")) {
    $template=new IPplanIPTemplate("../user/basetemplate.xml");
    $err=$template->is_error();
}
// error with template here is fatal
if($err) {
   myError($w,$p, my_("Error reading template!"));
}

insert($w,textb(sprintf(my_("Exporting all subnets marked as DHCP and all IP addresses with a user marked as '%s'"), DHCPRESERVED)));
insert($w,textbr());
insert($w,textbr());

$cnt=0;
// search only for subnets marked dhcp
$ds->dhcp=1;
$result=$ds->GetBase($startnum, $endnum, '', $cust);

// loop through each subnet looking for a template
while($row = $result->FetchRow()) {

    $baseaddr = inet_ntoa( $row["baseaddr"] );
    $baseindex = $row["baseindex"];
    $descrip = $row["descrip"];
    $size= inet_ntoa( inet_aton(ALLNETS)+1 - $row["subnetsize"] );

    $result_template=&$ds->ds->Execute("SELECT info, infobin
            FROM baseadd
            WHERE baseindex=$baseindex");
    // Search for string 'DHCP' in template variable 'dhcptrigger', set $trigger to 1, if found.
    $trigger=0;
    // no template defined on subnet, skip subnet
    if ($rowadd = $result_template->FetchRow()) {
        $template->Merge($template->decode($rowadd["info"]));
        insert($w,textbr(sprintf(my_("Exporting DHCP for %s"), $baseaddr)));

        //NOTE: need to check that correct template vars are available here!!!
        // else throw message and skip subnet!!!

    }
    else {
        // skip rest as no template on subnet
        continue;
    } // end template

    // first one found, open file for writing
    if ($cnt==0) {
        $tmpfname = tempnam (DHCPEXPORTPATH, "dhcp_");
        if(!$tmpfname) {
            myError($w,$p, my_("Could not create temporary file!"));
        }

        $fp = fopen ("$tmpfname", "w");

        // header of document
        $output='<?xml version="1.0" ?>';
        fputs($fp, $output);
        fputs($fp, "\n");
    }
    $cnt++;

    fputs($fp, sprintf("<network address=%s>\n", htmlspecialchars($baseaddr)));

    //$template->Merge($template->decode($rowadd["info"]));
    foreach($template->userfld as  $field=>$val) {
        fputs($fp, sprintf("\t<%s>%s</%s>\n", 
                    htmlspecialchars($field),
                    htmlspecialchars($val["value"]),
                    htmlspecialchars($field)));
    }


    // needs %% around userinf field as this could also contain a LNK!
    $result_ip=&$ds->ds->Execute("SELECT ipaddr, macaddr
            FROM ipaddr
            WHERE baseindex=$baseindex AND
            userinf LIKE ".$ds->ds->qstr("%".DHCPRESERVED."%")."
            ORDER BY ipaddr");

    while ($rowip = $result_ip->FetchRow()) {
        $ipaddr=inet_ntoa($rowip["ipaddr"]);

        $macaddr=$rowip["macaddr"];
        fputs($fp, sprintf("\t<host=%s>\n", 
                        htmlspecialchars($ipaddr)));

        // TODO: Just check for non-empty, needs care!
        // mac address is checked on entry, can be empty or correct format only!
        if (!empty($macaddr)) {
            if (strlen($macaddr)==12 and
                    preg_match("/[a-f0-9A-F]/", $macaddr)) {
                insert($w,textbr(sprintf(my_("Found IP with MAC: %s, %s"), $ipaddr, $macaddr)));

                fputs($fp, sprintf("\t\t<macaddr>%s</macaddr>\n", 
                            htmlspecialchars($macaddr)));
            }
            else {
                insert($w,textbr(sprintf(my_("Found IP with invalid MAC - ignoring: %s, %s"), $ipaddr, $macaddr)));
            }

        }
        fputs($fp, "\t</host>\n");

    } // end while: loop through ips of subnet. 

    fputs($fp, sprintf("</network>\n"));

} // end while

if ($cnt) {
    $ds->AuditLog(array("event"=>913, "action"=>"export DHCP subnets", "cust"=>$cust,
                "user"=>$_SERVER[AUTH_VAR], "tmpfname"=>$tmpfname));

    insert($w,textbr(sprintf(my_("Sent update to Backend Processor as file %s"), $tmpfname)));

}
else {
   myError($w,$p, my_("No DHCP subnets could be found."));
}

printhtml($p);
?> 
