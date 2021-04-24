<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    class internal_base_custom extends basic {
        function get_all()	{ $params = func_get_args(); return call_user_func_array($this->jffnms_class."_list",$params); }
        function add() 		{ $params = func_get_args(); return call_user_func_array("adm_".$this->jffnms_class."_add",$params); }
        function update()	{ $params = func_get_args(); return call_user_func_array("adm_".$this->jffnms_class."_update",$params); }
        function delete()	{ $params = func_get_args(); return call_user_func_array("adm_".$this->jffnms_class."_del",$params); }
	function status()	{ $params = func_get_args(); return call_user_func_array($this->jffnms_class."_status",$params); }
    }

    class internal_base_standard extends basic {
	var $jffnms_filter_record = 1;
	var $jffnms_order_field = "id";
	var $jffnms_order_type = "desc";

        function get_all($ids = NULL, $fields = array()) { 
	    return get_db_list(	$this->jffnms_class,	$ids, 	array($this->jffnms_class.".*"), //table,ids,fields	
		array(array($this->jffnms_class.".id",">",$this->jffnms_filter_record)), //where
		array(array($this->jffnms_class.".".$this->jffnms_order_field,$this->jffnms_order_type)) ); //order 
	}
	function add() 			{ return db_insert($this->jffnms_class,$this->jffnms_insert); }
	function update($id,$data) 	{ return db_update($this->jffnms_class,$id,$data); }
	function delete($id) 		{ return db_delete($this->jffnms_class,$id); }

	function internal_base_standard() {//constructor
	    if (!$this->jffnms_class) die ("No jffnms_class Defined.");

	    if (!is_array($this->jffnms_insert)) 
		die ("No jffnms_insert defined.");
	} 
    }

    class jffnms_zones 		extends internal_base_custom 	{ var $jffnms_class = "zones"; }

    class jffnms_maps 		extends internal_base_custom 	{ 
	var $jffnms_class = "maps"; 

	function status_all_down()	{ $params = func_get_args(); return call_user_func_array("maps_status_all_down",$params); }
    }

    class jffnms_hosts 		extends internal_base_custom 	{ 
	var $jffnms_class = "hosts"; 
	var $jffnms_insert = array("name"=>"New Host"); 

	function count()		{ $params = func_get_args(); return call_user_func_array("hosts_count",$params); }
	function poller_plan()		{ $params = func_get_args(); return call_user_func_array("poller_plan",$params); }
	function poller_plan_next()	{ $params = func_get_args(); return call_user_func_array("poller_plan_next",$params); }
	function status_dmii()		{ $params = func_get_args(); return call_user_func_array("hosts_status_dmii",$params); }

	function interfaces()		{ $params = func_get_args(); return call_user_func_array("hosts_interfaces_from_db",$params); }
	function discovery()		{ $params = func_get_args(); return call_user_func_array("hosts_interfaces_from_discovery",$params); }
    }

    class jffnms_maps_interfaces extends internal_base_custom 	{ 
	var $jffnms_class = "maps_interfaces"; 

	function delete_from_all()	{ $params = func_get_args(); return call_user_func_array("adm_maps_interfaces_del_from_all",$params); }
	function delete_links()		{ $params = func_get_args(); return call_user_func_array("maps_interfaces_delete_links",$params); }
    }

    class jffnms_hosts_config	extends internal_base_custom 	{ 
	var $jffnms_class = "hosts_config"; 
	
	function diff()	{ $params = func_get_args(); return call_user_func_array("hosts_config_diff",$params); }
    }

    class jffnms_hosts_config_types	extends internal_base_standard 	{ 
	var $jffnms_class = "hosts_config_types"; 
	var $jffnms_insert = array(description=>"New Host Config Type"); 
	var $jffnms_filter_record = 0;
    }

    class jffnms_interfaces	extends internal_base_custom 	{ 
	var $jffnms_class = "interfaces";
	
	function count()	{ $params = func_get_args(); return call_user_func_array("interface_count",$params); }
	function is_up()	{ $params = func_get_args(); return call_user_func_array("interface_is_up",$params); }
	function get_type()	{ $params = func_get_args(); return call_user_func_array("interface_get_type_info",$params); }
	function adjust_rrd()	{ $params = func_get_args(); return call_user_func_array("interface_adjust_rrd",$params); }
	function get_availability()	{ $params = func_get_args(); return call_user_func_array("interface_get_availability",$params); }
	function get_rtt_pl()	{ $params = func_get_args(); return call_user_func_array("get_rrd_rtt_pl",$params); }
	function maps()		{ $params = func_get_args(); return call_user_func_array("interface_maps",$params); }
	function graph()	{ $params = func_get_args(); return call_user_func_array("rrd_grapher",$params); }
	function fetch_ds()	{ $params = func_get_args(); return call_user_func_array("rrdtool_fetch_ds",$params); }
    }

    class jffnms_autodiscovery	extends internal_base_standard 	{ 
	var $jffnms_class = "autodiscovery"; 
	var $jffnms_insert = array(description=>"New Autodiscovery Type"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_field = "description";
    }

    class jffnms_clients	extends internal_base_standard 	{ 
	var $jffnms_class = "clients";  
	var $jffnms_insert = array(name=>"a New Customer",shortname=>"new_cust"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_field = "name";
	var $jffnms_order_type = "asc";
    }

    class jffnms_graph_types	extends internal_base_standard 	{ 
	var $jffnms_class = "graph_types";  
	var $jffnms_insert = array(description=>"New Graph Type"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"interface_types"),	$ids, 
		array($this->jffnms_class.".*","types_description"=>"interface_types.description") ,	
		array(array($this->jffnms_class.".type","=","interface_types.id"),array($this->jffnms_class.".id",">",0)),
		array(
		    array($this->jffnms_class.".type","asc"),
		    array($this->jffnms_class.".id","asc")
		    )); 
	}
    }

    class jffnms_severity extends internal_base_standard 	{ 
	var $jffnms_class = "severity";  
	var $jffnms_insert = array("severity"=>"New Severity",bgcolor=>"000000",fgcolor=>"FFFFFF"); 
    }

    class jffnms_journal extends internal_base_standard 	{ 
	var $jffnms_class = "journal";  
	var $jffnms_insert = array("subject"=>"New Journal"); 

        function get_all()		{ $params = func_get_args(); return call_user_func_array("journal_list",$params); }
        function update()		{ $params = func_get_args(); return call_user_func_array("journal_update",$params); }
	function create_ticket()	{ $params = func_get_args(); $params = array_merge(array("create"),$params); return call_user_func_array("journal_ticket",$params); }
	function view_ticket_url()	{ $params = func_get_args(); $params = array_merge(array("view"),$params); return call_user_func_array("journal_ticket",$params); }
    }

    class jffnms_syslog_types extends internal_base_standard 	{ 
	var $jffnms_class = "syslog_types";  
	var $jffnms_insert = array("match_text"=>"New Syslog Message Type","info"=>"*"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"types"),	$ids, 
		array($this->jffnms_class.".*","types_description"=>"types.description") ,	
		array(array($this->jffnms_class.".type","=","types.id"),array($this->jffnms_class.".id",">",1)),
		array(array($this->jffnms_class.".pos","asc"),array($this->jffnms_class.".id","desc"))
		); 
	}
    }

    class jffnms_event_types extends internal_base_standard 	{ 
	var $jffnms_class = "types";  
	var $jffnms_insert = array("description"=>"New Event Type"); 

        function get_all($ids = NULL,$filters = NULL)	{ 
	    $where_special = array();
	    if ($filters[generate_alarm]==1) $where_special[]=array("types.generate_alarm","=",1);

	    if ($filters[show_unknown]==1) $where_special[]=array($this->jffnms_class.".id",">",0);
		else $where_special[]=array($this->jffnms_class.".id",">",1);
	    
	    return get_db_list(	
		array($this->jffnms_class,"severity","up"=>$this->jffnms_class),	$ids, 
		array($this->jffnms_class.".*","severity_description"=>"severity.severity","alarm_up_description"=>"up.description"),	
		array_merge(
		    array(
			array($this->jffnms_class.".severity","=","severity.id"),
			array($this->jffnms_class.".alarm_up","=","up.id")),$where_special),
		array(array($this->jffnms_class.".description","desc"))
		); 
	}
    }

    class jffnms_interface_types extends internal_base_standard 	{ 
	var $jffnms_class = "interface_types";  
	var $jffnms_insert = array("description"=>"New Interface Type","autodiscovery_function"=>"none","rrd_structure_res"=>103680,
	    "rrd_structure_rra"=>"RRA:AVERAGE:0.5:1:<resolution>"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"pollers_groups","graph_types","slas"),	$ids, 
		array($this->jffnms_class.".*",
		    "poller_default"=>"pollers_groups.description",
		    "graph_types_description"=>"graph_types.description",	
		    "slas_description"=>"slas.description"),	
		array(
		    array($this->jffnms_class.".autodiscovery_default_poller","=","pollers_groups.id"),
		    array($this->jffnms_class.".graph_default","=","graph_types.id"),
		    array($this->jffnms_class.".sla_default","=","slas.id"),
		    array($this->jffnms_class.".id",">",0)),
		array(array($this->jffnms_class.".description","desc"))
		); 

	}
    }

    class jffnms_filters	extends internal_base_standard 	{ 
	var $jffnms_class = "filters";  
	var $jffnms_insert = array("description"=>"New Filter"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_type = "asc";
	
	function generate_sql()	{ $params = func_get_args(); return call_user_func_array("filters_generate_sql",$params); }
	function generate_where() { $params = func_get_args(); return call_user_func_array("filters_generate_sql2",$params); }
    }

    class jffnms_filters_fields	extends internal_base_standard 	{ 
	var $jffnms_class = "filters_fields";
	var $jffnms_insert = array("description"=>"New Filter Field"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_field = "description";
	var $jffnms_order_type = "asc";
    }

    class jffnms_filters_cond extends internal_base_standard 	{ 
	var $jffnms_class = "filters_cond";  
	var $jffnms_insert = array(pos=>1); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array("filters",$this->jffnms_class,"filters_fields"),	$ids, 
		array($this->jffnms_class.".*",
		    "filter_description"=>"filters.description",
		    "field_description"=>"filters_fields.description",	
		    "field_name"=>"filters_fields.field"),
		array(
		    array($this->jffnms_class.".field_id","=","filters_fields.id"),
		    array($this->jffnms_class.".filter_id","=","filters.id"),
		    ),
		array(
		    array("filters_cond.filter_id","asc"),
		    array("filters_cond.pos","asc"),
		    array("filters_cond.id","desc")
		    )); 
	}
	function add($filter = 1) { return db_insert($this->jffnms_class,array("filter_id"=>$filter)); }
    }

    class jffnms_slas extends internal_base_standard 	{ 
	var $jffnms_class = "slas";  
	var $jffnms_insert = array("description"=>"New SLA"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"types","interface_types","alarm_states"),	$ids, 
		array($this->jffnms_class.".*",
			"state_description"=>"alarm_states.description",
			"types_description"=>"types.description",
			"interface_type_description"=>"interface_types.description") ,	
		array(	
		    array($this->jffnms_class.".event_type","=","types.id"),
		    array($this->jffnms_class.".interface_type","=","interface_types.id"),
		    array($this->jffnms_class.".state","=","alarm_states.id"),
		    array($this->jffnms_class.".id",">",1)),
		    array(array($this->jffnms_class.".id","desc"))
		    ); 
	}
    }

    class jffnms_slas_cond	extends internal_base_standard 	{ 
	var $jffnms_class = "slas_cond";  
	var $jffnms_insert = array("description"=>"New Condition"); 
    }

    class jffnms_alarm_states	extends internal_base_standard 	{ 
	var $jffnms_class = "alarm_states";  
	var $jffnms_insert = array("description"=>"new"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_type = "asc";
    }

    class jffnms_pollers_backend	extends internal_base_standard 	{ 
	var $jffnms_class = "pollers_backend";  
	var $jffnms_insert = array("description"=>"a New Backend",command=>"no_backend"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_field = "description";
	var $jffnms_order_type = "asc";
    }

    class jffnms_pollers	extends internal_base_standard 	{ 
	var $jffnms_class = "pollers";  
	var $jffnms_insert = array("description"=>"a New Poller",name=>"new_poller",command=>"no_poller"); 
	var $jffnms_filter_record = 0;
	var $jffnms_order_field = "description";
	var $jffnms_order_type = "asc";
    }

    class jffnms_trap_receivers	extends internal_base_standard 	{ 
	var $jffnms_class = "trap_receivers";  
	var $jffnms_insert = array("description"=>"a New Trap Receiver", "match_oid"=>"Trap OID", "position"=>"10", "command"=>"none");
	var $jffnms_filter_record = 0;

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"interface_types","pollers_backend"),	$ids, 
		array(
		    $this->jffnms_class.".*",
		    "interface_type_description"=>"interface_types.description", 
		    "backend_description"=>"pollers_backend.description"
		    ) ,	
		array(
		    array($this->jffnms_class.".interface_type","=","interface_types.id"),
		    array($this->jffnms_class.".backend","=","pollers_backend.id")
		    ),
		array(
		    array($this->jffnms_class.".position","asc"),
		    array($this->jffnms_class.".description","asc"),
		    array($this->jffnms_class.".id","desc")
		    )
		); 
	}
    }

    class jffnms_pollers_groups extends internal_base_standard 	{ 
	var $jffnms_class = "pollers_groups";  
	var $jffnms_insert = array("description"=>"New Poller Group"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array($this->jffnms_class,"interface_types"),	$ids, 
		array($this->jffnms_class.".*","type_description"=>"interface_types.description") ,	
		array(	
		    array($this->jffnms_class.".interface_type","=","interface_types.id"),
		    array($this->jffnms_class.".id",">",1)),
		array(array($this->jffnms_class.".id","desc")) 
		    ); 
	}
    }

    class jffnms_pollers_poller_groups extends internal_base_standard 	{ 
	var $jffnms_class = "pollers_poller_groups";  
	var $jffnms_insert = array(); //no error

	function add() 	{ 
	    return db_insert($this->jffnms_class,array("poller_group"=>$GLOBALS[filter])); 
	}
    
        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array("pollers_groups",$this->jffnms_class,"pollers","pollers_backend"),	$ids, 
		array(	$this->jffnms_class.".*",
			"group_description"=>"pollers_groups.description",
			"poller_description"=>"pollers.description",
			"backend_description"=>"pollers_backend.description"
		    ) ,	
		array(	
		    array($this->jffnms_class.".poller_group","=","pollers_groups.id"),
		    array($this->jffnms_class.".poller","=","pollers.id"),
		    array($this->jffnms_class.".backend","=","pollers_backend.id"),
		    array($this->jffnms_class.".id",">",1)),
		
		array(
		    array("pollers_poller_groups.poller_group","asc"), 
		    array("pollers_poller_groups.pos","asc"), 
		    array("pollers_poller_groups.id","desc")
		)); 
	}
    }

    class jffnms_slas_sla_cond extends internal_base_standard 	{ 
	var $jffnms_class = "slas_sla_cond";  
	var $jffnms_insert = array(); //no error
	
	function add() 	{ 
	    return db_insert($this->jffnms_class,array("sla"=>$GLOBALS[filter])); 
	}
    
        function get_all($ids = NULL)	{ 
	    return get_db_list(	
		array("slas",$this->jffnms_class,"slas_cond"),	$ids, 
		array(	$this->jffnms_class.".*",
			"sla_description"=>"slas.description",
			"cond_description"=>"slas_cond.description"
		    ) ,	
		array(	
		    array($this->jffnms_class.".sla","=","slas.id"),
		    array($this->jffnms_class.".cond","=","slas_cond.id"),
		    array($this->jffnms_class.".id",">",1)),
		
		array(
		    array("slas_sla_cond.sla","asc"), 
		    array("slas_sla_cond.pos","asc"), 
		    array("slas_sla_cond.id","desc")
		)); 
	}
    }


    class jffnms_users extends basic {
	var $jffnms_class = "auth";  

        function get_all()	{ $params = func_get_args(); return call_user_func_array("users_list",$params); }
        function add() 		{ $params = func_get_args(); return call_user_func_array("user_add",$params); }
        function update()	{ $params = func_get_args(); return call_user_func_array("user_modify",$params); }
        function delete()	{ $params = func_get_args(); return call_user_func_array("user_del",$params); }
	function get_id()	{ $params = func_get_args(); return call_user_func_array("user_get_id",$params); }
	function get_username()	{ $params = func_get_args(); return call_user_func_array("user_get_username",$params); }
    }

    class jffnms_alarms extends basic {

        function get_all()	{ $params = func_get_args(); return call_user_func_array("alarms_list",$params); }
        function add() 		{ $params = func_get_args(); return call_user_func_array("insert_alarm",$params); }
        function update()	{ $params = func_get_args(); return call_user_func_array("alarms_update",$params); }
        function delete()	{ $params = func_get_args(); return call_user_func_array("alarms_delete",$params); }
	function status()	{ $params = func_get_args(); return call_user_func_array("have_other_alarm",$params); }
    }

    class jffnms_events extends basic {

        function get_all()	{ $params = func_get_args(); return call_user_func_array("events_list",$params); }
        function add() 		{ $params = func_get_args(); return call_user_func_array("insert_event",$params); }
        function set_analized()	{ $params = func_get_args(); return call_user_func_array("events_analized",$params); }
        function set_ack()	{ $params = func_get_args(); return call_user_func_array("events_ack",$params); }
        function make_latest()	{ $params = func_get_args(); return call_user_func_array("make_events_latest",$params); }

    }

    class jffnms_interface_types_field_types extends internal_base_standard { 
	var $jffnms_class = "interface_types_field_types";  
	var $jffnms_insert = array("description"=>"New","handler"=>"text"); 
	var $jffnms_filter_record = 1;
	var $jffnms_order_type = "asc";
    }

    class jffnms_interface_types_fields extends internal_base_standard { 
	var $jffnms_class = "interface_types_fields";  
	var $jffnms_insert = array();
	var $jffnms_filter_record = 0;
	
	function get_all()	{ $params = func_get_args(); return call_user_func_array("interface_types_fields_list",$params); }
	
	function update ($id, $data) {
	    
	    //call the update handler and then do a standard update
	
	    $update_function = $data["ftype_handler"];
	    $real_function = "handler_$update_function";
	    $function_file = get_config_option("jffnms_real_path")."/engine/handlers/$update_function.inc.php";

	    if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (include_once($function_file)))) {
		if (function_exists($real_function))
	    	    call_user_func_array($real_function,array($data["name"],&$data["default_value"]));
		else
		    logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
    	    } 

	    unset ($data["ftype_handler"]);
	    return parent::update($id,$data);
	}

	function add($itype = 1) { 
	    return db_insert($this->jffnms_class,array("description"=>"New Field","itype"=>$itype)); 
	}

    }

    class jffnms_interfaces_values extends internal_base_standard { 
	var $jffnms_class = "interfaces_values";  
	var $jffnms_insert = array();
	var $jffnms_filter_record = 0;

        function get_all()	{ $params = func_get_args(); return call_user_func_array("interface_values",$params); }
        function update()	{ $params = func_get_args(); return call_user_func_array("interfaces_update_value",$params); }
        function add()		{ $params = func_get_args(); return call_user_func_array("interfaces_insert_value",$params); }
        function delete()	{ $params = func_get_args(); return call_user_func_array("interfaces_delete_value",$params); }
    }

    class jffnms_nad extends basic {

        function get_data()	{ $params = func_get_args(); return call_user_func_array("nad_get_data",$params); }
        function graph() 	{ $params = func_get_args(); return call_user_func_array("nad_graph",$params); }
    }


    class basic {
	var $record;
	var $record_pos;

	//Generic item list handling functions
	//------------------------------------
		
	function fetch() {
	    if ($result = $this->get_current()) $this->record_pos++;
	    return $result;
	}

	function get_current() 	{ 
	    reset ($this->record);
	    for ($i=0; $i < $this->record_pos; $i++) next($this->record);
	    return current($this->record);
	}

        function count() 	{ return count($this->record); }
        function _count() 	{ return count($this->record); }
        function count_all() 	{ return count($this->get_all()); }
	
	function slice($init,$span) {
	    $this->record = array_slice($this->record,$init,$span+1);
	    reset($this->record);
	    return true;
	}	
    
        function get() 	{ 
	    $params = func_get_args(); 
	    $this->record_pos = 0;
	    $this->record = call_user_func_array(array(&$this,'get_all'),$params);
	    return $this->_count();
	}
    
	function get_empty_record () {
	    //Get the 'Unknown' Record 1
	    $aux = current(get_db_list(	$this->jffnms_class,	1, 	array($this->jffnms_class.".*"))); //table,ids,fields	

	    foreach ($aux as $key=>$value) 	//fill the values with the default data
		$aux[$key] = (isset($this->jffnms_insert[$key])?$this->jffnms_insert[$key]:$value);
	    
	    return $aux;
	}
    
	function field_values ($fields = NULL) {
	    $values = array();

	    $all_records = $this->get_all();
	    
	    while (list(,$row) = each ($all_records)) 
		while (list($field, $value) = each ($row))
		    if ($fields===NULL)
			$values[$field][]=$value;
	            else 
			if (isset($fields[$field]))
			    $values[$field][$value]=$row[$fields[$field]];
		
	    unset ($values["id"]);
	    
	    while (list ($field, $value) = each ($values)) {
		$values[$field] = array_unique($value);
		asort ($values[$field]);
		$values[$field] = array(""=>"") + $values[$field];
	    }
	    
	    reset ($values);
	    
	    return $values;
	}
    
	function verify_operations() {
	    $add = $this->add();
	    $upd = $this->update($add,array("id"=>$add));
	    $cant = $this->count_all();

	    if (method_exists($this,"status")) $status = $this->status($add);
		else $status = "Object does not have this method.";
		
	    $del = $this->delete($add);
	    
	    debug ("ADD(): ".$add);
	    debug ("UPDATE(): ".$upd);
	    debug ("COUNT_ALL(): ".$cant);
	    debug ("STATUS():");
	    debug ($status);
	    debug ("DELETE():");
	    debug ($del);
	}

	//Satellite Distribution Import/Export of Data
	//--------------------------------------------

	function export ($filter = NULL) {
	    
	    $result = array();
	    $tables = array($this->jffnms_class);
	
	    if (is_array($filter)) 
		foreach ($filter as $key=>$value)
		    switch ($key) {
		    
			case "add_tables":
			    if (is_array($value))
				$tables = array_merge($tables,$value);
			    else
				$tables[] = $value;
			    break;
			
			default:
			    if ($value) 
				$where_filter[]=array($key,"=",$value);
		    }
	    
            $result_raw = get_db_list ($tables, NULL, array($this->jffnms_class.".*"), //table,ids,fields
                $where_filter, //where
                array(array($this->jffnms_class.".id","asc"))); //order

            while (list($k,$v) = each($result_raw)) {
		$result[$v["id"]]=$v;
		unset ($result_raw[$k]);
	    }
	    
            reset($result);
            return $result;
	}
	
	function import ($new_data = NULL, $old_data = NULL) {
	    
	    if (!is_array($old_data) and is_array($new_data)) //new record 
		$result["add"] = db_insert ($this->jffnms_class,$new_data);
	    else
		if (!is_array($new_data) and is_array($old_data)) //delete
		    $result["del"] = db_delete($this->jffnms_class,$old_data["id"]);
		else { //update
		    $diff = array_merge ($old_data,$new_data);
		    $keys = array_keys ($diff);
		    
		    $keys_dont_check = array("last_poll");
		    
		    foreach ($keys as $k)
			if (((string)$old_data[$k]===(string)$new_data[$k]) || in_array($k,$keys_dont_check))
			    unset ($diff[$k]);

		    if (count($diff) > 0) //if there's a different field
			$result["mod"] = db_update($this->jffnms_class,$old_data["id"],$diff);
		    else
			$result["mod"] = 0;
		}
	    return $result;
	}

	function get_methods() {
	    return get_class_methods($this);
	}
    }
    

    class jffnms {
	var $detected_classes;
	var $initialized_classes;
				
    	function jffnms ($init_all=0) {
	    $classes = get_declared_classes();
	    
	    foreach ($classes as $aux)
		if (strpos($aux,"jffnms_") !== FALSE) {
		    $temp = substr($aux,7,strlen($aux));
		    $this->detected_classes[$aux]=$temp;
		    if ($init_all==1) $this->init_class($temp);
		}
	    
	    if ($init_all==1)
		return $this->get_initialized_classes();
	    else 
		return true;
	}
	
	function init_class($var) { 
	    $obj = "jffnms_$var";
	    $this->$var = new $obj(); 
	    $this->initialized_classes[$obj]=$var;
	}
		
	function get($obj) { 
           if (!isset($this->$obj) ) $this->$obj="dummy"; //FIXME return an error
	    if (!is_object($this->$obj)) $this->init_class($obj);
	    return $this->$obj;
	}

	function call_proxy() { $params = func_get_args(); return call_user_func_array(array($this,"proxy"),$params); } //proxy alias for perl

	function get_detected_classes () {
	    return $this->detected_classes;
	}

	function get_initialized_classes () {
	    return $this->initialized_classes;
	}

	function authenticate($user, $pass, $log_event = false, $log_event_info = "") { 
	    $auth = 0;
    	    $auth_type = 1;
	    $cant_auth = 0;
	    
	    if (isset($user) && isset($pass)) {
		$query_auth = "select id as auth_user_id, usern as auth_user_name, passwd, fullname as auth_user_fullname from auth where usern = '$user'";
		$result_auth = db_query ($query_auth);
		$cant_auth = db_num_rows($result_auth);
	    }
	    
	    if ($cant_auth == 1) {
		$reg = db_fetch_array ($result_auth);
		$passwd= trim($reg[passwd]);
		$encrypt = trim(crypt($pass,$passwd));
	
		//debug ("USER $user: plain: $pass crypt: $encrypt stored: $passwd");
		if ($encrypt == $passwd) $auth = 1;
	    } 
    
	    if (($auth==0) && ($cant_auth == 0)){  //not found in DB
		if (isset($user) && isset($pass)) {
    		    $query_auth = "select id as auth_user_id, username as auth_user_name, name as auth_user_fullname from clients where username= '$user' and password = '$pass'";
		    $result_auth = db_query ($query_auth);
		    $auth = db_num_rows( $result_auth);
		}
		if ($auth==1) { 
		    $reg = db_fetch_array($result_auth);
		    $auth_type = 2;
		}
	    }
	    
	    if (($log_event==true) && (!empty($user)))
		insert_event(date("Y-m-d H:i:s",time()),get_config_option("jffnms_internal_type"),1,"Login",(($auth==1)?"successful":"failed"),$user,$log_event_info,"",0);
	    
	    unset ($reg["passwd"]);
	    
	    return array($auth,$auth_type,$reg);
	}

	function get_methods() {
	    return get_class_methods($this);
	}

	function proxy() {
	    $all_params = func_get_args();
	    $obj = $all_params[0];
	    $method = $all_params[1];
	    $params = $all_params[2];

	    if ($obj!="jffnms") {
		if (!is_object($this->$obj)) $this->init_class($obj);
		return call_user_func_array(array(&$this->$obj,$method),$params);
	    } else
		return call_user_func_array(array(&$this,$method),$params);
	}
	
	function ping() {
	    return "pong";
	}
	
    	function config_option()	{ $params = func_get_args(); return call_user_func_array("get_config_option",$params); }
	
    }	
?>
