<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function users_action_view_profile() {
	adm_frame_menu_split("profiles");
    }

    function users_action_view_triggers() {
	adm_frame_menu_split("triggers_users",1);
    }

    function users_action_update() {
    
	if (!$_POST["router"]) $_POST["router"] = "0";

	if ($GLOBALS["admin_users"]==false) { // if its not admin dont let it modify these fields
	    $_POST["router"]="";
	    $_POST["usern"]="";
	}

	if (($GLOBALS["actionid"]=="new") && !empty($_POST["usern"]))
	    $_POST["actionid"] = $GLOBALS["api"]->add($_POST["usern"]);

	$GLOBALS["api"]->update($_POST["actionid"],$_POST["usern"],
	    $POST["old_passwd"],$_POST["new_passwd"],$_POST["fullname"],$_POST["router"]);

	$GLOBALS["action"]="list";
    }

    function users_action_delete() {

	if ($GLOBALS["admin_users"]==true) // if its not admin dont let it delete any user
	    $GLOBALS["api"]->delete($_REQUEST["actionid"]);
    }
?>
