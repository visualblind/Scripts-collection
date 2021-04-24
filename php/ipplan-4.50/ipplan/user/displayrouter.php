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


// return array containing routing table obtained via SNMP
// array looks like this:
//      a["network"][$i]
//      a["mask"][$i]
function GetRoutingTable($host, $community, $rtrtype) {

   global $w,$p;

   $OID=array("generic"=>".1.3.6.1.2.1.4.21.1.11",
              "riverstone"=>".1.3.6.1.2.1.4.24.4",
              "juniper"=>".1.3.6.1.2.1.4.24.4.1");

   if (!extension_loaded("snmp")) {
       myError($w,$p, "no snmp!!! - compile php with --with-snmp --enable-ucd-snmp-hack");
       exit;
   }

   if (strpos(strtoupper(PHP_OS),'WIN') !== false) {
      // Windows snmp different
   } else {
      // Unix snmp different - need to set quickprint to be compatible
      // with Windows format. Windows does not have long print format
      // must test for os version as undefined function generates error
      // even with @
      snmp_set_quick_print(1);
   }
   // protect against bad users!
   if (!array_key_exists($rtrtype, $OID)) {
       $rtrtype="generic";
   }
   $routes = @snmpwalkoid($host, $community, $OID[$rtrtype]);

   if (!$routes) {
      return 0;
   }

   for (reset($routes); $network = key($routes); next($routes)) {
       //here is the way to do it with RFC 2096 using ipCidrRouteMask
       //this is what we get back from the riverstone
       //meaning:  subnet IP, subnet mask, destination = ip destination ip
       if ($rtrtype=="riverstone") {
           //kill the destination
           list($oc1, $oc2, $oc3, $oc4, $oc5, $rest) = explode(".", strrev($network), 6);
           //take the subnetmask
           list($oc1, $oc2, $oc3, $oc4, $rest) = explode(".", $rest, 5);
           $mask=strrev(sprintf("%s.%s.%s.%s", $oc1, $oc2, $oc3, $oc4));
           //take the subnet addr
           list($oc1, $oc2, $oc3, $oc4, $rest) = explode(".", $rest, 5);
           $netaddr=strrev(sprintf("%s.%s.%s.%s", $oc1, $oc2, $oc3, $oc4));
       }
       else {
           // The Old way to do it with RFC 1213 MIBv2 (which is deprecated)
           // do some magic to obtain a unique, sortable array index to force the results
           // into ip address order. index will be x0000000000 where the digits are the
           // integer representation of the ip address padded with zeros.
           $mask=$routes[$network];
           // strip out last 4 octets from mib value - lots of .'s
           // complicate matters
           list($oc1, $oc2, $oc3, $oc4, $rest) = explode(".", strrev($network), 5);
           $netaddr=strrev(sprintf("%s.%s.%s.%s", $oc1, $oc2, $oc3, $oc4));
       }

       // $ind='x'.str_pad(inet_aton(substr($netaddr, strpos($netaddr, '.')+1)), 10, "0", STR_PAD_LEFT);
       $ind='x'.str_pad(inet_aton($netaddr), 10, "0", STR_PAD_LEFT);
       $result["$ind"]=array(
               "rtrbase"=>$netaddr,
               "rtrmask"=>$mask);
   }

                        //"rtrmask"=>substr($mask, strpos($mask, ' ')+1));
   return $result;
}

require_once("../ipplanlib.php");
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../layout/class.layout");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Display routing table results");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $ipaddr, $community, $rtrtype) = myRegister("I:cust S:ipaddr S:community S:rtrtype");

if (!$_POST) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

$startnum=inet_aton(DEFAULTROUTE);
$endnum=inet_aton(ALLNETS);

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if (testIP($ipaddr)) {
   myError($w,$p, my_("Invalid IP address"));
}
// get snmp info
if (!$resultsnmp = GetRoutingTable($ipaddr, $community, $rtrtype)) {
   myError($w,$p, my_("Could not query router - no SNMP on router or firewall blocking access?"));
}

