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
require_once '../menus/lib/PHPLIB.php';
require_once '../menus/lib/layersmenu-common.inc.php';
require_once '../menus/lib/treemenu.inc.php';
require_once("../auth.php");


$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);
$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

newhtml($p);
$myWwwPath='../menus/';
$w=myheading($p,my_("User Manager"));
insert($w, generic("link",array("rel"=>"stylesheet","href"=>"$myWwwPath"."layerstreemenu.css")));
insert($w, generic("link",array("rel"=>"stylesheet","href"=>"$myWwwPath"."layerstreemenu-hidden.css")));
insert($w, script("",array("language"=>"JavaScript","type"=>"text/javascript","src"=> $myWwwPath . 'libjs/layerstreemenu-cookies.js')));

//Make this a stylesheet soon.
insert($w, $t=table(
array(
     "cols"		=>"2",
     "width"		=>"100%",
     "border"		=>"1",
     "cellspacing"	=>"2",
     "frame"		=>"void",
     "rules"		=>"ALL",
     "cellpadding"  =>"5")));


// Create the view and editor containers.  
insert($t,       $view   = cell(array("align"=>"left" ,"width"=>"27%" ,"valign"=>"top")));
insert($t,       $editor1= cell(array("align"=>"left" ,"width"=>"73%" ,"valign"=>"top")));
insert($editor1, $editor = container("div",array("class"=>"usermanager")));


// We just do this once and pass the variable around.
$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));


// Next we check to see if the POST variables have been sent.
// If so we handle this first.
// For example, if we change the user information,
// we want this to be immediately reflected in the user/group control in
// the left hand part of the screen.

list($action)=myRegister("S:action");
$formerror="";

if ($_GET || $_POST) {
    if ($action == "deletegroupboundary")   {  $formerror .= parseDeleteBounds($editor,$ds);         }
    if ($action == "parsecreateuserform")   {  $formerror .= parseCreateUserForm($editor, $ds);      }
    if ($action == "parsecreategroupform")  {  $formerror .= parseCreateGroupForm($editor, $ds);     }
    if ($action == "deleteuser") 	     	{  $formerror .= parseDeleteForms($editor, $ds);         }
    if ($action == "deletegroup")	        {  $formerror .= parseDeleteForms($editor, $ds);         }
    if ($action == "deleteuserfromgroup")	{  $formerror .= parseDeleteUserFromGroup($editor, $ds); }
    if ($action == "changeuserpw")          {  $formerror .= parseChangeUserPassword($editor, $ds);  }
    if ($action == "addusertogroup")        {  $formerror .= parseAddUserToGroupForm($editor,$ds);   }
    if ($action == "modifygroup")           {  $formerror .= parseModifyGroupForm($editor, $ds);     }
    if ($action == "addgroupboundary")	{  $formerror .= parseAddGroupBoundaryForm($editor, $ds);}
}

list($usersearch)=myRegister("S:usersearch");

$MENU="";

// This generates the results for the search bar.  
if ($usersearch != "") {
    $result=&$ds->ds->Execute("SELECT userid, userdescrip
            FROM users
            WHERE userid LIKE ".$ds->ds->qstr("%".$usersearch."%")
            ." OR userdescrip LIKE ".$ds->ds->qstr("%".$usersearch."%"));

    $MENU=".|".my_("Search Result")."\n";
    $count=0;
    while ($row = $result->FetchRow()) {
        $MENU .="..|".$row["userid"]."|".$_SERVER["PHP_SELF"]."?action=usereditform&userid=".$row["userid"]."\n";
        $count++;
    }
    if ($count==0) {$MENU .="..|".my_("No Matches Found")."\n";}
}


