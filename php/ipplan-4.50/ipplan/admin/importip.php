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
require_once("../class.templib.php");
require_once("../layout/class.layout");
require_once("../auth.php");
require_once("../xmllib.php");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Import IP details result");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($cust, $format) = myRegister("I:cust S:format");

if (!$_POST) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

if (empty($_FILES)) {
   $tmp=get_cfg_var("file_uploads");
   if (empty($tmp)) {
      insert($w,block("<b>".my_("File uploads may have been disabled in the php.ini configuration file")."</b><p>"));
   }
}
else {
   if ($_FILES['userfile']['size'] == 0) {
      myError($w,$p, my_("Possible file size exceeded php.ini or webserver limit of 2meg - break file into smaller parts"));
   }
   if (!is_uploaded_file($_FILES['userfile']['tmp_name'])) {
      myError($w,$p, my_("Possible file upload attack"));
   }
}
$filename = $_FILES['userfile']['tmp_name'];

// basic sequence is connect, search, interpret search
// result, close connection

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

$rowcnt=0;
$ds->DbfTransactionStart();
if ($format=="xml") {
   // read entire file
   $input = implode("",file($filename));
   $xml_parser = new xmlnmap("HOST");
   if (!$xml_parser->parser) {
      myError($w,$p, my_("XML not available"));
   }
   $output=$xml_parser->parse($input);
   if (!$output) {
      myError($w,$p, my_("Data not in XML format"));
   }

   foreach ($output as $value) {
      $rowcnt++;
      insert($w,textbr());
      insert($w,text(my_("Importing record:")." $rowcnt "));
      if ($value["STATUS"][0]["STATE"]=="up") {
         $data[0]=$value["ADDRESS"][0]["ADDR"];
         $data[6]="";
         if (isset($value["ADDRESS"][1]["ADDRTYPE"]) and $value["ADDRESS"][1]["ADDRTYPE"]=="mac") {
             $data[6]=str_replace(array(":", "-", " "), "", $value["ADDRESS"][1]["ADDR"]);
         }
         $data[1]="";
         if(!empty($value["OSMATCH"][0]["NAME"])) {
            $data[1]=$value["OSMATCH"][0]["NAME"];
         }
         $data[2]="";
         $data[3]="active";
         if(isset($value["HOSTNAME"][0]["NAME"]) and !empty($value["HOSTNAME"][0]["NAME"])) {
            $data[4]=$value["HOSTNAME"][0]["NAME"];
         }
         else {
            $data[4]="";
         }
         $data[5]="";
         ProcessRow($ds, $cust, $w,$p, $data, FALSE);
      }
   }
}
else {
    // open uploaded file for read
    $fp = @fopen ($filename, "r");
    // no real portable way to check if file was uploaded - php version
    // dependent
    if (!$fp) {
        myError($w,$p, my_("File could not be opened."));
    }

    // can we read the template?
    $template=FALSE;
    if (is_readable(dirname(dirname($_SERVER['SCRIPT_FILENAME']))."/user/iptemplate.xml")) {
        $template=new IPplanIPTemplate(dirname(dirname($_SERVER['SCRIPT_FILENAME']))."/user/iptemplate.xml");
        if ($template->is_error() == TRUE) {
            myError($w,$p, my_("Template could not be opened."), FALSE);
            $template=FALSE;
        }
    }
    else {
        myError($w,$p, my_("Template could not be opened."), FALSE);
        $template=FALSE;
    }

    while ($data = fgetcsv ($fp, 2048, FIELDS_TERMINATED_BY)) {
        $rowcnt++;
        insert($w,textbr());
        insert($w,text(my_("Importing row:")." $rowcnt "));

        ProcessRow($ds, $cust, $w, $p, $data, $template);
    }
    fclose ($fp);
}
$ds->DbfTransactionEnd();

printhtml($p);


// $data is number indexed array that has format of ip, user, location, 
// description, telephone
function ProcessRow($ds, $cust, &$w, &$p, $data, $template) {

    global $format;

    $num = count ($data);

    // blank row
    if (empty($data[0])) {
        insert($w,block("<b>".my_("Row is blank - ignoring")."</b>"));
        return;
    }
    // bogus row
    if ($num<6) {
        // ok to save what has been imported already
        $ds->DbfTransactionEnd();
        myError($w,$p, my_("Row not the correct format."));
    }

    if (testIP($data[0])) {
        insert($w,block("<b>".my_("Invalid IP address")."</b>"));
        return;
    }

    $ip=inet_aton($data[0]);
    $user=substr($data[1],0,80);
    $location=substr($data[2],0,80);
    $descrip=substr($data[3],0,80);
    $hname=substr($data[4],0,100);
    $telno=substr($data[5],0,15);
    $macaddr="";
    if ($format=="xml") {
        $macaddr=$data[6];
    }

    $info="";
    if (is_object($template)) {
        // all columns over 6 are considered for adding to template fields
        $cnt=6;
        $userfld=array();
        foreach($template->userfld as $key=>$value) {
            // set fields in template only if field in import file exists, else make blank
            $userfld[$key]=isset($data[$cnt]) ? $data[$cnt] : "";
            $cnt++;
        }
        $template->Merge($userfld);
        $err=$template->Verify($w);
        if ($err) {
            // ok to save what has been imported already
            $ds->DbfTransactionEnd();
            myError($w,$p, my_("Row failed template verify."));
        }

        if ($template->is_blank() == FALSE) {
            $info=$template->encode();
        }
    }

    // NOTE: Test ip address
    $result=$ds->GetBaseFromIP($ip, $cust);
    if (!$row = $result->FetchRow()) {
        // ok to save what has been imported already
        $ds->DbfTransactionEnd();
        myError($w,$p, sprintf(my_("Subnet could not be found for IP address %s"), $data[0]));
    }

    $baseindex=$row["baseindex"];
    $baseaddr=$row["baseaddr"];
    $subnetsize=$row["subnetsize"];

    if ($ds->ModifyIP($ip, $baseindex, $user, $location, 
                $telno, $macaddr, $descrip, $hname, $info) == 0) {
        insert($w,text(my_("IP address details modified")));
    }
    else
        insert($w,text(my_("IP address details could not be modified")));

}

?>