$custdescrip=$ds->GetCustomerDescrip($cust);

insert($w,heading(3, sprintf(my_("Search for IP subnets from a routing table for customer '%s'"), $custdescrip)));

// get database info
$result = $ds->GetBase($startnum, $endnum, $descrip, $cust);

// rewrite arrays for sorting and merging to work - use ip address
// as key in this format "x0000012345"
$dbf=array();
while ($row = $result->FetchRow()) {
   $ind='x'.str_pad($row["baseaddr"], 10, "0", STR_PAD_LEFT);
   $dbf["$ind"]=array("dbfbase"=>inet_ntoa($row["baseaddr"]),
                              "dbfsize"=>$row["subnetsize"],
                              "baseindex"=>$row["baseindex"],
                              "dbfdescrip"=>$row["descrip"]);
}

// do the merge
$arr=array_merge_recursive($resultsnmp, $dbf);
ksort($arr);

// create a table
insert($w,$t = table(array("cols"=>"7",
                           "class"=>"outputtable")));
 
// create a table
setdefault("cell",array("class"=>"heading"));
insert($t,$ct = cell(array("colspan"=>"3")));
insert($ct,block("<center>"));
insert($ct,text(my_("Routing Table")));
insert($ct,block("</center>"));
insert($t,$ct = cell(array("colspan"=>"4")));
insert($ct,block("<center>"));
insert($ct,text(my_("IPplan information")));
insert($ct,block("</center>"));
 
// draw heading
insert($t,$c = cell());
insert($c,text(my_("Routing Table Base address")));
insert($t,$c = cell());
insert($c,text(my_("Routing Table Subnet size")));
insert($t,$c = cell());
insert($c,text(my_("Routing Table Subnet Mask")));
insert($t,$c = cell());
insert($c,text(my_("Base address")));
insert($t,$c = cell());
insert($c,text(my_("Subnet size")));
insert($t,$c = cell());
insert($c,text(my_("Subnet Mask")));
insert($t,$c = cell());
insert($c,text(my_("Description")));

 
$cnt=0;
while (list ($key, $val) = each ($arr)) {

    setdefault("cell",array("class"=>color_flip_flop()));

    $hosts=inet_aton(ALLNETS)-inet_aton($val["rtrmask"])+1;
    if ($val["rtrbase"] == DEFAULTROUTE) {
       insert($t,$c = cell(array("colspan"=>"3")));
       insert($c,text("Default route"));
       insert($t,$c = cell(array("colspan"=>"4")));
       continue;
    }
    insert($t,$c = cell());
    insert($c,anchor("createsubnetform.php?ipaddr=".$val["rtrbase"].
                     "&cust=".$cust."&size=".$hosts, $val["rtrbase"]));

    insert($t,$c = cell());
    if ($val["rtrmask"]) {
       if ($hosts == 1)
          insert($c,text(my_("Host")));
       else {
          insert($c,text($hosts));
       }
    }

    insert($t,$c = cell());
    if ($val["rtrmask"]) {
       insert($c,text($val["rtrmask"]."/".inet_bits(inet_aton(ALLNETS)-inet_aton($val["rtrmask"])+1)));
    }

    insert($t,$c = cell());
    if ($val["dbfsize"] == 1) {
       insert($c,text($val["dbfbase"]));
    }
    else {
       insert($c,anchor("displaysubnet.php?baseindex=".$val["baseindex"], 
                        $val["dbfbase"]));
    }
    insert($t,$c = cell());
    if ($val["dbfsize"] == 1)
       insert($c,text(my_("Host")));
    else
       insert($c,text($val["dbfsize"]));
    insert($t,$c = cell());
    if ($val["dbfsize"])
       insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1-$val["dbfsize"])."/".inet_bits($val["dbfsize"])));
    insert($t,$c = cell());
    insert($c,text($val["dbfdescrip"]));

    $cnt++;
}

insert($w,block("<p>"));
insert($w,textb(sprintf(my_("Total records: %u"), $cnt)));

$result->Close();
printhtml($p);

?>
