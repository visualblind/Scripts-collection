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

require_once("../xmllib.php");
require_once("../class.templib.php");

// function to generate swip entry - returns a string with swip
// which can then be displayed/emailed etc
function genSWIP($ds, $baseindex, $start, $end, $cust, $descrip, $filename) {

    global $ntnameopt;

    //************ now process customer standard fields ************//

    $result1=&$ds->ds->Execute("SELECT *
            FROM custinfo
            WHERE customer=$cust");
    // should only be one row here, none if SWIP turned off during creation
    // of customer
    $row1=$result1->FetchRow();

    $result2=&$ds->ds->Execute("SELECT hname, ipaddr
            FROM revdns
            WHERE customer=$cust
            ORDER BY horder");

    $fields=array();
    $fields["ntsnum"]=$start;
    $fields["ntenum"]=$end;
    $fields=array_merge($fields, $row1);

    // use subnet description field? then only a-z, 0-9 max 21 chars allowed
    if ($ntnameopt and preg_match("/^[A-Za-z0-9\-]{1,21}$/", $descrip)) {
        $ntname=$descrip;
    }
    else {
        $ntname=MAINTAINERID."-".str_replace(".", "-", $start);
    }
    $fields["ntname"]=$ntname;
    $fields["maint"]=MAINTAINERID;

    if($row2 = $result2->FetchRow()) {
        $fields["hname1"]=$row2["hname"];
        $fields["ipaddr1"]=$row2["ipaddr"];
    }
    else {
        $fields["hname1"]="";
        $fields["ipaddr1"]="";
    }

    if($row2 = $result2->FetchRow()) {
        $fields["hname2"]=$row2["hname"];
        $fields["ipaddr2"]=$row2["ipaddr"];
    }
    else {
        $fields["hname1"]="";
        $fields["ipaddr1"]="";
    }

    if($row2 = $result2->FetchRow()) {
        $fields["hname3"]=$row2["hname"];
        $fields["ipaddr3"]=$row2["ipaddr"];
    }
    else {
        $fields["hname1"]="";
        $fields["ipaddr1"]="";
    }

    $cnt=3;
    while($row2 = $result2->FetchRow()) {
        $fields["hname$cnt"]=$row2["hname"];
        $fields["ipaddr$cnt"]=$row2["ipaddr"];
        $cnt++;
    }

    $fields["regid"]=REGID;
    $fields["password"]=REGPASS;
    $fields["source"]=REGISTRY;

    // add a UTC format date
    $now = getdate();
    $fields["date"] = $now["year"] . str_pad($now["mon"], 2, '0',
            STR_PAD_LEFT) . str_pad( $now["mday"], 2, '0', STR_PAD_LEFT);

    //************ now process customer template fields ************//

    // if a specific customer template exists
    $template=NULL;
    $err=TRUE;
    if (is_readable("../user/custtemplate.xml")) {
        $template=new IPplanIPTemplate("../user/custtemplate.xml");
        $err=$template->is_error();
    }

    // process fields form the user defined template
    if (!$err) {
        $restmp=&$ds->ds->Execute("SELECT info
                FROM custadd
                WHERE customer=$cust");

        if($rowadd = $restmp->FetchRow()) {
            $template->Merge($template->decode($rowadd["info"]));
            foreach($template->userfld as $key=>$arr) {
                $fields[$key]=$arr["value"];
            }
        }
    }

    //************ now process base template fields ************//

    // if a specific base template exists, use that, else use generic template
    $template=NULL;
    $err=TRUE;
    if (is_readable("../user/basetemplate.xml")) {
        $template=new IPplanIPTemplate("../user/basetemplate.xml");
        $err=$template->is_error();
    }

    if (!$err) {
        $result_template=&$ds->ds->Execute("SELECT info, infobin
                FROM baseadd
                WHERE baseindex=$baseindex");

        if ( $rowadd = $result_template->FetchRow()) {
            $template->Merge($template->decode($rowadd["info"]));

            foreach($template->userfld as $key=>$arr) {
                $fields[$key]=$arr["value"];
            }
        }
    }

    $rep = new myTemplate;
    if ($rep->get("../templates/$filename") == FALSE)
        return FALSE;
    $swip=$rep->process($fields);

    return $swip;
}

// email the swip entry
function emailSWIP($swip) {

    require_once("../class.phpmailer.php");
    $mail = new PHPMailer();
    $mail->IsSMTP(); // telling the class to use SMTP
    $mail->SetLanguage("en", "../");
    $mail->Host = EMAILSERVER; // SMTP server
    $mail->From = REGADMINEMAIL;
    $mail->FromName = "IP Plan";
    $mail->AddAddress(REGEMAIL);
    $mail->IsHTML(false);
    $mail->Subject = "SWIP";
    $mail->Body= $swip;
    $mail->AddReplyTo(REGADMINEMAIL);
    $mail->AddCustomHeader("X-Mailer: PHP/" . phpversion());
    //$mail->AddCustomHeader("IPplan version goes here");

    if(REGISTRY=="RIPE") {
       $mail->AddCustomHeader("X-NCC-regid: ".REGID);
    }

    if(!@$mail->Send()) {
        return $mail->ErrorInfo;
    }

/*
    $header="From: ".REGADMINEMAIL."\n".
        "Reply-To: ".REGADMINEMAIL."\n".
        "X-Mailer: PHP/" . phpversion();

    if(REGISTRY=="RIPE") {
        $header.="\nX-NCC-regid: ".REGID."\n";
    }

    mail(REGEMAIL, "SWIP",
            $swip, $header);
    */
}

?>
