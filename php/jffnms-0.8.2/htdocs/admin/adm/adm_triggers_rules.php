<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php");

    if (!profile("ADMIN_SYSTEM")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");

    $api = $jffnms->get("triggers_rules");
    
    adm_header("Triggers Rules");

    if ($action=="update") {
	if ($stop=="") $stop="0";

	if (is_array($value)) $value = join($value,",");
	
	unset($action_parameters);
	unset($aux);
	if (is_array($action_params)) {
	    foreach ($action_params as $key=>$data)
		$aux[]="$key:$data";
	    $action_parameters=join(",",$aux);
	}
	
	$options_data = compact("trigger_id","pos","field","operator","value","action_id","action_parameters","stop","and_or");
	$api->update($actionid,$options_data);
	$action="list";
    }

    if ($action=="add") {
	$actionid=$api->add($filter);
	$action="edit";
    }

    if ($action=="delete") {
	$api->delete($actionid);
	$action="list";
    }

    if ($action=="edit") 
	$editid = $actionid;

    $cant = $api->get($filter);

    echo 
	adm_table_header("Triggers Rules", $init, &$span, 13, $cant, "admin_triggers_rules", true).
        tag("tr","","header").
        td ("Action", "field", "action").
	td ("ID", "field").
	td ("Position", "field").
	td ("Field", "field","",2).
	td ("Operator", "field","",2).
	td ("Value", "field").
	td ("Action", "field","",2).
	td ("Parameters", "field").
	td ("if Match", "field").
	td ("&nbsp;", "field").
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
	    	td(textbox("pos",$rec["pos"],5),"field").
	    	td("if","field").
	    	td(select_trigger_fields("field",$rec["field"],$rec["trigger_type"]),"field").
	    	td("is","field").
		((($rec["field"]!="none") && ($rec["field"]!="any"))
		    ?td(select_trigger_operator("operator",$rec["operator"]),"field").
		     td(select_trigger_fields_value("value",$rec["value"],$rec["trigger_type"],$rec["field"]),"field")
		    :td("&nbsp;","field","",2)).
		
	    	td("then","field").
	    	td(select_actions("action_id",$rec["action_id"]),"field").
	    	td(($rec["action_id"]!=1)
		    ?select_action_parameters("action_params",$rec["action_parameters"],$rec["action_parameters_def"],0)
		    :"&nbsp;","field").
	    	td(select_stop_continue("stop",$rec["stop"]),"field").
	    	td(select_and_or("and_or",$rec["and_or"]),"field").
		form_close();
	} else 
	    echo
    	        adm_standard_edit_delete($rec["id"],false).
		td($rec["id"],"field", "field_id").
	    	td($rec["pos"],"field").
		((($rec["field"]!="none") && ($rec["field"]!="any"))
		    ?td("if","field").
	    	     td(select_trigger_fields("field",$rec["field"],$rec["trigger_type"],1),"field").
	    	     td("is","field").
		     td(select_trigger_operator("operator",$rec["operator"],1),"field").
		     td(select_trigger_fields_value("value",$rec["value"],$rec["trigger_type"],$rec["field"]),"field")

		    :(($rec["field"]=="any")
			?td("&nbsp;","field","",5)
			:"")).

		((($rec["field"]!="none") && ($rec["action_id"]!=1))
		    ?td("then","field").
	    	     td($rec["action_description"],"field").
		     td(select_action_parameters("action_params",$rec["action_parameters"],$rec["action_parameters_def"],1),"field")
		    :td("&nbsp;","field","",3)).
	    	td(select_stop_continue("stop",$rec["stop"],1),"field").
	    	td(select_and_or("and_or",$rec["and_or"],1),"field");

	echo 
	    tag_close("tr");
    }

    echo 
	tag_close("tbody").
        table_close();

    adm_footer();

?>
