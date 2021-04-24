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

require_once("../class.templib.php");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// basic sequence is connect, search, interpret search
// result, close connection

// explicitly cast variables as security measure against SQL injection
list($cust) = myRegister("I:cust");

$ds=new IPplanDbf() or die(my_("Could not connect to database"));

// force file download due to bad mime type
header("Content-Type: bad/type");
header("Content-Disposition: attachment; filename=ipaddr.txt");
header("Pragma: no-cache");
header("Expires: 0");

// if a specific network template exists, use that, else use generic template
$template=NULL;
$err=TRUE;
if (is_readable("../user/iptemplate.xml")) {
    $template=new IPplanIPTemplate("../user/iptemplate.xml");
    $err=$template->is_error();
}

$result=&$ds->ds->Execute("SELECT ipaddr.userinf, ipaddr.location, ipaddr.telno, 
                          ipaddr.descrip, ipaddr.hname, ipaddr.ipaddr AS ip,
                          ipaddr.baseindex AS baseip
                        FROM ipaddr, base
                        WHERE ipaddr.baseindex=base.baseindex AND
                           base.customer=$cust
                        ORDER BY
                           ipaddr.ipaddr");  

// main loop
while($row = $result->FetchRow()) {
    echo inet_ntoa($row["ip"]).FIELDS_TERMINATED_BY.$row["userinf"].FIELDS_TERMINATED_BY.
        $row["location"].FIELDS_TERMINATED_BY.$row["descrip"].FIELDS_TERMINATED_BY.
        $row["hname"].FIELDS_TERMINATED_BY.$row["telno"];

    if (!$err) {
        $restmp=&$ds->ds->Execute("SELECT info, infobin
                FROM ipaddradd
                WHERE ipaddr=".$row["ip"]." AND baseindex=".$row["baseip"]);

        if($rowadd = $restmp->FetchRow()) {
            $template->Merge($template->decode($rowadd["info"]));
            foreach($template->userfld as $arr) {
                echo FIELDS_TERMINATED_BY.$arr["value"];
            }
        }
    }

    echo "\n";
}


?>
