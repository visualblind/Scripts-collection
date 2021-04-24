<?
require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=addedit-users.php");
	exit;
}

unset($err_msg);


if (($_SESSION["isadmin"] == $glbl_hash) && ($_POST["add_username"]) && ($_POST["add_password"]) && ($_POST["add_confirm_password"])) {
  $add_username = strip_tags(rtrim(ltrim($_POST["add_username"])));
  $add_password = strip_tags(rtrim(ltrim($_POST["add_password"])));
  $add_confirm_password = strip_tags(rtrim(ltrim($_POST["add_confirm_password"])));
  $add_isadmin = strip_tags(rtrim(ltrim($_POST["add_admin"])));
  if ($add_password == $add_confirm_password) { // this should have already been checked with JS, but just in case...
	$insert_user = "INSERT INTO users VALUES ('','".$add_username."','".md5($add_password)."','".$add_isadmin."')";
	$result_user = db_query($insert_user);
	if ($result_user == 1) { $err_msg .= '<b><br>User added successfully.</b><br>&nbsp;'; }
  } else { // password matching should have also been checked already, but just in case...
    $err_msg .= '<b><br>Passwords do not match!</b><br>&nbsp;';
  }
  unset($add_username,$add_password,$add_confirm_password,$add_isadmin);
}


if (($_POST["which_user"]) && ($_POST["edit_password"]) && ($_POST["edit_confirm_password"])) {
  $userid = strip_tags(rtrim(ltrim($_POST["which_user"])));
  $edit_password = strip_tags(rtrim(ltrim($_POST["edit_password"])));
  $edit_confirm_password = strip_tags(rtrim(ltrim($_POST["edit_confirm_password"])));
  if ($edit_password == $edit_confirm_password) { // this should have already been checked with JS, but just in case...
	$update_pw = "UPDATE users SET password='".md5($edit_password)."' WHERE userid='".$userid."'";
	$result_pw = db_query($update_pw);
	if ($result_pw == 1) { $err_msg .= '<b><br>Password changed successfully.</b><br>&nbsp;'; }
  } else { // password matching should have also been checked already, but just in case...
    $err_msg .= '<b><br>Passwords do not match!</b><br>&nbsp;';
  }
  unset($userid,$edit_password,$edit_confirm_password);
}


if (($_SESSION["isadmin"] == $glbl_hash) && ($_POST["adminpriv_userid"])) {
  // Must be an admin to change someone's admin rights or delete them.
  $del_userid = strip_tags(rtrim(ltrim($_POST["adminpriv_userid"])));
  $edit_admin = strip_tags(rtrim(ltrim($_POST["admin"])));
  if (($_POST["del_sure"] != 1) && ($del_userid != $_SESSION["userid"])) {
    // user must have tripped the admin box
	$update_admin = "UPDATE users SET admin='".$edit_admin."' WHERE userid='".$del_userid."'";
	$result_admin = db_query($update_admin);
  } else if (($_POST["del_sure"] == 1) && ($del_userid != $_SESSION["userid"])) {
    // user must have tripped the delete box
    $delete_admin = "DELETE FROM users WHERE userid='".$del_userid."'";
    $result_admin = db_query($delete_admin);
  }
  unset($del_userid,$edit_admin);
}




$title = "Add/Edit Users";
require_once("header.php");

if ($err_msg) {
  echo '<center><div style="width:400px;" class="errmsg">'.$err_msg.'</div></center><br><br>';
}

