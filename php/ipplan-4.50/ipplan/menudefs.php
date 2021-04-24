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

$ADMIN_MENU=
".|".my_("Main")."|$BASE_URL/index.php
.|".my_("Customers")."
..|".my_("Create a New Customer/Autonomous System")."|$BASE_URL/user/modifycustomer.php
..|".my_("Edit Existing Customer/Autonomous System")."|$BASE_URL/user/displaycustomerform.php
.|".my_("Network")."
..|".my_("Hierarchy")."
...|".my_("Create a new Network Area")."|$BASE_URL/user/createarea.php
...|".my_("Create a new Network Range/Supernet")."|$BASE_URL/user/createrange.php	
...|".my_("Display/Modify/Delete Ranges/Supernets")."|$BASE_URL/user/modifyarearangeform.php
";

if (REGENABLED) {
$ADMIN_MENU.="
..|".my_("Registrar")."
...|".my_("Display Registrar Information")."|$BASE_URL/user/displayswipform.php\n";
}

$ADMIN_MENU.="
..|".my_("Subnets")."
...|".my_("Create Subnet")."|$BASE_URL/user/createsubnetform.php
...|".my_("Create from Routing Table")."|$BASE_URL/user/displayrouterform.php
...|".my_("Delete/Edit/Modify/Split/Join Subnet")."|$BASE_URL/user/modifybaseform.php
...|".my_("Display Subnet Information")."|$BASE_URL/user/displaybaseform.php
...|".my_("Search All Subnets")."|$BASE_URL/user/searchallform.php
...|".my_("Find Free Space")."|$BASE_URL/user/findfreeform.php
...|".my_("Display Subnet Overlap")."|$BASE_URL/user/displayoverlapform.php
..|".my_("Request an IP address")."|$BASE_URL/user/requestip.php\n";

if (DNSENABLED) {
$ADMIN_MENU .="
.|".my_("DNS")."
..|".my_("Create/Modify/Export Zone Domains")."|$BASE_URL/user/modifydns.php
..|".my_("Create/Modify Zone DNS Records")."|$BASE_URL/user/modifydnsrecord.php
..|".my_("Create/Modify Reverse DNS Records")."|$BASE_URL/user/modifyzone.php\n";

}
$ADMIN_MENU .="
.|".my_("Options")."
..|".my_("Settings")."|$BASE_URL/admin/changesettings.php
..|".my_("Change my Password")."|$BASE_URL/admin/changepassword.php
.|".my_("Admin")."
..|".my_("Users")."
...|".my_("Create a new User")."|$BASE_URL/admin/usermanager.php?action=newuserform
...|".my_("Add a user to Group")."|$BASE_URL/admin/usermanager.php
...|".my_("Display/Edit Users")."|$BASE_URL/admin/usermanager.php
..|".my_("Groups")."
...|".my_("Create a new Group")."|$BASE_URL/admin/usermanager.php?action=newgroupform
...|".my_("Add Authority Bounderies to Group")."|$BASE_URL/admin/usermanager.php
...|".my_("Display/Modify Authority Boundary Info")."|$BASE_URL/admin/displayboundsform.php
..|".my_("Import")."
...|".my_("Import Subnet Descriptions")."|$BASE_URL/admin/importbaseform.php
...|".my_("Import IP Address Detail Records")."|$BASE_URL/admin/importipform.php
..|".my_("Export")."
...|".my_("Export Subnet Descriptions")."|$BASE_URL/admin/exportbaseform.php
...|".my_("Export IP Address Detail Records")."|$BASE_URL/admin/exportipform.php
..|".my_("Maintenance")."|$BASE_URL/admin/maintenance.php
..|".my_("Display Audit Log")."|$BASE_URL/admin/displayauditlog.php
.|".my_("Help")."
..|".my_("Online Manual")."|http://iptrack.sourceforge.net/ 
..|".my_("Support Groups")."|http://sourceforge.net/forum/?group_id=32122
..|".my_("Home Page")."|http://sourceforge.net/projects/iptrack/
..|".my_("License")."|$BASE_URL/license.php
";

// add menu extensions
if (MENU_PRIV) {
$ADMIN_MENU .= MENU_EXTENSION;
}

if (AUTH_LOGOUT) {
$ADMIN_MENU .= ".|".my_("Logout")."|$BASE_URL/user/logout.php\n";
}


?>
