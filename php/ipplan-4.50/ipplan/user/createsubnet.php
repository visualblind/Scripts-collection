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

// save the last customer used
// must set path else Netscape gets confused!
setcookie("ipplanCustomer","$cust",time() + 10000000, "/");
setcookie("ipplanGroup","$admingrp",time() + 10000000, "/");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Create subnet results");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($cust, $admingrp, $ipaddr, $num, $descrip, $size, $addhostinfo, $addnmapinfo, $dhcp, $findfree) = myRegister("I:cust S:admingrp S:ipaddr I:num S:descrip I:size I:addhostinfo I:addnmapinfo I:dhcp S:findfree");
list($userfld) = myRegister("A:userfld");  // for template fields

$descrip=trim($descrip);

// must only check once - might need to create multiple nets
$nodescrip=0;
if (strlen($descrip) == 0) {
   $nodescrip=1;
}
if ($num <1 or $num > 255) {
   myError($w,$p, my_("Number of subnets to create is out of bounds."));
}

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// error checks
if (!$ipaddr)
   myError($w,$p, my_("IP address may not be blank"));
else if (testIP($ipaddr))
   myError($w,$p, my_("Invalid IP address"));
else if (!$size)
   myError($w,$p, my_("Size may not be zero"));
elseif ($size > 1) {
   if (TestBaseAddr(inet_aton3($ipaddr), $size)) {
      myError($w,$p, my_("Invalid base address!"));
   }
}

// use base template (for additional subnet information)
$template=NULL;
if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml")) {
    $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml");
}

$info="";
if (is_object($template) and $template->is_error() == FALSE) {
    // PROBLEM HERE: if template create suddenly returns error (template file
    // permissions, xml error etc), then each submit thereafter will erase
    // previous contents - this is not good
    $template->Merge($userfld);
    $err=$template->Verify($w);

    if ($template->is_blank() == FALSE) {
        $info=$template->encode();
    }
}

if ($err) {
    printhtml($p);
    exit;
}

if ($addhostinfo) {
   // increase time limit for scans - will have no effect in safe mode is on
   @set_time_limit(90);
}