$result=&$ds->ds->Execute("SELECT userid, grp 
                           FROM usergrp 
                           ORDER BY grp");
// Build a group mapper.

$lst=array();
$mgrp="";
$muid="";
while($row = $result->FetchRow()) {
    $mgrp=$row["grp"];
    $muid=$row["userid"];
    if (isset($lst["$mgrp"])) {
        $lst["$mgrp"] .= "...|$muid|".$_SERVER["PHP_SELF"]."?action=usereditform&userid=$muid"."\n";
    }
    else {
        $lst["$mgrp"] = "...|$muid|".$_SERVER["PHP_SELF"]."?action=usereditform&userid=$muid"."\n";
    }
}

// We now have a list of each userid->grp mapping...

$result=$ds->GetGrps();
$cnt=0;
while ($row = $result->FetchRow()) {
    if ($cnt++ == 0) {
        $MENU.=".|".my_("All Groups")."\n";
    } 
    $grp=$row["grp"];
    $MENU .= "..|$grp|".$_SERVER["PHP_SELF"]."?action=groupeditform&grp=".$row["grp"]."\n";
    if (array_key_exists($grp,$lst)) {
        $MENU .= $lst[$grp]; 
    }
    else {
        $MENU .= "...|".my_("No users in group")."\n";
    }
}    
if ($cnt == 0) {
   $MENU .= ".|No groups have been created.\n";
}

$result=&$ds->ds->Execute("SELECT users.userdescrip, users.userid
                        FROM users
                        LEFT JOIN usergrp
                        ON users.userid = usergrp.userid
                        WHERE usergrp.userid IS NULL
                        ORDER BY users.userid");
$cnt=0;
while($row = $result->FetchRow()) {
	if ($cnt++ == 0) {
          $MENU.=".|".my_("Orphan Users")."\n";
	}
	$MENU .="..|".$row["userid"]."|".$_SERVER["PHP_SELF"]."?action=usereditform&userid=".$row["userid"]."\n";
}

insert($view, block("<center><b>".my_("Current Users/Groups")."</b></center>"));
insert($view, $cc = container("center"));
insert($cc,block("| "));
insert($cc,anchor($_SERVER["PHP_SELF"]."?action=newuserform",
                  my_("New User")));
insert($cc,block(" | "));
insert($cc,anchor($_SERVER["PHP_SELF"]."?action=newgroupform",
                  my_("New Group")));
insert($cc,block(" |"));

//insert($view, $cc = container("center"));
insert($view, $searchform = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
insert($searchform, $con=container("fieldset",array("class"=>"fieldset")));
insert($con, $legend=container("legend",array("class"=>"legend")));
insert($legend, text(my_("Search")));

insert($con,input_text(array("name"=>"usersearch",
                    "value"=>"$usersearch",
                    "size"=>"20",
                    "maxlength"=>"40")));

insert($con,submit(array("value"=>my_("Search"))));
insert($view, textb(my_("Edit Users/Groups")));
insert($view, textbr());
insert($view, block("<i>".my_("Click on a group or user")."</i>"));

$mid = new TreeMenu();
$mid->setDirroot('../menus');
$mid->setLibjsdir('../menus/libjs/');
$mid->setImgdir('../menus/menuimages/');
$mid->setImgwww('../menus/menuimages/');
$mid->setIcondir('../menus/menuicons/');
$mid->setIconwww('../menus/menuicons/');
$mid->SetMenuStructureString($MENU);
$mid->setIconsize(16, 16);
$mid->parseStructureForMenu('treemenu1');
$mid->newTreeMenu('treemenu1');
insert($view, block($mid->getTreeMenu('treemenu1')));
insert($view, block('<br><br>'));


// If any of the parsing generates an error, we insert that error and then reinsert the form that generated the error.
// The two group functions can come from multiple forms so we don't bother.
// Since all the possible inputs are generated by the code this should rarely happen anyways 
// (assuming this is all bug free ;)

if ($formerror != "") {
    myError($editor,$p,$formerror,FALSE);
    if ($action == "parsecreateuserform")   {  insertCreateUserForm($editor, $ds);    }
    if ($action == "parsecreategroupform")  {  insertCreateGroupForm($editor, $ds);   }
    if ($action == "deleteuser")            {  insertEditUserForm($editor, $ds);      }
    if ($action == "deletegroup")           {  insetrEditGroupForm($editor, $ds);     }
    if ($action == "deleteuserfromgroup")   {  /* done in function with ref var */    }
    if ($action == "changeuserpw")          {  insertEditUserForm($editor, $ds);      }
    if ($action == "addusertogroup")        {           			            }
    if ($action == "modifygroup")           {  insertEditGroupForm($editor, $ds);     }
    if ($action == "addgroupboundary")      {  insertEditGroupForm($editor, $ds);     }
    if ($action == "changeuserpw")          {  insertEditUserForm($editor, $ds);      }
}

// Ok From here Everything is all set to go.  We've built the tree menu thingy and now we're looking 
// Check for actions passed as a POST.

if ($action) {
    if ($action == "usereditform" ) { insertEditUserForm($editor,$ds);}
    if ($action == "groupeditform") { insertEditGroupForm($editor,$ds);}
    if ($action == "newuserform")   { insertCreateUserForm($editor,$ds);}
    if ($action == "newgroupform")  { insertCreateGroupForm($editor);}
}
else {
    insert ($editor, block("&nbsp;"));
}
printhtml($p); // The code should exit after this line.

////

// START FUNCTIONS


function insertCreateGroupForm($w) {

    list($grp, $grpdescrip,$createcust, $grpview)=myRegister("S:grp S:grpdescrip S:createcust S:grpview");
    $grp=trim($grp);
    $grpdescrip=trim($grpdescrip);
    insert($w, $f = form(array("method"=>"post",
                    "action"=>$_SERVER["PHP_SELF"])));
    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($f, generic("br"));
    insert($legend, text(my_("Create group")));

    insert($con,hidden(array("name"=>"action","value"=>"parsecreategroupform")));
    insert($con,textbr(my_("Group name:")));

    insert($con,input_text(array("name"=>"grp",
                    "value"=>"$grp",
                    "size"=>"40",
                    "maxlength"=>"40")));

    insert($con,textbrbr(my_("Group description:")));
    insert($con,input_text(array("name"=>"grpdescrip",
                    "value"=>"$grpdescrip",
                    "size"=>"40",
                    "maxlength"=>"80")));
    insert($con, $t=table(array("cols"=>"2","border"=>"0","cellspacing"=>"2","width"=>"100%")));
    insert($t, $c=cell());
    insert($c,textbrbr(my_("Group can create/modify/delete customers?")));
    insert($c,selectbox(array("N"=>my_("No"),
                    "Y"=>my_("Yes")),
                array("name"=>"createcust"),$createcust));
    insert($t, $c=cell());
    insert($c,textbrbr(my_("Group can view any customers data?")));
    insert($c,selectbox(array("Y"=>my_("Yes"),
                    "N"=>my_("No")),
                array("name"=>"grpview"),$grpview));

    insert($f,submit(array("value"=>my_("Create group"))));

}

// Changed function to allow the user to be passed as a variable.
// This is the easiest/cleanest way to enable passing the userid 
// after an action has been parsed and we want to redisplay the
// same screen for user ease.

function insertEditUserForm($w,$ds) {

    list($ipaddr, $userid, $grp, $grpdescrip, $createcust, $grpview) = myRegister("S:ipaddr S:userid S:grp S:grpdescrip S:createcust S:grpview");
    $grp=trim($grp);
    $grpdescrip=trim($grpdescrip);
    $result=&$ds->ds->Execute("SELECT * FROM users WHERE userid=".$ds->ds->qstr($userid));
    if ($result) {
        $row=$result->FetchRow();
    }

    // First off we insert the user information and delete button.
    insert($w, $t=table(array("cols"=>"2","border"=>"0","cellspacing"=>"2","width"=>"100%")));
    insert($t, $c=cell());
    insert($c ,block("<b>".my_("Editing User: $userid")."</b><br>"));
    insert($c, block("<i>".my_("Real Name: ").$row["userdescrip"]."</i>"));
    insert($t, $c=cell(array("align"=>"right")));
    insert($c, $f = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
    insert($f,hidden(array("name"=>"action","value"=>"deleteuser")));
    insert($f,hidden(array("name"=>"userid"   ,"value"=>"$userid")));
    insert($f,submit(array("value"=>my_("Delete User"))));

    // Next we add the change password form.

    insert($w, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Change Password")));
    insert($con, $pwform = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
    insert($pwform,hidden(array("name"=>"userid","value"=>"$userid")));
    insert($pwform,hidden(array("name"=>"action","value"=>"changeuserpw")));
    insert($pwform,textbr(my_("New password (case sensitive!):")));
    insert($pwform,password(array("name"=>"password1",
                    "size"=>"40",
                    "maxlength"=>"40")));
    insert($pwform,textbrbr(my_("New password (again):")));
    insert($pwform,password(array("name"=>"password2",
                    "size"=>"40",
                    "maxlength"=>"40")));
    insert($pwform,generic("br"));
    insert($pwform,submit(array("value"=>my_("Change Password"))));
    insert($w,generic("br"));

    // START Add User to Group

    $result2=$ds->GetGrps();

    $lst=array();
    $c=0;
    while($row = $result2->FetchRow()) {
        $col=$row["grp"];
        $lst["$col"]=$row["grp"];
        $c++;
    }

    // We count how many groups exist....
    // and add group code if necessary.

    if ($c > 0) {
        insert($w, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text(my_("Groups")));
        insert($con, $f2 = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
        insert($f2,hidden(array("name"=>"action","value"=>"addusertogroup")));
        insert($f2,hidden(array("name"=>"refpage","value"=>"user")));
        insert($f2,hidden(array("name"=>"userid"   ,"value"=>"$userid")));
        insert($f2,selectbox($lst, array("name"=>"grp")));
        insert($f2,submit(array("value"=>my_("Add User to Group"))));

        // START User Group Listing
        // Here we check to see if any of the user is
        // in any groups and if so we print them out
        // in a table and allow the user to delete them.

        insert($con, generic("br"));
        $result=&$ds->ds->Execute("SELECT * FROM usergrp WHERE userid=".$ds->ds->qstr($userid));
        $lst=array();

        while($row = $result->FetchRow()) {
            $col=$row["grp"];
            $lst["$col"]=$row["grp"];
        }

        if (!empty($lst)) {
            insert($con, $t = table(array("cols"=>"2","border"=>"0","cellspacing"=>"0")));
            // draw heading
            insert($t,$c = cell());
            insert($c,text(my_("Group Membership")));
            insert($t,$c = cell());

            $count=0;
            foreach($lst as $g) {
                $count++;
                insert($t,$c=cell());
                insert($c,block("$g"));
                insert($t,$c=cell());
                insert($c,$f= form(array("name"=>"userkill$count","method"=>"post","action"=>$_SERVER["PHP_SELF"]))); 
                insert($f,hidden(array("name"=>"action","value"=>"deleteuserfromgroup")));
                insert($f,hidden(array("name"=>"userid"   ,"value"=>"$userid")));
                insert($f,hidden(array("name"=>"grp"   ,"value"=>"$g")));
                insert($f,hidden(array("name"=>"refpage","value"=>"user")));
                insert($f,block("<a href='#' onclick='userkill$count.submit();'>".my_(" Remove From Group")."</a>"));
            }
        }
    }
    insert($w, generic("br"));
}

function insertEditGroupForm($w,$ds) {

    list($ipaddr, $size, $grp) = myRegister("S:ipaddr S:size S:grp");

    $result=&$ds->ds->Execute("SELECT * FROM grp WHERE grp=".$ds->ds->qstr($grp));
    $row=$result->FetchRow();
    $grpdescrip=$row["grpdescrip"];
    $createcust=$row["createcust"];
    $grpopt    =$row["grpopt"];
    $resaddr   =$row["resaddr"];
    insert($w, $t=table(array("width"=>"100%","cols"=>"2","border"=>"0","cellspacing"=>"0","valign"=>"middle")));
    insert($t, $c = cell());
    insert($c, block("<b>".my_("Editing Group:")." $grp</b><br>"));
    insert($c, block("<i>".my_(" Description: ")."</i>".$grpdescrip));
    insert($w,generic("br"));  
    insert($t,$c = cell (array("align"=>"right")));
    insert($c, $f = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
    insert($f,hidden(array("name"=>"action","value"=>"deletegroup")));
    insert($f,hidden(array("name"=>"grp"   ,"value"=>"$grp")));
    insert($f,submit(array("value"=>my_("Delete Group"))));
    // MODIFY GROUP FORM
    insert($w, $f1 = form(array("method"=>"post","action"=>$_SERVER["PHP_SELF"])));
    insert($f1, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Modify group")));
    insert($con,hidden(array("name"=>"grp","value"=>"$grp")));
    insert($con,hidden(array("name"=>"action","value"=>"modifygroup")));
    insert($con,textbr(my_("Group description:")));
    insert($con,input_text(array("name"=>"grpdescrip","value"=>"$grpdescrip","size"=>"80","maxlength"=>"80")));
    insert($con,textbrbr(my_("Group can create/modify/delete customers?")));
    insert($con,selectbox(array("N"=>my_("No"),
                    "Y"=>my_("Yes")),
                array("name"=>"createcust"),
                $createcust));
    insert($con,textbrbr(my_("Group can view any customers data?")));
    // first bit defines view capability
    insert($con,selectbox(array("N"=>my_("No"),
                    "Y"=>my_("Yes")),
                array("name"=>"grpview"),
                $grpopt & 1 ? "Y" : "N" ));
    insert($con,textbrbr(my_("Number of reserved addresses at start of subnets:")));
    insert($con,span(my_("NOTE: if the user belongs to multiple groups and one of the groups does not contain a reserved limit, then the user is allowed all actions"), array("class"=>"textSmall")));
    insert($con,input_text(array("name"=>"resaddr",
                                 "value"=>"$resaddr",
                                 "size"=>"4",
                                 "maxlength"=>"4")));
    insert($con,generic("br"));
    insert($con,generic("br"));
    insert($con,submit(array("value"=>my_("Update"))));
    insert($con,generic("br"));
    // START Add User Form
    $result1=&$ds->ds->Execute("SELECT userid
            FROM users
            ORDER BY userid");
    $c=0;
    $lst=array();
    while($row = $result1->FetchRow()) {
        $col=$row["userid"];
        $lst["$col"]=$row["userid"];
        $c++; // here
    }

    if ($c > 0) {

        insert($w, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text(my_("User Membership")));
        insert($con, $f2 = form(array("name"=>"ENTRY",
                        "method"=>"post",
                        "action"=>$_SERVER["PHP_SELF"])));


        insert($f2,selectbox($lst,                  array("name"=>"userid")));
        insert($f2,hidden(array("name"=>"action","value"=>"addusertogroup")));
        insert($f2,hidden(array("name"=>"refpage","value"=>"grp")));
        insert($f2,hidden(array("name"=>"grp","value"=>"$grp")));
        insert($f2,submit(array("value"=>my_("Add User"))));
        // Edit users assigned to the group.

        $result=&$ds->ds->Execute("SELECT * FROM usergrp WHERE grp=".$ds->ds->qstr($grp));

        $lst=array();
        while($row = $result->FetchRow()) {
            $col=$row["userid"];
            $lst["$col"]=$row["userid"];
        }

        if (!empty($lst)) {
            insert($con,$t = table(array("cols"=>"2")));
            //insert($con,$t = table(array("cols"=>"2", "class"=>"outputtable")));
            //setdefault("cell",array("class"=>"heading"));

            insert($t,$c = cell());
            insert($c,text(my_("Current Members")));
            insert($t,$c = cell());
            $icecream=0;
            foreach($lst as $u) {
                //setdefault("cell",array("class"=>color_flip_flop()));


                $icecream++;
                insert($t,$c=cell());
                insert($c,block("$u"));
                insert($t,$c=cell());
                insert($c,$f= form(array("name"=>"userkill$icecream","method"=>"post","action"=>$_SERVER["PHP_SELF"]))); 
                insert($f,hidden(array("name"=>"action","value"=>"deleteuserfromgroup")));
                insert($f,hidden(array("name"=>"userid"   ,"value"=>"$u")));
                insert($f,hidden(array("name"=>"grp"   ,"value"=>"$grp")));
                insert($f,hidden(array("name"=>"refpage","value"=>"grp")));
                insert($c,block("<a href='#' onclick='userkill$icecream.submit();'>".my_("Remove From Group")."</a>"));
            }
        }
    }
    insert($w,generic("br"));

    // Ok.  How bout adding bounds to the group???

    insert($w, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($con,textbr(my_("NOTE: if the user belongs to multiple groups and one of the groups does not contain authority boundaries, then the user is allowed all actions")));

    insert($legend, text(my_("Authority Boundaries")));
    insert($con, $f2 = form(array("name"=>"ENTRY",
                    "method"=>"post","action"=>$_SERVER["PHP_SELF"])));

    insert($f2,hidden(array("name"=>"grp","value"=>"$grp")));
    insert($f2,hidden(array("name"=>"action","value"=>"addgroupboundary")));
    insert($f2,text(my_("Authority boundary start address")));
    
    // from previous post?
    if ($ipaddr == "0.0.0.0") {
        $ipaddr="";
    }
    insert($f2,input_text(array("name"=>"ipaddr",
                    "value"=>"$ipaddr",
                    "size"=>"15",
                    "maxlength"=>"15")));
    insert($f2,generic("br"));
    insert($f2,text(my_("Authority size/mask")));
    insert($f2,selectbox(array("4"=>"255.255.255.252/30 - 4 hosts",
                    "8"=>"255.255.255.248/29 - 8 hosts",
                    "16"=>"255.255.255.240/28 - 16 hosts",
                    "32"=>"255.255.255.224/27 - 32 hosts",
                    "64"=>"255.255.255.192/26 - 64 hosts",
                    "128"=>"255.255.255.128/25 - 128 hosts",
                    "256"=>"255.255.255.0/24 - 256 hosts (class C)",
                    "512"=>"255.255.254.0/23 - 512 hosts",
                    "1024"=>"255.255.252.0/22 - 1k hosts",
                    "2048"=>"255.255.248.0/21 - 2k hosts",
                    "4096"=>"255.255.240.0/20 - 4k hosts",
                    "8192"=>"255.255.224.0/19 - 8k hosts",
                    "16384"=>"255.255.192.0/18 - 16k hosts",
                    "32768"=>"255.255.128.0/17 - 32k hosts",
                    "65536"=>"255.255.0.0/16 - 64k hosts (class B)",
                    "16777216"=>"255.0.0.0/8 - 16m hosts (class A)"),
                array("name"=>"size"),
                $size));

    insert($f2,submit(array("value"=>my_("Add Boundary"))));

    // add readonly button
    insert($con, $f2 = form(array("name"=>"READONLY",
                    "method"=>"post","action"=>$_SERVER["PHP_SELF"])));

    insert($f2,hidden(array("name"=>"ipaddr","value"=>"0.0.0.0")));
    insert($f2,hidden(array("name"=>"size","value"=>"0")));
    insert($f2,hidden(array("name"=>"grp","value"=>"$grp")));
    insert($f2,hidden(array("name"=>"action","value"=>"addgroupboundary")));
    insert($f2,submit(array("value"=>my_("Read only group"))));
    insert($f2, generic("br"));

    $result=&$ds->ds->Execute("SELECT boundsaddr, boundssize, grp
            FROM bounds
            WHERE grp=".$ds->ds->qstr($grp)."
            ORDER BY boundsaddr");

    // logic here is:
    // boundsaddr=0 and boundssize=0 -> then this is a read only group
    // boundsaddr=0 and boundssize>0 -> number of addresses this group is not allowed to edit
    //                                        at start of subnets
    // boundsaddr>1 and boundssize>0 -> normal bounds within which this group can edit subnets
    //                                      and ip addresses

    $tricky=0;
    while($row = $result->FetchRow()) {
        // create a table
        if ($tricky == 0) {
            ++$tricky;
            insert($con,$t = table(array("cols"=>"3")));
            // draw heading
            insert($t,$c = cell());
            insert($c,text(my_("Current Boundaries")));
            insert($t,$c = cell());
            insert($t,$c = cell());
        }
        insert($t,$c = cell());
        if ($row["boundsaddr"] == 0) {
            insert($c,text(my_("Read only group")));
            insert($t,$c = cell());
        }
        else {
            insert($c,text(inet_ntoa($row["boundsaddr"])));
            insert($t,$c = cell());
            insert($c,text(inet_ntoa(inet_aton(ALLNETS)+1 -
                            $row["boundssize"])."/".inet_bits($row["boundssize"])));
        }
        insert($t,$c = cell());
        $ipplanParanoid=$_COOKIE["ipplanParanoid"];
        insert($c,anchor("usermanager.php?action=deletegroupboundary&grp=".urlencode($row["grp"]).
                    "&boundsaddr=".$row["boundsaddr"],
                    my_("Delete boundary"),
                    $ipplanParanoid ? array("onclick"=>"return confirm('".my_("Are you sure?")."')") : FALSE));

        if ($row["boundsaddr"] == 0) {
            break;
        }
    }
    insert($w,generic("br"));
}


function insertCreateUserForm($w,$ds) {

    list($userid, $userdescrip, $grp)= myRegister("S:userid S:userdescrip S:grp");
    insert($w, $f = form(array("method"=>"post",
                    "action"=>$_SERVER["PHP_SELF"])));
    insert($f,hidden(array("name"=>"action","value"=>"parsecreateuserform")));
    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Create new user")));
    insert($con,textbr(my_("User-id (case sensitive!):")));
    insert($con,input_text(array("name"=>"userid",
                    "value"=>"$userid",
                    "size"=>"20",
                    "maxlength"=>"40")));
    insert($con,textbrbr(my_("User's fullname:")));
    insert($con,input_text(array("name"=>"userdescrip",
                    "value"=>"$userdescrip",
                    "size"=>"40",
                    "maxlength"=>"80")));
    if (AUTH_INTERNAL) {
        insert($con,textbrbr(my_("Password (case sensitive!):")));
        insert($con,password(array("name"=>"password1",
                        "size"=>"20",
                        "maxlength"=>"40")));
        insert($con,textbrbr(my_("Password (again):")));
        insert($con,password(array("name"=>"password2",
                        "size"=>"20",
                        "maxlength"=>"40")));
    }

    $result2=$ds->GetGrps();

    $lst=array(""=>"No group");
    while($row = $result2->FetchRow()) {
        $col=$row["grp"];
        $lst["$col"]=$row["grp"]." - ".$row["grpdescrip"];
    }
    insert($con,textbrbr(my_("Group")));
    insert($con,selectbox($lst,
                array("name"=>"grp"),$grp));

    insert($f, generic("br"));
    insert($f,submit(array("value"=>my_("Create User"))));
    insert($f,freset(array("value"=>my_("Clear"))));

}


function parseCreateUserForm($w,$ds) {

    list($userid, $userdescrip, $password1, $password2, $grp, $search)=myRegister("S:userid S:userdescrip S:password1 S:password2 S:grp S:search");

    $formerror="";
    $userid=trim($userid);
    $userdescrip=trim($userdescrip);
    $search=trim($search);
    if (AUTH_INTERNAL) {
        $password1=trim($password1);
        $password2=trim($password2);
    }
    else {
        // generate random password in case user changes authentication
        // from external to internal at some point
        $password1=$password2=rand(10000, 1000000);
    }

    if (strlen($userid) < 2) {
        $formerror .= my_("The user-id must be longer")."\n";
    }
    if (strlen($userdescrip) < 2) {
        $formerror .= my_("The user description must be longer")."\n";
    }
    if (strlen($password1) < 5 or strlen($password2) < 5) {
        $formerror .= my_("The password entered must be at least five characters")."\n";
    }
    if ($password1 != $password2) {
        $formerror .= my_("The passwords entered do not match")."\n";
    }
    if (!$formerror) {
        $password=crypt($password1, 'xq');
        $ds->DbfTransactionStart();
        // emulates mysql REPLACE
        $result=&$ds->ds->Execute("DELETE FROM users
                WHERE userid=".$ds->ds->qstr($userid));
        $result=&$ds->ds->Execute("INSERT INTO users
                (userid, userdescrip, password)
                VALUES
                (".$ds->ds->qstr($userid).",
                 ".$ds->ds->qstr($userdescrip).",
                 ".$ds->ds->qstr($password).")");

        // add group if user selected a group other than "No group"
        if (!empty($grp)) {
            $result=&$ds->ds->Execute("DELETE FROM usergrp
                    WHERE userid=".$ds->ds->qstr($userid)." AND
                    grp=".$ds->ds->qstr($grp));
            $result=&$ds->ds->Execute("INSERT INTO usergrp
                    (userid, grp)
                    VALUES
                    (".$ds->ds->qstr($userid).",
                     ".$ds->ds->qstr($grp).")");
        }
        if ($result) {
            $ds->DbfTransactionEnd();
            if ($ds->ds->Affected_Rows() == 2)
                insert($w,text(my_("Existing user overwritten")));
            else
                insert($w,text(my_("User created")));
            insertEditUserForm($w, $ds);
        }
        else {
            $formerror .= my_("User could not be created")."\n";
        }
    }
    return($formerror);
}

function parseCreateGroupForm($w,$ds) {

    list($grp, $grpdescrip, $createcust, $grpview, $resaddr) = myRegister("S:grp S:grpdescrip S:createcust S:grpview I:resaddr");

    $grp=trim($grp);
    $grpdescrip=trim($grpdescrip);
    $formerror="";

    if (strlen($grp) < 2) {
        $formerror .= my_("The group name must be longer")."\n";
    }
    if ($resaddr < 0 or $resaddr > 9999) {
        $formerror .= my_("Reserved addresses out of range")."\n";
    }
    if (strlen($grpdescrip) < 2) {
        $formerror .= my_("The group description must be longer")."\n";
    }
    if (ereg("[^[:alnum:]-]", $grp)) {
        $formerror .= my_("Only numbers and digits are allowed in the group name")."\n";
    }

    if (!$formerror) {
        $ds->DbfTransactionStart();

        // grpopt is a bit encoded field which will contain true/false type
        // options on groups - currently only one bit is used to define if
        // customers can view others data

        // bit 1 : 1 = user can view all customers info
        //         0 = user can view only groups customers
        $grpbit=0;
        if ($grpview == "Y") {
            $grpbit=1;
        }

        $result=&$ds->ds->Execute("INSERT INTO grp
                (grp, createcust, grpdescrip, grpopt, resaddr)
                VALUES
                (".$ds->ds->qstr($grp).",
                 ".$ds->ds->qstr($createcust).",
                 ".$ds->ds->qstr($grpdescrip).",
                 ".$grpbit.", $resaddr)");

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,textbr(my_("Group created")));
            insertEditGroupForm($w, $ds);
        }
        else {
            $ds->DbfTransactionRollback();
            $formerror .= my_("Group could not be created - possibly a duplicate")."\n";
        }
    }
    return($formerror);
}
function parseDeleteUserFromGroup($w, $ds) {
    // Added 6/29/2005 to avoid accidentally loosing groups.

    list($userid, $grp, $ref)=myRegister("S:userid S:grp S:refpage");

    $ds->DbfTransactionStart();
    $result=&$ds->ds->Execute("DELETE FROM usergrp
            WHERE userid=".$ds->ds->qstr($userid)." AND
            grp=".$ds->ds->qstr($grp));
    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,text(my_("User deleted from group")));
        if ($ref == "user") {
            insertEditUserForm($w, $ds);
        }
        if ($ref == "grp") {
            insertEditGroupForm($w, $ds);
        }
    }
    else {
        $formerror .=my_("User could not be deleted from group");
    }
}

function parseDeleteForms($w, $ds) {


    // NOTE: don't change order of if's!!!
    // This code is a crime against humanity and needs to be fixed ASAP.
    //
    // THIS FUNCTION PARTIALLY DEPRECATED.  SEE BELOW.

    list($userid, $usergrp, $grp, $ref)=myRegister("S:userid S:usergrp S:grp S:ref");
    $formerror="";

    // delete a user
    if ($userid) {
        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("DELETE FROM users
                WHERE userid=".$ds->ds->qstr($userid)) and
            $result=&$ds->ds->Execute("DELETE FROM usergrp
                    WHERE userid=".$ds->ds->qstr($userid));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("User $userid deleted")));
        }
        else {
            $formerror .=my_("User could not be deleted");
        }
    }
    // THIS SECTION IS DEPRECATED BY DELETEUSERFROMGROUP()
    // Left only to be sure we don't break the rest of this.
    else if ($usergrp) {
        $userid=$usergrp;
        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("DELETE FROM usergrp
                WHERE userid=".$ds->ds->qstr($userid)." AND
                grp=".$ds->ds->qstr($grp));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("User $userid deleted from group")));
            if ($ref == "user")
                insertEditUserForm($w, $ds);
            if ($ref == "grp")
                insertEditGroupForm($w, $ds);

        }
        else {
            $formerror .=my_("User could not be deleted from group");
        }
    }
    // END DEPRECATION
    else if ($grp and !$usergrp) {
        // check if grp has customers
        $result=&$ds->ds->Execute("SELECT custdescrip
                FROM customer
                WHERE admingrp=".$ds->ds->qstr($grp));
        if ($row=$result->FetchRow()) {
            $formerror .=my_("Cannot delete group because the following customers are assigned to the group:");
            do {
                $formerror .= $row["custdescrip"];
            } while($row=$result->FetchRow());

        }

        // check if grp has subnets
        $result=&$ds->ds->Execute("SELECT baseaddr, descrip
                FROM base
                WHERE admingrp=".$ds->ds->qstr($grp)."
                ORDER BY baseaddr");
        if ($row=$result->FetchRow()) {
            $formerror .= my_("Cannot delete group because the following subnets are assigned to the group:");
            do {
                $formerror .= inet_ntoa($row["baseaddr"])." - ".$row["descrip"];
            } while($row = $result->FetchRow());

        }

        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("DELETE FROM grp
                WHERE grp=".$ds->ds->qstr($grp)) and
            $result=&$ds->ds->Execute("DELETE FROM usergrp
                    WHERE grp=".$ds->ds->qstr($grp)) and
            $result=&$ds->ds->Execute("DELETE FROM bounds
                    WHERE grp=".$ds->ds->qstr($grp));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Group $grp deleted")));
        }
        else {
            $formerror .= my_("Group could not be deleted");
        }
    } // endif
} // end function


function parseChangeUserPassword($w, $ds) {

    list($password1, $password2, $userid) = myRegister("S:password1 S:password2 S:userid");

    $formerror="";

    if (strlen($password1) < 5 or strlen($password2) < 5) {
        $formerror .= my_("The password entered must be at least five characters")."\n";
    }

    if ($password1 != $password2) {
        $formerror .= my_("The passwords entered do not match")."\n";
    }

    if ($formerror == "" ) { // Whoops, missed this first time through.  Otherwise pw changes no matter what.
        $password=crypt($password1, 'xq');

        $ds->DbfTransactionStart();
        $result=&$ds->ds->Execute("UPDATE users
                SET password=".$ds->ds->qstr($password)."
                WHERE userid=".$ds->ds->qstr($userid));
        $ds->AuditLog(sprintf(my_("User %s changed password"), $userid));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Password changed")));
            insertEditUserForm($w,$ds);
        }
        else {
            $formerror .= my_("Password could not be changed")."\n";
        }
    }
    return($formerror);
}


function parseAddUserToGroupForm($w, $ds) {

    $formerror="";
    list($userid, $grp, $refpage, $grp)=myRegister("S:userid S:grp S:refpage S:grp");

    //REG is from  insert($f2,hidden(array("name"=>"refpage","value"=>"user")));
    // It lets us reprint the edit page after we parse.
    $ds->DbfTransactionStart();
    // emulate mysql REPLACE
    $result=&$ds->ds->Execute("DELETE FROM usergrp
            WHERE userid=".$ds->ds->qstr($userid)." AND
            grp=".$ds->ds->qstr($grp));
    $result=&$ds->ds->Execute("INSERT INTO usergrp
            (userid, grp)
            VALUES
            (".$ds->ds->qstr($userid).",
             ".$ds->ds->qstr($grp).")");

    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,textbr(my_("User added to group")));

        if ($refpage == "user")
            insertEditUserForm($w, $ds);
        if ($refpage == "grp")
            insertEditGroupForm($w, $ds);
    }
    else {
        $formerror .= my_("User could not be added to group")."\n";
    }
    return $formerror;
}

function parseModifyGroupForm($w, $ds) {

    $formerror="";
    list($grpdescrip, $grp, $grpview, $createcust, $resaddr) = myRegister("S:grpdescrip S:grp S:grpview S:createcust I:resaddr");
    $grpdescrip=trim($grpdescrip);
    if (strlen($grpdescrip) < 2) {
        $formerror .= my_("The group description must be longer")."\n";
    }
    if ($resaddr < 0 or $resaddr > 9999) {
        $formerror .= my_("Reserved addresses out of range")."\n";
    }

    if (!$formerror) {
        $ds->DbfTransactionStart();
        // grpopt is a bit encoded field which will contain true/false type
        // options on groups - currently only one bit is used to define if
        // customers can view others data
        $grpbit=0;
        if ($grpview=="Y") {
            $grpbit=1;
        }

        $result=&$ds->ds->Execute("UPDATE grp
                SET grpdescrip=".$ds->ds->qstr($grpdescrip).",
                createcust=".$ds->ds->qstr($createcust).",
                grpopt=".$grpbit.",
                resaddr=".$resaddr."
                WHERE grp=".$ds->ds->qstr($grp));

        if ($result) {
            $ds->DbfTransactionEnd();
            insert($w,text(my_("Group $grp details modified")));
            insertEditGroupForm($w, $ds);
        }
        else {
            $formerror .= my_("Group details could not be modified")."\n";
        }
    }

}

function parseAddGroupBoundaryForm($w, $ds) {

    list($grp, $ipaddr, $size) = myRegister("S:grp S:ipaddr S:size");

    // explicitly cast variables as security measure against SQL injection
    $formerror="";
    $size=floor($size);
    if ($_POST) {
        $base=inet_aton($ipaddr);

        // creating readonly group?
        if ($base == 0 and $size == 0) {
            if ($ds->ds->GetOne("SELECT count(*) AS cnt FROM bounds WHERE grp=".$ds->ds->qstr($grp))) {
                $formerror .= my_("Boundary cannot be created - overlaps with existing boundary")."\n";
            }
        }
        else {
            if (!$ipaddr)
                $formerror .= my_("Boundary address may not be blank")."\n";
            else if (testIP($ipaddr))
                $formerror .= my_("Invalid boundary address")."\n";
            else if (!$size)
                $formerror .= my_("Size may not be zero")."\n";
            else if (TestDuplicateBounds($ds, $base, $size, $grp))
                $formerror .= my_("Boundary cannot be created - overlaps with existing boundary")."\n";

            if ($size > 1) {
                if (TestBaseAddr(inet_aton3($ipaddr), $size)) {
                    $formerror .= my_("Invalid base address")."\n";
                }
            }
        }

        if (!$formerror) {
            $ds->DbfTransactionStart();
            // the fact that the range is unique prevents the range
            // being added to more than one area!
            $result=&$ds->ds->Execute("INSERT INTO bounds
                    (boundsaddr, boundssize, grp)
                    VALUES
                    ($base, $size, ".$ds->ds->qstr($grp).")");

            if ($result) {
                $ds->DbfTransactionEnd();
                insert($w,textbr(my_("Boundary created")));
                insertEditGroupForm($w, $ds);
            }
            else {
                $formerror .= my_("Boundary could not be created")."\n";
            }

        }   
    }
    return($formerror);
}

function TestDuplicateBounds($ds, $boundsaddr, $boundssize, $grp) {

    $result=&$ds->ds->Execute("SELECT boundsaddr
            FROM bounds
            WHERE (($boundsaddr BETWEEN boundsaddr AND
                    boundsaddr + boundssize - 1) OR
                ($boundsaddr < boundsaddr AND
                 $boundsaddr+$boundssize >
                 boundsaddr + boundssize - 1)) AND
            grp=".$ds->ds->qstr($grp));
    if ($result->FetchRow()) {
        return 1;
    }
}

function parseDeleteBounds($w, $ds) {

    list($grp, $boundsaddr) = myRegister("S:grp S:boundsaddr");

    $result=&$ds->ds->Execute("DELETE FROM bounds
            WHERE grp=".$ds->ds->qstr($grp)." AND boundsaddr=$boundsaddr");

    if ($result) {
        $ds->DbfTransactionEnd();
        insert($w,text(my_("Boundary deleted")));
    }
    else {
        insert($w,text(my_("Boundary could not be deleted")));
    }
    insertEditGroupForm($w, $ds);
}

?>
