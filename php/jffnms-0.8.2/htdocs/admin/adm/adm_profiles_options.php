<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php");

    if (!profile("ADMIN_USERS")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");

    $api = $jffnms->get("profiles_options");
    
    adm_header("Profiles Options");

    if ($action=="view") adm_frame_menu_split("profiles_values",1);

    if ($action=="update") {
	if ($use_default=="") $use_default="0";
	if ($editable=="") $editable="0";
	if ($show_in_profile=="") $show_in_profile="0";

	$options_data = compact("description","tag","editable","type","use_default","default_value","show_in_profile");
	$api->update($actionid,$options_data);
	$action="list";
    }

    if ($action=="add") {
	$actionid=$api->add();
	$action="edit";
    }

    if ($action=="delete") {
	$api->delete($actionid);
	$action="list";
    }
    
    if ($action=="edit") 
	$editid = $actionid;

    $types = array("select"=>"Select", "text"=>"Text Box");

    $cant = $api->get();

    echo 
	adm_table_header("Profiles Options", $init, &$span, 10, $cant, "admin_profiles_options", true).
        tag("tr","","header").
        td ("Action", "field", "action").
	td ("ID", "field").
	td ("Description", "field").
	td ("Tag", "field").
	td ("Type", "field").
	td ("Editable?", "field").
	td ("Show?", "field").
	td ("is Default?", "field").
	td ("Default Value", "field").
	tag_close("tr").
	tag("tbody");

    $api->slice($init,$span);

    while ($rec = $api->fetch()) {

	echo tr_open("row_".$rec["id"],(($editid==$rec["id"])?"editing":((($row++%2)!=0)?"odd":"")));

	if ($editid==$rec["id"]) {

	    adm_form("update");
	
	    echo
		td(adm_standard_submit_cancel("Save","Discard"), "action").
		td($rec["id"],"field", "field_id").
	    	td(textbox("description",$rec["description"],20),"field").
	    	td(textbox("tag",$rec["tag"],20),"field").
	    	td(select_custom("type",$types,$rec["type"]),"field").
		td(checkbox("editable",$rec["editable"]),"field").
		td(checkbox("show_in_profile",$rec["show_in_profile"]),"field").
		td(checkbox("use_default",$rec["use_default"]), "field").
		td(($rec["type"]=="select")
		    ?select_profiles_values("default_value",$rec["id"],$rec["default_value"])
		    :textbox("default_value",$rec["default_value"],20), "field").
		form_close();

	} else 
	    echo 
	        adm_standard_edit_delete($rec["id"],"Values").
	        td($rec["id"],"field","field_id").
		td($rec["description"],"field").
	    	td($rec["tag"],"field").
		td($types[$rec["type"]],"field").
		td(checkbox("editable",$rec["editable"]),"field").
		td(checkbox("show_in_profile",$rec["show_in_profile"]),"field").
		td(checkbox("use_default",$rec["use_default"]), "field").
		td(($rec["type"]=="select")
		    ?select_profiles_values("default_value",$rec["id"],$rec["default_value"])
		    :$rec["default_value"], "field");

	echo 
	    tag_close("tr");
    }

    echo 
	tag_close("tbody").
        table_close();

    adm_footer();
?>