$warn=0;
for ($i=1; $i <= $num; $i++) {
    // work out new base for each iteration of loop
    $base=inet_aton($ipaddr)+(($i-1)*$size);
    // create description if none
    if ($nodescrip) {
        $descrip="NET-".str_replace(".", "-", inet_ntoa($base));
    }

    // test if subnet to create is within bounds
    foreach ($grps as $value) {
        if ($extst = $ds->TestBounds($base, $size, $value)) {
            // got an overlap, allowed to create
            break;
        }
    }
    // could not find new subnet within any of the defined bounds
    // so do not create
    if (!$extst) {
        $warn=1;
        myError($w,$p, sprintf(my_("Subnet %s not created - out of defined authority boundary"), inet_ntoa($base))."\n", FALSE);
        continue;
    }

    $restemp=$ds->GetDuplicateSubnet($base, $size, $cust);
    if ($restemp->FetchRow()) {
        $warn=1;
        myError($w,$p, sprintf(my_("Subnet %s could not be created - possibly overlaps with an existing subnet"), inet_ntoa($base))."\n", FALSE);
    }
    else {

        // find subnets from other customers that overlap
        $result=$ds->GetDuplicateSubnetAll($base, $size, $grps);
        if ($row=$result->FetchRow()) {
            $warn=1;
            insert($w,textb(my_("WARNING: ")));
            insert($w,text(sprintf(my_("Subnet %s overlaps with the following subnets from other customers.  This may not be a problem as the subnet may occur in both customers routing tables:"),inet_ntoa($base))));
            insert($w,block("<p>"));

            // create a table
            insert($w,$t = table(array("cols"=>"3",
                            "class"=>"outputtable")));
            // draw heading
            setdefault("cell",array("class"=>"heading"));
            insert($t,$c = cell());
            insert($c,text(my_("Base address")));
            insert($t,$c = cell());
            insert($c,text(my_("Subnet description")));
            insert($t,$c = cell());
            insert($c,text(my_("Customer")));


            do {
                setdefault("cell",array("class"=>color_flip_flop()));

                insert($t,$c = cell());
                insert($c,text(inet_ntoa($row["baseaddr"])));

                insert($t,$c = cell());
                insert($c,text($row["descrip"]));

                insert($t,$c = cell());
                insert($c,text($row["custdescrip"]));
            } while($row = $result->FetchRow());

            setdefault("cell", "");
            insert($w,block("<p>"));
        }

        // check if user belongs to customer admin group
        $result=$ds->GetCustomerGrp($cust);
        // can only be one row - does not matter if nothing is 
        // found as array search will return false
        $row = $result->FetchRow();
        if (!in_array($row["admingrp"], $grps)) {
            myError($w,$p, my_("You may not create a subnet for this customer as you are not a member of the customers admin group"));
        }

        $ds->DbfTransactionStart();
        // use the first group user belongs to create subnet
        if ($id = $ds->CreateSubnet($base, $size, $descrip, $cust, $dhcp, $admingrp)) {
            $ds->AuditLog(array("event"=>170, "action"=>"create subnet", 
                    "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>inet_ntoa($base),
                    "size"=>$size, "cust"=>$cust));

            insert($w,text(sprintf(my_("Subnet %s created"), inet_ntoa($base))));

            // fill new subnet with nmap
            if (NMAP != "" and $addnmapinfo and $size >= 4 and $size <= 1024) {
                if (ProcessNmap($ds, $base, $id, $size)) {
                    insert($w,textbr());
                    myError($w,$p, my_("NMAP data not in XML format or XML not available"), FALSE);
                }
            }
            // fill new subnet with DNS info
            else if ($addhostinfo and $size > 0) {
                // remember to skip broadcast and network addresses!
                for ($i=1; $i < $size-1; $i++) {
                    $hname=gethostbyaddr(inet_ntoa($base+$i));
                    if ($hname != inet_ntoa($base+$i))
                        $ds->AddIP($base+$i, $id, "", "", "", "", "", $hname, "");
                }
            }

            if (!empty($info)) {
                $result = &$ds->ds->Execute("INSERT INTO baseadd
                        (info, baseindex)
                        VALUES
                        (".$ds->ds->qstr($info).", $id)");
            }

            $ds->DbfTransactionEnd();

            insert($w,textbr());
        }
        else {
            myError($w,$p, sprintf(my_("Subnet %s could not be created"), inet_ntoa($base)));
        }

    }
} // end of for loop for multiple subnet creation

// add link if script was called from findfree
// only if all subnets created without error or warning
if (!$warn and $findfree) {
    // $findfree contains HTTP_REFERER which is a full URI already - OK
    header("Location: ".base64_decode($findfree));
    exit;
}
if (!$warn and $num==1) {
    header("Location: ".location_uri("displaybase.php?cust=$cust&ipaddr=$ipaddr"));
    exit;
}

printhtml($p);

// $base=baseaddr of subnet, $id=baseindex
function ProcessNmap($ds, $base, $id, $size) {

   global $addhostinfo;

   $resarr=array();

   if ($addhostinfo)
      $command=NMAP." -sP ".escapeshellarg(inet_ntoa($base)."/".inet_bits($size))." -oX -";
   else
      $command=NMAP." -n -sP ".escapeshellarg(inet_ntoa($base)."/".inet_bits($size))." -oX -";

   exec($command, $resarr, $retval);
   // did NMAP fail due to safe mode or other error?
   if ($retval) { 
       return 1;
   }
   else { // no error
       require_once("../xmllib.php");

       $input = implode("",$resarr);
       // nmap parser always returns arrays for tags of form
       // [tagname][0...x][element]
       // array index will mostly be zero if one as most results
       // return 1 tag
       $xml_parser = new xmlnmap("HOST");
       if (!$xml_parser->parser) {
           return 1;  // XML parser failure - probably not compiled in
       }
       $output=$xml_parser->parse($input);
       if (!$output) {
           return 1;  // not XML format
       }

       foreach ($output as $value) {
           if ($value["STATUS"][0]["STATE"]=="up") {
               // need to loop through ADDR array here! Check that 
               // ["ADDRESS"][0]["ADDRTYPE"]=="ipv4" or 
               // ["ADDRESS"][0]["ADDRTYPE"]=="mac"
               $newbase=inet_aton($value["ADDRESS"][0]["ADDR"]);
               $newmac="";
               if ($value["ADDRESS"][1]["ADDRTYPE"]=="mac") {
                   $newmac=str_replace(array(":", "-", " "), "", $value["ADDRESS"][1]["ADDR"]);
               }
               if(empty($value["OSMATCH"][0]["NAME"])) {
                   $newuser="";
               }
               else {
                   $newuser=$value["OSMATCH"][0]["NAME"];
               }
               $newdescrip="active";
               if(!empty($value["HOSTNAME"][0]["NAME"])) {
                   $newhname=$value["HOSTNAME"][0]["NAME"];
               }
               else {
                   $newhname="";
               }

               // check within range of subnet before adding to ignore
               // broadcast and network addresses
               if ($newbase > $base and $newbase < $base+$size-1) {
                   $ds->AddIP($newbase, $id, $newuser, "", "", $newmac, $newdescrip, $newhname, "");
                   // address was polled? So add polled status
                   $ds->UpdateIPPoll($id, $newbase);
               }
           }
       }

       return 0;
   }

}
?>
