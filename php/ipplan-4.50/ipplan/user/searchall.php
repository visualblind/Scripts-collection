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
list($cust, $areaindex, $rangeindex, $block, $field, $day, $month, $year) = myRegister("I:cust I:areaindex I:rangeindex I:block S:field I:day I:month I:year");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

if (strlen($search) < 3) {
   myError($w,$p, my_("You need to enter a longer search criteria."));
}
if ($field != "userinf" and $field != "location" and 
    $field != "telno" and $field != "descrip" and
    $field != "hname" and $field != "template") {
   myError($w,$p, my_("Invalid search field."));
}
if ($day == 0 or $month == 0 or $year == 0) {
   $usedate=FALSE;
}
else {
   if (!checkdate((int)$month, (int)$day, (int)$year)) {
      myError($w,$p, my_("Invalid search date."));
   }
   $usedate=TRUE;
}

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

$addtables="";
if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
   if ($field == "userinf")
      $where="WHERE ipaddr.userinf RLIKE ".$ds->ds->qstr($search);
   else if ($field == "location")
      $where="WHERE ipaddr.location RLIKE ".$ds->ds->qstr($search);
   else if ($field == "telno")
      $where="WHERE ipaddr.telno RLIKE ".$ds->ds->qstr($search);
   else if ($field == "descrip")
      $where="WHERE ipaddr.descrip RLIKE ".$ds->ds->qstr($search);
   else if ($field == "hname")
      $where="WHERE ipaddr.hname RLIKE ".$ds->ds->qstr($search);
   else if ($field == "template") {
      $addtables=", ipaddradd";
      $where="WHERE ipaddr.ipaddr=ipaddradd.ipaddr AND 
                 ipaddradd.info RLIKE ".$ds->ds->qstr($search);
   }
}
else if (DBF_TYPE=="postgres7") {
   if ($field == "userinf")
      $where="WHERE ipaddr.userinf ~ ".$ds->ds->qstr($search);
   else if ($field == "location")
      $where="WHERE ipaddr.location ~ ".$ds->ds->qstr($search);
   else if ($field == "telno")
      $where="WHERE ipaddr.telno ~ ".$ds->ds->qstr($search);
   else if ($field == "descrip")
      $where="WHERE ipaddr.descrip ~ ".$ds->ds->qstr($search);
   else if ($field == "hname")
      $where="WHERE ipaddr.hname ~ ".$ds->ds->qstr($search);
   else if ($field == "template") {
      $addtables=", ipaddradd";
      $where="WHERE ipaddr.ipaddr=ipaddradd.ipaddr AND 
                 ipaddradd.info ~ ".$ds->ds->qstr($search);
   }
}
else {
   if ($field == "userinf")
      $where="WHERE ipaddr.userinf LIKE ".$ds->ds->qstr("%".$search."%");
   else if ($field == "location")
      $where="WHERE ipaddr.location LIKE ".$ds->ds->qstr("%".$search."%");
   else if ($field == "telno")
      $where="WHERE ipaddr.telno LIKE ".$ds->ds->qstr("%".$search."%");
   else if ($field == "descrip")
      $where="WHERE ipaddr.descrip LIKE ".$ds->ds->qstr("%".$search."%");
   else if ($field == "hname")
      $where="WHERE ipaddr.hname LIKE ".$ds->ds->qstr("%".$search."%");
   else if ($field == "template") {
      $addtables=", ipaddradd";
      $where="WHERE ipaddr.ipaddr=ipaddradd.ipaddr AND 
                 ipaddradd.info LIKE ".$ds->ds->qstr("%".$search."%");
   }
}

// add date info if user searched by date
if ($usedate) {
   $where .= " AND ipaddr.lastmod >= ".$ds->ds->DBTimeStamp(mktime(0,0,0,$month,$day,$year));
}

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
else {
    $start=DEFAULTROUTE;
    $end=ALLNETS;
}

$startnum=inet_aton($start);
$endnum=inet_aton($end);

$custdescrip=$ds->GetCustomerDescrip($cust);
// handle "all" customer
if (strtolower($custdescrip) == "all") {
   $cust=0;
}
else {
   $where = $where." AND base.customer=$cust ";
}

