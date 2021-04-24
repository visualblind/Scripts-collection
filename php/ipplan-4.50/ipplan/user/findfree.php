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

define("DUPWARN", "~D~");
define("DUPWARNFREE", "~F~");
define("MAXSIZE", 99999999);

if (!ANONYMOUS) {
   $auth = new SQLAuthenticator(REALM, REALMERROR);

   // And now perform the authentication
   $auth->authenticate();
}

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Results of your search");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $areaindex, $rangeindex, $start, $end, $showused, $size_from, $size_to) = myRegister("I:cust I:areaindex I:rangeindex S:start S:end I:showused I:size_from I:size_to");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// set start and end address according to range
$site="";
if ($rangeindex) {
   // should only return one row here!
   $result=$ds->GetRange($cust, $rangeindex);
   $row = $result->FetchRow();
 
   $start=inet_ntoa($row["rangeaddr"]);
   $end=inet_ntoa($row["rangeaddr"]+$row["rangesize"]-1);
   $site=" (".$row["descrip"].")";
}

if (testIP($start) or testIP($end)) {
   myError($w,$p, my_("Invalid IP address! You must select a range or fill in the start and end IP address."));
}

$startnum=inet_aton($start);
$endnum=inet_aton($end);

if ($endnum <= $startnum) {
   myError($w,$p, my_("Your end ip address is smaller than your start!"));
}

//if the $size* is empty set it to value
if (empty ($size_from)) $size_from = 0;
if (empty ($size_to)) $size_to = MAXSIZE;

$custdescrip=$ds->GetCustomerDescrip($cust);
$allcust=0;
if (strtolower($custdescrip)=="all") {
    $allcust=1;
}

insert($w,heading(3, sprintf(my_("Search for IP subnets between %s and %s %s for customer '%s'"), $start, $end, $site, $custdescrip)));

if ($size_from > 0 or $size_to < MAXSIZE) {
   insert($w,textb(sprintf(my_("Subnet size filter: Subnets between %s and %s"), 
                    $size_from, $size_to)));
   insert($w,block("<p>"));
}

