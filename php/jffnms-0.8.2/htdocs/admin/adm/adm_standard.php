<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php"); 
    include ("structures.php");

    $st = $structure;
    $st_name = $admin_structure;
    
    $admin_users = profile("ADMIN_USERS");
    
    clean_url(array(),array_keys($st["fields"])); //clear the REQUEST_URI with my fields

    if (!isset($adm_view_type)) $adm_view_type = "html";
    if ($adm_view_type!="html") $action = "list";


    if ($st["profile"]) {	//Authorization
	if (!$st["deny"]) 
	    $st["deny"]="You dont have Permission to access this page.";

	if (!profile($st["profile"])) die ("<H1>".$st["deny"]."</H1></HTML>");
    }
    
    if (!$st["no_records_message"]) $st["no_records_message"] = "No Records Found";

    if (isset($st["include"]))
	include_once("adm_".$st["include"].".inc.php");

    $api = $jffnms->get($st["object"]);

    if (function_exists($st_name."_action_".$action))
	call_user_func_array($st_name."_action_".$action, array($actionid));

    switch ($action) {
    
	case "list":
	    unset ($actionid);
	    break;
    
	case "view":
	    if ($structure["action_type"]==2) 
		adm_frame_menu_split($structure["split"],$structure["split_standard"]);
	    break;
    
	case "update" :

	    if ($actionid=="new") { 
		if (!$st["disable_add"]) 
		    $actionid = $api->add((($st["filter_by_user"] && !$admin_users)?$auth_user_id:$filter));
		else 
		    die ("Add not Allowed");
	    }
	    
	    foreach($st["fields"] as $field_name=>$field_data) 
		if ($field_name!=="") {
		    switch ($field_data["type"]) { 

			case "checkbox": 	
			    if (!isset($_POST[$field_name])) $_POST[$field_name]=0; 
			break;

			// FIXME This is not right			
			case "select"   : 	
			    if (($field_data["params"] > 1) && (is_array($_POST[$field_name]))) { //size > 1 and array result
				foreach ($_POST[$field_name] as $key=>$aux_value) 
				    if ($aux_value > 1) {
	    				if ($key==0) //Why ???
					    $api->update($actionid,array($field_name=>$aux_value));
					else 
					    $api->add($filter,$aux_value);
				    }
				    $field_name="";
			    }
			break;
		    }
		
		    if (($st["filter_by_user"]) && ($field_name==$st["filter_by_user"]) && !$admin_users) 
			$_POST[$field_name]=$auth_user_id; //filter by user

		    if ($field_name && (isset($_POST[$field_name]))) 
			$data[$field_name] = is_string($_POST[$field_name])
			    ?trim($_POST[$field_name])
			    :$_POST[$field_name];
		}
	    //debug ($data);
	    //debug ($actionid);
	    
	    $api->update($actionid, $data);
	    $action="list";
	    break;

	case "delete":
	    
	    if (isset($st["profile"]) && !isset($st["filter_by_user"]))
		$api->delete($actionid);
	
	    $action="list";
	    break;

	case "add":

	    $record = $api->get_empty_record();

	    if (isset($st["add_filter_field"]))
		$record[$st["add_filter_field"]] = $filter;
		
	    if (isset($st["filter_field"]))
		$record[$st["filter_field"]] = $filter;

	    $record["id"] = "new";
	    
	    foreach ($record as $field_name=>$aux) 
		if (isset($_REQUEST[$field_name]))
		    $record[$field_name]=$_REQUEST[$field_name];

	    $records = array($record);
	    $actionid = $record["id"];
	    unset ($filter_field);
	    unset ($filter_value);
	    unset ($record);

	case "edit":     
	    $editid = $actionid;
	    break; 
	
	default:
	    $action = "list";

    } // switch action
    
    // Main Code

    $init = round($init);
    $span = round($span);

    // Rows Number
    $rows = 0;
    $rows += 1; //action

    if ($st["show_id"])	//add ID Field
	$st["fields"] = array_merge(array("id"=>array("name"=>"ID", "type"=>"id")), $st["fields"]);

    $rows += count($st["fields"]);

    if ($actionid!="new") {
	// OLD Filter handling 

	if (isset($st["filter_field"])) 
	    $records = $api->get_all(NULL,array($st["filter_field"]=>$filter));
	else 
	    $records = $api->get_all($filter);
    }

    if (($action=="list") && ($adm_view_type=="html")) {
	// Filters
    
	// Get Filters Values
	while (list ($field, $data) = each ($st["fields"]))
	    if (($data!=NULL) && ($data["filter"]!==false))
		$filter_fields[$field]=(isset($data["view"])?$data["view"]:$field);

	$field_values = $api->field_values($filter_fields);

	// Render Filters HTML
	while (list($field, $values) = each ($field_values))
	    if (count($values) > 2)
		switch ($st["fields"][$field]["type"]) {

		    case "checkbox":
			$filters[$field] = select_custom ("filter_".$field, array(""=>"", "0"=>"Not Set", "1"=>"Set"), 
			    "-1"," javascript: filter(this);", 1, false, "filter");
		    break;
	
		    case "colorbox":
			//Disable Color Box Filter
		    break;
			
		    case "select":
			//Selects that does not have a View field (ie not from DB, like show_rootmap)
	    		//$filters[$field] = call_user_func_array($st["fields"][$field]["func"], array($field,$record[$field_name])); 
			if (!isset($st["fields"][$field]["view"])) break;
		    
		    default:
			if ($field!="description")
			    $filters[$field] = select_custom ("filter_".$field, $values, 
				(($field==$filter_field)?$filter_value:"")," javascript: filter(this);", 1, false, "filter");
		    break;
		}
    } //if its not new record or edit

    //Filter the Records
    if (!empty($filter_field) && ($filter_value!==""))
        $records = array_record_search(&$records, $filter_field, $filter_value);

    // SORT Records
    if (!isset($sf) || !isset($so)) {
	if (isset($st["default_sort_field"])) 
	    $sf = $st["default_sort_field"];

	if (isset($st["default_sort_order"])) 
	    $so = $st["default_sort_order"];
    }
    
    if (isset($sf) && isset($so))
	array_key_sort(&$records, array($sf=>(($so=="asc")?SORT_ASC:SORT_DESC)));

    
    //debug ($records);
    $cant = count($records);

    $adm_table_header = adm_table_header($st["title"], $init, &$span, $rows, $cant, "admin_".$admin_structure, ($st["disable_add"]?false:true));

    if ($adm_view_type=="html") {
	//Draw Header
	adm_header($st["title"]);
	
	echo $adm_table_header;
    
	if ($st["action_type"]==3) 
	    echo script ("
	function go_action(select_name, link) {
    	    field = document.getElementById(link);
	    if (field) {
    		select = document.getElementById(select_name);
    		value = select.options[select.selectedIndex].value;
    		field.href = '".$REQUEST_URI."'+value;
	    }
        }");

	echo script ("
	function filter (select) {
	    field = select.name.substr(7);
    	    value = select.options[select.selectedIndex].value;
	    location.href = '".$REQUEST_URI."' + '&action=list&init=0&filter_field=' + field + '&filter_value=' + value;
	}

	function toggle_filter(field) {
	    filter_field = document.getElementById('filter_'+field);
	    
	    filter_field.style.visibility = ((filter_field.style.visibility=='visible')?'hidden':'visible');
	}");

	echo 
	    tag("tr","","header").
    	    td ("Action", "field", "action");
    }
    
    //show only the init and span the user asked for
    if (($cant > 0) && ($actionid!="new"))
	$records = array_slice($records,$init,$span);


    foreach ($st["fields"] as $field_name=>$field_data) 
	if (is_array($field_data) && ($field_data["type"]!="hidden"))

	    switch ($adm_view_type) {
	    
		case "html": 
		    echo td(
			//ordering
			(($action=="list")
			    ?linktext($field_data["name"],
			    $REQUEST_URI."&action=list&sf=".$field_name."&so=".((($sf==$field_name) && ($so=="asc"))?"desc":"asc")
			    ,"","field")
			    :$field_data["name"]).
			//filter
			((($field_data["filter"]!==false) && ($field_name!=="id") && 
		    	($action=="list") && (isset($filters[$field_name])))
			    ?"&nbsp;".linktext( image("filter3.png"),"javascript: toggle_filter('".$field_name."');").
				"&nbsp;".$filters[$field_name]
			    :""),
			"field","field_".$field_name);
		    break;

		case "ascii":
		    $ascii["fields"][$field_name]=$field_data["name"];
		    break;
	    }

    if ($adm_view_type=="html") {
	echo 
	    tag_close("tr").
	    tag("tbody");
    }
    
    $shown = 0;

    if ($cant > 0) {
	while (list(, $record) = each($records))
	    if ((($st["hide_record_one"]==0) || ($record["id"] > 1) || ($record["id"]=="new")) && 	//hide record number 1, allow new record

		(!isset($st["filter_by_user"]) || 							//filter by user is not set or
		    ($record[$st["filter_by_user"]]==$auth_user_id) || 					//filter-by-user-record = logged in user
		    ($admin_users && (empty($filter) || ($record[$st["filter_by_user"]]==$filter))) 	//is admin and filter not set or filter matches
		) 
	       ) {
	    //debug ($record);
	    
	    $shown++;

	    if ($adm_view_type=="html")
		echo tr_open("row_".$record["id"],(($editid==$record["id"])?"editing":((($row++%2)!=0)?"odd":"")));

	    if ($editid!=$record["id"])  {
		
		if ($adm_view_type=="html") {
		    if ($st["action_type"]!=3)
			echo adm_standard_edit_delete($record["id"],(($structure["action_type"]==2)?$structure["split_view_name"]:false));
		    else
			echo td (action_dropdown("action_host", $record["id"], $st["actions"], $_GET["action"]), "action");
		}
		
		if ($adm_view_type=="ascii")
		    $ascii["data"]["id"][$record["id"]]=$record["id"];
			
		foreach ($st["fields"] as $field_name=>$field_data)
		    if ($field_name) {
			unset ($control_value);
			
			switch ($field_data["type"]) {
			    case "id":
				$control_value = ($adm_view_type=="html")
				    ?linktext($record[$field_name], $REQUEST_URI."&action=list&init=0&filter=".$record[$field_name],"","field_id")
				    :$record[$field_name];
			    break;
			
			    case "memobox": 
			    case "textbox": 
				$control_value = ($adm_view_type=="html")
				    ?htmlspecialchars(substr($record[$field_name],0,$field_data["size"]))
				    :$record[$field_name];
				break;

			    case "checkbox": 
				$control_value = ($adm_view_type=="html")
				    ?checkbox($field_name,$record[$field_name],0)
				    :(($record[$field_name]=="0")?"O":"X"); 
				break;

			    case "select": 

			    	if (!is_array($field_data["params"])) $field_data["params"] = array();
			    	if (!is_array($field_data["view_params"])) $field_data["view_params"] = array();
			
				if (isset($field_data["params_field"])) {
				    if (!is_array($record[$field_data["params_field"]])) 
					$params_field = array($record[$field_data["params_field"]]);
				    else
					$params_field = $record[$field_data["params_field"]];
				} else
				    $params_field = array();
				
				if (isset($field_data["view"]))
				    $control_value = (isset($record[$field_data["view"]])
					?(($adm_view_type=="html")
					    ?htmlspecialchars(substr($record[$field_data["view"]],0,$field_data["size"]))
					    :$record[$field_data["view"]])
				
					:$field_data["view"]);
				else {
				    $view_function = (isset($field_data["view_func"])?$field_data["view_func"]:$field_data["func"]);
				
				    $params = array_merge(
					    array($field_name,$record[$field_name]),
					    $params_field,
					    $field_data["params"],
					    $field_data["view_params"]);

				    //debug ($view_function);
				    //debug ($params);
					     
				    $control_value = call_user_func_array ($view_function, $params);
				}
				
				break;
			    
			    case "colorbox":
				$control_value = ($adm_view_type=="html")
				    ?select_color($field_name,$record[$field_name],0)
				    :"#".$record[$field_name]; break;
			
			    default:
				if ($field_data["type"]!="hidden")
				    $control_value = $record[$field_name]; 
				break;
			} //switch
			
			if ($adm_view_type=="html")
			    echo td ($control_value, "field","field_$field_name");

			if ($adm_view_type=="ascii")
			    $ascii["data"][$field_name][$record["id"]]=$control_value;
			
		    } //foreach-if

	    } else { //edit
		
		adm_form("update");

		echo td (adm_standard_submit_cancel("Save","Discard"), "action");
		
		if (is_array($st["hidden_fields"]))
		    foreach ($st["hidden_fields"] as $hidden_field)
			echo hidden ($hidden_field,$record[$hidden_field]);

		foreach ($st["fields"] as $field_name=>$field_data) 
		    if ($field_name) {
			unset ($control_value);
			switch ($field_data["type"]) {
			    case "textbox": 
				$control_value = textbox($field_name,$record[$field_name],$field_data["size"]); break;
			    
			    case "memobox": 
				$control_value = memobox($field_name,$field_data["height"],$field_data["width"],$record[$field_name]); break;

			    case "checkbox": 
				$control_value = checkbox($field_name,$record[$field_name],1); break;
	
			    case "select": 

				    // Don't execute Selects with params fields on new records
				    if (($record["id"]!="new") || !isset($record[$field_data["params_field"]])) {

			    		if (!is_array($field_data["params"])) $field_data["params"] = array();
				    
					if (isset($field_data["params_field"])) {
					    if (!is_array($record[$field_data["params_field"]])) 
						$params_field = array($record[$field_data["params_field"]]);
					    else
						$params_field = $record[$field_data["params_field"]];
					} else
					    $params_field = array();
					
					$aux_param = array_merge(array($field_name,$record[$field_name]),$field_data["params"],$params_field);
					//debug ($aux_param);
					
				        $control_value = call_user_func_array($field_data["func"],$aux_param); 
				    } else
					$control_value = "Not Available";
					
				    break;
		
			    case "colorbox": 
				$control_value = select_color($field_name,$record[$field_name],1); break;
				
			    case "hidden": 
				$control_value = hidden($field_name,$record[$field_name]); break;

			    default:
				if ($field_data["type"]!="hidden")
				    $control_value = $record[$field_name]; 
				break;
			} //switch
		    
			echo td ($control_value, "field_$field_name");
		    } //foreach-if

		echo form_close();
	    } //edit
	    
	    if ($adm_view_type=="html")
		echo tag_close("tr");
	    
	    if (function_exists($st["after_record_function"]))
	    	call_user_func_array($st["after_record_function"], array($record));

	} //while 
    } // cant
    
    if ($shown==0)
	if ($adm_view_type=="html")
	    table_row($st["no_records_message"],"no_records_found", $rows);
    
    if ($adm_view_type=="html") {
	echo 
	    tag_close("tbody").
	    table_close();

	adm_footer();
    }

    // ASCII Table Draw    
    if (($adm_view_type=="ascii") && (is_array($ascii))) {
	echo header("Content-Type: text/plain");
	
	$ascii_table = array();
	
	while (list($field, $name) = each ($ascii["fields"])) {
	    if (is_array($ascii["data"][$field]))
	    foreach ($ascii["data"][$field] as $data)
		$max_size[$field] = (strlen($data) > $max_size[$field])?strlen($data):$max_size[$field];
	    
	    $max_size[$field] = (strlen($name) > $max_size[$field])?strlen($name):$max_size[$field];
	    
	    $ascii_table[0] .= "-+-".str_repeat("-",$max_size[$field]);
	    $ascii_table[1] .= " | ".str_pad($name, $max_size[$field]," ");
	}
	
	$ascii_table[0] .= "-+";
	$ascii_table[1] .= " |";
	$ascii_table[3] = $ascii_table[0];
	
	if (is_array($ascii["data"])) {
	    $id_field = current(array_keys($ascii["data"]));
	
	    foreach ($ascii["data"][$id_field] as $id) {
		$row++;
		foreach ($ascii["fields"] as $field=>$aux)
		    $ascii_table[(3+$row)] .= " | ".str_pad($ascii["data"][$field][$id], $max_size[$field]," ");
	
		$ascii_table[(3+$row)] .= " |";
	    }
	    $ascii_table[] = $ascii_table[0];
	}
	foreach ($ascii_table as $data)
	    echo substr($data,1)."\n";
    }
?>
