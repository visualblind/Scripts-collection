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

// maximum number of outstanding IP address requests allowed - this is to prevent
// denial of service on the database as this feature is not authenticated
define("MAXREQUESTS", "100");

// disable or enable drop down menu on request page - default disabled
define("MENU", FALSE);

if (!REQUESTENABLED) {
    die("IP address request system has been disabled by the administrator.");
}

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

// explicitly cast variables as security measure against SQL injection
list($cust, $request, $user, $location, $descrip, $hname, $telno, $macaddr) = myRegister("I:cust S:request S:user S:location S:descrip S:hname S:telno S:macaddr");
$formerror="";

$title=my_("Request an IP address");

newhtml($p);
$w=myheading($p, $title, MENU);

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {

    $request=trim($request);
    $descrip=trim($descrip);

    if (strlen($request) == 0) {
        $formerror .= my_("You need to enter request details for the ip address request")."\n";
    }
    if (strlen($user) == 0) {
        $formerror .= my_("You need to enter user details for the request")."\n";
    }
    if (strlen($location) == 0) {
        $formerror .= my_("You need to enter location details for the request")."\n";
    }
    if (strlen($descrip) == 0) {
        $formerror .= my_("You need to enter description details for the request")."\n";
    }
    if (strlen($telno) == 0) {
        $formerror .= my_("You need to enter a telephone number for the request")."\n";
    }
    // check if mac address is valid - all or nothing!
    if (!empty($macaddr)) {
        $newmacaddr=str_replace(array(":", "-", " "), "", $macaddr);
        if (strlen($newmacaddr)==12 and
                preg_match("/[a-f0-9A-F]/", $newmacaddr)) {
        }
        else {
            $formerror .= sprintf(my_("Invalid MAC address: %s"), $macaddr)."\n";
        }
    }


    // use base template (for additional subnet information)
    $template=NULL;
    if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml")) {
        $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml");
    }

    $info="";
    if (is_object($template) and $template->is_error() == FALSE) {
        // PROBLEM HERE: if template create suddenly returns error (template file
        // permissions, xml error etc), then each submit thereafter will erase
        // previous contents - this is not good
        $template->Merge($userfld);
        if($err=$template->Verify($w)) {
            $formerror .= my_("Additional information error")."\n";
        }

        if ($template->is_blank() == FALSE) {
            $info=$template->encode();
        }
    }

    $recs=$ds->ds->GetOne("SELECT count(*) AS cnt
                           FROM requestip");
    if ($recs > MAXREQUESTS) {
            $formerror .= my_("Maximum number of outstanding IP requests exceeded")."\n";
    }

    if (!$formerror) {

        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("INSERT INTO requestip
                (customer, requestdesc, userinf, location, descrip,
                 hname, telno, macaddr, info)
                VALUES
                ($cust,
                 ".$ds->ds->qstr($request).",
                 ".$ds->ds->qstr($user).",
                 ".$ds->ds->qstr($location).",
                 ".$ds->ds->qstr($descrip).",
                 ".$ds->ds->qstr($hname).",
                 ".$ds->ds->qstr($telno).",
                 ".$ds->ds->qstr($newmacaddr).",
                 ".$ds->ds->qstr($info).")") and
                $ds->AuditLog(array("event"=>200, "action"=>"request ip", 
                            "descrip"=>$descrip, "user"=>$_SERVER[AUTH_VAR], "userinf"=>$user,
                            "location"=>$location, "hname"=>$hname, "telno"=>$telno, 
                            "macaddr"=>$macaddr));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,textbr(my_("IP address request created")));

            $custdescrip=$ds->GetCustomerDescrip($cust);

            //Send email notification that IP Request was entered 
            require("../class.phpmailer.php");
            $mail = new PHPMailer();
            $mail->IsSMTP(); // telling the class to use SMTP
            $mail->SetLanguage("en", "../");
            $mail->Host = EMAILSERVER; // SMTP server
            $mail->From = HELPDESKEMAIL;
            $mail->IsHTML(false);
            $mail->FromName = "IP Plan";
            $mail->AddAddress(HELPDESKEMAIL);
            $mail->Subject = "IP Request Submittal";
            $mail->Body= "The following IP address request has been submitted and needs to be actioned.\n\n";
            $mail->Body.= "IP Request Details\n\n";
            $mail->Body.="Customer: $custdescrip\n";
            $mail->Body.="Request Details: $request\n";
            $mail->Body.="User information: $user\n";
            $mail->Body.="Location: $location\n";
            $mail->Body.="Description: $descrip\n";
            $mail->Body.="Host Name: $hname\n";
            $mail->Body.="MAC Address: $macaddr\n\n";

            $template=NULL;
            $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml");

            if (is_object($template) and $template->is_error() == FALSE) {
                if (isset($userfld)) {
                    $template->Merge($userfld);
                }
                foreach ($template->userfld as $value) {
                    $mail->Body.=sprintf("%s: %s\n", $value["descrip"], $value["value"]);
                }
            }

            if(!@$mail->Send()) {
                $formerror .= my_("E-mail message was not sent")."\n";
                $formerror .= my_("Mailer Error: ") . $mail->ErrorInfo;
            }
            else {
                insert($w,textbr(my_("IP request E-mail message sent")));
            }

        }
        else {
            $ds->DbfTransactionRollback();
            $formerror .= my_("Request could not be created - possibly a duplicate request")."\n";
        }
    }
}