if ($areaindex and !$rangeindex) {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between multiple ranges for customer '%s'"), $custdescrip)));
   // NOTE: ipaddr column aliased to baseaddr to make DisplayBlock work
   $result=&$ds->ds->Execute("SELECT ipaddr.userinf, ipaddr.location, 
                             ipaddr.telno, ipaddr.descrip, ipaddr.lastmod,
                             ipaddr.ipaddr AS baseaddr, ipaddr.baseindex, 
                             ipaddr.hname, 
                             customer.custdescrip, customer.customer
                           FROM ipaddr, base, range, customer $addtables
                           $where AND
                             base.customer = customer.customer AND
                             base.baseindex = ipaddr.baseindex AND
                             range.areaindex=$areaindex AND
                             base.baseaddr BETWEEN range.rangeaddr AND 
                                range.rangeaddr+range.rangesize-1 AND
                             range.customer=$cust");

//                           ORDER by
//                              ipaddr.ipaddr"); 

}
else {
   insert($w,heading(3, sprintf(my_("Search for IP subnets between %s and %s %s for customer '%s'"), $start, $end, $site, $custdescrip)));
   // NOTE: ipaddr column aliased to baseaddr to make DisplayBlock work
   // get detail from ipaddr table - could be nothing!
   $result=&$ds->ds->Execute("SELECT ipaddr.userinf, ipaddr.location, 
                             ipaddr.telno, ipaddr.descrip, ipaddr.lastmod,
                             ipaddr.ipaddr AS baseaddr, ipaddr.baseindex,
                             ipaddr.hname, 
                             customer.custdescrip, customer.customer
                           FROM ipaddr, base, customer $addtables
                           $where AND
                             base.customer = customer.customer AND
                             base.baseindex = ipaddr.baseindex AND
                             base.baseaddr BETWEEN $startnum AND $endnum");

//                           ORDER by
//                              ipaddr.ipaddr");  

}
insert($w,textb(sprintf(my_("Search filter on %s: "), $field)));
insert($w,textbr($search));

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
       $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, 
                        "&cust=".$cust.
                        "&search=".urlencode($search)."&field=".$field);
    $totcnt++;
}
insert($w,block("<p>"));

// create a table
insert($w,$t = table(array("cols"=>"6",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
if (!empty($vars))
    insert($c,anchor($vars, "<<"));
insert($c,text(my_("IP address")));
insert($t,$c = cell());
insert($c,text(my_("User")));
insert($t,$c = cell());
insert($c,text(my_("Location")));
insert($t,$c = cell());
insert($c,text(my_("Device description")));
insert($t,$c = cell());
insert($c,text(my_("Telephone Number")));
insert($t,$ck = cell());
insert($ck,text(my_("Last modified")));


$cnt=0;
$prevrow="";
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

   // customer is 0, display all customers with customer description
   // on customer change
   if ($cust == 0 and $row["custdescrip"] != $prevrow) {
       insert($t,$c = cell(array("colspan"=>"6")));

       insert($c,generic("b"));
       insert($c,anchor($_SERVER["PHP_SELF"]."?cust=".$row["customer"]."&areaindex=&rangeindex=&ipaddr=$ipaddr&search=".urlencode($search)."&field=$field",
                        $row["custdescrip"]));
       $prevrow=$row["custdescrip"];
   }

   insert($t,$c = cell());

   insert($c,anchor("modifyipform.php?ip=".$row["baseaddr"].
                    "&baseindex=".$row["baseindex"],
                    inet_ntoa($row["baseaddr"])));
 
   insert($t,$c = cell());

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
       insert($c,anchor("displaybase.php?ipaddr=$lnk&cust=$cust&searchin=1",
                   my_(sprintf("Follow link to %s", $lnk))));
       insert($c,block("</i></small>"));
   }
      
   insert($t,$c = cell());
   insert($c,text($row["location"]));
   insert($t,$c = cell());
   insert($c,text($row["descrip"]));
   if (!empty($row["hname"])) {
       insert($c,textbr());
       insert($c,block("<small><i>"));
       insert($c,text($row["hname"]));
       insert($c,block("</i></small>"));
   }
   insert($t,$c = cell());
   insert($c,text($row["telno"]));
   insert($t,$c = cell());
   insert($c,block("<small>"));
   insert($c,block($result->UserTimeStamp($row["lastmod"], "M d Y H:i:s")));
   insert($c,block("</small>"));

   if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
      break;
   $cnt++;
   $totcnt++;
}

insert($w,block("<p>"));

if (!$cnt) {
   myError($w,$p, my_("Search found no matching entries"));
}

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, 
                        "&cust=".$cust.
                        "&search=".urlencode($search)."&field=".$field);
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

$result->Close();
printhtml($p);

?>
