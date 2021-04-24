<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function select_general($control_name,$table,$where="(1=1)",$order = "id" ,$match_field = "id" ,$match_value, $show_field = "id", $size = 1, $add_data = NULL, $onchange = "") {
    $query = "Select $match_field as match_aux, $show_field as show_aux from $table where (1=1) and $where order by $order";
    //debug ($query);
    $result_aux = db_query ($query) or die ("Query failed - select_general($table) - ".db_error());
    
    if (!is_array($match_value)) $match_value=array($match_value);

    if (is_array($add_data)) $select_data = $add_data;
    else $select_data = array();
    
    while ($reg = db_fetch_array($result_aux)) 
	$select_data[$reg["match_aux"]]=$reg["show_aux"];
    
    unset ($result_aux);

    return select_custom($control_name, $select_data, $match_value,$onchange,$size);
}

function select_object ($obj_name, $control_name, $selected_values, $add_data = NULL, $match_field, $show_fields, $obj_params = NULL,$size = 1, $onchange = "", $ondblclick = "",$option_size = NULL) {
    
    $obj = $GLOBALS["jffnms"]->get($obj_name);
    
    //debug ($obj);
    //debug ($obj_params);
    $obj_data = call_user_func_array(array(&$obj,"get_all"),$obj_params);
    
    //debug ($obj_data);
    
    if (is_array($add_data)) $select_data = $add_data;
    else $select_data = array();

    if (!is_array($show_fields)) $show_fields=array($show_fields);
    
    foreach ($obj_data as $key=>$value) {
	unset($aux);
	foreach ($show_fields as $field_aux) 
	    $aux.=$value[$field_aux]. " ";
	$select_data[$value[$match_field]] = (is_numeric($option_size)?substr($aux,0,$option_size):$aux);
    }
    
    unset($obj_name);
    unset($obj_data);
    unset($obj_params);
    unset($obj);

    if ($size > 0)
	return select_custom($control_name, $select_data, $selected_values,$onchange,$size,0,"",$ondblclick);
    else
	return $select_data[$selected_values];
}

//INTERFACES

function select_interfaces ($name,$interface_id,$size = 1,$add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("interfaces",$name,$interface_id,$add_data,"id",array("client_shortname","interface","description"),$params,$size,$onchange);
} 

function select_interfaces_host ($name,$interface_id,$size = 1,$add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("interfaces",$name,$interface_id,$add_data,"id",array("host_name","zone_shortname","interface","description"),$params,$size,$onchange);
} 

function select_maps ($name, $map_id,$size = 1, $add_data = NULL, $onchange = "", $params = NULL) { //FIXME option to hide RootMap
    return select_object("maps",$name,$map_id,$add_data,"id","name",$params,$size,$onchange);
} 

function select_hosts ($name,$host_id,$size = 1, $add_data = NULL, $onchange = "", $char_size = 50) {
    return select_object("hosts",$name,$host_id,$add_data,"id",array("name","zone_description"),array(NULL,NULL,array("show_host=1")),$size,$onchange,"",$char_size);
}

function select_hosts_filtered ($name,$host_id,$size = 1, $add_data = NULL, $onchange = "", $filters = array()) {
    return select_object("hosts",$name,$host_id,$add_data,"id",array("name","zone_description"),array(NULL,$filters),$size,$onchange,"",50);
}

function select_clients ($name, $client_id, $size = 1, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("clients",$name,$client_id,$add_data,"id","name",$params,$size,$onchange);
}

function select_journal ($name,$journal_id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("journal",$name,$journal_id,$add_data,"id","subject",$params,1,$onchange);
}

function select_interface_types ($name,$type_id,$size = 1, $add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("interface_types",$name,$type_id,$add_data,"id","description",$params,$size,$onchange);
}

function select_triggers ($name,$trigger_id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("triggers",$name,$trigger_id,$add_data,"id","description",$params,1,$onchange);
}

function select_users ($name,$user_id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("users",$name,$user_id,$add_data,"id","fullname",$params,1,$onchange);
} 