if ($_SESSION["isadmin"] == $glbl_hash) { // must be admin to add new users
  echo '<table class="addedit-users" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
      <form name="addedit" action="'.$_SERVER["PHP_SELF"].'" method="POST">
         <tr valign="top">
           <td colspan="2" align="left"><span style="border-bottom:1px solid #A00000;font-weight:bold;">ADD A NEW USER:</span><font size="1"><br><br></font></td>
	     </tr>
		 <tr>
		   <td align="right"><b>Username:</b>&nbsp;</td>
		   <td align="left"><input type="text" name="add_username" size="25"></td>
		 </tr>
		 <tr>
		   <td align="right"><b>Password:</b>&nbsp;</td>
		   <td align="left"><input type="password" name="add_password" size="25"></td>
		 </tr>
		 <tr>
		   <td align="right"><b>Re-Type Password:</b>&nbsp;</td>
		   <td align="left"><input type="password" name="add_confirm_password" size="25"></td>
		 </tr>
		 <tr>
		   <td colspan="2" align="center"><b><font color="#A00000">Grant Administrative Privileges</font></b>&nbsp;[<a href="help.php?topic=admin_priv" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=admin_priv\',300,160))">?</a>] <input type="checkbox" name="add_admin" value="1">&nbsp;
             <input type="hidden" name="addedit" value="1">
		     <input type="button" value="ADD USER" onClick="javascript:verify();">
		     <font size="1"><br>&nbsp;</font>
		   </td>
		 </tr>
	   </form>
	   </table>
	   <br><br>';
}

if ($_SESSION["isadmin"] == $glbl_hash) { // non-admins can only change their own passwords
  echo '
	   <table class="addedit-users" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
	   <form name="addedit2" action="'.$_SERVER["PHP_SELF"].'" method="POST">
		 <tr>
		   <td colspan="2" align="left"><span style="border-bottom:1px solid #A00000;font-weight:bold;">CHANGE PASSWORD:</span><font size="1"><br><br></font></td>
		 </tr>
		 <tr>
		   <td align="right"><b>Username:</b>&nbsp;</td>
		   <td align="left"><select name="which_user">
	           <option value="0" selected>- SELECT A USER -</option>';
	           $userid_array = array();
	           $username_array = array();
	           $isadmin_array = array();
		       $query_get_users = "SELECT userid,username,admin FROM users ORDER BY username ASC";
		       $result_get_users = db_query($query_get_users);
		       while ($r = db_fetch_array($result_get_users)) {
		              $edit_userid = $r["userid"];
		              array_push($userid_array, $edit_userid);
		              $edit_username = $r["username"];
		              $edit_isadmin = $r["admin"];
		              array_push($isadmin_array, $edit_isadmin);
		              if (strlen($edit_username) > 50) { $edit_username = substr($edit_username, 0, 50)."..."; }
		              array_push($username_array, $edit_username);
		              echo '<option value='.$edit_userid.'>'.$edit_username.'</option>';
		       }

  echo '
	         </select>
		   </td>
		 </tr>';
		 
} else { // user is not an admin, so only display the two change password fields

  echo '
	   <table class="addedit-users" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
	   <form name="addedit2" action="'.$_SERVER["PHP_SELF"].'" method="POST">
	   <input type="hidden" name="which_user" value="'.$_SESSION["userid"].'">
	   <font size="1"><br></font>
	   ';

}
		 
  echo '
		 <tr>
		   <td align="right"><b>Change Password:</b>&nbsp;</td>
		   <td align="left"><input type="password" name="edit_password" size="25"></td>
		 </tr>
		 <tr>
		   <td align="right"><b>Confirm New Password:</b>&nbsp;</td>
		   <td align="left"><input type="password" name="edit_confirm_password" size="25"></td>
	     </tr>
         <tr>
           <td align="center" colspan="2">
		     <input type="hidden" name="addedit2" value="1">
             <input type="button" value="CHANGE PASSWORD" onClick="javascript:verify2();">
             <font size="1"><br>&nbsp;</font>
           </td>
         </tr>
	   </form>
	   </table>
	   <br><br>';
	   
if ($_SESSION["isadmin"] == $glbl_hash) { // must be admin to modify admin privileges or delete users
  echo '
       <table class="addedit-users" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
         <tr>
           <td align="left"><span style="border-bottom:1px solid #A00000;font-weight:bold;">GRANT/REVOKE ADMIN PRIVILEGES:</span><br></td>
		   <td style="border-style: solid;border-color: #EFEFEF #EFEFEF #A00000 #EFEFEF;border-width:1px;" align="center" width="10"><b>A</b></td>
		   <td style="border-style: solid;border-color: #EFEFEF #EFEFEF #A00000 #EFEFEF;border-width:1px;" align="center" width="10"><b>D</b></td>
         </tr>';
         for ($x=0; $x<sizeof($userid_array); $x++) {
           if ($isadmin_array[$x] == 1) {
		    	$checked = 'checked';
		   } else {
		       unset($checked);
		   }
		   if ($userid_array[$x] == $_SESSION["userid"]) {
				$disabled = 'disabled';
		   } else {
				unset($disabled);
		   }
		   echo '<form name="adminpriv'.$x.'" action="'.$_SERVER["PHP_SELF"].'" method="POST">
				 <input type="hidden" name="adminpriv_userid" value="'.$userid_array[$x].'">
		         <tr>
		           <td align="left">'.$username_array[$x].'</td>
		           <td style="border-style: solid;border-color: #EFEFEF #A00000 #EFEFEF #A00000;border-width:1px;" align="center" width="10"><input onClick="javascript:document.adminpriv'.$x.'.submit();" type="checkbox" name="admin" value="1" '.$checked.' '.$disabled.'></td>
		           <td style="border-style: solid;border-color: #EFEFEF #EFEFEF #EFEFEF #EFEFEF;border-width:1px;" align="center" width="10">
		           <script language="Javascript">
                     function deleteUserRec'.$x.'() {
                       if (confirm("Are you sure you want to delete this user?")) {
                         document.adminpriv'.$x.'.del_sure.checked=true;
                         document.adminpriv'.$x.'.submit();
                       }
                     }
                   </script>
				   <input onClick="javascript:deleteUserRec'.$x.'();" type="checkbox" name="del_sure" value="1" '.$disabled.'></td>
		         </tr>
				 </form>';
         }
         
		 
  echo '
	   </table>
	   <table class="addedit-users" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
		 <tr>
		   <td align="right"><b><font color="#A00000">A</b> = Administrator, <b>D</b> = Delete User</font>&nbsp;</td>
		 </tr>
	   </table>
        ';
}


require_once("footer.php");

?>
