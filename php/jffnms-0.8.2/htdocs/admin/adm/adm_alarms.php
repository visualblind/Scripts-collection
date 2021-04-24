<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php");
    
    if (!profile("ADMIN_HOSTS")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");

    adm_header("Alarm Editor");

    $interfaces = $jffnms->get("interfaces");
    $alarms = $jffnms->get("alarms");
    
    $id = $actionid;
    if (!is_array($actionid)) $actionid=array($actionid);

    if ($action=="update") {
	if (empty($triggered)) $triggered = 0;
	
	$data = compact("date_start","date_stop","interface","active","referer_start","referer_stop","triggered","type");
	$alarms->update($id,$data);
	$action="list";
    }

    if ($action=="delete") {
        
	foreach ($actionid as $id) 
	    if (is_numeric($id)) 
	        $alarms->delete($id);

	$action="list";
    }

    $fields = 10;

    $interface_filters = reports_make_interface_filter();

    $interfaces_list = $interfaces->get_all($use_interfaces, $interface_filters);
    
    $interfaces_ids_list = array_keys($interfaces_list);

    if (is_array($alarm_filters))
	foreach ($alarm_filters as $key=>$value)
	    if (empty($value) || !is_string($key)) unset($alarm_filters[$key]);

    $alarms_list_cant = $alarms->get($interfaces_ids_list,$alarm_filters);

    echo
	adm_table_header("Alarm Editor", $init, &$span, $fields, $alarms_list_cant, "admin_alarms", false).
        tag("tr","","header").
        td ("Action", "field", "action").
	td ("ID", "field", "field_id").
	td ("Start Date", "field").
	td ("Stop Date", "field").
	td ("Duration", "field").
	td ("Type", "field").
	td ("State", "field").
	td ("Interface", "field").
	td ("Triggered", "field").
	td ("Start/Stop Ref", "field").
	tag_close("tr").
	tag("tbody");

    adm_form("update");
    echo reports_pass_options();

    $alarms->slice($init,$span);

    if ($alarms_list_cant > 0) {

	while ($r = $alarms->fetch()) {

	    echo tr_open("row_".$rec["id"],
		((in_array($r["id"],$actionid) && ($action=="edit"))
		    ?"editing"
		    :((($row++%2)!=0)?"odd":"")));

	    if (in_array($r["id"],$actionid) && ($action=="edit")) 
		echo
		    td(adm_standard_submit_cancel("Save","Discard"), "action").
		    td($r["id"],"field", "field_id").
	    	    td(textbox("date_start",$r["date_start"],20),"field").
	    	    td(textbox("date_stop",$r["date_stop"],20),"field").
		    td(time_hms($r["duration"]),"field").
		    td(select_event_types("type",$r["type"]),"field").
		    td(select_alarm_states("active",$r["active"]), "field").
		    td(select_interfaces("interface",$r["interface"]), "field").
	    	    td(checkbox("triggered",$r["triggered"]),"field").
		    td(textbox("referer_start",$r["referer_start"],5)." / ".textbox("referer_stop",$r["referer_stop"],5), "field");
	    else
		echo 
		    adm_standard_edit_delete($r["id"],false).
		    td($r["id"],"field","field_id").
	    	    td($r["date_start"],"field").
	    	    td($r["date_stop"],"field").
		    td(time_hms($r["duration"]),"field").
		    td(linktext($r["type_description"], $REQUEST_URI."&alarm_filters[type]=".$r["type"]),"field").
		    td(
			linktext($r["state_description"], $REQUEST_URI."&alarm_filters[state]=".$r["active"])." &nbsp; ".
			linktext("(".$r["alarm_state"].")", $REQUEST_URI."&alarm_filters[alarm_state]=".$r["alarm_state"]),
			"field").
		    td(linktext($r["interface_description"], $REQUEST_URI."&interface_id=".$r["interface"]),"field").
		    td(checkbox("triggered",$r["triggered"],false),"field").
		    td($r["referer_start"]." / ".$r["referer_stop"],"field");

	    echo 
		tag_close("tr");
	}

    } else 
	table_row("No Alarms Found.","no_records_found", $fields);

    echo
	form_close().
	tag_close("tbody").
        table_close();

    adm_footer();
?>
