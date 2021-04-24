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

$title=my_("Display Audit Log");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($descrip, $block, $expr) = myRegister("S:descrip I:block S:expr");

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

// display opening text
insert($w,heading(3, "$title."));

$srch = new mySearch($w, $_GET, $descrip, "descrip");
//$srch->legend=my_("Refine Search on Domain");
$srch->expr=$expr;
$srch->expr_disp=TRUE;
$srch->Search();  // draw the sucker!

// what is the additional search SQL?
$where=$ds->mySearchSql("action", $expr, $descrip, FALSE);
if ($where) {
    $where = "WHERE ".$where;
}
$result=&$ds->ds->Execute("SELECT action, dt
        FROM auditlog
        $where
        ORDER BY dt DESC");

insert($w,textbr());

$totcnt=0;
$vars="";
// fastforward till first record if not first block of data
while ($block and $totcnt < $block*MAXTABLESIZE and
        $row = $result->FetchRow()) {
    $vars=DisplayBlock($w, $row, $totcnt, "&descrip=".urlencode($descrip), "dt");
    $totcnt++;
}

// create a table
insert($w,$t = table(array("cols"=>"2",
                "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
if (!empty($vars))
    insert($c,anchor($vars, "<<"));
insert($c,text(my_("Timestamp")));
insert($t,$ck = cell());
insert($ck,text(my_("Action")));

$cnt=0;
while ($row = $result->FetchRow()) {
    setdefault("cell",array("class"=>color_flip_flop()));

    insert($t,$c = cell());
    insert($c,block($result->UserTimeStamp($row["dt"], "M d Y H:i:s")));

    insert($t,$c = cell());
    insert($c,text($row["action"]));

    if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1)
        break;
    $cnt++;
    $totcnt++;
}

insert($w,block("<p>"));

$vars="";
$printed=0;
while ($row = $result->FetchRow()) {
    $totcnt++;
    $vars=DisplayBlock($w, $row, $totcnt, "&descrip=".urlencode($descrip), "dt" );
    if (!empty($vars) and !$printed) {
        insert($ck,anchor($vars, ">>"));
        $printed=1;
    }
}

insert($w,block("<p>"));

insert($w,text(my_("Total records:")." ".$cnt));

/*
include_once('../adodb/adodb-pager.inc.php');
$sql = "SELECT userid, action, dt FROM auditlog ORDER BY dt DESC";

function callback($buffer) {
    return ($buffer);
}

// need to print at this stage as display data is cached via layout template
// buffer the output and do some tricks to place system call output in correct
// place
ob_start("callback");

$pager = new ADODB_Pager($ds->ds,$sql);
//$pager->htmlSpecialChars = false;
$pager->gridAttributes = "class=outputtable";
$pager->Render($rows_per_page=MAXTABLESIZE);

$buf=ob_get_contents();
ob_end_clean();

insert($w,block($buf));
*/

printhtml($p);

?>
