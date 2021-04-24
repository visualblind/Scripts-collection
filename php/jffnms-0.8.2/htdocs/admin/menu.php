<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../auth.php"); 
    
    $menus = array(
	"administration"=>array("title"=>"Administration",
	    "items"	=>array("users_cust","host_int","reports","internal","setup")),

	"internal"=>array("title"=>"Internal Configuration",
	    "items"	=>array("events","polling","sla_def","trig_filters","int_others")),

	"users_cust"	=>array("title"=>"Users and Customers", "image"=>"users",
	    "items"	=>array("customers","users","triggers_users_admin")),
	"customers"		=>array("title"=>"Customers", 		"type"=>"standard", 	"link"=>"clients", 	"image"=>"user2"),
	"users"			=>array("title"=>"Users",		"type"=>"standard",	"link"=>"users",	"image"=>"users"),
	"triggers_users_admin"	=>array("title"=>"Triggers Users",	"type"=>"standard",				"image"=>"event"),

	"host_int"	=>array("title"=>"Hosts and Interfaces", "image"=>"host",
	    "items"	=>array("zones","hosts","interfaces","nad","hosts_config","maps","satellites")),
	"zones"			=>array("title"=>"Zones", 		"type"=>"standard", 				"image"=>"world"),
	"hosts"			=>array("title"=>"Hosts",		"type"=>"standard",				"image"=>"host" ),
	"interfaces"		=>array("title"=>"Interfaces",		"type"=>"intframe",				"image"=>"int1"	),
	"hosts_config"		=>array("title"=>"Hosts Saved Configs",	"type"=>"admin",				"image"=>"config"),
	"maps"			=>array("title"=>"SubMaps", 		"type"=>"stdframe", 				"image"=>"map2"	),
	"satellites"		=>array("title"=>"Satellites", 		"type"=>"standard", 				"image"=>""	),
	"nad"			=>array("title"=>"Network Discovery",	"type"=>"admframe",				"image"=>"world"),

	"events"	=>array("title"=>"Event Analyzer", "image"=>"event",
	    "items"	=>array("severity","event_types","syslog_types","trap_receivers","receiver_backends","alarm_states")),
	"severity"		=>array("title"=>"Severities",		"type"=>"standard", 				"image"=>""	),
	"event_types"		=>array("title"=>"Event Types",		"type"=>"standard",				"image"=>"event"),
	"syslog_types"		=>array("title"=>"Syslog Message Rules","type"=>"standard",				"image"=>""	),
	"trap_receivers"	=>array("title"=>"SNMP Trap Receivers",		"type"=>"standard",			"image"=>""	),
	"alarm_states"		=>array("title"=>"Alarm States & Sounds","type"=>"standard",				"image"=>"alert"),

	"polling"	=>array("title"=>"Polling & Discovery", "image"=>"",
	    "items"	=>array("interface_types","pollers_groups","pollers","pollers_backend","graph_types","autodiscovery")),
	"interface_types"	=>array("title"=>"Interface Types",		"type"=>"standard",			"image"=>""	),
	"pollers_groups"	=>array("title"=>"Poller Grouping",		"type"=>"stdframe",			"image"=>""	),
	"pollers"		=>array("title"=>"Poller Items",		"type"=>"standard",			"image"=>""	),
	"pollers_backend"	=>array("title"=>"Poller Backends",		"type"=>"standard",			"image"=>""	),
	"graph_types"		=>array("title"=>"Graph Types",			"type"=>"standard",			"image"=>"graph"),
	"autodiscovery"		=>array("title"=>"Autodiscovery Policy",	"type"=>"standard", 			"image"=>""	),

	"setup"			=>array("title"=>"System Setup",	"type"=>"raw",	"link"=>"/admin/setup.php", "image"=>""	),

	"sla_def"	=>array("title"=>"SLA Definitions", "image"=>"pen",
	    "items"	=>array("slas","slas_cond")),
	"slas"			=>array("title"=>"Conditions Groups",		"type"=>"stdframe",		"image"=>"pen"	),
	"slas_cond"		=>array("title"=>"Individual Definitions","type"=>"standard",		"image"=>""	),

	"reports"	=>array("title"=>"Reports", "image"=>"text",
	    "items"	=>array("state_report","performance","journals","alarms")),
	"state_report"		=>array("title"=>"State & Availability","type"=>"intframe", 				"image"=>"text"	),
	"performance"		=>array("title"=>"Performance Graphs",	"type"=>"intframe",				"image"=>"graph"),
	"journals"		=>array("title"=>"Journals",		"type"=>"standard",				"image"=>""),
	"alarms"		=>array("title"=>"Alarm Editor",	"type"=>"intframe",				"image"=>"text"),
	
	"trig_filters"	=>array("title"=>"Triggers & Filters", "image"=>"query",
	    "items"	=>array("triggers","actions","filters","filters_fields")),
	"triggers"		=>array("title"=>"Triggers Configuration",	"type"=>"stdframe", 			"image"=>""	),
	"actions"		=>array("title"=>"Actions Definition",		"type"=>"standard",			"image"=>""	),
	"filters"		=>array("title"=>"Event Filters",		"type"=>"stdframe",			"image"=>"query"),
	"filters_fields"	=>array("title"=>"Filter Fields",		"type"=>"standard",			"image"=>""	),
	
	"int_others"	=>array("title"=>"Other Configurations", "image"=>"",
	    "items"	=>array("hosts_config_types","profiles_options","tools","interface_types_field_types")),
	"hosts_config_types"	=>array("title"=>"Host Config",			"type"=>"standard", 			"image"=>""	),
	"profiles_options"	=>array("title"=>"Profiles Options",		"type"=>"admframe",			"image"=>"tag"	),
	"tools"			=>array("title"=>"Interface/Host Tools",	"type"=>"standard",			"image"=>"tool"	),
	"interface_types_field_types"=>array("title"=>"Int. Types Fields Types",	"type"=>"standard",		"image"=>""	),
	
	NULL
    );

    function process_url ($type, $link) {
	global $jffnms_rel_path;
    
	switch ($type) {
	    case "raw"		: $url = $jffnms_rel_path.$link; break;

	    case "standard"	: $url = $jffnms_rel_path."/admin/adm/adm_standard.php?admin_structure=".$link; break;
	    case "admin"	: $url = $jffnms_rel_path."/admin/adm/adm_".$link.".php"; break;
	
	    case "admframe"	: $url = $jffnms_rel_path."/admin/menu_frame.php?name1=".urlencode("adm/adm_".$link.".php?"); break;
	    case "stdframe"	: $url = $jffnms_rel_path."/admin/menu_frame.php?name1=".urlencode("adm/adm_standard.php?admin_structure=".$link); break;
	    case "intframe"	: $url = $jffnms_rel_path."/admin/menu_frame.php?menu=interface_list&size1=200&scroll1=no&type=vertical&menu_type=".$link; break;

	    default		: $url = $_SERVER["SCRIPT_NAME"]."?menu=".$link."&show_frame=1"; break;
	}
    
	return $url;
    } 

    function show_option($menu, $id) {
	global $jffnms_rel_path;
		
	$sub_menu = $menu[$id];

	if (isset($menu[$id])) {
	    if (!isset($sub_menu["link"]))  $sub_menu["link"]=$id;
	    if (!isset($sub_menu["type"]))  $sub_menu["type"]="";
	    if (!isset($sub_menu["image"])) $sub_menu["image"]="";

	    $url = (isset($sub_menu["items"]))
	    	?"javascript: show_submenu('".$id."', 'option_".$id."');"
		:process_url ($sub_menu["type"],$sub_menu["link"]);
		
	    return 
		tr_open("option_".$id).
		td( image((empty($sub_menu["image"])?"bullet2":$sub_menu["image"]).".png"),"image").
		td(linktext($sub_menu["title"], $url, (isset($sub_menu["items"])?"_self":"work"))).
		tag_close("tr").
		((isset($sub_menu["items"]))
		    ?	tr_open($id,"submenu").td(
			table().
			show_menu ($menu, $id).
			table_close()
			,"","",2).tag_close("tr")
		    :"");
			
	}
    }
	    
    function show_menu ($menu, $id) {
	$sub_menu = $menu[$id];
	if (is_array($sub_menu["items"]))
	    foreach ($sub_menu["items"] as $item)
		$output .= show_option ($menu, $item);
		
	return $output;
    }


    if (!isset($menu)) $menu = "administration";
    
    if (!is_array($menus[$menu]["items"])) {	// Direct Menu
	header ("Location: ".process_url ($menus[$menu]["type"],$menus[$menu]["link"]));
	die();
    }

    if (!profile("ADMIN_ACCESS")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");
    
    adm_header("Menu");

    echo
        script("
	    function open_menu (url) {
	        parent.work.location.href = url;
	    }
		
	    function show_submenu(id, caller_name) {
	        submenu = document.getElementById (id);
	        caller = document.getElementById (caller_name);

	        submenu.className = (submenu.className=='selected_submenu')?'submenu':'selected_submenu';
	        caller.className = (caller.className=='selected_option')?'option':'selected_option';
	    }").

	tag("div", "menu").
	table().
	table_row("Menu", "title", 2,"","",false).
	    
	show_menu ($menus, "administration").
	table_close().
	tag_close("div");

    adm_footer();

?>
