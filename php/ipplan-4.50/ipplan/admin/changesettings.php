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
require_once("../ipplanlib.php");
require_once("../adodb/adodb.inc.php");
require_once("../layout/class.layout");
require_once("../auth.php");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

$title=my_("Change display settings");
newhtml($p);

// explicitly cast variables as security measure against SQL injection
list($paranoid, $poll, $lang) = myRegister("I:paranoid I:poll S:lang");

$results="";
if ($_POST) {
    setcookie("ipplanTheme",$theme, time() + 10000000, "/");
    // Make change immediate.
    $_COOKIE["ipplanTheme"]=$theme;
    setcookie("ipplanParanoid","$paranoid",time() + 10000000, "/");
    $ipplanParanoid=$paranoid;  // to update display once page submitted
    setcookie("ipplanPoll","$poll",time() + 10000000, "/");
    $ipplanPoll=$poll;  // to update display once page submitted

    // set language cookie if language changed by user
    // language includes path of ipplan root seperated by :
    if ($lang) {
        setcookie("ipplanLanguage",$lang.":".dirname(dirname(__FILE__)),time() + 10000000, "/");
        $_COOKIE['ipplanLanguage']=$lang.":".dirname(dirname(__FILE__));
        //isset($_COOKIE["ipplanLanguage"]) && myLanguage($lang.":".dirname(dirname(__FILE__)));
    }

    $results=my_("Settings changed");
}
// Call myheading after setting
// the theme variable any change shows up
// immediately.
$w=myheading($p, $title);

insert($w,text($results));

//if (!$_POST) {
// display opening text
insert($w,heading(3, "$title."));

// start form
insert($w, $f = form(array("method"=>"post",
                "action"=>$_SERVER["PHP_SELF"])));

insert($f, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend,text(my_("Change display settings for this workstation")));

insert($con,textbr(my_("Setting paranoid prompts 'Are you sure?' for all deletes")));
insert($con,selectbox(array("0"=>my_("No"),
                "1"=>my_("Yes")),
            array("name"=>"paranoid"),
            (int)$ipplanParanoid));

insert($con,generic("br"));
insert($con,generic("br"));
insert($con,textbr(my_("Setting poll forces a scan of the IP address before assigning it, and warns the user if the address is active. This slows down address assignment.")));
insert($con,selectbox(array("0"=>my_("No"),
                "1"=>my_("Yes")),
            array("name"=>"poll"),
            (int)$ipplanPoll));

insert($con,textbr());

if(extension_loaded("gettext") and LANGCHOICE) {

    insert($con,block("<br>Language:<br>"));
    //      insert($f,block('<select NAME="lang" ONCHANGE="submit()">'));
    insert($con,block('<select NAME="lang">'));

    foreach($iso_codes as $key => $value)
        // look only at language part of cookie
        if (substr($_COOKIE['ipplanLanguage'],0,5)==$key)
            insert($con,block('<option VALUE="'.$key.'" SELECTED>'.$value."\n"));
        else
            insert($con, block('<option VALUE="'.$key.'">'.$value."\n"));

    insert($con,block("</select>"));
    insert($con,textbr());

}

insert($f,textbr());
insert($con,generic("br"));
insert($con,block(my_("Theme:")));
insert($con,generic("br"));
$theme=isset($_COOKIE["ipplanTheme"]) ? $_COOKIE["ipplanTheme"] : "";
$themelist=array();
foreach (array_keys($config_themes) as $th) {
  $themelist[$th]=$th;
}
    
insert($con,selectbox($themelist,array("name"=>"theme"),$theme));
     
insert($f,submit(array("value"=>my_("Submit"))));
insert($f,freset(array("value"=>my_("Clear"))));

printhtml($p);

?>
