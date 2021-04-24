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

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Import subnet data");
newhtml($p);
$w=myheading($p, $title);

// display opening text
insert($w,heading(3, "$title."));
insert($w,text(my_("Import network data from flat ascii files.  The file should contain three columns each delimited by TAB. The first column contains the IP base address, the second the description and the third the mask either in dotted decimal format or in bit format.")));
insert($w,block("<p>"));
insert($w,text(my_("If the import file has more than three columns, each additional column will be added to the user defined fields defined in the basetemplate.xml file in the order specified in the template.")));
insert($w,block("<p>"));
insert($w,textbr(my_("If an error occurs during the import, the process will stop. Records that have been successfully imported should be deleted from the import file, the error corrected and the import resumed.")));

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// start form
insert($w, $f = form(array("method"=>"post",
                           "enctype"=>"multipart/form-data",
                           "action"=>"importbase.php")));

$cust=myCustomerDropDown($ds, $f, 0, 0, FALSE) or myError($w,$p, my_("No customers"));

$result=$ds->GetGrps();

$lst=array();
while($row = $result->FetchRow()) {
   $col=$row["grp"];
   $lst["$col"]=$row["grpdescrip"];
}
if (empty($lst)) {
   myError($w,$p, my_("You first need to create some groups!"));
}

insert($f,textbrbr(my_("Admin Group")));
insert($f,selectbox($lst,
                 array("name"=>"admingrp")));

insert($f,textbrbr(my_("File name")));

insert($f,hidden(array("name"=>"MAX_FILE_SIZE",
                       "value"=>MAXUPLOADSIZE)));

insert($f,inputfile(array("name"=>"userfile")));

insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

$result->Close();
printhtml($p);

?>