function select_actions ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("actions",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_event_types ($name,$id,$size = 1,$add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("event_types",$name,$id,$add_data,"id",array("description"),$params,$size,$onchange);
} 

function select_event_types_alarms ($name,$id,$size = 1,$add_data = NULL, $onchange = "") {
    return select_object("event_types",$name,$id,$add_data,"id",array("description"),array(NULL,array("generate_alarm"=>1)),$size,$onchange);
} 

function select_zones ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("zones",$name,$id,$add_data,"id","zone",$params,1,$onchange);
} 

function select_severity ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("severity",$name,$id,$add_data,"id",array("level","severity"),$params,1,$onchange);
} 

function select_severity_level ($name,$id, $size, $add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("severity",$name,$id,$add_data,"level",array("level","severity"),$params,$size,$onchange);
} 

function select_profiles_options ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("profiles_options",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_satellites ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("satellites",$name,$id,$add_data,"id","description",array(NULL,2),1,$onchange);
} 

function select_satellites_groups ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    return select_object("satellites",$name,$id,$add_data,"id","description",array(NULL,1),1,$onchange);
} 

function select_hosts_config_types ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("hosts_config_types",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_graph_types ($name, $id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("graph_types",$name,$id,$add_data,"id",array("types_description","description"),$params,1,$onchange);
} 

function select_alarm_states ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("alarm_states",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_pollers ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("pollers",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_pollers_backend ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("pollers_backend",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_autodiscovery ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("autodiscovery",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_filters ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("filters",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_filters_fields ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("filters_fields",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_slas_cond ($name,$id, $add_data = NULL, $onchange = "", $params = NULL) {
    return select_object("slas_cond",$name,$id,$add_data,"id","description",$params,1,$onchange);
} 

function select_profiles_values ($name,$option_id, $value_id) {
    return select_object("profiles_values",$name,$value_id,$add_data,"value","description",array(NULL,array(option=>$option_id)),1,$onchange);
}

function select_interface_types_field_types ($name,$id,$add_data = NULL,$onchange = "", $params = NULL) {
    if ($id==1) $id = 8;
    return select_object("interface_types_field_types",$name,$id,$add_data,"id","description",array(NULL,1),1,$onchange);
} 

// FIXME CONVERT TO select_object

function select_slas ($name,$sla_id,$interface_type = 0) {
    if ($interface_type > 0) $filter = " and (interface_type = $interface_type or interface_type = 1) ";
    return select_general($name,"slas","(1=1) $filter","description","id",$sla_id,"description");
}

function select_pollers_groups ($name,$poller_group_id,$type = 0) {
    if ($type > 1) $type_filter = "and ((interface_type = '$type') or (id = 1))";
    $result = select_general($name,"pollers_groups","(1=1) $type_filter","description","id",$poller_group_id,"description");
    return $result;
}

    function select_alarm_duration($name, $value, $text = 0) {
	$alarm_duration_options = array(0=>"Default",300=>"5 Minutes",600=>"10 Minutes",1800=>"30 Minutes",3600=>"60 Minutes");

	if ($text==0)
	    return select_custom($name,$alarm_duration_options,$value);
	else 
	    return $alarm_duration_options[$value];
    }

    function select_triggers_types($name, $value, $text = 0) {
	$triggers_types_options = array("alarm"=>"Match Alarms","event"=>"Match Events");

	if ($text==0)
	    return select_custom($name,$triggers_types_options,$value);
	else
	    return $triggers_types_options[$value];
    }

    function select_show_rootmap($name, $value, $text = 0) {
	$show_rootmap_options = array(0=>"Dont Show",1=>"Show",2=>"Mark Disabled");

	if ($text==0)
	    return select_custom($name,$show_rootmap_options,$value);
	else 
	    return $show_rootmap_options[$value];
	    
    }

    function select_satellites_types($name,$value,$text = 0) {
	$satellite_types = array(0=>"Satellite",1=>"Master",2=>"Master Backup",3=>"Group",4=>"Client",5=>"Local Master");
	if ($text==0)
	    return select_custom($name,$satellite_types,$value);
	else 
	    return $satellite_types[$value];
    }

    function select_alarm_states_states($name, $value, $text = 0) {
	$alarm_states = array(ALARM_DOWN=>"Down",ALARM_UP=>"Up",ALARM_ALERT=>"Alert",ALARM_TESTING=>"Testing");

	if ($text==0)
	    return select_custom($name,$alarm_states,$value);
	else 
	    return $alarm_states[$value];
    }

    function select_trigger_operator($name,$value,$text = 0) {
	$trigger_op = array(
				"="=>"Equal to",
				"!="=>"Not Equal to",
				">"=>"Greater Than",
				"<"=>"Less Than",
				">="=>"Greater Than or Equal to",
				"<="=>"Less Than or Equal to",
				"IN"=>"In",
				"!IN"=>"Not In",
				"C"=>"Contains",
				"!C"=>"Not Contains"
			);

	if ($text==0)
	    return select_custom($name,$trigger_op,$value);
	else 
	    return $trigger_op[$value];
	    
    }

$trigger_fields = array(
    "event"=>array(
	"any"=>			array("name"=>"Any"),
    	"date"=>		array("name"=>"Hour",		"function"=>"select_hours",		"params"=>array()),
	"host_id"=>		array("name"=>"Host",		"function"=>"select_hosts",		"params"=>array(3)),
	"zone_id"=>		array("name"=>"Zone",		"function"=>"select_zones",		"params"=>array()),
	"type_id"=>		array("name"=>"Type",		"function"=>"select_event_types",	"params"=>array(3)),
	"text"=>		array("name"=>"Event Text",	"function"=>"textbox",			"params"=>array(30)),
	"interface_id"=>	array("name"=>"Interface",	"function"=>"select_interfaces",	"params"=>array(6)),
	"map"=>			array("name"=>"Interface Maps", "function"=>"select_maps",		"params"=>array()),
	"interface_client_id"=>	array("name"=>"Client", 	"function"=>"select_clients",		"params"=>array(3)),
	"none"=>		array("name"=>"None")
    ),
    "alarm"=>array(
	"any"=>			array("name"=>"Any"),
    	"date"=>		array("name"=>"Hour",		"function"=>"select_hours",		"params"=>array()),
	"type"=>		array("name"=>"Type",		"function"=>"select_event_types_alarms","params"=>array(3)),
	"duration"=>    	array("name"=>"Duration",	"function"=>"select_alarm_duration",    "params"=>array()),
	"active"=>		array("name"=>"State",		"function"=>"select_alarm_states",	"params"=>array()),
	"interface_host"=>	array("name"=>"Host",		"function"=>"select_hosts",		"params"=>array(3)),
	"interface_type"=>	array("name"=>"Interface Type",	"function"=>"select_interface_types",	"params"=>array(3)),
	"interface"=>		array("name"=>"Interface",	"function"=>"select_interfaces_host",	"params"=>array(6)),
	"map"=>			array("name"=>"Interface Maps", "function"=>"select_maps",		"params"=>array()),
	"interface_client_id"=>	array("name"=>"Client", 	"function"=>"select_clients",		"params"=>array(3)),
	"interface_interface"=> array("name"=>"Interface Name", "function"=>"textbox",                  "params"=>array(30)), 
	"none"=>		array("name"=>"None")
    )
);

    function select_trigger_fields($name,$value,$type,$text = 0) {
	global $trigger_fields;
	
	foreach ($trigger_fields[$type] as $key=>$aux)
	    $temp[$key]=$aux["name"];
	
	if ($text==0)
	    return select_custom($name,$temp,$value);
	else 
	    return $temp[$value];
	    
    }

    function select_trigger_fields_value($name,$value,$type,$field) {
	global $trigger_fields;
    
	if ((!$field) || ($field=="any") || ($field=="none")) 
	    return;
	else 
	    return call_user_func_array($trigger_fields[$type][$field]["function"],
		array_merge(array($name, $value), $trigger_fields[$type][$field]["params"]));
    }

    function select_action_parameters($name,$value,$field_struct,$text = 0) {
	
	$fields = array();
	$fields_final = array();
	$values = array();
	
	if (!empty($value)) $values = explode(",",$value);
	if (!empty($field_struct)) $fields = explode(",",$field_struct);	

	foreach ($values as $aux) {
	    list ($key,$value) = explode (":",$aux);
	    $values_final[$key]=$value;
	}
	
	foreach ($fields as $field) {
	    list ($key,$description) = explode (":",$field);
	    $fields_final[$key]=array(name=>$description,value=>$values_final[$key]);
	}

	if ($text==0) 
	    foreach ($fields_final as $key=>$data)
		$temp.=$data[name].": ".textbox($name."[$key]",$data[value],30)."<br>";
	else 
	    foreach ($fields_final as $key=>$data)
		$temp.=$data[name].": ".htmlspecialchars(substr($data[value],0,30))."<br>";	

	return $temp;
    }

    function select_hosts_dmii($name, $id, $host_id, $text = 0) {
    
	if ($text==0) {
	    global $jffnms;
	
	    $list[1]="None Set";
	    $aux = $jffnms->get("interfaces");
	    $list_int = $aux->get_all(NULL,array("host"=>$host_id));
	    unset($aux);

	    $aux = $jffnms->get("maps");
	    $list_map = $aux->get_all();
	    unset($list_map[1]);
	    unset($aux);
    
	    $list[]="";
	    $list[]="==== Host Interfaces ====";
	    foreach ($list_int as $key=>$data) 
		$list["I$key"]=$data["interface"]." ".substr($data["description"],0,30);
	    $list[]="";
	    $list[]="==== Maps ====";
	    foreach ($list_map as $key=>$data) 
		$list["M$key"]=$data["name"];
    
	    return select_custom($name,$list,$id);
	} else 
	    return (($id!=1)?"Set":"(None Set)");

    }

    function show_unix_date () {

	//Find the first numeric parameter
	$args = func_get_args();
	while (($unixtime = current($args)) && !is_numeric($unixtime) && ($aux = next($args)));
		
	if (is_numeric($unixtime) && ($unixtime!=0)) {
	    $result = date ("Y-m-d H:i:s",$unixtime);
	} else
	    $result = "Not Set";
    
	return $result;
    }
    
    function interface_value_control ($name, $value, $type = "text", $text = false) {

	switch ($type) {

	    case "bool" : //check box
		$result = ($GLOBALS["adm_view_type"]=="ascii")?(($value==0)?"O":"X"):checkbox($name, $value, !$text);
		break;
	
	    case "rrd_ds": // RRDTool DS
		$result = rrdtool_ds_control($name, $value, $text);
	        break;
		
	    case "text" : //text is the pseudo-default
	    default  :
		$result = ($text)?substr($value,0,20):textbox($name,$value,20);
	        break;
	}
	
	return $result;
    }
    
    function rrdtool_ds_control ($name, $value = "", $text = false) {

	list ($ds, $ds_name, $ds_type, $hb, $min, $max) = explode (":",$value);
	
	if ($max[0]=="<") { //variable
	    $auto_max = 1; 
	    $max_field = substr($max,1,strlen($max)-2);
	} else
	    $auto_max = 0;
	
	if (empty($min)) $min = 0;
	
	$ds_types = array("COUNTER"=>"Counter","GAUGE"=>"Gauge", "ABSOLUTE"=>"Absolute");
    
	if ($text)
	    $result = "Type: ".$ds_types[$ds_type]." Min: ".$min." ".(($auto_max==0)?"Max: ".$max:"Using ".$max_field." for Max");
	
	else {
    
	    if (!empty($value)) $result .= hidden($name,$value);
	    $result .= "Type: ".select_custom($name."[type]",$ds_types,$ds_type);
	    $result .= "Min: ".textbox($name."[min]",$min,5);

	    if ($auto_max==0) $result .= "Max: ".textbox($name."[max]",$max,10)." or ";

	    $result .= "Use ";
	    $result .= textbox ($name."[max_field]",$max_field,10);
	    $result .= " for Max: ".checkbox($name."[auto_max]",$auto_max,1);
	}
	
	return $result;
    }

    function select_interface_types_field_show ($name, $value, $text = false) {

	$show_options = array(0=>"Never",1=>"Always",2=>"Not in Discovery");

	if ($text==false)
	    return select_custom($name,$show_options,$value);
	else 
	    return $show_options[$value];
    }

    function select_events_show ($name,$value,$text = 0) {
	$show_options = array(0=>"Never",1=>"Always",2=>"Only when Filtering");
	if ($text==0)
	    return select_custom($name,$show_options,$value);
	else 
	    return $show_options[$value];
	    
    }

    function select_and_or ($name,$value,$text = 0) {
	$and_or_options = array(0=>"Or",1=>"And");
	if ($text==0)
	    return select_custom($name,$and_or_options,$value);
	else 
	    return $and_or_options[$value];
	    
    }

    function select_stop_continue ($name,$value,$text = 0) {
	$stop_continue_options = array(0=>"Continue",1=>"Stop this Trigger");
	if ($text==0)
	    return select_custom($name,$stop_continue_options,$value);
	else 
	    return $stop_continue_options[$value];
	    
    }

    function select_poll_interval ($name,$value,$text = 0) {
	$poll_interval_options = array(0=>"When Poller Runs");

	for ($i = 5; $i <= 60; $i += 5) 
	    $poll_interval_options[$i*60] = "Every $i Minutes";

	for ($i = 2; $i <= 24; $i ++) 
	    $poll_interval_options[$i*60*60] = "Every $i Hours";

	if ($text==0)
	    return select_custom($name,$poll_interval_options,$value);
	else 
	    return $poll_interval_options[$value];
    }

    function select_host_poll_interval ($name, $value, $text = 0) {
	$poll_interval_options = array();
	for ($i = 1; $i <= 60; $i++) 
	    $poll_interval_options[$i*60] = "Every ".$i." Minutes";

	if ($text==0)
	    return select_custom($name,$poll_interval_options,$value);
	else 
	    return $poll_interval_options[$value];
    }

    function select_nad_refresh ($name, $value, $text = 0) {
	$hour = 60*60;
	$nad_refresh_options = array(
	    $hour=>"Every Hour", $hour*3=>"Every 3 Hours",  $hour*6=>"Every 6 Hours", 
	    $hour*12=>"Every 12 Hours", $hour*24=>"Every 24 Hours", 
	    $hour*36=>"Every 36 Hours", $hour*48=>"Every 48 Hours");

	if ($text==0)
	    return select_custom($name,$nad_refresh_options,$value);
	else 
	    return $nad_refresh_options[$value];
    }

    function select_nad_deep ($name, $value, $text = 0) {
	$nad_deep_options = array(
	    1=>"1 - Just the specified Subnets",
	    2=>"2 - Include Subnets directly connected to the Seeds",
	    3=>"3 - Include Subnets 3 Hops away from the Seeds",
	    4=>"4 - Include Subnets 4 Hops away from the Seeds",
	    5=>"5 - Include Subnets 5 Hops away from the Seeds"
	    );

	if ($text==0)
	    return select_custom($name,$nad_deep_options,$value);
	else 
	    return $nad_deep_options[$value];
    }

    function action_dropdown ($name, $id, $actions, $selected_action = "") {
	
	foreach ($actions as $action=>$data)
	    if (is_array($data))
    		$actions_urls["&action=".$action."&actionid=".$id] = $data["name"];

	if (empty($selected_action)) $selected_action = current($actions_urls);

	$action_keys = array_keys($actions_urls);
	$action_sel = $action_keys[array_search_partial("action=$selected_action",$action_keys)];

	$result = 
	    select_custom($name.$id, $actions_urls, $action_sel, "javascript: go_action('".$name.$id."','".$name."_link".$id."')", 1, false, "action_dropdown").
	    linktext(
		image(get_config_option("jffnms_rel_path")."/images/bullet6.png"), 
		$GLOBALS["REQUEST_URI"].$action_sel,"","action_button","",$name."_link".$id);
		
	return $result;
    }
    
    function select_community ($name,$value,$text = 0) {
	return ((!empty($value))?"Set":"Not Set");
    }

    function select_op ($name, $value, $text = 0) {

	$filter_op = array(
	    "="=>"Equal to",
	    "!="=>"Not Equal to",
	    ">"=>"Greater Than",
	    "<"=>"Less Than"
	);
	
	if ($text==0)
	    return select_custom($name, $filter_op, $value);
	else 
	    return $filter_op[$value];
	    
    }

    function select_filter_option($name, $value, $field, $size = 1) {

	$fields = array (
	    "types.id"=>	array("function"=>"select_event_types",	"events_var"=>"type_id"),
	    "severity.level"=>	array("function"=>"select_severity_level","events_var"=>"severity_level"),
	    "hosts.id"=>	array("function"=>"select_hosts",	"events_var"=>"host_id"),
	    "zones.id"=>	array("function"=>"select_zones",	"events_var"=>"zone_id"),
	    "interfaces.id"=>	array("function"=>"select_interfaces",	"events_var"=>"interfaceid"),
	    "events.ack"=>	array("function"=>"checkbox",		"events_var"=>"ack")
	    );

	$aux = $fields[$field];

	if (is_array($aux)) {
	    if ($name) 
		return call_user_func_array($aux["function"], array($name, $value, $size));
	    else 
		return $aux["events_var"];
	} else 
	    return $value;
    }

    function select_usern ($name, $value, $text = 0) {

	if (($text==0) && ($GLOBALS["admin_users"]))	//if requesting text input and the user is admin
	    return textbox($name, $value, 20);
	else
	    return $value;
    }

    function select_color($name, $color, $modify) {

	return 
	    (($modify==1)?script("
	    
	    function popupColor(URL,option) {
		day = new Date();
		id = day.getTime();
		eval(\"color\"+id+\" = window.open(URL, '\" + id + \"', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=100,height=200');\");
		eval(\"color\"+id+\".opener = self; \");
		self.select = option;
	    }"):"").
	    tag("input", "", "", "style='background-color: #".$color."' type='text'".
		(($modify==1)?" id='".$name."' name='".$name."'":"").
		" value='".$color."' size='8'").

	    (($modify==1) 
		?linktext (image("color.png"),
		    "javascript:popupColor('".$GLOBALS["jffnms_rel_path"]."/admin/color_select.php?actual_color=".$color."','".$name."');")
		:"");
    }

    function select_date($name, $date, $cant, $show_hour = false,$hour_actual = 0, $onchange_hour =""){
	global $jffnms_rel_path;

	echo script (
"
    function popupCalendar(URL,option) {
	day = new Date();
	id = day.getTime();
	
	eval(\"calendar\"+id+\" = window.open(URL, '\" + id + \"', 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=215,height=185');\");
	eval(\"if (!calendar\"+id+\".opener) calendar\"+id+\".opener = self; \");

	self.dateselect = option;
    }
    
    function SetDate(option, date) {
	select = document.getElementById(option);
	select.options[select.options.length] = new Option(date, date);
	select.selectedIndex = select.options.length-1;
    }");

	$today = date("Y-m-d",time());

	if (strpos($date," ") > 0) $date = substr($date,0,10);
        if (!$date) $date = $today;
    
	$date_unix = strtotime($date);
    
	if ($date==$today) $date_unix -= 60*60*24;
    
	$select = "<select id='$name' name='$name' $onchange_select>\n";
	$select .="\t<option value='$today'>Today</option>\n";

	for ($i = 0; $i < $cant; $i++){
	    $day = date("Y-m-d",$date_unix-(3600*24*$i));

	    if ($day==$date) 
		$selected = " selected";
	    else 
		$selected="";

	    $select .="\t<option value='$day'$selected>$day</option>\n";
	}
    
	$last = Array();
        $aux = Array();
    
	$aux["date"] = date("Y-m-d",$date_unix-(60*60*24*7));
        $aux["name"] = "a Week Ago";
        $last[] = $aux;
    
        $aux["date"] = date("Y-m-d",$date_unix-(60*60*24*30));
        $aux["name"] = "a Month Ago";
        $last[] = $aux;
    
        $aux["date"] = date("Y-m-d",$date_unix-(60*60*24*350));
        $aux["name"] = "a Year Ago";
        $last[] = $aux;
    
        foreach ($last as $day) 
	    $select .="\t<option value='".$day["date"]."'>".$day["name"]."</option>\n";

        $select .= "\n</select><a href=\"javascript:popupCalendar('$jffnms_rel_path/admin/calendar.php?','$name')\">".
	    image("calendar.png")."</a>\n";

        if ($show_hour==true) 
	    $select.= select_hours($name."_hour",$hour_actual,$onchange_hour);
    
        return $select;
    }


    function select_hours($name,$actual,$onchange = NULL) {
	for ($i=0; $i < 24; $i++) {
	    $hours[(string)(60*(60*$i))]=str_pad($i,2,"0",STR_PAD_LEFT).":00";
	    $hours[(string)(60*((60*$i)+30))]=str_pad($i,2,"0",STR_PAD_LEFT).":30";
	}
	$hours[(60*60*24)]="24:00";
	
	if (!empty($actual) && (!isset($hours[$actual]))) 	//if a time is set, but its not round at 30 minutes
	    $hours[$actual] = substr(time_hms($actual),0,-3);	//add it

	return select_custom($name,$hours,$actual,$onchange);
    }

    function snmp_options ($name, $value = "", $text = false) {

	if (!empty($value) && ($value[2]!==":"))		// default
	    $value = "v1:".$value;	// SNMPv1

	list ($version, $community) = explode (":",$value);

	$snmp_versions = array(""=>"Not Set", "v1"=>"SNMPv1");

	if (get_config_option("os_type")=="unix") 	//only Unix has SNMPv2 support 
	    $snmp_versions["v2"] = "SNMPv2c";
	
	$snmp_versions["v3"] = "SNMPv3";

	$snmpv3_levels = array(
	    "noAuthNoPriv"=>"No Authentication, No Privacy",
	    "authNoPriv"=>"Authentication, No Privacy",
	    "authPriv"=>"Authentication and Privacy");

	$snmpv3_auth = array("md5"=>"MD5", "sha"=>"SHA");
	$snmpv3_priv = array("des"=>"DES", "aes128"=>"AES128");

	if ($text)
	    $result  = (empty($community)?"Not Set":"SNMP".$version." Set");
	
	else {
	    $result .= select_custom($name."[version]", $snmp_versions, $version);
	    
	    switch ($version) {
		case "v3":
		    list ($user, $level, $auth_protocol, $auth_key, $priv_proto, $priv_key) = explode("|", $community);
		    
		    $result .= select_custom($name."[level]", $snmpv3_levels, $level).br();
		    $result .= "User: ".textbox ($name."[user]", $user,10);
		    $result .= "Pass: ".textbox ($name."[pass]", $auth_key,10).br();
		    $result .= select_custom($name."[auth]", $snmpv3_auth, $auth_protocol);
		    $result .= select_custom($name."[priv]", $snmpv3_priv, $priv_proto);
		    $result .= "Key: ".textbox ($name."[priv_key]", $priv_key,10);
		break;
	
		case "v1":
		case "v2":
		default:
		    $result .= textbox($name."[community]", $community);
		break;
		
	    }
	}
	
	return $result;
    }
    
    function snmp_options_parse ($value) {
	if (is_array($value))
	    switch ($value["version"]) {
	        case "v1":
	        case "v2":
	    	    $value = $value["version"].":".$value["community"];
		break;
		    
		case "v3":
		    $value = $value["version"].":".
			    $value["user"]."|".$value["level"]."|".$value["auth"]."|".
			    $value["pass"]."|".$value["priv"]."|".$value["priv_key"];
		break;
		default:
		    $value = "";
		break;
	}
    }

?>
