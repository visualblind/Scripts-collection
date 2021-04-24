<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $structures["zones"] = array(
	"title"=>"Zones",
	"object"=>"zones",
	"show_id"=>1,
	"profile"=>"ADMIN_HOSTS",

	"action_type"=>2,
	"split"=>"nad",
	"split_standard"=>0,
	"split_view_name"=>"Discovered Networks",

	"fields"=>array(
	    "zone"=>array(	"name"=>"Zone",		"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "shortname"=>array(	"name"=>"ShortName",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "image"=>array(	"name"=>"Image",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "show_zone"=>array(	"name"=>"Visibility",	"type"=>"select",	"func"=>"select_show_rootmap", "view_params"=>array(1), "size"=>30),

	    "admin_status"=>array("name"=>"Network Discovery Enabled",	"type"=>"checkbox"),
	    "seeds"=>array(	"name"=>"Network Discovery Seeds CIDR",	"type"=>"textbox",	"size"=>60),
	    "allow_private"=>array("name"=>"Allow Private IPs",		"type"=>"checkbox"),
	    "communities"=>array("name"=>"SNMP Communities CSV",	"type"=>"textbox",	"size"=>60),
	    "max_deep"=>array(	"name"=>"Max Hops to scan",		"type"=>"select",	"func"=>"select_nad_deep", "view_params"=>array(1)),
	    "refresh"=>array(	"name"=>"Re-Scan",			"type"=>"select",	"func"=>"select_nad_refresh", "view_params"=>array(1)),
	    NULL)
	);

    $structures["graph_types"] = array(
	"title"=>"Graph Types",
	"object"=>"graph_types",
	"show_id"=>1,
	"hide_record_one"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",		"type"=>"textbox",	"size"=>20),
	    "type"=>array(		"name"=>"Interface Type",	"type"=>"select",	"func"=>"select_interface_types", "view"=>"types_description", "size"=>30),
	    "allow_aggregation"=>array(	"name"=>"Allow Aggregation",	"type"=>"checkbox"),

	    "graph1"=>array(	"name"=>"Graph 1",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "sizex1"=>array(	"name"=>"Width 1",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "sizey1"=>array(	"name"=>"Height 1",	"type"=>"textbox",	"size"=>20, "filter"=>false),

	    "graph2"=>array(	"name"=>"Graph 2",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "sizex2"=>array(	"name"=>"Width 2",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "sizey2"=>array(	"name"=>"Height 2",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    NULL)
	);

    $structures["clients"] = array(
	"title"=>"Customers",
	"object"=>"clients",
	"show_id"=>1,
	"hide_record_one"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_HOSTS",

	"fields"=>array(
	    "name"=>array(	"name"=>"Customer Name",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "shortname"=>array(	"name"=>"Customer ShortName",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "username"=>array(	"name"=>"Username",		"type"=>"textbox",	"size"=>60, "filter"=>false),
	    "password"=>array(	"name"=>"Password",		"type"=>"textbox",	"size"=>20, "filter"=>false),
	    NULL)
	);

    $structures["autodiscovery"] = array(
	"title"=>"Autodiscovery",
	"object"=>"autodiscovery",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_HOSTS",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",		"type"=>"textbox",	"size"=>30),
	    "poller_default"=>array(	"name"=>"Default Poller",	"type"=>"checkbox"),
	    "permit_add"=>array(	"name"=>"Permit Add",		"type"=>"checkbox"),
	    "permit_del"=>array(	"name"=>"Permit Delete",	"type"=>"checkbox"),
	    "alert_del"=>array(		"name"=>"Alert on Delete",	"type"=>"checkbox"),
	    "permit_mod"=>array(	"name"=>"Permit Modify",	"type"=>"checkbox"),
	    "permit_disable"=>array(	"name"=>"Permit Disable",	"type"=>"checkbox"),
	    "skip_loopback"=>array(	"name"=>"Skip LoopBack",	"type"=>"checkbox"),
	    "check_state"=>array(	"name"=>"Check State",		"type"=>"checkbox"),
	    "check_address"=>array(	"name"=>"Check Valid Address",	"type"=>"checkbox"),
	    NULL)
	);


    $structures["severity"] = array(
	"title"=>"Severities",
	"object"=>"severity",
	"show_id"=>0,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "level"=>array(	"name"=>"Level",		"type"=>"textbox",	"size"=>3),
	    "severity"=>array(	"name"=>"Description",		"type"=>"textbox",	"size"=>20),
	    "bgcolor"=>array(	"name"=>"Background Color",	"type"=>"colorbox"),
	    "fgcolor"=>array(	"name"=>"Foreground Color",	"type"=>"colorbox"),
	    NULL)
	);


    $structures["syslog_types"] = array(
	"title"=>"Syslog Events Types",
	"object"=>"syslog_types",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "match_text"=>array(	"name"=>"Text Match",	"type"=>"textbox",	"size"=>70, "filter"=>false),
	    "interface"=>array(	"name"=>"Interface Field",	"type"=>"textbox",	"size"=>10, "filter"=>false),
	    "username"=>array(	"name"=>"Username Field",	"type"=>"textbox",	"size"=>10, "filter"=>false),
	    "state"=>array(	"name"=>"State Field",		"type"=>"textbox",	"size"=>10, "filter"=>false),
	    "info"=>array(	"name"=>"Extra Info Field",	"type"=>"textbox",	"size"=>10, "filter"=>false),
	    "type"=>array(	"name"=>"Event Type",		"type"=>"select",	"func"=>"select_event_types",	"view"=>"types_description", "size"=>30),
	    "pos"=>array(	"name"=>"Position",		"type"=>"textbox",	"size"=>3, "filter"=>false),
	    NULL)
	);

    $structures["event_types"] = array(
	"title"=>"Event Types",
	"object"=>"event_types",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",			"type"=>"textbox",	"size"=>30),
	    "severity"=>array(	"name"=>"Severity",				"type"=>"select",	"func"=>"select_severity", "view"=>"severity_description", "size"=>30),
	    "text"=>array(	"name"=>"Event Text",				"type"=>"textbox",	"size"=>60, "filter"=>false),
	    "show_default"=>array(	"name"=>"Show in Event Viewer?",	"type"=>"select", 	"func"=>"select_events_show", "size"=>10, "view_params"=>array(1)),
	    "generate_alarm"=>array(	"name"=>"Event Generates an Alarm?",	"type"=>"checkbox"),
	    "alarm_up"=>array(	"name"=>"Different Alarm for Up Event",		"type"=>"select",	"func"=>"select_event_types", "params"=>array(1,NULL,NULL,array(NULL,array("show_unknown"=>1))), "view"=>"alarm_up_description", "size"=>30),
	    "alarm_duration"=>array(	"name"=>"Alarm Duration",		"type"=>"select",	"func"=>"select_alarm_duration", "size"=>30, "view_params"=>array(1)),
	    "show_host"=>	array(	"name"=>"Show Host Field?",		"type"=>"checkbox"),
	    NULL)
	);

    $structures["interface_types"] = array(
	"title"=>"Interface Types",
	"object"=>"interface_types",
	"show_id"=>1,
	"hide_record_one"=>1,

	"action_type"=>2,
	"split"=>"interface_types_fields",
	"split_standard"=>1,
	"split_view_name"=>"Fields",

	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(		"name"=>"Description",			"type"=>"textbox",	"size"=>30),

	    "autodiscovery_enabled"=>array(	"name"=>"AD Enabled",	"type"=>"checkbox"),
	    "autodiscovery_validate"=>array(	"name"=>"Validate in AD",	"type"=>"checkbox"),
	    "autodiscovery_function"=>array(	"name"=>"Discovery Function (Internal)",	"type"=>"textbox", "size"=>40),
	    "autodiscovery_parameters"=>array(	"name"=>"Discovery Parameters",	"type"=>"textbox",	"size"=>30),
	    "autodiscovery_default_poller"=>array(	"name"=>"Discovery Default Poller",	"type"=>"select",	"func"=>"select_pollers_groups", "view"=>"poller_default", "size"=>30, "filter"=>false),
	    
	    "update_handler"=>	array(	"name"=>"Internal Update Handler","type"=>"textbox", "size"=>20),

	    "allow_manual_add"=>array(		"name"=>"Manual Interface Add",		"type"=>"checkbox"),

	    "break_by_card"=>array(	"name"=>"Break by Card",	"type"=>"checkbox"),
	    "have_tools"=>array(	"name"=>"Have Tools",		"type"=>"checkbox"),
	    "have_graph"=>array(	"name"=>"Have Graph",		"type"=>"checkbox"),

	    "graph_default"=>array(	"name"=>"Default Graph",	"type"=>"select",	"func"=>"select_graph_types", "view"=>"graph_types_description", "size"=>30, "filter"=>false),
	    "sla_default"=>array(	"name"=>"Default SLA",		"type"=>"select",	"func"=>"select_slas", "view"=>"slas_description", "size"=>30),
	
	    "rrd_structure_rra"=>array(	"name"=>"RRDTool Structure RRA","type"=>"memobox", "width"=>40, "height"=>5, "size"=>40, "filter"=>false),
	    "rrd_structure_res"=>array(	"name"=>"RRDTool Resolution",	"type"=>"textbox", "size"=>20),
	    "rrd_structure_step"=>array(	"name"=>"RRDTool Step",	"type"=>"textbox", "size"=>10),

	    NULL)
	);

    $structures["filters"] = array(
	"title"=>"Filters",
	"object"=>"filters",
	"show_id"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"action_type"=>2,
	"split"=>"filters_cond",
	"split_standard"=>1,

	"fields"=>array("description"=>array(	"name"=>"Description",		"type"=>"textbox",	"size"=>30))
	);


    $structures["filters_cond"] = array(
	"title"=>"Filters Conditions",
	"object"=>"filters_cond",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"hidden_fields"=>array("filter_id"),
	"add_filter_field"=>"filter_id",
	
	"fields"=>array(
	    //"filter_id"=>array(	"name"=>"Filter",	"type"=>"select",	"func"=>"select_filters",	"size"=>30, "view"=>"filter_description", "hidden"=>true),
	    "pos"=>array(	"name"=>"Position",		"type"=>"textbox", "size"=>5),
	    "field_id"=>array(	"name"=>"Field",	"type"=>"select",	"func"=>"select_filters_fields",	"size"=>30, "view"=>"field_description"),
	    "op"=>array(	"name"=>"Operator",	"type"=>"select",	"func"=>"select_op",	"size"=>30, "view_params"=>array(1)),
	    "value"=>array(	"name"=>"Value",	"type"=>"select",	"func"=>"select_filter_option",	"size"=>30, "params_field"=>"field_name", "view_params"=>array(0)),
	    NULL)
	);

    $structures["filters_fields"] = array(
	"title"=>"Filter Fields",
	"object"=>"filters_fields",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"	=>array(	"name"=>"Description",	"type"=>"textbox",	"size"=>30),
	    "field"		=>array(	"name"=>"Field Name",	"type"=>"textbox",	"size"=>30),
	    NULL)
	);

    $structures["slas"] = array(
	"title"=>"SLAs",
	"object"=>"slas",
	"show_id"=>1,
	"action_type"=>2,
	"split"=>"slas_sla_cond",
	"split_standard"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox",	"size"=>30),
	    "interface_type"=>array(	"name"=>"Interface Type",	"type"=>"select",	 "func"=>"select_interface_types", "view"=>"interface_type_description", "size"=>30),
	    "event_type"=>array(	"name"=>"Event Type",	"type"=>"select",		"func"=>"select_event_types", "view"=>"types_description", "size"=>30),
	    "state"=>array(	"name"=>"Alarm State",	"type"=>"select",		"func"=>"select_alarm_states", "view"=>"state_description", "size"=>60),
	    "info"=>array(	"name"=>"Event Text",	"type"=>"textbox",	"size"=>30, "filter"=>false),
	    "threshold"=>array(	"name"=>"Threshold % (for Reports)",	"type"=>"textbox",	"size"=>3, "filter"=>false),
	    NULL)
	);

    $structures["slas_cond"] = array(
	"title"=>"SLA Individual Conditions",
	"object"=>"slas_cond",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "event"=>array(	"name"=>"Show Info",	"type"=>"textbox",	"size"=>30),
	    "condition"=>array(	"name"=>"Condition",	"type"=>"textbox",	"size"=>100, "filter"=>false),
	    "variable_show"=>array(	"name"=>"Show Expression",	"type"=>"textbox",	"size"=>100),
	    "variable_show_info"=>array(	"name"=>"Show Unit",	"type"=>"textbox",	"size"=>30),
	    NULL)
	);

    $structures["maps"] = array(
	"title"=>"SubMaps (Interface Groups)",
	"object"=>"maps",
	"show_id"=>1,
	"action_type"=>2,
	"split"=>"maps_interfaces",
	"split_standard"=>1,
	"profile"=>"ADMIN_HOSTS",

	"fields"=>array(
	    "name"=>array(	"name"=>"Map Name",		"type"=>"textbox", 	"size"=>30, 		"filter"=>false),
	    "parent"=>array(	"name"=>"Parent Map",		"type"=>"select",	"func"=>"select_maps", 	"view"=>"parent_name", "size"=>30),
	    "color"=>array(	"name"=>"Background Color",	"type"=>"colorbox"),
	    NULL)
	);

    $structures["alarm_states"] = array(
	"title"=>"Alarm States (and Sounds)",
	"object"=>"alarm_states",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "activate_alarm"=>array(	"name"=>"Alarm Level",	"type"=>"textbox", "size"=>5),
	    "sound_in"=>array(		"name"=>"Sound In",	"type"=>"textbox","size"=>30),
	    "sound_out"=>array(		"name"=>"Sound Out",	"type"=>"textbox","size"=>30),
	    "state"=>array(		"name"=>"Internal State", "type"=>"select", "func"=>"select_alarm_states_states", "view_params"=>1, "view_params"=>array(1)),
	    NULL)
	);

    $structures["maps_interfaces"] = array(
	"title"=>"SubMaps/Interfaces",
	"object"=>"maps_interfaces",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_HOSTS",
	"no_records_message"=>"No Interfaces Found in this Map.",

	"hidden_fields"=>array("map"),
	"add_filter_field"=>"map",

	"fields"=>array(
	    //"map"=>array(	"name"=>"Map Name",	"type"=>"select",	"func"=>"select_maps",		"view"=>"map_name",	"size"=>30),
	    "interface"=>array(	"name"=>"Interface",	"type"=>"select",	"func"=>"select_interfaces",	"view"=>"interface_description",	"size"=>60, "params"=>array(6)),
	    "x"=>	array(	"name"=>"X",		"type"=>"textbox","size"=>5, "filter"=>false),
	    "y"=>	array(	"name"=>"Y",		"type"=>"textbox","size"=>5, "filter"=>false),
	    NULL)
	);

    $structures["pollers"] = array(
	"title"=>"Pollers",
	"object"=>"pollers",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "name"=>array(		"name"=>"Name (Match RRD Struct DS)",	"type"=>"textbox", "size"=>30),
	    "command"=>array(		"name"=>"Poller Command (file)",	"type"=>"textbox","size"=>30),
	    "parameters"=>array(	"name"=>"Parameters",	"type"=>"textbox","size"=>100),
	    NULL)
	);

    $structures["trap_receivers"] = array(
	"title"=>"SNMP Trap Receivers",
	"object"=>"trap_receivers",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>0,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "position"=>array(		"name"=>"Position",	"type"=>"textbox", "size"=>3),
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "interface_type"=>array(	"name"=>"Interface Type",	"type"=>"select",	"func"=>"select_interface_types", "view"=>"interface_type_description", "size"=>30),
	    "match_oid"=>array(		"name"=>"OID Match",	"type"=>"textbox","size"=>50),
	    "command"=>array(		"name"=>"Receiver Command (file)",	"type"=>"textbox","size"=>30),
	    "parameters"=>array(	"name"=>"Parameters",	"type"=>"textbox","size"=>100),
	    "backend"=>array(		"name"=>"Backend",	"type"=>"select",	"func"=>"select_backends",	"size"=>30, "view"=>"backend_description"),
	    "stop_if_matches"=>array(	"name"=>"Stop if Matches",		"type"=>"checkbox"),
	    NULL)
	);

    $structures["pollers_backend"] = array(
	"title"=>"Pollers Backends",
	"object"=>"pollers_backend",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "command"=>array(		"name"=>"Poller Command (file)",	"type"=>"textbox","size"=>30),
	    "parameters"=>array(	"name"=>"Parameters",	"type"=>"textbox","size"=>30),
	    "type"=>array(		"name"=>"Type (is Status?)",		"type"=>"checkbox"),
	    NULL)
	);

    $structures["pollers_groups"] = array(
	"title"=>"Poller Groups",
	"object"=>"pollers_groups",
	"show_id"=>1,
	"action_type"=>2,
	"split"=>"pollers_poller_groups",
	"split_standard"=>1,
	"profile"=>"ADMIN_SYSTEM",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "interface_type"=>array(	"name"=>"Interface Type",	"type"=>"select",	"func"=>"select_interface_types",	"size"=>30, "view"=>"type_description"),
	    NULL)
	);

    $structures["pollers_poller_groups"] = array(
	"title"=>"Poller Group - Pollers/Backend Relation",
	"object"=>"pollers_poller_groups",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    //"poller_group"=>array(	"name"=>"Poller Group",	"type"=>"select",	"func"=>"select_pollers_groups",	"size"=>30, "view"=>"group_description"),
	    "pos"=>array(	"name"=>"Position",	"type"=>"textbox", "size"=>3, "filter"=>false),
	    "poller"=>array(	"name"=>"Poller",		"type"=>"select",	"func"=>"select_pollers",		"size"=>30, "view"=>"poller_description"),
	    "backend"=>array(	"name"=>"Backend",	"type"=>"select",	"func"=>"select_pollers_backend",	"size"=>30, "view"=>"backend_description"),
	    NULL)
	);

    $structures["slas_sla_cond"] = array(
	"title"=>"SLAs - SLA Conditions Relation",
	"object"=>"slas_sla_cond",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "sla"=>array(	"name"=>"SLA",		"type"=>"select",	"func"=>"select_slas",		"size"=>30, "view"=>"sla_description"),
	    "pos"=>array(	"name"=>"Position",	"type"=>"textbox", "size"=>3),
	    "cond"=>array(	"name"=>"Condition",	"type"=>"select",	"func"=>"select_slas_cond",	"size"=>30, "view"=>"cond_description"),
	    "show_in_result"=>array(	"name"=>"Show",		"type"=>"checkbox"),
	    NULL)
	);

    $structures["profiles_values"] = array(
	"title"=>"Profiles Option Values",
	"object"=>"profiles_values",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_USERS",
	
	"fields"=>array(
	    "profile_option"=>array(	"name"=>"Option",	"type"=>"select",	"func"=>"select_profiles_options",	"size"=>30, "view"=>"option_description"),
	    "description"=>array(	"name"=>"Description",		"type"=>"textbox", "size"=>30),
	    "value"=>array(	"name"=>"Value",		"type"=>"textbox", "size"=>30),
	    NULL)
	);

    $structures["actions"] = array(
	"title"=>"Actions",
	"object"=>"actions",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"	 =>array(	"name"=>"Description",			"type"=>"textbox", "size"=>30),
	    "command"		 =>array(	"name"=>"Command",			"type"=>"textbox", "size"=>30),
	    "internal_parameters"=>array(	"name"=>"Internal Parameters",		"type"=>"textbox", "size"=>100, "filter"=>false),
	    "user_parameters"	 =>array(	"name"=>"User Parameters",		"type"=>"textbox", "size"=>100, "filter"=>false),
	    NULL)
	);

    $structures["triggers"] = array(
	"title"=>"Triggers",
	"object"=>"triggers",
	"show_id"=>1,
	"action_type"=>2,
	"hide_record_one"=>1,
	"split"=>"triggers_rules",
	"profile"=>"ADMIN_SYSTEM",
	"split_view_name"=>"View Rules",

	"fields"=>array(
	    "description"=>array(	"name"=>"Description",		"type"=>"textbox", "size"=>30),
	    "type"=>array(		"name"=>"Type",			"type"=>"select", "func"=>"select_triggers_types", "view_params"=>array(1)),
	    NULL)
	);

    $structures["triggers_users"] = array(
	"title"=>"User Triggers",
	"object"=>"triggers_users",
	"show_id"=>0,
	"action_type"=>1,
	"filter_by_user"=>"user_id",
	"filter_field"=>"user_id",
	
	"fields"=>array(
	    "trigger_id"=>array(	"name"=>"Trigger",	"type"=>"select",	"func"=>"select_triggers",	"size"=>30, "view"=>"trigger_description"),
	    "active"=>array(	    	"name"=>"Active",	"type"=>"checkbox"),
	    NULL)
	);

    $structures["triggers_users_admin"] = array(
	"title"=>"User Triggers",
	"object"=>"triggers_users",
	"show_id"=>1,
	"action_type"=>1,
	"profile"=>"ADMIN_USERS",
	
	"fields"=>array(
	    "user_id"=>array(		"name"=>"Username", 	"type"=>"select",	"func"=>"select_users",		"size"=>30, "view"=>"user_description"),
	    "trigger_id"=>array(	"name"=>"Trigger",	"type"=>"select",	"func"=>"select_triggers",	"size"=>30, "view"=>"trigger_description"),
	    "active"=>array(	    	"name"=>"Active",	 	"type"=>"checkbox"),
	    NULL)
	);

    $structures["hosts_config_types"] = array(
	"title"=>"Host Config Commands",
	"object"=>"hosts_config_types",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>60),
	    "command"=>array(		"name"=>"Command",	"type"=>"textbox","size"=>30),
	    NULL)
	);

    $structures["interface_types_field_types"] = array(
	"title"=>"Interface Field Types",
	"object"=>"interface_types_field_types",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "handler"=>array(		"name"=>"Handler",	"type"=>"textbox","size"=>30),
	    NULL)
	);

    $structures["interface_types_fields"] = array(
	"title"=>"Interface Type Fields",
	"object"=>"interface_types_fields",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",

	//add filter
	"filter_field"=>"itype",
		
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "name"=>array(		"name"=>"Internal Name",	"type"=>"textbox","size"=>30, "filter"=>false),
	    "pos"=>array(		"name"=>"Position",	"type"=>"textbox","size"=>3),
	    "itype"=>array(		"name"=>"Interface Type",	"type"=>"select",	 "func"=>"select_interface_types", "view"=>"itype_description", "size"=>30),
	    "ftype"=>array(		"name"=>"Field Type",	"type"=>"select",	 "func"=>"select_interface_types_field_types", "view"=>"ftype_description", "size"=>30),
	    "showable"=>array(	    	"name"=>"Show",	 	"type"=>"select",	 "func"=>"select_interface_types_field_show", "view_params"=>array(true)),
	    "overwritable"=>array(	"name"=>"Overwritable", 	"type"=>"checkbox"),
	    "tracked"=>array(	    	"name"=>"Tracked", 	"type"=>"checkbox"),
	    "default_value"=>array(	"name"=>"Default Value",	"type"=>"select",	"func"=>"interface_value_control", "params_field"=>"ftype_handler", "view_params"=>array(true), "size"=>30),
	    "ftype_handler"=>array(    	"name"=>"Field Type Handler",  "type"=>"hidden"),
	    NULL)
	);

    $structures["tools"] = array(
	"title"=>"Tools",
	"object"=>"tools",
	"show_id"=>1,
	"action_type"=>1,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_SYSTEM",

	//add filter
	"filter_field"=>"itype",
		
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox","size"=>30),
	    "name"=>array(		"name"=>"Internal Name",	"type"=>"textbox","size"=>30	, "filter"=>false),
	    "pos"=>array(		"name"=>"Position",	"type"=>"textbox","size"=>3),
	    "itype"=>array(		"name"=>"Interface Type",	"type"=>"select",	 "func"=>"select_interface_types", "view"=>"itype_description", "size"=>30),
	    "file_group"=>array(	"name"=>"File Group",	"type"=>"textbox","size"=>30),
	    "allow_set"=>array(		"name"=>"Allow Set", 	"type"=>"checkbox"),
	    "allow_get"=>array(		"name"=>"Allow Get", 	"type"=>"checkbox"),
	    NULL)
	);
    

    $structures["hosts"] = array(
	"title"=>"Hosts",
	"object"=>"hosts",
	"show_id"=>1,
	"action_type"=>3,
	"hide_record_one"=>1,
	"profile"=>"ADMIN_HOSTS",
	"no_records_message"=>"No Hosts Found",
	"include"=>"hosts",

	"actions"=>array(
	    "edit"=>		array("name"=> "Edit Host"),
	    "delete"=>		array("name"=> "Delete Host"),
	    "view_interfaces"=>	array("name"=> "View Host Interfaces"),
	    "discovery"=>	array("name"=> "Manual Discovery"),
	    "fast_discovery"=>	array("name"=> "Manual Discovery w/o PortScan"),
	    "view_config"=>	array("name"=> "View Stored Configurations"),
	    NULL
	),

	"fields"=>array(
	    "name"=>array(		"name"=>"Name",		"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "zone"=>array(		"name"=>"Zone",		"type"=>"select",	"func"=>"select_zones", "view"=>"zone_description", "size"=>"30"),
	    "ip"=>array(		"name"=>"IP Address",	"type"=>"textbox",	"size"=>15, "filter"=>false),

	    "rocommunity"=>array(	"name"=>"R/O Community","type"=>"select",	"func"=>"snmp_options", "size"=>20, "view_params"=>array(1),"filter"=>false),
	    //"rwcommunity"=>array(	"name"=>"R/W Community","type"=>"select",	"func"=>"textbox",	"view_func"=>"select_community", "size"=>20, "filter"=>false),
	    "rwcommunity"=>array(	"name"=>"R/W Community","type"=>"select",	"func"=>"snmp_options", "size"=>20, "view_params"=>array(1),"filter"=>false),

	    "autodiscovery"=>array(	"name"=>"AutoDiscovery Policy",	"type"=>"select","func"=>"select_autodiscovery", "view"=>"autodiscovery_description", "size"=>30),
	    "autodiscovery_default_customer"=>
			    array(	"name"=>"AD Default Customer",	"type"=>"select","func"=>"select_clients", "view"=>"default_customer_description", "size"=>30),
	    "show_host"=>array(		"name"=>"Visibility",	"type"=>"select","func"=>"select_show_rootmap", "view_params"=>array(1), "size"=>30),
	    "poll"=>array(		"name"=>"Polling", 	"type"=>"checkbox"),
	    "dmii"=>array(		"name"=>"Main Interface(s)",	"type"=>"select","func"=>"select_hosts_dmii", "params_field"=>"id", "view_params"=>array(1), "size"=>30, "filter"=>false),
	    "tftp"=>array(		"name"=>"TFTPd Server IP",	"type"=>"textbox",	"size"=>15),
	    "config_type"=>array(	"name"=>"Config Transfer Mode",	"type"=>"select","func"=>"select_hosts_config_types", "view"=>"config_type_description", "size"=>50),
	    "ip_tacacs"=>array(		"name"=>"Tacacs+ Source IP",	"type"=>"textbox",	"size"=>15, "filter"=>false),
	    "satellite"=>array(		"name"=>"Satellite",		"type"=>"select","func"=>"select_satellites", "view"=>"satellite_description", "size"=>30),
	    //"lat"=>array(		"name"=>"Latitude",		"type"=>"textbox",	"size"=>20, "filter"=>false),
	    //"lon"=>array(		"name"=>"Longitude",		"type"=>"textbox",	"size"=>20, "filter"=>false),

	    "poll_interval"=>array(	"name"=>"Poll Interval",		"type"=>"select", "func"=>"select_host_poll_interval", "view_params"=>array(1)),
	    	    
	    "creation_date"=>array(	"name"=>"Creation Date",	"type"=>"select", "func"=>"show_unix_date", "size"=>40, "filter"=>false ),
	    "modification_date"=>array(	"name"=>"Modification Date",	"type"=>"select", "func"=>"show_unix_date", "size"=>40, "filter"=>false ),
	    "last_poll_date"=>array(	"name"=>"Last Poll Date",	"type"=>"select", "func"=>"show_unix_date", "size"=>40, "filter"=>false ),

	    "last_poll_time"=>array(	"name"=>"Last Poll Duration",	"type"=>"select", "func"=>"time_hms", "size"=>40, "filter"=>false),

	    
	    NULL)
	);
    
    $structures["users"] = array(
	"title"=>"Users",
	"object"=>"users",
	"show_id"=>1,
	"action_type"=>3,
	"hide_record_one"=>1,
	"no_records_message"=>"No Users Found",
	"filter_by_user"=>"id",
	"include"=>"users",

	"actions"=>array(
	    "edit"=>		array("name"=> "Edit User"),
	    "delete"=>		array("name"=> "Delete User"),
	    "view_profile"=>	array("name"=> "View User Profile"),
	    "view_triggers"=>	array("name"=> "View User Triggers"),
	    NULL
	),
	
	"hidden_fields"=>array("old_passwd"),

	"fields"=>array(
	    "usern"=>array(		"name"=>"Username",	"type"=>"select",	"size"=>20, "func"=>"select_usern", "filter"=>false, "view_params"=>array(1)),
	    "new_passwd"=>array(	"name"=>"Password",	"type"=>"select",	"size"=>20, "view"=>"(Encrypted)", "func"=>"textbox", "filter"=>false),
	    "fullname"=>array(		"name"=>"Full Name",	"type"=>"textbox",	"size"=>30, "filter"=>false),
	    "router"=>array(		"name"=>"Router Access","type"=>"checkbox"),
	    NULL)
	);

    $structures["journals"] = array(
	"title"=>"Journals",
	"object"=>"journal",
	"profile"=>"VIEW_REPORTS",
	"no_records_message"=>"No Journals Found",
	"include"=>"journals",
	"disable_add"=>true,

	"action_type"=>3,

	"actions"=>array(
	    "edit"=>	array("name"=> "Edit"),
	    "delete"=>	array("name"=> "Delete"),
	    "view"=>	array("name"=> "View"),
	    NULL
	),

	"fields"=>array(
	    "subject"=>array(		"name"=>"Subject",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "ticket"=>array(		"name"=>"Ticket",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "active"=>array(		"name"=>"Active", 	"type"=>"checkbox"),
	    
	    "date_start"=>array(	"name"=>"Start Date",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    "date_stop"=>array(		"name"=>"Stop Date",	"type"=>"textbox",	"size"=>20, "filter"=>false),
	    NULL)
	);

    $structures["satellites"] = array(
	"title"=>"Satellites",
	"object"=>"satellites",
	"show_id"=>1,
	"action_type"=>1,
	"no_records_message"=>"No Satellites Found",
	"profile"=>"ADMIN_HOSTS",
	"include"=>"satellites",
	
	"fields"=>array(
	    "description"=>array(	"name"=>"Description",	"type"=>"textbox",	"size"=>30, "filter"=>false),
	    "parent"=>array(		"name"=>"Parent",	"type"=>"select",	"size"=>20, "view"=>"parent_description", "func"=>"select_satellites", "filter"=>false),
	    "url"=>array(		"name"=>"Satellite URI, Full Path to /admin/satellite.php",	"type"=>"textbox",	"size"=>60, "filter"=>false),
	    "sat_group"=>array(		"name"=>"Group",	"type"=>"select",	"size"=>20, "view"=>"group_description", "func"=>"select_satellites_groups"),
	    "sat_type"=>array(		"name"=>"Type",		"type"=>"select",	"size"=>20, "func"=>"select_satellites_types", "view_params"=>array(1)),
	    NULL)
	);

    if ($admin_structure=="list_all") { 
	foreach (array_keys($structures) as $aux) 
	    echo tag("li").linktext($aux, "adm_standard.php?admin_structure=".$aux); 
	die();
    } else 
	if (is_array($structures[$admin_structure])) 
	    $structure = $structures[$admin_structure];
	else
	    die(html("h1", "Admin Structure Not Found"));
?>
