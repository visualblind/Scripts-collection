<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php");

    adm_header("Profiles");

    $admin = profile("ADMIN_USERS");

    $api = $jffnms->get("profiles");
    
    if ($admin==false) $user_filter = array(array("auth.id","=",$auth_user_id));

    if ($action=="update") {

	if (!$api->get_option($userid,$profiles_options_id)) { //we dont have this option 
	
	    if ($profiles_options_id_old==1) { //it was the No Option Option
		$api->delete_option($userid,$profiles_options_id_old); //delete old one
		$api->add($userid,$profiles_options_id); //add it
	    }

	} else  //the option already exists, modify it
	    $api->update($userid,$profiles_options_id,$profiles_values_value);

	$action="list";
    }

    if (($action=="add") && ($admin)) {
	if (!$filter) $filter =1; 

	$editid = $api->add($filter,1);
	
	$action = "edit";
    }

    if (($action=="delete") && ($admin)) {

	$api->delete($actionid);
	$action = "list";
    }
    
    if ($action=="edit") 
	$editid = $actionid;

    $cant = $api->get($filter, $user_filter);
    
    echo 
	adm_table_header("Profiles", $init, &$span, 3, $cant, "admin_profiles", true).
        tag("tr","","header").
        td ("Action", "field", "action").
	td ("Option", "field").
	td ("Value", "field").
	tag_close("tr").
	tag("tbody");

    $api->slice($init,$span);

    while ($rec = $api->fetch()) {

	echo tr_open("row_".$rec["id"],(($editid==$rec["id"])?"editing":((($row++%2)!=0)?"odd":"")));
	
	if (($editid==$rec["id"]) && (($rec["editable"]==1) || ($admin)))  {
	
	    adm_form("update");

	    echo 
		hidden("userid",$rec["userid"]).
		hidden("profiles_options_id_old",$rec["profile_option"]).
		td(adm_standard_submit_cancel("Save","Discard"), "action").
		td((($rec["profile_option"]==1)
		    ?select_profiles_options("profiles_options_id",$rec["profile_option"])
		    :hidden("profiles_options_id",$rec["profile_option"]).$rec["description"])).
		
		td( (($rec["type"]=="select") 
		    ?select_profiles_values("profiles_values_value",$rec["profile_option"],$rec["values_value"]):"").
		    (($rec["type"]=="text")
		    ?textbox("profiles_values_value",$rec["values_value"],20):"")).
		form_close();
	    
	} else 
	    if (($rec["show_in_profile"]==1) || ($admin))
	    	echo 
		    adm_standard_edit_delete($rec["id"],false).
	    	    td ($rec["description"], "field").
		    td (
			(($rec["type"]=="select")?$rec["values_description"]:"").
	    		(($rec["type"]=="text")?$rec["values_value"]:""), "field");
	
	echo 
	    tag_close("tr");
    }

    echo 
	tag_close("tbody").
        table_close();

    adm_footer();
?>