if ($allcust) {
    $sql="";
}
else {
    $sql=" AND base.customer=$cust ";
}
// do not count the network and broadcast addresses - they are always add later
// NULL's are not counted by count()
// if() is mysql specific! Need to use case as this is SQL99 compliant
$result=&$ds->ds->Execute("SELECT base.baseindex, base.subnetsize, base.descrip, 
                          base.baseaddr, base.admingrp, base.customer,
                          count(CASE WHEN ipaddr.ipaddr=base.baseaddr 
                                       OR ipaddr.ipaddr=(base.baseaddr+base.subnetsize-1) 
                                THEN NULL 
                                ELSE ipaddr.baseindex END) AS cnt
                        FROM base
                        LEFT JOIN ipaddr 
                          ON base.baseindex=ipaddr.baseindex
                        WHERE base.baseaddr BETWEEN $startnum AND $endnum 
			  $sql
                        GROUP BY base.baseindex, base.subnetsize, base.descrip,
                          base.baseaddr, base.admingrp, base.customer
                        ORDER BY
                           base.baseaddr");

// read entire result set into memory
$maxcnt=0;
$cnt=0;
$cntsubsize=0;
$used=0;
$cntfree=0;
$cntfreesubsize=0;
$arr=array();

$prevbase=0;
$prevsize=0;
while($row = $result->FetchRow()) {
    if ($row["baseaddr"] >= $prevbase and $row["baseaddr"] < $prevbase+$prevsize) {
        $prevbase=min($prevbase, $row["baseaddr"]);
        $prevsize=max($prevsize, $row["subnetsize"]);

    if (substr(strtolower($row["descrip"]),0,4)=="free" or
            substr(strtolower($row["descrip"]),0,5)=="spare") {
        $arr[$maxcnt-1]["descrip"]=DUPWARNFREE;
    }
        if ($arr[$maxcnt-1]["descrip"]!=DUPWARNFREE) {
        $arr[$maxcnt-1]["descrip"]=DUPWARN;
        }
        $arr[$maxcnt-1]["subnetsize"]=$prevsize;
        $arr[$maxcnt-1]["cnt"]=max($arr[$maxcnt-1]["cnt"], $row["cnt"]);
    }
    else {
        $arr[$maxcnt++]=$row;
        $prevbase=$row["baseaddr"];
        $prevsize=$row["subnetsize"];
    }
    //$arr[$maxcnt-1]["descrip"].=inet_ntoa($prevbase)." ".$prevsize;
}
// Why is the previous result read into an array?
$result->Close(); // save up some memory - won't help much. 

if (!$maxcnt) {
    myError($w,$p, my_("Search found no matching entries"));
}

// create a table
insert($w,$t = table(array("cols"=>"6",
                "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
insert($c,text(my_("Base address")));
insert($t,$c = cell());
insert($c,text(my_("Subnet size")));
insert($t,$c = cell());
insert($c,text(my_("Subnet mask")));
insert($t,$c = cell());
insert($c,text(my_("Description")));
insert($t,$c = cell());
insert($c,text(my_("Utilization")));

insert($t,$c = cell());
insert($c,text(my_("Barchart")));

for ($i=0; $i < $maxcnt; $i++) {
    setdefault("cell",array("class"=>color_flip_flop()));

    if (substr(strtolower($arr[$i]["descrip"]),0,4)=="free" or
            substr(strtolower($arr[$i]["descrip"]),0,5)=="spare") {
        $free=1;
        $cntfree++;
    }
    else {
        $free=0;
        // don't display anything if only unassigned is selected
        if ($showused == 2) {
            $cnt++;
            continue;
        }
    }

    // handle beginning of range
    if ($rangeindex) {
        if ($i==0 and $startnum!=$arr[$i]["baseaddr"]) {
            // work out size from start of range
            $newsize=$arr[$i]["baseaddr"]-$startnum;

            //display only subnets with free space between from/to size
            if ($newsize >= $size_from && $newsize <= $size_to) {
                insert($t,$c = cell(array("class"=>"greencell")));
                insert($c,anchor("createsubnetform.php?ipaddr=".$start."&cust=".$cust, 
                            $start));
                insert($t,$c = cell());
                insert($c,text($newsize));
                insert($t,$c = cell());
                insert($t,$c = cell());
                insert($c,text(my_("Free space")));
                insert($t,$c = cell());
                insert($t,$c = cell());
                $width=100;
                insert($c,block("<img height=\"10\" width=\"$width\" src=\"../images/square_green.jpg\">"));
            }

        }
    }

    // only show used space if user asked for it
    // only display subnets between size boundaries
    if (($showused == 1 or $free) and 
            ($arr[$i]["subnetsize"] >= $size_from and $arr[$i]["subnetsize"] <= $size_to)) {

        // exclude free networks from allocated space calculations
        if ($free) {
            $cntfreesubsize += $arr[$i]["subnetsize"];
            insert($t,$c = cell(array("class"=>"greencell")));
            insert($c,anchor("modifybase.php?cust=".$arr[$i]["customer"]."&ipaddr=".
                        inet_ntoa($arr[$i]["baseaddr"]),
                        inet_ntoa($arr[$i]["baseaddr"])));
        }
        else {
            $cntsubsize += $arr[$i]["subnetsize"];
            insert($t,$c = cell());
            if ($arr[$i]["descrip"]==DUPWARN or $arr[$i]["descrip"]==DUPWARNFREE) {
                insert($c,anchor("displaybase.php?cust=$cust&ipaddr=".
                            inet_ntoa($arr[$i]["baseaddr"])."&subnetsize=".$arr[$i]["subnetsize"],
                            inet_ntoa($arr[$i]["baseaddr"])));
            }
            else {
                insert($c,anchor("displaysubnet.php?baseindex=".$arr[$i]["baseindex"], 
                            inet_ntoa($arr[$i]["baseaddr"])));
            }
        }

        if ($arr[$i]["subnetsize"] == 1) {
            insert($t,$c = cell());
            insert($c,text(my_("Host")));
        }
        else {
            insert($t,$c = cell());
            insert($c,text($arr[$i]["subnetsize"]));
        }

        insert($t,$c = cell());
        insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                        $arr[$i]["subnetsize"])."/".inet_bits($arr[$i]["subnetsize"])));

        insert($t,$c = cell());
        // hack to make it more intuitive for ISP's
        if ($free) {
            insert($c,text(my_("Free/Unassigned space")));
        }
        else {
            if ($arr[$i]["descrip"]==DUPWARN) {
                insert($c,span(my_("SPACE IS ASSIGNED OVER MULTIPLE CUSTOMERS/AS's"), 
                            array("class"=>"textError")));
            }
            else if ($arr[$i]["descrip"]==DUPWARNFREE) {
                insert($c,span(my_("SPACE IS ASSIGNED OVER MULTIPLE CUSTOMERS/AS's AND CONTAINS SPACE MARKED FREE"), 
                            array("class"=>"textError")));
            }
            else {
                insert($c,text($arr[$i]["descrip"]));
            }
        }
        // display utilization
        insert($t,$c = cell());
        if ($arr[$i]["subnetsize"] == 1) {
            insert($c,text("1/100%"));
            $used++;
        }
        else {
            insert($c,text(($arr[$i]["cnt"]+2)."/".
                        round(($arr[$i]["cnt"]+2)/$arr[$i]["subnetsize"]*100,2)."%"));
            // add reserved addresses
            $used+=$arr[$i]["cnt"]+2;
        }

        // display barchart
        insert($t,$c = cell());
        if ($arr[$i]["subnetsize"] == 1) {
            $width=100;
            insert($c,block("<img height=\"10\" width=\"$width\" src=\"../images/square_red.jpg\">"));
        }
        else {
            $width=round(($arr[$i]["cnt"]+2)/$arr[$i]["subnetsize"]*100,2);
            $diff=100-$width;
            insert($c,block("<img height=\"10\" width=\"$width\" src=\"../images/square_red.jpg\">"));
            insert($c,block("<img height=\"10\" width=\"$diff\" src=\"../images/square_green.jpg\">"));
        }
    }

    // calculate gaps in address space (ie no space assigned in database)
    if ($i != $maxcnt-1 and 
            $arr[$i]["baseaddr"]+$arr[$i]["subnetsize"] != $arr[$i+1]["baseaddr"] and
            $showused != 2) {
        $newbase=inet_ntoa($arr[$i]["baseaddr"]+$arr[$i]["subnetsize"]);
        $newsize=$arr[$i+1]["baseaddr"]-$arr[$i]["baseaddr"]-$arr[$i]["subnetsize"];

        //display only subnets with free space between from/to size
        if ($newsize >= $size_from && $newsize <= $size_to) {
            insert($t,$c = cell(array("class"=>"greencell")));
            insert($c,anchor("createsubnetform.php?ipaddr=".$newbase.
                        "&cust=".$cust."&size=".$newsize, 
                        $newbase));
            insert($t,$c = cell());
            insert($c,text($newsize));
            insert($t,$c = cell());
            insert($t,$c = cell());
            insert($c,text(my_("Free space")));
            insert($t,$c = cell());
            insert($t,$c = cell());
            $width=100;
            insert($c,block("<img height=\"10\" width=\"$width\" src=\"../images/square_green.jpg\">"));
        }

    }

    $cnt++;

}

// handle end of range
if ($cnt and $showused != 2) {
    if ($endnum!=$arr[$i-1]["baseaddr"]+$arr[$i-1]["subnetsize"]-1) {
        // work out size up to end of range
        $newsize = $endnum+1-$arr[$i-1]["baseaddr"]-$arr[$i-1]["subnetsize"];

        //display only subnets with free space between from/to size
        if ($newsize >= $size_from && $newsize <= $size_to) {
            insert($t,$c = cell(array("class"=>"greencell")));
            insert($c,anchor("createsubnetform.php?ipaddr=".
                        inet_ntoa($arr[$i-1]["baseaddr"]+$arr[$i-1]["subnetsize"]).
                        "&cust=".$cust, 
                        inet_ntoa($arr[$i-1]["baseaddr"]+$arr[$i-1]["subnetsize"])));
            insert($t,$c = cell());
            insert($c,text($newsize));
            insert($t,$c = cell());
            insert($t,$c = cell());
            insert($c,text(my_("Free space")));
            insert($t,$c = cell());
            insert($t,$c = cell());
            $width=100;
            insert($c,block("<img height=\"10\" width=\"$width\" src=\"../images/square_green.jpg\">"));
        }
    }
}

// display totals
if ($showused == 1 and $size_from == 0 and $size_to == MAXSIZE) {
    insert($t,$c = cell());
    insert($c,textb(my_("Total:")));
    insert($t,$c = cell());
    insert($c,textb($endnum-$startnum+1));
    insert($t,$c = cell());
    insert($t,$c = cell());
    insert($t,$c = cell());
    insert($c,textb($used));

    insert($w,block("<p>"));
    insert($w,textb(my_("Total allocated networks/subnets: ")));
    insert($w,textbr($cnt));
    insert($w,textb(my_("Network/subnet space allocated: ")));
    insert($w,textbr(round($cntsubsize/($endnum-$startnum+1)*100, 2)."%"));

    $width=round( $cntsubsize/($endnum-$startnum+1)*100, 2);
    $diff=(100-$width)*5;
    $width=$width*5;
    insert($w,block("<img height=\"10\" width=\"$width\" src=\"../images/square_red.jpg\">"));
    insert($w,block("<img height=\"10\" width=\"$diff\" src=\"../images/square_green.jpg\">"));
    insert($w,textbr(''));
    insert($w,textb(my_("Total unassigned subnets (pre-allocated subnets marked as free): ")));
    insert($w,textbr($cntfree));
    insert($w,textb(my_("Unassigned subnets (pre-allocated subnets marked as free): ")));
    insert($w,textbr(round($cntfreesubsize/($endnum-$startnum+1)*100, 2)."%"));

    $width=round( $cntfreesubsize/($endnum-$startnum+1)*100, 2);
    $diff=(100-$width)*5;
    $width=$width*5;
    insert($w,block("<img height=\"10\" width=\"$width\" src=\"../images/square_red.jpg\">"));
    insert($w,block("<img height=\"10\" width=\"$diff\" src=\"../images/square_green.jpg\">"));
    insert($w,textbr());

    insert($w,textb(my_("IP addresses allocated (including reserved addresses/excluding reserved addresses): ")));
    insert($w,textbr(round($used/($endnum-$startnum+1)*100, 2)."%"."/".
                round(($used-($cnt*2))/($endnum-$startnum+1)*100, 2)."%"   ));

    $width=round($used/($endnum-$startnum+1)*100, 2);
    $diff=(100-$width)*5;
    $width=$width*5;
    insert($w,block("<img height=\"10\" width=\"$width\" src=\"../images/square_red.jpg\">"));
    insert($w,block("<img height=\"10\" width=\"$diff\" src=\"../images/square_green.jpg\">"));

}

/*
if( function_exists('memory_get_usage') ) {
echo memory_get_usage(); // php >=4.3 only
}
*/

printhtml($p);

?>
