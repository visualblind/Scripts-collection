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

require_once("../config.php");
//require_once("../schema.php");
require_once("../ipplanlib.php");
require_once("../layout/class.layout");

// check for latest variable added to config.php file, if not there
// user did not upgrade properly
if (!defined('DNSAUTOCREATE')) die("Your config.php file is inconsistent - you cannot copy over your old config.php file during upgrade");

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);


newhtml($p);
insert($p,block("<script type=\"text/javascript\">
</script>
<noscript>
<p><b>
<font size=4 color=\"#FF0000\">
Your browser must be JavaScript capable to use this application. Please turn JavaScript on.
</font>
</b>
</noscript>
"));

$w=myheading($p, my_("Install/Upgrade IPPlan"), false);
insert($w, $t=container("div"));

insert($t, heading(3, my_("IPplan v4.50 Installation System")));

// BEGIN INSTALLER LANGUAGE SUPPORT
if(extension_loaded("gettext") and LANGCHOICE) {

    if ($_POST) {

        // set language cookie if language changed by user
        // language includes path of ipplan root seperated by :
        if ($lang) {
            setcookie("ipplanLanguage",$lang.":".dirname(dirname(__FILE__)),time() + 10000000, "/");
            $_COOKIE['ipplanLanguage']=$lang.":".dirname(dirname(__FILE__));
        }
    }

    if (isset($_COOKIE["ipplanLanguage"])) { 
        myLanguage($_COOKIE['ipplanLanguage']);
    }

    insert($w, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Language")));
    insert($con,  $f=form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
    insert($f,  textbr(my_("Please choose your language:")));
    insert($f,  block('<select NAME="lang">'));

    foreach($iso_codes as $key => $value)
        // look only at language part of cookie
        if (isset($_COOKIE["ipplanLanguage"]) and substr($_COOKIE['ipplanLanguage'],0,5)==$key) {
            insert($f,block('<option VALUE="'.$key.'" SELECTED>'.$value."\n")); }
        else {
            insert($f, block('<option VALUE="'.$key.'">'.$value."\n"));
        }
    insert($f,block("</select>"));
    insert($f,submit(array("value"=>my_("  Change  "))));
    insert($w,generic("br"));
    insert($w,generic("br"));

}
// END INSTALLER LANGUAGE SUPPORT

insert($w, $r=container("fieldset",array("class"=>"fieldset")));
insert($r, $q=container("div",array("class"=>"textErrorBig")));
insert($q,textbr(my_("IF YOU ARE UPGRADING IPPLAN, BACKUP YOUR DATABASE NOW")));
insert($q,textbr(my_("THERE IS NO WAY TO RECOVER YOUR DATA IF SOMETHING GOES WRONG.")));

insert($w, $t=container("div", array("class"=>"MrMagooInstall")));
insert($t, $s=container("ul"));

insert($s, $l1=container("li"));
insert($l1,textb(my_("For security purposes, it is highly recomended that IPPlan is installed on an SSL Webserver.")));
insert($s, generic("br"));
insert($s, $l2=container("li"));
insert($l2,textb(my_("Production systems need to use a transaction-aware database table. Do not use MYISAM (use INNODB) and enable it in config.php")));
insert($s, generic("br"));
insert($s, $l3=container("li"));
insert($l3,textb(my_("Read all Instructions carefully before proceeding!")));

insert($w, generic("br"));
insert($w,block(my_("Have you read the <a href=\"http://iptrack.sourceforge.net/doku.php?id=faq\">FAQ</a>? How about the <a href=\"http://iptrack.sourceforge.net/documentation/\">User Manual</a>? ")));
insert($w,text(my_("Have you read the UPGRADE document if upgrading?")));
insert($w, generic("br"));
insert($w, generic("br"));
insert($w,textbrbr(my_("What would you like to do today?")));

insert($w, $f = form(array("name"=>"THISFORM","method"=>"POST","action"=>"schemacreate.php")));
insert($f,selectbox(array("0"=>"Upgrade","1"=>"New Installation"),array("name"=>"new")));
insert($f, generic("br"));
insert($f, generic("br"));

insert($f,textbr(my_("Would you like us to run the SQL against the database defined in config.php or would you rather print it to the screen so you can do it yourself?")));
 
insert($f,selectbox(array("0"=>my_("Run the SQL Now"),
                          "1"=>my_("Just print it to the screen")),
                          array("name"=>my_("display"))));
insert($f, generic("br"));

insert($f,textbr(my_("If you are displaying the schema, please remove the comments with a text editor before executing into your database.")));
insert($f,generic("br"));
insert($f,submit(array("value"=>my_("Go!"))));

printhtml($p);
?>

