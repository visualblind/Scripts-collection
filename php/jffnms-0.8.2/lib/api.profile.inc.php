<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
//CLASS
//------------------------------------------------------------

    class jffnms_profiles_values extends internal_base_standard 	{ 
	var $jffnms_class = "profiles_values";  
	var $jffnms_insert = array("description"=>"New Value"); 

        function get_all($filter = NULL, $filters=NULL)	{ 

	    if (is_numeric($filter)) $filters["option"] = $filter;
	    $where_filters = array();
	    
	    if (isset($filters["option"])) $where_filters[]=array($this->jffnms_class.".profile_option","=",$filters["option"]);

	    return get_db_list(	array("profiles_options",$this->jffnms_class),	$ids, 	
		array($this->jffnms_class.".*",option_description=>"profiles_options.description"), //table,ids,fields	
		array_merge(
		    array(
			array($this->jffnms_class.".profile_option","=","profiles_options.id"),
			array($this->jffnms_class.".id",">",1)
		    ),$where_filters
		), //where
		array(array($this->jffnms_class.".id","desc")) ); //order 
	}

	function add($option_id = 1) {
	    if (profile_get_option_type($option_id)!="text") 
		return db_insert($this->jffnms_class,array("description"=>"New Value",profile_option=>$option_id,value=>"new_value")); 
	}
    }

    class jffnms_profiles_options extends internal_base_standard 	{ 
	var $jffnms_class = "profiles_options";  
	var $jffnms_insert = array(tag=>"New Tag",description=>"New Option","type"=>"text");

        function get_all($ids = NULL)	{ 
	    return get_db_list(	$this->jffnms_class,	$ids, 	array($this->jffnms_class.".*"), //table,ids,fields	
		array(array($this->jffnms_class.".id",">",0)), //where
		array(array($this->jffnms_class.".id","desc")) ); //order 
	}
    }


    class jffnms_profiles extends basic {

        function get_all()	{ $params = func_get_args(); return call_user_func_array("profiles_list",$params); }
        function add() 		{ $params = func_get_args(); return call_user_func_array("profile_add_option",$params); }
        function update()	{ $params = func_get_args(); return call_user_func_array("profile_modify_value",$params); }
        function delete()	{ $params = func_get_args(); return call_user_func_array("profile_delete",$params); }
	function delete_option(){ $params = func_get_args(); return call_user_func_array("profile_del_option",$params); }
	function get_option()	{ $params = func_get_args(); return call_user_func_array("profile_get_option",$params); }
	function get_value()	{ $params = func_get_args(); return call_user_func_array("profile_get_value",$params); }
    }

