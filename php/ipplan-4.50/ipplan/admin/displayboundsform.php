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

$title=my_("Display authority boundary information");
newhtml($p);
$w=myheading($p, $title);

// explicitly cast variables as security measure against SQL injection
list($grp) = myRegister("S:grp");

// basic sequence is connect, search, interpret search
// result, close connection
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

$where="";
if ($grp) {
   $where="WHERE grp=".$ds->ds->qstr($grp);
}

$result=&$ds->ds->Execute("SELECT boundsaddr, boundssize, grp
                       FROM bounds
                       $where
                       ORDER BY grp, boundsaddr");

insert($w,heading(3, $title));

// create a table
insert($w,$t = table(array("cols"=>"4",
                           "class"=>"outputtable")));
// draw heading
setdefault("cell",array("class"=>"heading"));
insert($t,$c = cell());
insert($c,text(my_("Group name")));
insert($t,$c = cell());
insert($c,text(my_("Boundary address")));
insert($t,$c = cell());
insert($c,text(my_("Boundary mask")));
insert($t,$c = cell());
insert($c,text(my_("Group action")));

$cnt=0;
$savegrp="";
while($row = $result->FetchRow()) {
setdefault("cell",array("class"=>color_flip_flop()));

   insert($t,$c = cell());
   if ($savegrp!=$row["grp"]) {
      insert($c,text($row["grp"]));
   }

   insert($t,$c = cell());
   insert($c,text(inet_ntoa($row["boundsaddr"])));

   insert($t,$c = cell());
   insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                $row["boundssize"])."/".inet_bits($row["boundssize"])));

   insert($t,$c = cell());
   insert($c,block("<small>"));
   insert($c,anchor("deletebounds.php?grp=".urlencode($row["grp"]).
                    "&boundsaddr=".$row["boundsaddr"], 
                    my_("Delete boundary"),
                    $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));
   insert($c,block("</small>"));

   $cnt++;
   $savegrp=$row["grp"];
}

insert($w,block("<p><b>".sprintf(my_("Total records: %u"), $cnt)."</b>"));

$result->Close();
printhtml($p);

?>
