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

// find the next available address - this needs cleanup, can be done with 
// only baseindex and look for gap
function FindNextFree($ds, $baseindex, $baseaddr, $subnetsize) {

    // order is important here!
    $result=&$ds->ds->Execute("SELECT ipaddr
            FROM ipaddr
            WHERE baseindex=$baseindex
            ORDER BY ipaddr");

    $cnt=0;
    $arr=array();
    while($row = $result->FetchRow()) {
        // protect against network and broadcast address potentially
        // existing in database
        if ($row["ipaddr"] > $baseaddr and 
                $row["ipaddr"] < $baseaddr+$subnetsize-1)
            $arr[$cnt++]=$row["ipaddr"];
    }

    $cnt=0;
    for ($i=$baseaddr+1; $i < $baseaddr+$subnetsize-1; $i++) {
        if (isset($arr[$cnt]) and $arr[$cnt] == $i)
            $cnt++;
        else
            break;
    }

    return $i;

}


if (!ANONYMOUS) {
   $auth = new SQLAuthenticator(REALM, REALMERROR);

   // And now perform the authentication
   $auth->authenticate();
}

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Modify IP address details");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($ip, $baseindex, $block, $updatedescrip, $ind, $action, $probe, $search, $expr, $ipplanParanoid) = myRegister("B:ip I:baseindex I:block I:updatedescrip I:ind S:action I:probe S:search S:expr, I:ipplanParanoid");
// and add the cookie
list($ipplanPoll) = myRegister("I:ipplanPoll");

$formerror="";
if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// make sure subnetsize is available
$result=$ds->GetBaseFromIndex($baseindex);
$row = $result->FetchRow();
$subnetsize=$row["subnetsize"];
$netdescrip=$row["descrip"];
$baseaddr=$row["baseaddr"];
$cust=$row["customer"];
$formerror="";

// already have ip address to modify
if ($ip) {
    $iptemp=inet_ntoa($ip);

    // query could return nothing which is OK
    $result=&$ds->ds->Execute("SELECT userinf, location, telno, macaddr, ipaddr, descrip, hname
            FROM ipaddr
            WHERE ipaddr=$ip AND baseindex=$baseindex");

    $row = $result->FetchRow();

    $result=&$ds->ds->Execute("SELECT info, infobin
            FROM ipaddradd
            WHERE ipaddr=$ip AND baseindex=$baseindex");

    $rowadd = $result->FetchRow();
}
// find next free address to modify
else {
    $ip=FindNextFree($ds, $baseindex, $baseaddr, $subnetsize);
    $iptemp=inet_ntoa($ip);

    if ($ip==$baseaddr+$subnetsize-1) {
        myError($w,$p, my_("There are no available addresses"));
    }

    // rowadd is empty as this is a new empty address assignment
    $rowadd = array();
    $row = array();

}

// initialize $files array now as can be used by uploaded file section
// required later to draw table of uploaded files too
// files should be "" if no record (rowadd is not set)
$files=isset($rowadd["infobin"]) ? unserialize($rowadd["infobin"]) : "";    
// suppress warning if string is empty
            
// file uploaded
if ($action=="fileupload") {

    if (empty($_FILES)) {
        $tmp=get_cfg_var("file_uploads");
        if (empty($tmp)) {
            insert($w,textB(my_("File uploads may have been disabled in the php.ini configuration file")));
            insert($w,block("<b>"));
        }
    }
    else {
        // some versions of PHP return 0 on failed upload due to size exceeded
        if ($_FILES['userfile']['size'] == 0) {
            myError($w,$p, sprintf(my_("Possible file size exceeded php.ini or webserver limit of %s - break file into smaller parts"), MAXUPLOADSIZE));
        }
        if (!is_uploaded_file($_FILES['userfile']['tmp_name'])) {
            myError($w,$p, my_("Possible file upload attack"));
        }
    }
    $filename = $_FILES['userfile']['tmp_name'];

    if (empty($descrip)) {
            $formerror .= my_("Filename must have a description - uploaded aborted")."\n";
    }
    else {

        // try to move file
        if (is_dir(UPLOADDIRECTORY) && is_writable(UPLOADDIRECTORY) &&
            move_uploaded_file($filename, UPLOADDIRECTORY."/".basename($filename))) {

        // move successful, now update files array and save to dbf
            $files[] = array("name"=>$_FILES['userfile']['name'],
                    "size"=>$_FILES['userfile']['size'],
                    "date"=>date("F j, Y, g:i a"),
                    "descrip"=>$descrip,
                    "tmp_name"=>basename($_FILES['userfile']['tmp_name']));

            $ds->DbfTransactionStart();

            // add serialized info from file upload
            $ds->ds->Execute("UPDATE ipaddradd
                    SET infobin=".$ds->ds->qstr(serialize($files))."
                    WHERE baseindex=$baseindex AND
                    ipaddr=$ip");
            // this generates a "duplicate key" error if no update
            // should be OK under normal circumstances, but generates error under
            // debug mode turned on
            if ($ds->ds->Affected_Rows() == 0) {
                $ds->ds->Execute("INSERT INTO ipaddradd
                        (infobin, baseindex, ipaddr)
                        VALUES
                        (".$ds->ds->qstr(serialize($files)).",
                         $baseindex,
                         $ip)");
            }
            $ds->AuditLog(array("event"=>140, "action"=>"upload file", 
                        "ip"=>$iptemp, "user"=>$_SERVER[AUTH_VAR], "baseindex"=>$baseindex,
                        "filename"=>$_FILES['userfile']['name']));
            $ds->DbfTransactionEnd();

        }
        else {
            $formerror .= my_("File could not be moved to upload location - upload failed probably due to directory permission problem")."\n";
        }
    }
}
else if ($action=="filedelete") {
    // use basename again - just incase somebody tampered with array?
    if (is_file(UPLOADDIRECTORY."/".basename($files[$ind]["tmp_name"])) &&
        unlink(UPLOADDIRECTORY."/".basename($files[$ind]["tmp_name"]))) {

        $ds->DbfTransactionStart();

        $filename=$files[$ind]["name"];

        unset($files[$ind]);
        // last file deleted, clear array
        if (empty($files)) {
            $files="";   // so that array test fails?
            //unset($files);
        }

        // add serialized info after file deteled
        $ds->ds->Execute("UPDATE ipaddradd
                SET infobin=".$ds->ds->qstr(empty($files) ? "" : serialize($files))."
                WHERE baseindex=$baseindex AND
                ipaddr=$ip") and
            $ds->AuditLog(array("event"=>141, "action"=>"delete file", 
                "ip"=>$iptemp, "user"=>$_SERVER[AUTH_VAR], "baseindex"=>$baseindex,
                "filename"=>$filename));
        $ds->DbfTransactionEnd();

    }
    else {
            $formerror .= my_("File could not be deleted - delete failed probably due to directory permission problem")."\n";
    }

}
else if ($action=="filedownload") {

    // use basename again - just incase somebody tampered with array?
    if (is_readable(UPLOADDIRECTORY."/".basename($files[$ind]["tmp_name"]))) {
        $ds->DbfTransactionStart();
        $ds->AuditLog(array("event"=>142, "action"=>"download file", 
                    "ip"=>$iptemp, "user"=>$_SERVER[AUTH_VAR], "baseindex"=>$baseindex,
                    "tmpname"=>$files[$ind]["tmp_name"],
                    "filename"=>$files[$ind]["name"]));
        $ds->DbfTransactionEnd();

        // force file download due to bad mime type
        header("Content-Description: File Transfer");
        header("Content-Type: application/force-download");
        header("Content-Type: application/octet-stream");
        header("Content-Length: ".$files[$ind]["size"]);
        header("Content-Transfer-Encoding: binary");
        header("Content-Disposition: attachment; filename=".$files[$ind]["name"].";");

        readfile(UPLOADDIRECTORY."/".($files[$ind]["tmp_name"]));
        exit;
    }
    else {
        $formerror .= my_("File could not be downloaded - download failed probably due to directory permission problem")."\n";
    }
}

// save md5str for check in displaysubnet.php to see if info has
// been modified since start of edit
$md5str=$ds->GetMD5($ip, $baseindex);

myError($w,$p, $formerror, FALSE);

insert($w,block("<h3>"));
insert($w,text(my_("Subnet:")." ".
                  inet_ntoa($baseaddr)." ".my_("Mask:")." ".
                  inet_ntoa(inet_aton(ALLNETS)+1 -
                    $subnetsize)."/".inet_bits($subnetsize)));
insert($w,block("<small>"));
if (isset($_SERVER['HTTP_REFERER']) and stristr($_SERVER['HTTP_REFERER'], "displaysubnet.php")) {
    insert($w,anchor($_SERVER['HTTP_REFERER'], my_("Back to subnet")));
}
insert($w,block("</small>"));
insert($w,textbr());
insert($w,text(my_("Description:")." ".$netdescrip));
insert($w,block("</h3>"));

// ------------------- request ip address section starts here ------------------------

requestip($p, $w, $ds, $cust);

function requestip(&$p, &$w, $ds, $cust) {

    // get all request records
    $result=$ds->ds->Execute("SELECT requestindex, requestdesc, userinf, location, telno, 
                             descrip, hname, macaddr, lastmod, info
                           FROM requestip
                           WHERE customer=$cust");

    // emulate for databases that do not have RecordCount
    // not records, do nothing
    if (!$result->PO_RecordCount("requestip", "customer=$cust")) {
        return;
    }

    // if a specific network template exists, use that, else use generic template
    $template=NULL;
    $err=TRUE;
    if (is_readable("../user/iptemplate.xml")) {
        $savtemplate=new IPplanIPTemplate("../user/iptemplate.xml");
        $err=$savtemplate->is_error();
    }

    // first element of "Additional data" section of modifyipform page
    // this changes as elements are added to the page
    define("ADD_INFO", 9);

    $lst=array();
    $jsarr="";
    $lst["0"]="No request";
    $cnt=0;
    while($row=$result->FetchRow()) {
        $template=$savtemplate;  // reset template - additional fields could have been added
        $col=$row["requestindex"];
        $lst["$col"]=$row["requestdesc"];

        $jsarr.="    dbf[$col]=new Array();\n";
        $jsarr.="    dbf[$col][1]=\"".$row["userinf"]."\";\n";
        $jsarr.="    dbf[$col][2]=\"".$row["location"]."\";\n";
        $jsarr.="    dbf[$col][3]=\"".$row["descrip"]."\";\n";
        $jsarr.="    dbf[$col][4]=\"".$row["hname"]."\";\n";
        $jsarr.="    dbf[$col][5]=\"".$row["telno"]."\";\n";
        $jsarr.="    dbf[$col][6]=\"".substr(chunk_split($row["macaddr"], 2, ':'), 0, -1)."\";\n";

        // no template error
        if (!$err) {
            $template->Update($template->decode($row["info"]));
            $cnt2=ADD_INFO;
            $jsset="";
            foreach($template->userfld as $arr) {
                $jsarr.="    dbf[$col][$cnt2]=\"".preg_replace('/(\r\n)|\n|\r/m', '\n', $arr["value"])."\";\n";
                $jsset.="    parent.document.MODIFY.elements[$cnt2].value=dbf[idx][$cnt2];\n";

                $cnt2++;
            }
        }

        $cnt++;
    }

    insert($p, script('
function modifyipform() {

   dbf=new Array();
   '.$jsarr.'

   idx=document.REQUESTIP.request.value;
   document.MODIFY.request.value=idx;

   if ((idx) == 0) return;

   document.MODIFY.user.value=dbf[idx][1];
   document.MODIFY.location.value=dbf[idx][2];
   document.MODIFY.descrip.value=dbf[idx][3];
   document.MODIFY.hname.value=dbf[idx][4];
   document.MODIFY.telno.value=dbf[idx][5];
   document.MODIFY.macaddr.value=dbf[idx][6];
   '.$jsset.'

} ', array("language"=>"JavaScript", "type"=>"text/javascript")));

    insert($w, $f = form(array("name"=>"REQUESTIP",
                    "method"=>"get",
                    "action"=>$_SERVER["PHP_SELF"])));
    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Requested addresses")));

    insert($con,selectbox($lst,
                array("name"=>"request", "onChange"=>"modifyipform()")));
}

// ------------------- request ip address section ends here ------------------------

// ------------------- support functions block start here ------------------------
insert($w,textB(my_("IP Address to modify:")." ".$iptemp));
// scan the new address to see if it is currently active
if ($probe or $ipplanPoll) {
    if (NMAP != "") {
        $ipscan = NmapScan(NmapRange($iptemp, $iptemp));
        if (!empty($ipscan)) {
            insert($w,text(my_(" (Address active on network) "),
                        array("color"=>"#FF0000")));
        }
    }
    else {
        if (ScanHost($iptemp, 1)) {
            insert($w,text(my_(" (Address active on network) "),
                        array("color"=>"#FF0000")));
        }
    }
}

insert($w,block(" | "));

insert($w,anchor("whois.php?lookup=".$iptemp,
                  my_("Whois")));
insert($w,block(" | "));
// dont bother checking for safe mode as error will be thrown in called scripts
//if (!ini_get("safe_mode")) {
   insert($w,anchor("ping.php?lookup=".$iptemp,
                     my_("Ping")));
   insert($w,block(" | "));
   insert($w,anchor("traceroute.php?lookup=".$iptemp,
                     my_("Traceroute")));
   insert($w,block(" | "));
//}
insert($w,anchor("dns.php?ip=".$iptemp,
                  my_("DNS")));
insert($w,block(" | "));

insert($w,anchor("modifyipform.php?ip=".$ip.
                 "&baseindex=".$baseindex."&block=".$block.
                 "&updatedescrip=1",
                 my_("Update hostname from DNS")));

if (extension_loaded("snmp")) {
   insert($w,block(" | "));

   insert($w,anchor("modifyipform.php?ip=".$ip.
                    "&baseindex=".$baseindex."&block=".$block.
                    "&updatedescrip=2",
                    my_("Query device info via SNMP")));

}

insert($w,generic("p"));

// start form for delete - to be completed later
$settings=array("name"=>"DELETE",
                "method"=>"post",
                "action"=>"displaysubnet.php");
if ($ipplanParanoid)
   $settings["onsubmit"]="return confirm('".my_("Are you sure?")."')";
insert($w, $fdel = form($settings));
// end of delete form
// ------------------- support functions block ends here ------------------------

// ------------------- user information block starts here ------------------------
insert($w,generic("p"));

// start form for modify
insert($w, $f = form(array("name"=>"MODIFY",
                           "method"=>"post",
                           "action"=>"displaysubnet.php")));

$userinf=isset($row["userinf"]) ? $row["userinf"] : "";
$location=isset($row["location"]) ? $row["location"] : "";
$descrip=isset($row["descrip"]) ? $row["descrip"] : "";
$hname=isset($row["hname"]) ? $row["hname"] : "";
$telno=isset($row["telno"]) ? $row["telno"] : "";
$macaddr=isset($row["macaddr"]) ? $row["macaddr"] : "";
// format macaddr with :'s
$macaddr=substr(chunk_split($macaddr, 2, ':'), 0, -1);
// check if userinf field has an encoded linked address in format of LNKx.x.x.x
// where x.x.x.x is an ip address
$lnk="";
if (preg_match("/^LNK[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}/", $userinf)) {
    list($lnk, $userinf) = preg_split("/[\s]+/", $userinf, 2);
    $lnk=substr($lnk, 3);
}
// rowadd could be empty if looking for next available address
$dbfinfo=isset($rowadd["info"]) ? $rowadd["info"] : "";

if ($updatedescrip==1) {
    $dnsdescrip=gethostbyaddr($iptemp);
    if ($dnsdescrip != $iptemp) {
        $hname=$dnsdescrip;
    }
} else if ($updatedescrip==2) {
    $community=(SNMP_COMMUNITY=="") ? "public" : SNMP_COMMUNITY;
    // snmpget returns false on error, substr in if would break logic
    if ($userinf = @snmpget($iptemp, $community, ".1.3.6.1.2.1.1.4.0")) {
        $userinf = substr($userinf, 8);
        // only query others if first query was a success
        $descrip = substr(@snmpget($iptemp, $community, ".1.3.6.1.2.1.1.1.0"),8);
        $hname = substr(@snmpget($iptemp, $community, ".1.3.6.1.2.1.1.5.0"),8);
        $location = substr(@snmpget($iptemp, $community, ".1.3.6.1.2.1.1.6.0"),8);
        // get the interface table while we are at it and check the subnet
        // mask - could be multiple interfaces on router
        // array contains ip address as key and mask as value
        $interfaces = snmpwalkoid($iptemp, $community, ".1.3.6.1.2.1.4.20.1.3");
        foreach($interfaces as $key => $value) {
            if (strstr($key, $iptemp)) {
                // found exact match of interface - compare mask
                if (!strstr($value, inet_ntoa(inet_aton(ALLNETS)+1 - $subnetsize))) {
                    insert($f,textbr());
                    myError($f,$p, my_("The subnet mask configured on the device appears to be incorrect!")."\n", FALSE);
                }
                break;
            }
        }
    }
    else {
        // reset failed query to original value
        $userinf=$row["userinf"];
    }
}

// user section starts here

myFocus($p, "MODIFY", "user");
insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("User information")));
insert($con,textbr(my_("User")));
insert($con,input_text(array("name"=>"user",
                           "value"=>$userinf,
                           "size"=>"80",
                           "maxlength"=>"80")));
insert($con,block(" <a href='#' onclick='MODIFY.user.value=\"".
                    DHCPRESERVED."\";'>DHCP address</a>"));
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
insert($con,textbrbr(my_("Linked address")));
insert($con,span(my_("Link this address by pointing it to another address - useful for NAT definitions"), 
    array("class"=>"textSmall")));
insert($con,input_text(array("name"=>"lnk",
                           "value"=>$lnk,
                           "size"=>"15",
                           "maxlength"=>"15")));
insert($con,anchor("JavaScript:follow()",
                     my_("Go to address")));
//insert($con,anchor("JavaScript:printDOMTree(document.getElementById('framediv'));",
//                     my_("Test")));


// add some javascript magic to follow a link if field is completed
    insert($w, script('
function empty(x) {
    if (x.length > 0) return false;
    else return true;
}

function follow() {

    if (empty(document.MODIFY.lnk.value)) return;

       document.DUMMY.ipaddr.value=document.MODIFY.lnk.value;
       document.DUMMY.submit();
} 
', array("language"=>"JavaScript", "type"=>"text/javascript")));

// ------------------- user information block ends here ------------------------

// -------------------- template section starts here ---------------------------
// if a specific network template exists, use that, else use generic template
$template=NULL;
if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate-network.xml") and !TestBaseAddr($ip, $subnetsize)) {
    $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate-network.xml");
}
else {
    $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/iptemplate.xml");
}
if (is_object($template) and $template->is_error() == FALSE) {
    //insert($f,block("<hr>"));
    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Additional information")));

    //insert($f,textbr(my_("Additional information"), array("b"=>1)));

    $template->Merge($template->decode($dbfinfo));
    $template->DisplayTemplate($con);
}
// -------------------- template section ends here ---------------------------

insert($con,hidden(array("name"=>"baseindex",
                      "value"=>"$baseindex")));
insert($con,hidden(array("name"=>"ip",
                      "value"=>"$ip")));
insert($con,hidden(array("name"=>"subnetsize",
                      "value"=>"$subnetsize")));
insert($con,hidden(array("name"=>"block",
                      "value"=>"$block")));
insert($con,hidden(array("name"=>"search",
                      "value"=>"$search")));
insert($con,hidden(array("name"=>"expr",
                      "value"=>"$expr")));
insert($con,hidden(array("name"=>"md5str",
                      "value"=>"$md5str")));
// from the requestip - this will be the index to delete from the request
// table
insert($con,hidden(array("name"=>"request",
                      "value"=>"0")));

insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

// --------------------------- start of upload section ----------------------------
insert($w, $f = form(array("method"=>"post",
                           "enctype"=>"multipart/form-data",
                           "action"=>$_SERVER["PHP_SELF"]."?baseindex=$baseindex&ip=$ip&block=$block")));

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Upload files")));

//insert($f,block("<hr>"));
//insert($f,textbr(my_("Upload files"), array("b"=>1)));
//insert($f,block("<p>"));

// files have been uploaded previously - $files array has been initialize
// earlier
if (is_array($files)) {
        insert($con,$t = table(array("cols"=>"5",
                    "cellspacing"=>"1",
                    "class"=>"outputtable")));
        // draw heading
        setdefault("cell",array("class"=>"heading"));
        insert($t,$c = cell());
        insert($c,text(my_("Filename")));
        insert($t,$c = cell());
        insert($c,text(my_("Description")));
        insert($t,$c = cell());
        insert($c,text(my_("Size")));
        insert($t,$c = cell());
        insert($c,text(my_("Date")));
        insert($t,$c = cell());
        insert($c,text(my_("Action")));


        foreach($files as $key => $value) {
        setdefault("cell",array("class"=>color_flip_flop()));

            insert($t,$c = cell());
            insert($c,text($files[$key]["name"]));

            insert($t,$c = cell());
            insert($c,text($files[$key]["descrip"]));

            insert($t,$c = cell());
            insert($c,text($files[$key]["size"]));

            insert($t,$c = cell());
            insert($c,text($files[$key]["date"]));

            insert($t,$c = cell());
            insert($c,block("<small>"));
            insert($c,anchor($_SERVER["PHP_SELF"]."?baseindex=$baseindex&ip=$ip&block=$block&action=filedelete&ind=$key",
                        my_("Delete file")));
            insert($c,block("</small>"));
            insert($c,block(" | "));
            insert($c,block("<small>"));
            insert($c,anchor($_SERVER["PHP_SELF"]."?baseindex=$baseindex&ip=$ip&block=$block&action=filedownload&ind=$key",
                        my_("Download file")));
            insert($c,block("</small>"));


        }
}

insert($con,textbr(my_("Filename description")));
insert($con,input_text(array("name"=>"descrip",
                           "size"=>"80",
                           "maxlength"=>"80")));

insert($con,textbrbr(my_("File name")));
insert($con,hidden(array("name"=>"MAX_FILE_SIZE",
                       "value"=>MAXUPLOADSIZE)));
insert($con,inputfile(array("name"=>"userfile")));

insert($con,hidden(array("name"=>"action",
                      "value"=>"fileupload")));
insert($con,hidden(array("name"=>"md5str",
                      "value"=>"$md5str")));
insert($con,submit(array("value"=>my_("Upload file"))));
// --------------------------- end of upload section ----------------------------

// complete delete form - created earlier

insert($fdel,hidden(array("name"=>"baseindex",
                      "value"=>"$baseindex")));
insert($fdel,hidden(array("name"=>"ip",
                      "value"=>"$ip")));
insert($fdel,hidden(array("name"=>"subnetsize",
                      "value"=>"$subnetsize")));
insert($fdel,hidden(array("name"=>"action",
                      "value"=>"delete")));
insert($fdel,hidden(array("name"=>"block",
                      "value"=>"$block")));
insert($fdel,hidden(array("name"=>"search",
                      "value"=>"$search")));
insert($fdel,hidden(array("name"=>"expr",
                      "value"=>"$expr")));
insert($fdel,hidden(array("name"=>"md5str",
                      "value"=>"$md5str")));

insert($fdel,submit(array("value"=>my_("Delete record"))));
insert($fdel,text(my_("WARNING: Deleting an entry does not preserve the last modified information as the record is completely removed from the database to conserve space. ")));

if (is_array($files)) {
    myError($fdel,$p, my_("Deleting this record will delete all associated uploaded files!")."\n", FALSE);
}
// end of delete form

// dummy form for "follow" function
$settings=array("name"=>"DUMMY",
                "method"=>"get",
                "action"=>"displaybase.php");
insert($w, $f = form($settings));

insert($f,hidden(array("name"=>"ipaddr",
                      "value"=>$lnk)));
insert($f,hidden(array("name"=>"cust",
                      "value"=>$cust)));
insert($f,hidden(array("name"=>"searchin",
                      "value"=>"1")));
insert($f,hidden(array("name"=>"jump",
                      "value"=>"1")));

printhtml($p);

?>
