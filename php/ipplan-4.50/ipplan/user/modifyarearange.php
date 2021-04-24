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

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$auth->authenticate();

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Results of your search for areas");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $ipplanParanoid) = myRegister("I:cust I:ipplanParanoid");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

$custdescrip=$ds->GetCustomerDescrip($cust);

insert($w,heading(3, sprintf(my_("Search for areas and ranges for customer '%s'"), $custdescrip)));

$result=&$ds->ds->Execute("SELECT area.areaaddr, area.descrip AS adescrip, 
                          range.rangeaddr,
                          range.rangesize, range.descrip AS rdescrip,
                          range.rangeindex, area.areaindex
                        FROM range
                        LEFT JOIN area
                        ON range.areaindex=area.areaindex
                        WHERE range.customer=$cust
                        ORDER BY area.areaaddr, range.rangeaddr, range.rangesize");

// create a table
insert($w,$t = table(array("cols"=>"8",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
insert($c,text(my_("Area address")));
insert($t,$c = cell());
insert($c,text(my_("Description")));
insert($t,$c = cell());
insert($c,text(my_("Action")));
insert($t,$c = cell());
insert($c,text(my_("Range address")));
insert($t,$c = cell());
insert($c,text(my_("Range size")));
insert($t,$c = cell());
insert($c,text(my_("Range mask")));
insert($t,$c = cell());
insert($c,text(my_("Description")));
insert($t,$c = cell());
insert($c,text(my_("Action")));

 
$cnt=0;
$savearea=0;
while($row=$result->FetchRow()) {
    setdefault("cell",array("class"=>color_flip_flop()));

    // first record could be NULL due to left join
    if ($savearea==$row["areaaddr"] and $cnt!=0) {
        insert($t,$c = cell());
        insert($t,$c = cell());
        insert($t,$c = cell());
    }
    else {
        if (is_numeric($row["areaaddr"])) {
            insert($t,$c = cell());
            insert($c,text(inet_ntoa($row["areaaddr"])));

            insert($t,$c = cell());
            insert($c,text($row["adescrip"]));

            insert($t,$c = cell());
            insert($c,block("<small>"));
            insert($c,anchor("deletearea.php?areaindex=".$row["areaindex"]."&cust=".$cust, 
                        my_("Delete Area"),
                        $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));

            insert($c,block(" | "));

            insert($c,anchor("createarea.php?action=modify&areaindex=".$row["areaindex"].
                        "&ipaddr=".inet_ntoa($row["areaaddr"]).
                        "&cust=".$cust."&descrip=".urlencode($row["adescrip"]),
                        "Modify Area"));
            insert($c,block("</small>"));
        }
        else {
            insert($t,$c = cell());
            insert($c,text(my_("No area")));

            insert($t,$c = cell());
            insert($c,text(my_("Range not part of area")));
            insert($t,$c = cell());
        }
    }

    insert($t,$c = cell());
    insert($c,text(inet_ntoa($row["rangeaddr"])));

    insert($t,$c = cell());
    insert($c,text($row["rangesize"]));

    insert($t,$c = cell());
    insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                    $row["rangesize"])."/".inet_bits($row["rangesize"])));

    insert($t,$c = cell());
    insert($c,text($row["rdescrip"]));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,anchor("deleterange.php?rangeindex=".$row["rangeindex"]."&cust=".$cust, 
                my_("Delete Range"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));

    insert($c,block(" | "));

    insert($c,anchor("createrange.php?action=modify&rangeindex=".$row["rangeindex"].
                "&areaindex=".$row["areaindex"].
                "&size=".$row["rangesize"].
                "&ipaddr=".inet_ntoa($row["rangeaddr"]).
                "&cust=".$cust."&descrip=".urlencode($row["rdescrip"]),
                "Modify Range"));
    insert($c,block("</small>"));

    $savearea=$row["areaaddr"];
    $cnt++;
}
insert($w,block("<p>"));
insert($w,textb(sprintf(my_("Total records: %u"), $cnt)));

$result=&$ds->ds->Execute("SELECT area.areaaddr,
                             area.descrip AS adescrip, area.areaindex
                           FROM area
                           LEFT JOIN range
                           ON area.areaindex=range.areaindex
                           WHERE area.customer=$cust AND
                               range.areaindex IS NULL
                           ORDER BY area.areaaddr");

insert($w,heading(3, my_("Areas that have no ranges defined")));

setdefault("cell", FALSE);
// create a table
insert($w,$t = table(array("cols"=>"3",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
insert($c,text(my_("Area address")));
insert($t,$c = cell());
insert($c,text(my_("Description")));
insert($t,$c = cell());
insert($c,text(my_("Action")));

$cnt=0;
while($row=$result->FetchRow()) {
    setdefault("cell",array("class"=>color_flip_flop()));

    insert($t,$c = cell());
    insert($c,text(inet_ntoa($row["areaaddr"])));

    insert($t,$c = cell());
    insert($c,text($row["adescrip"]));

    insert($t,$c = cell());
    insert($c,block("<small>"));
    insert($c,anchor("deletearea.php?areaindex=".$row["areaindex"]."&cust=".$cust,
                my_("Delete Area"),
                $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
    insert($c,block(" | "));

    insert($c,anchor("createarea.php?action=modify&areaindex=".$row["areaindex"].
                "&ipaddr=".inet_ntoa($row["areaaddr"]).
                "&cust=".$cust."&descrip=".urlencode($row["adescrip"]),
                "Modify Area"));
    insert($c,block("</small>"));

    $cnt++;

}
insert($w,block("<p>"));
insert($w,textb(sprintf(my_("Total records: %u"), $cnt)));

$result->Close();
printhtml($p);

?>
