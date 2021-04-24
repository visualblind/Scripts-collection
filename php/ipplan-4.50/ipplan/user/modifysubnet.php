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
// Changed - Begin [FE]
require_once("../class.templib.php");
// Changed - End [FE]


$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Modify/Copy/Move subnet details");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($baseindex, $cust, $descrip, $grp, $origcust, $dhcp) = myRegister("I:baseindex I:cust S:descrip S:grp S:origcust I:dhcp");
// additional vars for Location: header
list($areaindex, $rangeindex, $search, $ipaddr) = myRegister("I:areaindex I:rangeindex S:search S:ipaddr");
list($userfld) = myRegister("A:userfld");  // for template fields

$formerror="";

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// remember original customer
if (!$origcust) {
   $origcust=$cust;
}

if ($_POST) {

    // check if user belongs to customer admin group
    $result=$ds->GetCustomerGrp($cust);
    // can only be one row - does not matter if nothing is 
    // found as array search will return false
    $row = $result->FetchRow();
    if (!in_array($row["admingrp"], $grps)) {
        myError($w,$p, my_("You may not modify this subnet for this customer as you are not a member of the new customers admin group"));
    } 

    $descrip=trim($descrip);

    if (strlen($descrip) == 0) {
        $formerror .= my_("You need to enter a description for the subnet")."\n";
    } 

    if (!$formerror) {
        $userid=$_SERVER[AUTH_VAR];

        // move or duplicate the subnet to another customer
        if ($origcust and $origcust!=$cust) {
            // check if user belongs to customer admin group
            $result=$ds->GetCustomerGrp($origcust);
            // can only be one row - does not matter if nothing is 
            // found as array search will return false
            $row = $result->FetchRow();
            if (!in_array($row["admingrp"], $grps)) {
                myError($w,$p, my_("You may not move this subnet for this customer as you are not a member of the original customers admin group"));
            } 

            // did somebody else whack the subnet in the meantime?
            $result=$ds->GetBaseFromIndex($baseindex);
            if (!$row = $result->FetchRow()) {
                myError($w,$p, my_("Subnet cannot be found!"));
            }
            $size=$row["subnetsize"];
            $base=$row["baseaddr"];
            $baseip=inet_ntoa($row["baseaddr"]);

            // test if subnet to delete is within bounds
            foreach ($grps as $value) {
                if ($extst = $ds->TestBounds($base, $size, $value)) {
                    // got an overlap, allowed to create
                    break;
                } 
            }
            // could not find new subnet within any of the defined bounds
            // so do not create
            if (!$extst) { 
                myError($w,$p,sprintf(my_("Subnet %s not modified - out of defined authority boundary"), $baseip)."\n");
            }

            $restemp=$ds->GetDuplicateSubnet($base, $size, $cust);
            if ($restemp->FetchRow()) {
                $formerror .= my_("Subnet could not be created - possibly overlaps with an existing subnet on new customers network")."\n";
            }
            else {
                $ds->DbfTransactionStart();

                // move the subnet to another customer, template will move with as relation
                // between base and baseadd is baseindex column
                if ($duplicatesubnet==0) {
                    $result=&$ds->ds->Execute("UPDATE base
                            SET descrip=".$ds->ds->qstr($descrip).",
                            admingrp=".$ds->ds->qstr($grp).",
                            customer=$cust,
                            lastmod=".$ds->ds->DBTimeStamp(time()).",
                            userid=".$ds->ds->qstr($userid)."
                            WHERE baseindex=$baseindex");
                    
                    $ds->AuditLog(array("event"=>174, "action"=>"move subnet", 
                                "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>inet_ntoa($base),
                                "size"=>$size, "newcust"=>$cust));
                }
                // duplicate the subnet to another customer
                else {
                    // use the first group user belongs to create subnet
                    if ($id = $ds->CreateSubnet($base, $size, $descrip, $cust, 0, $grp)) {

                        if ($duplicatesubnet==1) {
                            // subnet created, now move info to new subnet
                            // cant use a temp table here as database does not
                            // have enough rights - don't want to give it anymore
                            // anyway, so we need to do it the hard way
                            $result=$ds->GetSubnetDetails($baseindex);
                            while($row = $result->FetchRow()) {
                                $tempipaddr=$row["ipaddr"];
                                $tempuser=$row["userinf"];
                                $templocation=$row["location"];
                                $temptelno=$row["telno"];
                                $tempdescrip=$row["descrip"];
                                $templastmod=$row["lastmod"];
                                $tempuserid=$row["userid"];
                                $tempresult=&$ds->ds->Execute("INSERT INTO ipaddr
                                        (ipaddr, userinf, location, telno,
                                         descrip, lastmod, userid, baseindex)
                                        VALUES
                                        (".$ds->ds->qstr($tempipaddr).",
                                         ".$ds->ds->qstr($tempuser).",
                                         ".$ds->ds->qstr($templocation).",
                                         ".$ds->ds->qstr($temptelno).",
                                         ".$ds->ds->qstr($tempdescrip).",
                                         $templastmod,
                                         ".$ds->ds->qstr($tempuserid).",
                                         $id)");
                            } // end while
                        }
                        $ds->AuditLog(array("event"=>170, "action"=>"create subnet", 
                                    "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>inet_ntoa($base),
                                    "size"=>$size, "cust"=>$cust));
                    }
                }
            }
        }
        // just update the description
        else {
            // did somebody else whack the subnet in the meantime?
            $result=$ds->GetBaseFromIndex($baseindex);
            if (!$row = $result->FetchRow()) {
                myError($w,$p, my_("Subnet cannot be found!"));
            }
            $size=$row["subnetsize"];
            $base=$row["baseaddr"];
            $baseip=inet_ntoa($row["baseaddr"]);

            // test if subnet to update is within bounds
            foreach ($grps as $value) {
                if ($extst = $ds->TestBounds($base, $size, $value)) {
                    // got an overlap, allowed to create
                    break;
                } 
            }
            // could not find new subnet within any of the defined bounds
            // so do not create
            if (!$extst) { 
                myError($w,$p,sprintf(my_("Subnet %s not modified - out of defined authority boundary"), $baseip)."\n");
            }

            $ds->DbfTransactionStart();
            $result=&$ds->ds->Execute("UPDATE base
                    SET descrip=".$ds->ds->qstr($descrip).",
                    admingrp=".$ds->ds->qstr($grp).",
                    lastmod=".$ds->ds->DBTimeStamp(time()).",
                    baseopt=$dhcp,
                    userid=".$ds->ds->qstr($userid)."
                    WHERE baseindex=$baseindex") and
                $ds->AuditLog(array("event"=>171, "action"=>"modify subnet", 
                            "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "baseaddr"=>inet_ntoa($base),
                            "size"=>$size, "cust"=>$cust));

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

            if($ds->ds->GetRow("SELECT baseindex
                        FROM baseadd
                        WHERE baseindex=$baseindex")) {   // should have FOR UPDATE here!
                $result = &$ds->ds->Execute("UPDATE baseadd
                        SET info=".$ds->ds->qstr($info)."
                        WHERE baseindex=$baseindex");
            // this generates a "duplicate key" error if no update
            // should be OK under normal circumstances, but generates error under
            // debug mode turned on
        }
            else {
                if (!empty($info)) {
                    $result = &$ds->ds->Execute("INSERT INTO baseadd
                            (info, baseindex)
                            VALUES
                            (".$ds->ds->qstr($info).", $baseindex)");
                }
            }

        } // end of modify subnet

        if (!$err and !$formerror and $result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Subnet modified")));
            // go back to modifybase table display
            header("Location: ".location_uri("modifybase.php?baseindex=".$baseindex.
                     "&areaindex=".$areaindex."&rangeindex=".$rangeindex.
                     "&cust=".$cust."&descrip=".urlencode($search)."&ipaddr=".urlencode($ipaddr)));
        }
        else
            $formerror .= my_("Subnet could not be modified")."\n";
    }
}

if (!$_POST || $formerror) {
    myError($w,$p, $formerror, FALSE);

    $result=$ds->GetBaseFromIndex($baseindex);
    if (!$row = $result->FetchRow()) {
       myError($w,$p, my_("Subnet cannot be found!"));
    }
    $size=$row["subnetsize"];
    $baseaddr=$row["baseaddr"];
    $baseip=inet_ntoa($row["baseaddr"]);
    $dhcp=$row["baseopt"] & 1;

    insert($w,block("<h3>"));
    insert($w,text(my_("Subnet:")." ".
                inet_ntoa($baseaddr)." ".my_("Mask:")." ".
                inet_ntoa(inet_aton(ALLNETS)+1 -
                    $size)."/".inet_bits($size)));
    insert($w,textbr());
    insert($w,text(my_("Description:")." ".$row["descrip"]));
    insert($w,block("</h3>"));

    // start form
    insert($w, $f1 = form(array("name"=>"THISFORM",
                    "method"=>"get",
                    "action"=>$_SERVER["PHP_SELF"])));

    $cust=myCustomerDropDown($ds, $f1, $cust, $grps) or myError($w,$p, my_("No customers"));

    insert($f1,hidden(array("name"=>"descrip",
                    "value"=>"$descrip")));
    insert($f1,hidden(array("name"=>"search",
                    "value"=>"$search")));
    insert($f1,hidden(array("name"=>"ipaddr",
                    "value"=>"$ipaddr")));
    insert($f1,hidden(array("name"=>"areaindex",
                    "value"=>"$areaindex")));
    insert($f1,hidden(array("name"=>"rangeindex",
                    "value"=>"$rangeindex")));
    insert($f1,hidden(array("name"=>"baseindex",
                    "value"=>"$baseindex")));
    insert($f1,hidden(array("name"=>"grp",
                    "value"=>"$grp")));
    insert($f1,hidden(array("name"=>"origcust",
                    "value"=>"$origcust")));

    $result=$ds->GetGrps();

    $lst=array();
    while($row = $result->FetchRow()) {
        $col=$row["grp"];
        $lst["$col"]=$row["grpdescrip"];
    }
    if (empty($lst)) {
        myError($w,$p, my_("You first need to create some groups!"));
    }

    // start form
    insert($w, $f = form(array("method"=>"post",
                    "action"=>$_SERVER["PHP_SELF"])));

    if ($origcust and $origcust != $cust) {
        insert($f,radio(array("name"=>"duplicatesubnet",
                        "value"=>"0"),
                    my_("Move subnet to new customer"), "checked"));
        insert($f,radio(array("name"=>"duplicatesubnet",
                        "value"=>"1"),
                    my_("Duplicate subnet on new customer")));
        insert($f,radio(array("name"=>"duplicatesubnet",
                        "value"=>"2"),
                    my_("Duplicate subnet on new customer without IP detail")));
        insert($f,generic("br"));
    }

    insert($f,textbrbr(my_("Subnet description")));
    insert($f,input_text(array("name"=>"descrip",
                    "value"=>"$descrip",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($f,generic("br"));
    insert($f,checkbox(array("name"=>"dhcp",
                         "value"=>"1"),
                         my_("Is this a DHCP subnet?"), $dhcp));
    insert($f,generic("br"));

    insert($f,hidden(array("name"=>"baseindex",
                    "value"=>"$baseindex")));
    insert($f,hidden(array("name"=>"cust",
                    "value"=>"$cust")));
    insert($f,hidden(array("name"=>"search",
                    "value"=>"$search")));
    insert($f,hidden(array("name"=>"ipaddr",
                    "value"=>"$ipaddr")));
    insert($f,hidden(array("name"=>"areaindex",
                    "value"=>"$areaindex")));
    insert($f,hidden(array("name"=>"rangeindex",
                    "value"=>"$rangeindex")));
    insert($f,hidden(array("name"=>"origcust",
                    "value"=>"$origcust")));

    insert($f,textbrbr(my_("Admin Group")));
    insert($f,textbr(my_("WARNING: If you choose a group that you do not have access to, you will not be able to see or access the data")));
    insert($f,selectbox($lst,
                array("name"=>"grp"),
                $grp));

    // Changed - Begin [FE]

    // Requires new default template: basetemplate.xml
    // Start of template support [FE]

    $result=&$ds->ds->Execute("SELECT info, infobin
            FROM baseadd
            WHERE baseindex=$baseindex");

    $rowadd = $result->FetchRow();
    $dbfinfo=$rowadd["info"];

    // use base template (for additional subnet information)
    if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml")) {
        $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/basetemplate.xml");
    }

    if (is_object($template) and $template->is_error() == FALSE) {
        insert($f, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text(my_("Additional information")));

        $template->Merge($template->decode($dbfinfo));
        $template->DisplayTemplate($con);
    }
    // Changed - End [FE]	

    insert($f,generic("br"));
    insert($f,submit(array("value"=>my_("Submit"))));
    insert($f,freset(array("value"=>my_("Clear"))));
}

printhtml($p);

?>
