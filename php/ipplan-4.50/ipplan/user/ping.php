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
require_once("../config.php");
require_once("../layout/class.layout");
require_once("../auth.php");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));

$title=my_("Ping results");
newhtml($p);
$w=myheading($p, $title, true);

// explicitly cast variables as security measure against SQL injection
list($lookup) = myRegister("S:lookup");

if (!$_GET) {
   myError($w,$p, my_("You cannot reload or bookmark this page!"));
}

if (testIP($lookup)) {
   myError($w,$p, my_("Invalid IP address"));
}

function callback($buffer) {
    return ($buffer);
}

// need to print at this stage as display data is cached via layout template
// buffer the output and do some tricks to place system call output in correct
// place
ob_start("callback");
printhtml($p);

$buf=ob_get_contents();
ob_end_clean();

// now print first half of HTML to browser - split at start of "normalbox"
list($beg, $end) = spliti('CLASS="normalbox">', $buf);
echo $beg;
echo 'CLASS="normalbox">';   // add "normalbox" again as this was removed by split

// system calls do not work with safe mode
$lookup=escapeshellarg($lookup);
echo "<pre>";
// different code for Windows
if (strpos(strtoupper(PHP_OS),'WIN') !== false) {
   $err=system("ping $lookup", $err);
} else {
   $err=system("ping -c5 $lookup 2>&1", $err);
}
echo "</pre>";

if($err==FALSE) {
    echo "Could not execute command - probably due to php safe mode";
}

// display last part of HTML
echo $end;

?>