myError($w,$p, $formerror, FALSE);
 
// display opening text
insert($w,heading(3, "$title."));

insert($w,textbrbr(my_("Complete the details below to request an IP address. An administrator will need to action the request before an address will be allocated.")));

// create list of customers to display based on REQUESTCUST variable
$sql = "";
$lst = split(",", REQUESTCUST);
if (REQUESTCUST != "" and !empty($lst)) {
    foreach ($lst as $value) {
        $i=(int)$value;  // force to int
        $sql.="$i,";
    }
    $sql=substr($sql, 0, -1);
    $sql=" customer IN ($sql) ";
}

$result=$ds->GetCustomer($sql);
$lst=array();
$custset=0;
while($row = $result->FetchRow()) {
   if (strtolower($row["custdescrip"])=="all")
      continue;

   // strip out customers user may not see due to not being member
   // of customers admin group. $grps array could be empty if anonymous
   // access is allowed!
   if(!empty($grps)) {
      if(!in_array($row["admingrp"], $grps))
         continue;
   }

   $col=$row["customer"];
   // make customer first customer in database
   if (!$cust) {
      $cust=$col;
      $custset=1;    // remember that customer was blank
   }
   // only make customer same as cookie if customer actually
   // still exists in database, else will cause loop!
   if ($custset) {
       if ($col == $ipplanCustomer) {
           // dont trust cookie
           $cust=floor($ipplanCustomer);
       }
   }
   $lst["$col"]=$row["custdescrip"];
}

insert($w, $f = form(array("name"=>"ENTRY",
                            "method"=>"post",
                            "action"=>$_SERVER["PHP_SELF"])));

myFocus($p, "MODIFY", "request");
insert($f,textbrbr(my_("Customer")));
insert($f,selectbox($lst,
                 array("name"=>"cust"),
                 $cust));

insert($f,textbrbr(my_("Request details")));
insert($f,span(my_("Enter full details describing the request to enable the administrators to allocate the correct IP address on the network"), array("class"=>"textSmall")));
insert($f,input_text(array("name"=>"request",
                           "value"=>$request,
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("User information")));
insert($con,textbr(my_("User")));
insert($con,input_text(array("name"=>"user",
                           "value"=>$user,
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,textbrbr(my_("Location")));
insert($con,input_text(array("name"=>"location",
                           "value"=>$location,
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,textbrbr(my_("Device description")));
insert($con,input_text(array("name"=>"descrip",
                           "value"=>$descrip,
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,textbrbr(my_("Device hostname")));
insert($con,input_text(array("name"=>"hname",
                           "value"=>$hname,
                           "size"=>"80",
                           "maxlength"=>"100")));
insert($con,textbrbr(my_("Telephone number")));
insert($con,input_text(array("name"=>"telno",
                           "value"=>$telno,
                           "size"=>"15",
                           "maxlength"=>"15")));
insert($con,textbrbr(my_("MAC address")));
insert($con,input_text(array("name"=>"macaddr",
                           "value"=>$macaddr,
                           "size"=>"17",
                           "maxlength"=>"17")));

$template=NULL;
$template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml");

if (is_object($template) and $template->is_error() == FALSE) {
    //insert($f,block("<hr>"));
    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Additional information")));

    //insert($f,textbr(my_("Additional information"), array("b"=>1)));

    if (isset($userfld)) {
        $template->Merge($userfld);
    }
    $template->DisplayTemplate($con);
}


insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
