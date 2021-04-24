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

require_once("../config.php");
require_once("../ipplanlib.php");
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../layout/class.layout");
require_once("../auth.php");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("IPplan Maintenance");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($action) = myRegister("S:action");

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {
    if ($action=="deleterequest") {
          $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("DELETE FROM requestip");

        $ds->AuditLog(my_("Requested IP addresses cleared"));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Requested IP addresses cleared!")));
        }
        else {
            insert($w,text(my_("Requested IP addresses could not be cleared.")));
        }
    }
    if ($action=="deleteaudit") {
        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("DELETE FROM auditlog");

        $ds->AuditLog(my_("Audit log cleared"));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Audit log cleared!")));
        }
        else {
            insert($w,text(my_("Audit log could not be cleared.")));
        }
    }
    if ($action=="custindex") {
        $result=$ds->GetCustomer();

        // create a table
        insert($w,$t = table(array("cols"=>"3",
                        "class"=>"outputtable")));
        // draw heading
        setdefault("cell",array("class"=>"heading"));
        insert($t,$c = cell());
        insert($c,text(my_("Customer description")));
        insert($t,$c = cell());
        insert($c,text(my_("Group name")));
        insert($t,$c = cell());
        insert($c,text(my_("Customer index")));

        while($row = $result->FetchRow()) {
            if (strtolower($row["custdescrip"]) == "all") {
                continue;
            }

            setdefault("cell",array("class"=>color_flip_flop()));

            insert($t,$c = cell());
            insert($c,text($row["custdescrip"]));

            insert($t,$c = cell());
            insert($c,text($row["admingrp"]));

            insert($t,$c = cell());
            insert($c,text($row["customer"]));
        }
    }
}

// display opening text
insert($w,heading(3, "$title."));

insert($w,textbr(my_("Perform the selected IPplan database maintenance.")));

// start form
insert($w, $f = form(array("method"=>"post",
                "action"=>$_SERVER["PHP_SELF"])));

insert($f,hidden(array("name"=>"action",
                "value"=>"custindex")));

insert($f,generic("p"));
insert($f,submit(array("value"=>my_("Display list of customer indexes"))));
 
// start form
insert($w, $f = form(array("method"=>"post",
                "action"=>$_SERVER["PHP_SELF"])));

insert($f,hidden(array("name"=>"action",
                "value"=>"deleterequest")));

insert($f,generic("p"));
insert($f,submit(array("value"=>my_("Clear IP address request list"))));
 
// start form
insert($w, $f = form(array("method"=>"post",
                "action"=>$_SERVER["PHP_SELF"])));

insert($f,hidden(array("name"=>"action",
                "value"=>"deleteaudit")));

insert($f,generic("p"));
insert($f,submit(array("value"=>my_("Clear Audit Log"))));
 
printhtml($p);

?>
