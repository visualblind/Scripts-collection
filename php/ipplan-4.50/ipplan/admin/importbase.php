<?php

// IPplan v4.50
// Aug 24, 2001
//
// Modified by Frank Elsner [FE], June 2005

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

// given a mask in either dotted decimal or number of bits, returns the
// subnet size
function getSizeFromMask($mask) {
   $arr=array("1"=>array("255.255.255.255", "32"),
              "2"=>array("255.255.255.254", "31"),
              "4"=>array("255.255.255.252", "30"),
              "8"=>array("255.255.255.248", "29"),
              "16"=>array("255.255.255.240", "28"),
              "32"=>array("255.255.255.224", "27"),
              "64"=>array("255.255.255.192", "26"),
              "128"=>array("255.255.255.128", "25"),
              "256"=>array("255.255.255.0", "24"),
              "512"=>array("255.255.254.0", "23"),
              "1024"=>array("255.255.252.0", "22"),
              "2048"=>array("255.255.248.0", "21"),
              "4096"=>array("255.255.240.0", "20"),
              "8192"=>array("255.255.224.0", "19"),
              "16384"=>array("255.255.192.0", "18"),
              "32768"=>array("255.255.128.0", "17"),
              "65536"=>array("255.255.0.0", "16"));

   // masks from imported file may be padded - strip
   $mask=str_replace("000", "0", $mask);
   $mask=str_replace("00", "0", $mask);

   foreach ($arr as $key => $value) {
      if ($value[0]==$mask or $value[1]==$mask)
         return $key;
   }

   return 0;
}

require_once("../ipplanlib.php");
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../class.templib.php");
require_once("../layout/class.layout");
require_once("../auth.php");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

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

$title=my_("Import subnet results");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($cust, $admingrp) = myRegister("I:cust S:admingrp");

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

// open uploaded file for read
$fp = @fopen ($filename, "r");
if (!$fp) {
   myError($w,$p, my_("File could not be opened."));
}

// Changed - Begin [FE]
// Start of template support for base.

// can we read the template?
$template=FALSE;
if (is_readable(dirname(dirname($_SERVER['SCRIPT_FILENAME']))."/user/basetemplate.xml")) {
    $template=new IPplanIPTemplate(dirname(dirname($_SERVER['SCRIPT_FILENAME']))."/user/basetemplate.xml");
    if ($template->is_error() == TRUE) {
       myError($w,$p, my_("Template could not be opened."), FALSE);
       $template=FALSE;
   }
}
else {
    myError($w,$p, my_("Template could not be opened."), FALSE);
    $template=FALSE;
}
// Changed - End [FE]

