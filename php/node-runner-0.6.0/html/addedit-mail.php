<?
require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=addedit-mail.php");
	exit;
} else if (($_SESSION["isloggedin"] == $glbl_hash) && ($_SESSION["isadmin"] != $glbl_hash)) {
	header("Location: ".$nr_url);
	exit;
}

unset($err_msg,$magic_quotes_gpc);

$magic_quotes_gpc = ini_get('magic_quotes_gpc');

// Sanitize incoming GET variables
unset($get_id);
if (($_SESSION["isadmin"] == $glbl_hash) && ($_GET["id"])) {
	$get_id = strip_tags(rtrim(ltrim($_GET["id"])));
	if (($_GET["del"] == 1) && $get_id) {
	  $del_group = "DELETE FROM mail_group WHERE id='".$get_id."'";
	  $result_group = db_query($del_group);
	  if ($result_group == 1) {
  	    $err_msg .= '<b><br>Group deleted successfully.</b><br>&nbsp;';
	  }
	} else if (($_GET["edit"] == 1) && $get_id) {
	  $select_group = "SELECT * FROM mail_group WHERE id='".$get_id."'";
	  $result_group = db_query($select_group);
	  list($edit_group_id,$edit_group_name,$edit_group_addresses) = db_fetch_array($result_group);
	}
}



if (($_SESSION["isadmin"] == $glbl_hash) && ($_POST["add_groupname"]) && ($_POST["add_addresses"])) {
  $add_groupname = strip_tags(rtrim(ltrim($_POST["add_groupname"])));
  $add_addresses = strip_tags(rtrim(ltrim($_POST["add_addresses"])));
  $add_group_id = strip_tags(rtrim(ltrim($_POST["group_id"])));
  if (!$magic_quotes_gpc) { // Check for magic quotes, if it's Off, addslashes
	$add_groupname = addslashes($add_groupname);
  }
  if ($add_group_id) {
    // UPDATE existing mail group in database
    $update_mail_group = "UPDATE mail_group SET name='".$add_groupname."',email='".$add_addresses."' WHERE id='".$add_group_id."'";
	$result_mail_group = db_query($update_mail_group);
    if ($result_mail_group == 1) {
  	  $err_msg .= '<b><br>Group updated successfully.</b><br>&nbsp;';
	  $edit_group_id = $add_group_id;
    }
  } else {
    // INSERT new mail group into database
    $insert_mail_group = "INSERT INTO mail_group VALUES ('','".$add_groupname."','".$add_addresses."')";
    $result_mail_group = db_query($insert_mail_group);
    if ($result_mail_group == 1) {
  	  $err_msg .= '<b><br>Group added successfully.</b><br>&nbsp;';
      $select_recent_id = "SELECT id FROM mail_group ORDER BY id DESC LIMIT 1";
      $result_recent_id = db_query($select_recent_id);
      list($edit_group_id) = db_fetch_array($result_recent_id);
    }
  }
  $edit_group_name = $add_groupname;
  $edit_group_addresses = $add_addresses;
  unset($add_groupname,$add_addresses,$add_group_id);

  // stripslashes for re-display
  $edit_group_name = stripslashes($edit_group_name);
  
}



$title = "Configure Mail Groups";
require_once("header.php");

if ($err_msg) {
  echo '<center><div style="width:400px;" class="errmsg">'.$err_msg.'</div></center><br><br>';
}


echo '<table class="addedit-mail" align="center" width="400" border="0" cellspacing="0" cellpadding="3">
      <form name="mailgroups" action="'.$_SERVER["PHP_SELF"].'" method="POST">
         <tr valign="top">
           <td colspan="2" align="left">';
           if ($edit_group_id) {
		     echo '<span style="border-bottom:1px solid #A00000;font-weight:bold;">EDIT MAIL GROUP:</span><font size="1">';
           } else {
             echo '<span style="border-bottom:1px solid #A00000;font-weight:bold;">ADD A NEW MAIL GROUP:</span><font size="1">';
           }
           
echo '
		   <br><br></font></td>
	     </tr>
		 <tr>
		   <td align="right"><b>Group Name:</b>&nbsp;</td>
		   <td align="left"><input type="text" name="add_groupname" size="25" value="'.$edit_group_name.'"></td>
		 </tr>
		 <tr>
		   <td align="right"><b>Email Addresses:</b>&nbsp;</td>
		   <td align="left"><input type="text" name="add_addresses" size="25" value="'.$edit_group_addresses.'"></td>
		 </tr>
		 <tr>
		   <td colspan="2" align="center">
             <b><font color="#A00000">NOTE: Use commas to separate with no spaces.</font></b>&nbsp;[<a href="help.php?topic=mail_group_syntax" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=mail_group_syntax\',300,130))">?</a>]
             <input type="hidden" name="group_id" value="'.$edit_group_id.'">
             <font size="1"><br><br></font>';
             
             if ($edit_group_id) {
                echo '<input type="button" value="EDIT MAIL GROUP" onClick="javascript:verify();">';
             } else {
                echo '<input type="button" value="ADD MAIL GROUP" onClick="javascript:verify();">';
             }
             
echo '
		     <font size="1"><br>&nbsp;</font>
		   </td>
		 </tr>
	   </form>
	   </table>
	   <br><br>
       <table class="addedit-mail" align="center" width="400" border="0" cellspacing="0" cellpadding="5">
         <tr>
           <td align="left"><span style="border-bottom:1px solid #A00000;font-weight:bold;">MODIFY EXISTING GROUPS:</span><br></td>
         </tr>';

  $i = 0;
  $query_mail_groups = "SELECT * FROM mail_group ORDER BY name ASC";
  $result_mail_groups = db_query($query_mail_groups);
  while ($r = db_fetch_array($result_mail_groups)) {
		 $edit_mail_id = $r["id"];
		 $edit_mail_name = $r["name"];
		 $edit_mail_addresses = $r["email"];
		 $edit_mail_addresses = explode(",", $edit_mail_addresses);

  echo '
         <tr>
		   <td align="left">';
		   
		 if ($i>0) {
		 	echo '<div style="border-top:1px solid #AD8802;">';
		 } else {
		    echo '<div>';
		 }
		 
		 
  echo '
		     <script language="Javascript">
             function deleteMailGroup'.$x.'(url) {
               if (confirm("Are you sure you want to delete this mail group?")) {
                 location.href = url;
               }
             }
             </script>
             
		     <br>'.$edit_mail_name.'&nbsp;&nbsp;&nbsp;
             <span style="font-size:11px;font-weight:bold;">(&nbsp;<a style="font-size:11px;text-decoration:none;color:#AD8802;" href="'.$_SERVER["PHP_SELF"].'?edit=1&id='.$edit_mail_id.'">EDIT</a>&nbsp;|&nbsp;
		     <a style="font-size:11px;text-decoration:none;color:#AD8802;" href="javascript:deleteMailGroup'.$x.'(\''.$_SERVER["PHP_SELF"].'?del=1&id='.$edit_mail_id.'\');">DEL</a>&nbsp;)</span><br>
		     <ul>';
			   for ($x=0; $x<sizeof($edit_mail_addresses); $x++) {
			     echo '<li>'.$edit_mail_addresses[$x].'</li>';
			   }
  echo '
		     </ul>
		     </div>

		   </td>
		 </tr>';
		 
	$i++;
		 
  }
  
  echo '</table>';


require_once("footer.php");

?>