//METHODS
//---------------------------------------------------

    function profiles_list ($ids = NULL,$where_special = NULL)	{ 
    
	if (!is_array($where_special)) $where_special = array();
    
        return get_db_list(	
	array("auth","profiles","profiles_options","profiles_values"),	$ids, 
	array(	"profiles.*",
		"profiles_options.*",
		"auth.*",
		"profiles.id",
		"values_description"=>"profiles_values.description",
		"values_value"=>"profiles_values.value"
	    ) ,	
	array_merge(
	array(	
	    array("profiles.userid"   ,"=","auth.id"),
	    array("profiles.profile_option","=","profiles_options.id"),
	    array("profiles.value" ,"=","profiles_values.id"),
	    array("profiles.id",">",1)),
	    $where_special),
	array(
	    array("profiles.userid","desc"), 
	    array("profiles.id","desc")
	)); 
    }

    function profile_get_value($tag, $user_id = 0) {
	global $auth_user_id;
	
	if ($user_id == 0) $user_id = $auth_user_id; //FIXME

	$query_auth = "
		select 	profiles_values.value as profile_value 
		from 	profiles, profiles_options, profiles_values 
		where 	profiles.userid = '$user_id' and 
			profiles_options.tag = '$tag' and 
			profiles_options.id = profiles.profile_option and
			profiles_values.id = profiles.value
			";
	$result_auth = db_query ($query_auth) or die("Query Profile 1 -".db_error());
	$autho = db_num_rows($result_auth);
	if ($autho == 1) {
	    extract(db_fetch_array($result_auth));
	    //echo "$tag: $profile_value";
	    return $profile_value;
	} else 
	    return false;
    }


    function profile_get_option_type ($option) {

	$type = "";
	//find out the type of the option
	$query = " Select type from profiles_options where id = $option";
	$result = db_query ($query) or die ("Query Failed - profile_get_option_type() - ".db_error());
	
	if (db_num_rows($result) == 1) { 
	    $row = db_fetch_array($result);
	    $type = $row["type"];
	}

	return $type;
    }

    function profile_get_option_id ($tag) {

	$id = "";
	//find out the id of the option
	$query = " Select id from profiles_options where tag = '$tag'";
	//echo $query;
	$result = db_query ($query) or die ("Query Failed - AZ10 - ".db_error());
	
	if (db_num_rows($result) == 1) { 
	    $row = db_fetch_array($result);
	    $id = $row["id"];
	}

	return $id;
    }


    function profile_get_option_default_value ($option) {

	$type = "";
	//find out the default_value of the option
	$query = " Select default_value from profiles_options where id = $option";
	$result = db_query ($query) or die ("Query Failed - AZ20 - ".db_error());
	
	if (db_num_rows($result) == 1) { 
	    $row = db_fetch_array($result);
	    $default_value = $row["default_value"];
	}
	return $default_value;
    }


    function profile_modify_value($user_id, $option, $value) {

	$value_id = 0;
	
	if (!is_numeric($option)) $option = profile_get_option_id ($option);

	if ($type = profile_get_option_type($option)){
	
	    if ($type=="text") { //if its text modify the value
		
		$value_id = profile_get_option($user_id,$option); //get the actual value of this option for this user

		if (($value_id=="0") or ($value_id==1)) { // didnt have that option //we didnt have any value there so add a new one
		    $query = "insert into profiles_values (profile_option) values ($option)";
		    $result = db_query($query) or die ("Query Failed - AZ12 - ".db_error()); 
		    $value_id = db_insert_id();
		}
	
		if ($value_id > 1) db_update("profiles_values",$value_id,array("value"=>$value)); //update the value
	    }
	    
	    if ($type=="select") { //if its select, find out the ID of the value
		$query = " Select id from profiles_values where profile_option = $option and value = '$value'";
		//echo $query;
		$result = db_query ($query) or die ("Query Failed - AZ10 - ".db_error());
		if (db_num_rows($result) == 1) { 
		    $row = db_fetch_array($result);
		    $value_id = $row["id"];
		}
	    }
	}

	if ($value_id > 0) {
	    $query="Update profiles set 
		    value = '$value_id'
		    where profile_option = '$option' and userid = $user_id";
	    //echo "$query\n";
	    $result = db_query ($query) or die ("Query failed - profiles_modify_value() - ".db_error());
	    return true;
	}
	return false;
    }	


    function profile_add_option($user_id, $option) {//

	$id = "";
	
	if (!is_numeric($option)) $option = profile_get_option_id ($option);

	if (is_numeric($option) and ($option > 0)) { 
	    $query = "insert into profiles (userid,profile_option,value) VALUES ($user_id, $option, 1)";
	    $result = db_query ($query) or die ("Query Failed - AZ15 - ".db_error());
	    $id = db_insert_id();

	    profile_modify_value($user_id,$option,profile_get_option_default_value($option));
	    if ($value=="") $value=1;
	}
	return $id;
    }
	    
    function profile_del_option($user_id, $option) {//

	$query = "delete from profiles where userid = $user_id and profile_option = $option";
	$result = db_query ($query) or die ("Query Failed - AZ14 - ".db_error());
    }

    function profile_get_option( $user_id, $option) {//

	$value_id = 0;
	
	//find out the type of the option
	$query = "select value from profiles where userid = $user_id and profile_option = $option";
	$result = db_query ($query) or die ("Query Failed - AZ17 - ".db_error());
	$num_rows = db_num_rows($result);

	if ($num_rows == 1) { //we have that option 
	    $row = db_fetch_array($result);
	    $value_id = $row["value"];
	}
	
	return $value_id; //return the value
    }

    function profile_delete ($id) {  //
	return db_delete("profiles",$id);	
    }

?>
