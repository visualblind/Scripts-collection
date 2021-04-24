<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

//CLASS 
//-----------------------------------------

    class jffnms_actions extends internal_base_standard 	{ 
	var $jffnms_class = "actions";  
	var $jffnms_insert = array("description"=>"New Action","command"=>"none"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	$this->jffnms_class,	$ids, 	array($this->jffnms_class.".*"), //table,ids,fields	
		array(array($this->jffnms_class.".id",">",0)), //where
		array(array($this->jffnms_class.".id","desc")) ); //order 
	}

    }


    class jffnms_triggers extends internal_base_standard 	{ 
	var $jffnms_class = "triggers";  
	var $jffnms_insert = array("description"=>"New Trigger"); 

        function get_all($ids = NULL)	{ 
	    return get_db_list(	$this->jffnms_class,	$ids, 	array($this->jffnms_class.".*"), //table,ids,fields	
		array(array($this->jffnms_class.".id",">",0)), //where
		array(array($this->jffnms_class.".id","asc")) ); //order 
	}
    
        function delete()		{ $params = func_get_args(); return call_user_func_array("triggers_del",$params); }
    }

    class jffnms_triggers_users extends internal_base_standard 	{ 
	var $jffnms_class = "triggers_users";  
	var $jffnms_insert = array("active"=>"0"); 

	function add($user_id) 		{   if ($user_id < 1) $user_id=1;
					    $this->jffnms_insert[user_id]=$user_id;
					    return db_insert($this->jffnms_class,$this->jffnms_insert); }
        function get_all()		{ $params = func_get_args(); return call_user_func_array("triggers_users_list",$params); }
        function delete()		{ $params = func_get_args(); return call_user_func_array("triggers_users_del",$params); }
    }

    class jffnms_triggers_rules extends internal_base_standard 	{ 
	var $jffnms_class = "triggers_rules";  
	var $jffnms_insert = array("action_id"=>"1","stop"=>"0"); 

	function add($trigger_id) 	{   $this->jffnms_insert[trigger_id]=$trigger_id;
					    return db_insert($this->jffnms_class,$this->jffnms_insert); }

        function get_all()		{ $params = func_get_args(); return call_user_func_array("triggers_rules_list",$params); }
        function delete()		{ $params = func_get_args(); return call_user_func_array("triggers_rules_del",$params); }
    }



