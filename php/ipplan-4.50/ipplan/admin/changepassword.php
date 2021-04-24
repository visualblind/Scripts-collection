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

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Change user password");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($user, $password1, $password2) = myRegister("S:user S:password1 S:password2");

$formerror="";
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {
   $password1=trim($password1);
   $password2=trim($password2);

   if (strlen($password1) < 5 or strlen($password2) < 5) {
      $formerror .= my_("The password entered must be at least five characters")."\n";
   }
   if ($password1 != $password2) {
      $formerror .= my_("The passwords entered do not match")."\n";
   }

   if (!$formerror) {
      if ($user and $_SERVER[AUTH_VAR] == ADMINUSER)
         $userid=$user;
      else
         $userid=$_SERVER[AUTH_VAR];

      $password=crypt($password1, 'xq');

      $ds->DbfTransactionStart();
      $result=&$ds->ds->Execute("UPDATE users
                              SET password=".$ds->ds->qstr($password)."
                              WHERE userid=".$ds->ds->qstr($userid));
      $ds->AuditLog(sprintf(my_("User %s changed password"), $userid));

      if ($result) {
         $ds->DbfTransactionEnd();
         insert($w,text(my_("Password changed")));
      }
      else {
         $formerror .= my_("Password could not be changed")."\n";
      }
   }
}

if (!$_POST || $formerror) {
    myError($w,$p, $formerror, FALSE);

    if ($user) {
        insert($w,heading(3, sprintf(my_("Change password for user %s"), $user)));
    }
    else {
        insert($w,heading(3, sprintf(my_("Change password for user %s"), $_SERVER[AUTH_VAR])));
    }

    // start form
    insert($w, $f = form(array("method"=>"post",
                    "action"=>$_SERVER["PHP_SELF"])));

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend,text($title));

    // display opening text

    if ($user) {
        insert($con,hidden(array("name"=>"user",
                        "value"=>"$user")));
    }
    insert($con,textbr(my_("New password (case sensitive!):")));
    insert($con,password(array("name"=>"password1",
                    "value"=>"$password1",
                    "size"=>"40",
                    "maxlength"=>"40")));

    insert($con,textbrbr(my_("New password (again):")));
    insert($con,password(array("name"=>"password2",
                    "value"=>"$password2",
                    "size"=>"40",
                    "maxlength"=>"40")));
    insert($con,generic("br"));
    insert($con,submit(array("value"=>my_("Submit"))));
    insert($con,freset(array("value"=>my_("Clear"))));
}

printhtml($p);

?>
