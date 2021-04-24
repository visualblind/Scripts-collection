<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $clean_url_del_vars=Array("bulk_add_ids","bulk_add");
    include ("../../auth.php");
    
    if (!profile("ADMIN_HOSTS")) die (html("H1","You dont have Permission to access this page."));

    adm_header("Interfaces");

    echo script ("
    function check(field_aux) {
	field=document.forms[0].elements[field_aux];
	for (i = 0; i < field.length; i++) { 
	    if (field[i].checked==true) 
		field[i].checked = false; 
	    else	
		field[i].checked = true; 
	}
	return true;
    }
    ");

    unset($old_action);

    function show_header($fields,$sample_data = array(),$number_of_showable_fields = 0) {
    
	echo tr_open("","header");

	if (is_array($fields))
	foreach ($fields as $field_name=>$data) 
	    if ($data["showable"] > 0)
		switch ($field_name) {
		    case "action" :
			echo td ( (is_numeric($GLOBALS["type_id"])
			    ?linktext("View all Types",$GLOBALS["REQUEST_URI"]."&type_id=&action=")
			    :linktext($sample_data["type_description"],$GLOBALS["REQUEST_URI"]."&action=&type_id=".$sample_data["type"]))
			    ,"type_filter");
		        break;
    		    case "row_filler":
			$rows = $data["max"]-$number_of_showable_fields;
			if ($rows > 0)
			    echo td("&nbsp;","row_filler","",$rows);
			break;
		    default: 
			echo td($data["description"],"field","field_".$field_name);
		}

	echo tag_close("tr");
    }

    function show_values ($fields,$values,$edit = 0, $ids = array(),$cant = 1, $number_of_showable_fields = 0) {
    
	if (is_array($fields))
	foreach ($fields as $field_name=>$data) if ($data["showable"] > 0) {
	
	    if (isset($values[$field_name]))
		$value = htmlspecialchars($values[$field_name]);
	    else
		$value = $data["default_value"];

	    unset ($content);

	    switch ($field_name) {
		case "action" :
		    if ($cant != 0) {
		        if ($edit) 
			    echo td (adm_standard_submit_cancel("Save","Discard"), "action");
			else
			    echo adm_standard_edit_delete($values["id"],false);
		    } else
		    	    $content = adm_form_submit().br().
				radiobutton("action",$GLOBALS["action_select"]["update"],"update")."Update";
		    break;
    		
		case "id" :
		    if ($cant != 0) { 
			if ($edit)
			    $content = checkbox_value("actionid[]",$value,1)." ".$value;
			else {
			    $check = ((in_array($value,$ids) or ($cant==1))?1:0);
			    $content = checkbox_value("actionid[]", $value, $check)." ".$value;
		        }
		    } else
		    	$content = checkbox_value("","",false,true, "this.value=check('actionid[]');")." All".br();

		    break;

		case "host":
		    $content = ($edit)
			?select_hosts("host",$value)
			:$values["host_name"]." ".$values["zone_shortname"];
		    break;

		case "type": 
		    $content = ($edit)
			?select_interface_types($field_name,$value)
			:$values["type_description"];
		    break;

		case "poll": 
		    $content = ($edit)
			?select_pollers_groups($field_name,$value,$values["type"])
			:$values["poller_group_description"];
		    break;

		case "interface": 
		    $content = ($edit)
			?textbox($field_name,$value,20)
			:$values["interface"];
		    break;

		case "client": 
		    $content = ($edit)
			?select_clients($field_name,$value)
	    		:$values["client_name"];
		    break;
		
		case "sla": 
		    $content = ($edit)
			?select_slas($field_name,$value,$values["type"])
			:$values["sla_description"];
		    break;
		
		case "check_status": 
		case "make_sound": 
		    $content = ($edit)
			?checkbox($field_name,$value)
			:checkbox($field_name,$value,0);
		    break;

		case "show_rootmap":
		    $content = select_show_rootmap($field_name,$value,!$edit);
		    break;

    		case "row_filler":
		    $rows = $data["max"]-$number_of_showable_fields;
		    
		    if ($rows > 0)
		        echo td("&nbsp;","row_filler","",$rows);
		    break;
		
		case "poll_interval": 
		    $content = select_poll_interval($field_name,$value,!$edit);
		    break;

		case "creation_date" :
		case "modification_date" :
		case "last_poll_date" :

		    $content = ($cant!=0)
			?show_unix_date($values[$field_name])
			:"&nbsp;";
		    break;
		    		
		default: 
		    switch ($data["type_handler"]) {

			case "bool" : //check box
			    $content = checkbox($field_name,$value,$edit);
			    break;
			    
			case "text" : //text is the pseudo-default
			default  :
			    $content = ($edit && ($data["overwritable"]==1))
				?textbox($field_name,$value,20)
				:$value;
			    break;
		    }
	    	
	    }

	    if (isset($content))
	        echo td($content, "field", "field_".$field_name);
	    
	    if (($edit==1) && ($cant!=0) && ($data["overwritable"]==1)) //normal one interface edit
		echo hidden("update_fields[]",$field_name);

	}
    
    }

    function show_multiple_edit_boxes ($fields, $number_of_showable_fields) {
    	if (is_array($fields)) {
	    foreach ($fields as $field_name=>$data) if ($data["showable"] > 0) {
		unset ($content);
		$rows = 1;
		
		switch ($field_name) {
		    case "action" :
			$content = radiobutton("action",$GLOBALS["action_select"]["delete"],"delete")."Delete";
			break;
			
		    case "id": 
		        $content = "Multiple".br()."Edit";
			break;

		    case "row_filler":
			$rows = $data["max"]-$number_of_showable_fields;
		
		    case "creation_date" :
		    case "modification_date" :
		    case "last_poll_date" :
		        if ($rows > 0)
			    $content = "&nbsp;"; 
			break;
			
		    default:
			$content = ($data["overwritable"]==1)
			    ?checkbox_value("update_fields[]",$field_name,0)
			    :"&nbsp;";
		}
	    
		if (!empty($content))
		    echo td ($content, "field", "field_".$field_name, $rows);
	    }
	}
    }
    
    $fields_init = array (
	"action"	=>array("description"=>"Action", 				"showable"=>1,	"overwritable"=>0),
	"id"		=>array("description"=>"ID", 					"showable"=>1,	"overwritable"=>0),
	"host"		=>array("description"=>"Host",		"default_value"=>1, 	"showable"=>1,	"overwritable"=>1),
	"type"		=>array("description"=>"Type", 		"default_value"=>1, 	"showable"=>0,	"overwritable"=>1),
	"interface"	=>array("description"=>"Interface Name", 			"showable"=>1,	"overwritable"=>1)
    );
    
    $fields_end = array (
	"row_filler"	=>array("description"=>"Row Filler", 				"showable"=>1,	"overwritable"=>0),
	"client"	=>array("description"=>"Customer", 	"default_value"=>1, 	"showable"=>1,	"overwritable"=>1),
	"poll"		=>array("description"=>"Poller Group", 	"default_value"=>1, 	"showable"=>1,	"overwritable"=>1),
	"check_status"	=>array("description"=>"Check Status", 	"default_value"=>1, 	"showable"=>1,	"overwritable"=>1),
	"sla"		=>array("description"=>"SLA", 		"default_value"=>1, 	"showable"=>1,	"overwritable"=>1),
	"make_sound"	=>array("description"=>"Enable Sound?", "default_value"=>0, 	"showable"=>1,	"overwritable"=>1),
	"show_rootmap"	=>array("description"=>"Show", 		"default_value"=>0, 	"showable"=>1,	"overwritable"=>1),
	"poll_interval" =>array("description"=>"Polling Interval", "default_value"=>0, 	"showable"=>1,	"overwritable"=>1),
	"creation_date"	=>array("description"=>"Creation Date", 			"showable"=>1,	"overwritable"=>0),
	"modification_date"=>array("description"=>"Modification Date", 			"showable"=>1,	"overwritable"=>0),
	"last_poll_date"=>array("description"=>"Last Poll Date", 			"showable"=>1,	"overwritable"=>0)
    );	


    $api = $jffnms->get("interfaces");

    if (!$action)     $action_select["update"] = 1;
	else $action_select[$action] = 1;

    if (!$filter && $host_id) $filter = $host_id;

    if (!$add_to_map_id) $add_to_map_id = 1;
    
    if (!isset($actionid) && isset($interface_id)) $actionid = $interface_id; //for Manual Discovery filter and edit in one step
    if (!is_array($actionid)) $actionid=array("$actionid");

    if ($action=="add") {
	if (!$host_id) $host_id = 1; 

	$aux = $api->add($host_id);
	$actionid=array($aux);
	$interface_id = $aux;
	
	$action="edit";
	$old_action = "add";
    }

    if ($action=="update") {

	if (is_array($update_fields))
	    foreach ($update_fields as $field) 
		$data[$field]=trim($$field); 

	if (is_array($data) && (is_array($actionid))) 
	    foreach ($actionid as $id) 
		if (is_numeric($id)) 
		    $api->update($id,$data);

	$action="list";
    }

    if ($action=="bulkadd") {
	if (is_array($bulk_add_ids) && is_array($bulk_add)) { 
	    while (list($key,$data) = each ($bulk_add))
		if (in_array($key,$bulk_add_ids)) {
		    $aux_id = $api->add(array("host"=>$data["host"],"type"=>$data["type"])); //add
		    $result = $api->update($aux_id,$data); //update
		    $use_interfaces[]=$aux_id; //filter interfaces
		    $actionid[]=$aux_id; //mark interfaces
		}
	    if (count($bulk_add_ids)==1) 
		$action = "edit";
	    else
		$action = "list";
		
	    $action_select["update"]=1;
	    clean_url(array("use_interfaces"=>$use_interfaces),$clean_url_del_vars);
	    unset($bulk_add_ids);
	    unset($bulk_add);
	}
    }

    if ($action=="delete") {
	if (is_array($actionid)) 
	    foreach ($actionid as $id) 
		if (is_numeric($id)) 
		    $api->delete($id);
	$action="list";
    }

    if (($action=="map") && ($add_to_map_id > 1)) {
	$map = $jffnms->get("maps_interfaces");
	$map_list = $map->get_all($add_to_map_id);

	if (is_array($actionid)) 
	    foreach ($actionid as $id) 
		if (is_numeric($id)) {
		    $ok = 1;
		    foreach ($map_list as $aux) 
			if ($aux["interface"]==$id) $ok = 0; 

		    if ($ok==1) $map->add($add_to_map_id,$id);
		}
	unset($map);
	$action="list";
    }

    if (is_array($use_interfaces)) 
	if (!$_SERVER["QUERY_STRING"]) $interfaces_url = "&use_interfaces[]=".join("&use_interfaces[]=",$use_interfaces);

    $max_fields = 50;

    $filters = reports_make_interface_filter();
    $filters["with_field_type"] = 1;
    if (isset($filter)) $filters["host"] = $filter;
    $cant = $api->get($use_interfaces, $filters);

    echo adm_table_header("Interfaces", $init, &$span, $max_fields, $cant, "admin_interfaces", false);

    if ($cant > 0) {
	$types_fields = $api->fetch();
	$cant--;

	foreach ($types_fields as $it=>$fds) 
	    foreach ($fds as $fd) if ($fd["showable"] > 0) $num_fields[$it]++;

	$fields_end["row_filler"]["max"] = (is_array($num_fields))?max($num_fields):0;
	
	unset ($it);
	unset ($fds);
	unset ($fd);
	
        $api->slice($init,$span);
	
	$old_interface_type = 0;
	$number_of_types = 0;
	
	echo 
    	    adm_form("update", "POST", "_self", false).
	    reports_pass_options();

	while ($register = $api->fetch()) {

	    if ($register["type"]!=$old_interface_type) {
		echo tag ("tbody","itype_".$register["type"]);	
	    
		$type_fields = array_merge($fields_init,
		    (is_array($types_fields[$register["type"]])?$types_fields[$register["type"]]:array()),    
		    $fields_end);
	
		show_header ($type_fields, $register,$num_fields[$register["type"]]);
		$row = 0;
		
		$old_interface_type = $register["type"];
		$number_of_types++;
	    }
	
	    if ((in_array($register["id"],$actionid)) && ($action=="edit")) 
		$edit = 1;
	    else 
		$edit = 0;

	    echo tr_open("row_".$register["id"],($edit)?"editing":((($row++%2)!=0)?"odd":""));

	    show_values ($type_fields,$register,$edit,$actionid,$cant,$num_fields[$register["type"]]);

	    echo tag_close("tr");
	}
	echo tag_close("tbody");
	
	
	if (($action!="edit") && ($cant > 1)) { //multiple editor

	    if ($number_of_types > 1) {
		$multiple_edit_fields = array_merge($fields_init, $fields_end);
		unset ($old_interface_type); //to show all field types (sla, poll)
	    } else 
		$multiple_edit_fields = $type_fields;


	    table_row("&nbsp;","",$max_fields);
	    
	    echo tr_open("multi_editor");

	    show_values ($multiple_edit_fields,array("type"=>$old_interface_type),1,0,0,$num_fields[$old_interface_type]);

	    echo 
		tag_close("tr").
		tr_open("multi_editor_checkboxes");
	
	    show_multiple_edit_boxes($multiple_edit_fields,$num_fields[$old_interface_type]);
	    
	    echo tag_close("tr");
	}
	
	if ($cant > 0) { //if theres an interface listed

	    if ($action!="edit") //if we are in edit mode
		echo 
		    tr_open ("options").
		    td ((($cant == 1) //if the other option arent showing, show a Submit button
			    ?adm_form_submit("Add To Map").br().hidden("action","map")
			    :radiobutton("action",$action_select["map"],"map")."Add to Map:".br())
			,"field","add_to_map").
		
		    td(select_maps("add_to_map_id",$add_to_map_id),"field","add_to_map_select",2).
		    td(linktext("View Map", $jffnms_rel_path."/admin/adm/adm_standard.php?admin_structure=maps_interfaces&filter=".$add_to_map_id),
			"field","view_map");
		    td("&nbsp;","row_filler","",$max_fields-5).
		    tag_close("tr");
	
	    //Shortcuts
	    echo 
		tr_open("shortcuts").
		td(linktext(image("graph.png","","","Performance").
		    " Performance",$jffnms_rel_path."/view_performance.php?".$_SERVER["QUERY_STRING"].$interfaces_url),
		    "","",2).
		td(linktext(image("text.png","","","Report").
		    " Report",$jffnms_rel_path."/admin/reports/state_report.php?".$_SERVER["QUERY_STRING"].$interfaces_url)).
		td(linktext(image("text.png","","","Alarms").
		    " Alarms",$jffnms_rel_path."/admin/adm/adm_alarms.php?".$_SERVER["QUERY_STRING"].$interfaces_url)).
		td("&nbsp;","row_filler","",$max_fields-4).
		tag_close("tr");
	}
    } else 
	table_row("No Interfaces Found","no_records_found",$max_fields);
    
    echo 
	table_close().
	form_close();

    adm_footer();
?>