$cnt=0;
$ds->DbfTransactionStart();
while ($data = fgetcsv ($fp, 1000, FIELDS_TERMINATED_BY)) {
   $cnt++;
   insert($w,textbr());
   insert($w,text(my_("Importing row:")." $cnt "));
   $num = count ($data);

   // blank row
   if (empty($data[0])) {
      insert($w,block("<b>".my_("Row is blank - ignoring")."</b>"));
      continue;
   }
   // bogus row
   if ($num<3) {
      insert($w, text(sprintf(my_("Row %u of imported file is not the correct format [ %s ]"), $cnt, $data[0])));
      break;
   }

   $ipaddr=$data[0];
   $base=inet_aton($data[0]);
   $descrip=$data[1];

   $size=getSizeFromMask($data[2]);

   $descrip=substr(trim($descrip),0,80);
   
   // Changed - Begin [FE]
   // Start of template support for base
   $info="";
   if (is_object($template)) {
        // all columns over 3 are considered for adding to template fields
        $position=3;
        $userfld=array();
        foreach($template->userfld as $key=>$value) {
            // set fields in template only if field in import file exists, else make blank
            $userfld[$key]=isset($data[$position]) ? $data[$position] : "";
            $position++;
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
			// myError($w,$p, my_("info: $info"));
        }
    }
	 // Changed - End [FE]

   if (strlen($descrip) == 0) {
      insert($w, text(my_("No description for the subnet")));
      break;
   }
   else if (!$ipaddr) {
      insert($w, text(my_("IP address may not be blank")));
      break;
   }
   else if (testIP($ipaddr)) {
      insert($w, text(sprintf(my_("Invalid IP address [ %s ]"), $ipaddr)));
      break;
   }
   else if (!$size) {
      insert($w, text(my_("Subnet mask is invalid")));
      break;
   }
   else {
       // handle duplicate subnets
       $result=$ds->GetDuplicateSubnet($base, $size, $cust);
       if ($row=$result->FetchRow()) {
           // check if baseaddr and size match EXACTLY
           if ($row["baseaddr"] != $base or $row["subnetsize"] != $size) {
               insert($w, text(sprintf(my_("Subnet could not be updated - start address and size do not EXACTLY match existing subnet [ %s ]"), $ipaddr)));
               break;
           }
           insert($w,block("<b>".sprintf(my_("Row is duplicate - updating with [ %s, %s ]"), $ipaddr, $descrip)."</b>"));

           $result=&$ds->ds->Execute("UPDATE base
                   SET descrip=".$ds->ds->qstr($descrip).",
                   lastmod=".$ds->ds->DBTimeStamp(time()).",
                   userid=".$ds->ds->qstr($_SERVER[AUTH_VAR]).",
                   admingrp=".$ds->ds->qstr($admingrp)."
                   WHERE customer=$cust AND
                   baseaddr=$base");

           // Changed - Begin [FE]
           // Start of template support for base [FE]
           if (!empty($info)) {
               // Get the last insert_id
               $baseindex = $ds->ds->GetOne("SELECT baseindex 
                       FROM base
                       WHERE baseaddr=$base AND customer=$cust");

               // First, try to insert.
               $result = &$ds->ds->Execute("INSERT INTO baseadd
                       (info, baseindex)
                       VALUES
                       (".$ds->ds->qstr($info).",
                        $baseindex)");
               // Second, try to update.
               if ( $result == FALSE ) {
                   $result=&$ds->ds->Execute("UPDATE baseadd
                           SET info=".$ds->ds->qstr($info)."                                 
                           WHERE baseindex=$baseindex");

                   if ( $result == FALSE ) {
                       insert($w,block("<b>".my_("Error inserting/updating info.")."</b>"));
                   }   
               }
           }
           // End of template support for base
           // Changed - End [FE]

           $ds->AuditLog(sprintf(my_("User %s modified subnet details %s size %u customer cust %u"),
                       $_SERVER[AUTH_VAR], inet_ntoa($base), $size, $cust));

       }
       else {
           // if not duplicate, fall through to here
           if ($size > 1) {
               if (TestBaseAddr(inet_aton3($ipaddr), $size)) {
                   insert($w, text(my_("Invalid base address!")));
                   break;
               }
           }

           // use the first group user belongs to create subnet
           if ($baseindex = $ds->CreateSubnet($base, $size, $descrip, $cust, 0, $admingrp)) {
               $ds->AuditLog(sprintf(my_("User %s created new subnet %s size %u cust %u"),
                           $_SERVER[AUTH_VAR], inet_ntoa($base), 
                           $size, $cust));

               // Changed - Begin [FE]
               // Start of template support for base
               if (!empty($info)) {
                   // First, try to insert.
                   $result = &$ds->ds->Execute("INSERT INTO baseadd
                           (info, baseindex)
                           VALUES
                           (".$ds->ds->qstr($info).",
                            $baseindex)");
                   // Second, try to update.
                   if ( $result == FALSE ) {
                       $result=&$ds->ds->Execute("UPDATE baseadd
                               SET info=".$ds->ds->qstr($info)."                                 
                               WHERE baseindex=$baseindex");

                       if ( $result == FALSE ) {
                           insert($w,block("<b>".my_("Error inserting/updating info.")."</b>"));
                       }   
                   }
               }
               // End of template support for base
               // Changed - End [FE]

           }
           else {
               insert($w, text(my_("Subnet could not be created")));
               break;
           }
       }
   }
}
// commit whatever has already been written
$ds->DbfTransactionEnd();

fclose ($fp);
printhtml($p);

?>
