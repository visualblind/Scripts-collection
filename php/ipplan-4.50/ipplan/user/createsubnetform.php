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
require_once("../class.templib.php");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Create a new subnet");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $size) = myRegister("I:cust I:size");

// display opening text
insert($w,heading(3, "$title."));

insert($w,text(my_("Create a new subnet by entering the base (network) address of the subnet. Subnets are the building blocks of all networks, and are all that is required for small networks.")));
insert($w,block("<p>"));
insert($w,text(my_("Unused subnets can be pre-allocated with a description of either 'free' or 'spare'. These can be searched for at a later stage using the 'Find Free' function.")));
insert($w,block("<p>"));
insert($w,textbr(my_("It may also be beneficial to give ASE (Autonomous System External, networks not local to yours) a special handle like EXTERNAL so that they can be searched for at a later stage. These networks often appear in routing tables as static routes to third parties (not via the Internet).")));

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// start form
insert($w, $f = form(array("name"=>"ENTRY",
                           "method"=>"post",
                           "action"=>"createsubnet.php")));

$cust=myCustomerDropDown($ds, $f, $cust, $grps, FALSE) or myError($w,$p, my_("No customers"));

$result=$ds->GetGrps();

$lst=array();
while($row = $result->FetchRow()) {
   $col=$row["grp"];
   $lst["$col"]=$row["grpdescrip"];
}
if (empty($lst)) {
   myError($w,$p, my_("You first need to create some groups!"));
}

insert($f,textbrbr(my_("Admin Group")));
insert($f,span(my_("WARNING: If you choose a group that you do not have access to, you will not be able to see or access the data"), array("class"=>"textSmall")));
insert($f,selectbox($lst,
                 array("name"=>"admingrp"), "$ipplanGroup"));

insert($f,textbrbr(my_("Network address")));

myFocus($p, "ENTRY", "ipaddr");
insert($f,input_text(array("name"=>"ipaddr",
                           "value"=>isset($ipaddr) ? $ipaddr : "",
                           "size"=>"15",
                           "maxlength"=>"15")));

insert($f,textbrbr(my_("Number of contiguous networks to create")));

insert($f,input_text(array("name"=>"num",
                           "value"=>"1",
                           "size"=>"3",
                           "maxlength"=>"3")));

insert($f,textbrbr(my_("Description")));
insert($f,span(my_("Leave blank to automatically describe"), array("class"=>"textSmall")));
insert($f,input_text(array("name"=>"descrip",
                       "size"=>"80",
                       "maxlength"=>"80")));
insert($f,textbrbr(my_("Subnet size/mask")));

// size maybe set from router script!!!
insert($f,selectbox(array("1"=>"255.255.255.255/32 - host",
                          "2"=>"255.255.255.254/31 - 2 hosts",
                          "4"=>"255.255.255.252/30 - 4 hosts",
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
                          "262144"=>"255.252.0.0/14 - 256k hosts"),
                    array("name"=>"size"), $size));

insert($f,textbr());
//if (NMAP != "" and ini_get("safe_mode") == 0) {
if (NMAP != "") {
    insert($f,checkbox(array("name"=>"addnmapinfo",
                    "value"=>"1"),
                my_("Add active hosts using NMAP")));
    insert($f,text(" | "));
}
insert($f,checkbox(array("name"=>"addhostinfo",
                         "value"=>"1"),
                         my_("Add host names from DNS")));
insert($f,text(" | "));
insert($f,checkbox(array("name"=>"dhcp",
                         "value"=>"1"),
                         my_("Is this a DHCP subnet?")));
insert($f,textbr());

// if called from findfree, save find results
if (isset($_SERVER['HTTP_REFERER']) and stristr($_SERVER['HTTP_REFERER'], "findfree.php")) {
   insert($f,hidden(array("name"=>"findfree", 
                          "value"=>base64_encode($_SERVER['HTTP_REFERER']))));
}

    // Requires new default template: basetemplate.xml
    // Start of template support [FE]

    // use base template (for additional subnet information)
    if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml")) {
        $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml");
    }

    if (is_object($template) and $template->is_error() == FALSE) {
        insert($f, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text(my_("Additional information")));

        //$template->Merge($template->decode($dbfinfo));
        $template->DisplayTemplate($con);
    }

insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

$result->Close();
printhtml($p);

?>