//Methods 
//-----------------------------------------
  
    function action_execute ($command, $parameters, $user_ids, $data_type, $data) {
        $real_function = "action_$command";
        $function_file = get_config_option("jffnms_real_path")."/engine/actions/$command.inc.php";

	if (!is_array($user_ids)) $user_ids=array($user_ids);

        if (in_array($function_file,get_included_files()) || (file_exists($function_file) &&  (@include_once($function_file))) ) {
	    if (function_exists($real_function)) {

		unset($parameters_array);
		unset($function_data);
		
		if ($data_type=="alarm") { 
		    if ($data["interface"]) $function_data["interface"]=current(interfaces_list($data["interface"]));	
		
		    if ($data[referer_start]) $function_data[event][start]=current(events_list($data[referer_start]));
		    if ($data[referer_stop]) $function_data[event][stop]=current(events_list($data[referer_stop]));
		    
		    if ($function_data[event]) krsort($function_data[event]);
		    
		    $function_data[alarm]=$data; //alarm data
		}

		if ($data_type=="event") {
		    $function_data[event][]=$data;
		    
		    if ($data[interface_id] > 1)
			$function_data["interface"]=current(interfaces_list($data[interface_id]));
		}
		
		$param_aux = explode(",",$parameters);

		foreach ($param_aux as $aux) 
		    if ($aux) {
			$pair = explode(":",$aux);
			
			if (($pair[0]=="from") && (!empty($pair[1]))) $parameters_array[$pair[0]]=""; //EXCEPTION "from" handling, keep the last one
			
			$parameters_array[$pair[0]].=" ".$pair[1];
			$parameters_array[$pair[0]] = trim($parameters_array[$pair[0]]);
		    }
	
		if (is_array($parameters_array)) {  	
		    $replacer=array("interface","alarm","event");
		
		    foreach ($replacer as $aux) 
			if ($function_data[$aux]) { //replace variables 

			    if ($aux=="event") $data=current($function_data[$aux]); //take only last event
				else $data = $function_data[$aux];
    
			    if (is_array($data))
			    foreach ($data as $var_key=>$var_data) //every piece of data
				foreach ($parameters_array as $key=>$param)  //every parameter
				    $parameters_array[$key]=str_replace("<$aux-$var_key>",$var_data,$parameters_array[$key]);
			}
		}//parameters
		
		//debug ($parameters_array);
	
		$parameters_array_aux = $parameters_array; //save parameters before users loop
		
		$result=Array();
		
		if (is_array($user_ids) && (count ($user_ids) > 0)) 		
		foreach ($user_ids as $user_id)
                        if ($user_id > 1) {
				$user_id = $user_id[user_id];
				$function_data[user] = current(users_list($user_id)); 	//get user data
          
				if (is_array($parameters_array)) {  	
					$profile_options = profiles_list($user_id);
					foreach ($profile_options as $profile) //replace profile variables
						foreach ($parameters_array as $key=>$param) 
							$parameters_array[$key]=str_replace("<profile-".strtolower($profile[tag]).">",$profile[values_value],$param);
				}
				
		        	$function_data[parameters]=$parameters_array;
				//debug ($function_data);
				$result[]= call_user_func_array($real_function,array($function_data));

				$parameters_array=$parameters_array_aux; //restore parameters
			}
	    } else logger("ERROR: Calling Function '$real_function' doesn't exists.<br>\n");
	} else logger ("ERROR Loading file $function_file.<br>\n");

	return join(",",$result);
    }

    function trigger_analize ($data_type, $data, $log_it = 1){
    
	$old_script_name = $GLOBALS["jffnms_logging_file"];	
	$GLOBALS["jffnms_logging_file"] = "triggers";

	//debug ($data);

	$query_rules = " 
	    select 
		triggers.id as trigger_id, 
		triggers_rules.id as rule_id, triggers_rules.pos as rule_pos, triggers_rules.field, 
		triggers_rules.operator, triggers_rules.value, triggers_rules.action_parameters, triggers_rules.stop as rule_stop,
		triggers_rules.and_or,
		actions.id as action_id, actions.command as action_command, actions.internal_parameters as internal_parameters
	    from triggers_rules, triggers, triggers_users, actions
	    where 
	        triggers_users.trigger_id = triggers.id and triggers_users.active = 1 and triggers.type = '$data_type' and
		triggers_rules.trigger_id = triggers.id  and triggers_rules.action_id = actions.id 
	    group by 
		triggers_rules.id, triggers_rules.pos, triggers_rules.field, triggers_rules.operator, triggers_rules.value, 
		triggers_rules.action_parameters, triggers_rules.stop, actions.id, actions.command, actions.internal_parameters, triggers.id,
		triggers_rules.and_or
	    order by triggers.id asc, triggers_rules.pos asc, triggers_rules.id asc
	    ";
	    
	//logger($query_rules);

	$result_rules = db_query ($query_rules) or die ("Query failed - trigger_analize(".$data[id].") - ".db_error());
	
	unset ($old_rule);
	
	$stopped_triggers = array();
	
	if ($log_it)
	    if (db_num_rows($result_rules) > 0) 
		logger(str_repeat("=",100)."\n");
	
	while ($rule = db_fetch_array($result_rules)) {
	    unset ($test_value);
	    unset ($test_modifier);
	    unset ($rule_field);
	    unset ($eval_result);
	    
	    //debug ($data);

	    if ($stopped_triggers[$rule[trigger_id]]==0) { //trigger rules are not over

		if (($log_it) && ($old_trigger) && ($old_trigger!=$rule[trigger_id]))  //debuging
		    logger ("$data_type ".$data[id].": ".str_repeat("-",80)."\n");
	
		$rule_field = $rule[field];
		//exceptions
		unset($test_modifier);
		if (strpos("date",$rule["field"]) > -1) $test_modifier = "time";
		if (strpos("map",$rule["field"]) > -1)  $test_modifier = "map";
	
		if (($data_type=="alarm") && ($rule[field]=="date")) {
			if (strtotime($data[date_stop]) > strtotime($data[date_start]))
				$data[date]=$data[date_stop];
			else
				$data[date]=$data[date_start];
		}

		$test_value = $data[$rule_field];
		
		//Map Exception
		if ($rule_field=="map") {
		    $test_value = $rule["value"];
		    $rule["value"] = join(",",interface_maps($data["interface"]));
		    $rule["operator"]="IN"; //force IN
		}

		if ($rule_field=="none") $eval_result = 0;
		    else if ($rule_field=="any") $eval_result = 1;
			else $eval_result = trigger_test_operation ($test_value,$rule[operator],$rule[value],$test_modifier);


		if ($eval_result==1) { //if the eval was true
		    if ($rule[rule_stop]==1) $stopped_triggers[$rule[trigger_id]]=1;
		    
		    if ($rule[action_id] > 1) {
				$action_result = action_execute($rule[action_command],$rule[internal_parameters].",".$rule[action_parameters],
						triggers_users_list(NULL,NULL,$rule[trigger_id],1),$data_type,$data);
				/**
				 * Update the alarm and set the triggered flag
				 * To not sent out triggers for the same alarm twice
				 */
				 db_update("alarms",$data["id"],$arr = array("triggered" => 1));
			} else {
				$action_result = 0;
			}

		} else //if the eval was false
		    if ($rule["and_or"]==1) //and rule specified AND
			$stopped_triggers[$rule[trigger_id]]=1; //Stop this trigger

		//Logging & Debugging

		$log=array();
		if (($rule_field!="none") && ($rule_field!="any"))
		    $log[]="\tIf '".$rule[field]."(".substr($test_value,0,20).") ".$rule[operator]." ".$rule[value]."' ($eval_result)";
		else
		    $log[]="\tIf '".$rule[field]."' ($eval_result)";
		
		if (($eval_result==1) && ($rule[action_id] > 1))
		    $log[]="\tThen ".$rule[action_command]." ($action_result)";
	    	    
		if ($stopped_triggers[$rule[trigger_id]]==1) 
		    $log[]="\tStop"; 

		if ($log_it)
		logger ("$data_type ".$data[id].": ".
		    "\tT ".$rule[trigger_id].
		    " - P ".$rule[rule_pos].
		    " - R ".$rule[rule_id].
		    join("",$log)."\n");

	    }//not stopped
	
	    $old_trigger = $rule[trigger_id];
	    $old_rule = $rule[rule_id];
	}//while

	$GLOBALS["jffnms_logging_file"] = $old_script_name;
    }

    function trigger_test_operation ($value1, $op, $value2, $modifier = NULL) {
	$result = 0;
	
	switch ($modifier) { //exceptions
	    case "time" : 	
			    $today = strtotime(substr($value1,0,10)." 00:00:00");
	        	    $value1 = strtotime($value1)-$today;  //only take today hour 
			    break;
	}

	switch ($op) {
	    case "=" 	: 	if ($value1 == $value2) $result = 1; break;
	    case "!=" 	: 	if ($value1 != $value2) $result = 1; break;
	    case ">" 	: 	if ($value1 > $value2) $result = 1; break;
	    case "<" 	: 	if ($value1 < $value2) $result = 1; break;
	    case ">=" 	: 	if ($value1 >= $value2) $result = 1; break;
	    case "<=" 	: 	if ($value1 <= $value2) $result = 1; break;
	    case "IN" 	: 	if (in_array($value1,explode(",",$value2))) $result = 1; break;
	    case "!IN" 	: 	if (!in_array($value1,explode(",",$value2))) $result = 1;break;
	    case "C"	:	if (stristr($value1,$value2)!=false) $result = 1; break;
	    case "!C"	:	if (stristr($value1,$value2)==false) $result = 1; break;
	}
	
	return $result;
    }

    function triggers_users_list($ids = NULL, $user_id = NULL,$trigger_id = NULL,$only_active = 0)	{ 
	$where = array();
	
	if (is_array($user_id)) $user_id = current($user_id);	//fix for adm_standard filter_field
	
	if ($user_id) $where[]=array("triggers_users.user_id","=",$user_id);
	if ($trigger_id) $where[]=array("triggers_users.trigger_id","=",$trigger_id);
	if ($only_active==1) $where[]=array("triggers_users.active","=",1);

	return get_db_list( 
		array("triggers_users","auth","triggers"), $ids, 	
		array(  "triggers_users.*",
			"user_description"=>"auth.fullname",
			"trigger_description"=>"triggers.description"), 	
		array_merge(array(
			array("triggers_users.id",">",1),
			array("triggers_users.user_id","=","auth.id"),
			array("triggers_users.trigger_id","=","triggers.id")),
			$where), 
		array(	array("triggers_users.user_id","desc"),
			array("triggers_users.id","desc")) ); //order 
    }


    function triggers_rules_list($ids = NULL)	{ 
	return get_db_list(	
	    array("triggers","triggers_rules","actions"),$ids, 	
	    array(	"triggers_rules.*",
			"action_description"=>"actions.description",
			"action_parameters_def"=>"actions.user_parameters",
			"trigger_description"=>"triggers.description",	
			"trigger_type"=>"triggers.type"),	
	    array(
	        array("triggers_rules.id",">",0),
	        array("triggers_rules.trigger_id","=","triggers.id"),
	        array("triggers_rules.action_id","=","actions.id")
	    ),
	    array(array("triggers.id","asc"),array("triggers_rules.pos","asc"),array("triggers_rules.id","asc")) ); //order 
    }

    function triggers_rules_del ($trigger_rule_id) {
	return db_delete("triggers_rules",$trigger_rule_id);
    }

    function triggers_users_del ($trigger_user_id) {
	return db_delete("triggers_users",$trigger_user_id);
    }

    function triggers_del ($trigger_id) {

	//delete all rules	
	$rules = triggers_rules_list ($trigger_id);
	
	foreach ($rules as $rule) 
	    triggers_rules_del($rule[id]);

	$rules = triggers_rules_list ($trigger_id);
	

	//delete all user/trigger mappings
	
	$users = triggers_users_list(NULL,NULL,$trigger_id);
	
	foreach ($users as $user)
	    triggers_users_del($user[id]);

	$users = triggers_users_list(NULL,NULL,$trigger_id);
	
	//delete the trigger if everthing is ok
	if ((count($rules) == 0) && (count($users) == 0)) return db_delete("triggers",$trigger_id);
	else return FALSE;
    }

?>
