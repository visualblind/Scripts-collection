<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function user_add ($username) {

	$user_id = db_insert("auth", array("usern"=>$username));

	$query = "SELECT id, default_value FROM profiles_options WHERE use_default = 1"; //FIXME order
	$result = db_query($query) or die ("Query Filed - user_add() - profile - ".db_error()); 

	while ($row = db_fetch_array($result)) //add every default option to the user profile
	    profile_add_option($user_id,$row["id"]);

	return $user_id;
    }

    function user_get_id($username){
	if ($username) {
	    $query = "select id from auth where usern = '$username'";
	    $result = db_query($query) or die ("Query Failed - USER_GET_ID-1 - ".db_error());
	
	    if (db_num_rows($result)==1) {
		$row = db_fetch_array($result);
    		return $row["id"];
	    }
	}
	return false;
    }

    function user_get_username($user_id){
	if ($user_id > 0) {
	    $query = "select usern from auth where id = '$user_id'";
	    $result = db_query($query) or die ("Query Failed - USER_GET_USERNAME-1 - ".db_error());
	    $row = db_fetch_array($result);
	}
	return $row["usern"];
    }

    function user_del ($user_id){ 
	if ($user_id) {
	    foreach (profiles_list($user_id) as $option)  
		profile_del_option($user_id,$option[profile_option]); //delete all user profile options

	    foreach (triggers_users_list(NULL,$user_id) as $user) //delete all user triggers
	        triggers_users_del($user[id]);

	    if ((count(profiles_list($user_id)) == 0) && 
		(count(triggers_users_list(NULL,$user_id)) == 0) )
		return db_delete("auth",$user_id); //if everthing is ok delete the user
	    else 
		return FALSE;
	}	
    }

    function user_modify($user_id, $usern, $old_password, $new_password, $fullname, $router) {

	if ($new_password == $old_password) $passwd = $new_password;
	    else if (!empty($new_password)) $passwd = crypt($new_password);
		
	if (empty($router)) unset($router);
	if (empty($usern)) unset($usern);
	if (empty($passwd)) unset($passwd);
	
    	$user_fields = compact("fullname","usern","passwd","router");
		
	return db_update("auth",$user_id,$user_fields);
    }

    function users_list ($ids = NULL,$where_special = NULL) { 
	
	if (!is_array($where_special)) $where_special = array();

        return get_db_list(
	    "auth",
	    $ids, 
	    array(
	    "*",
	    "old_passwd"=>"passwd"),
	    array_merge(
	        array(array("id",">",1)),
	        $where_special), //where
	    array(array("usern","asc")) ); //order 
    }

?>
