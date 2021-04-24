<?
require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=addedit-nodes.php");
	exit;
} else if (($_SESSION["isloggedin"] == $glbl_hash) && ($_SESSION["isadmin"] != $glbl_hash)) {
	header("Location: ".$nr_url);
	exit;
}

unset($err_msg);

if ($_POST["description"] && $_POST["ipaddress"] && $_POST["ptime"] && $_POST["submitit"] && (!$_POST["del_sure"]) && ($_POST["delete"] != "DELETE THIS NODE")) {

  // Sanitize incoming data
  $edit_dependency = rtrim(ltrim(strip_tags($_POST["dependency"])));
  $edit_description = strtoupper(rtrim(ltrim(strip_tags($_POST["description"]))));
  $edit_ipaddress = rtrim(ltrim(strip_tags($_POST["ipaddress"])));
  $edit_port = rtrim(ltrim(strip_tags($_POST["port"])));
  $edit_query_type = rtrim(ltrim(strip_tags($_POST["query_type"])));
  $edit_server = rtrim(ltrim(strip_tags($_POST["server"])));
  $edit_enabled = rtrim(ltrim(strip_tags($_POST["enabled"])));
  if (!$edit_enabled) { $edit_enabled = 'N'; }
  $edit_mail_group = rtrim(ltrim(strip_tags($_POST["mail_group"])));
  $edit_ptime = rtrim(ltrim(strip_tags($_POST["ptime"])));
  $edit_smon_time = rtrim(ltrim(strip_tags($_POST['shour'].$_POST['smin'])));
  $edit_emon_time = rtrim(ltrim(strip_tags($_POST['ehour'].$_POST['emin'])));
  $edit_url = rtrim(ltrim(strip_tags($_POST["url"])));
  $edit_snmp_comm = rtrim(ltrim(strip_tags($_POST["snmp_comm"])));
  $edit_days= rtrim(ltrim(strip_tags($_POST['Sun']." ".$_POST['Mon']." ".$_POST['Tue']." ".$_POST['Wed']." ".$_POST['Thu']." ".$_POST['Fri']." ".$_POST['Sat'])));
  $edit_comments = rtrim(ltrim(strip_tags($_POST["comments"])));
  $edit_auth_user = rtrim(ltrim(strip_tags($_POST["auth_user"])));
  $edit_auth_pass = rtrim(ltrim(strip_tags($_POST["auth_pass"])));

  $magic_quotes_gpc = ini_get('magic_quotes_gpc');
  if (!$magic_quotes_gpc) { // Check for magic quotes, if it's Off, addslashes
    $edit_description = addslashes($edit_description);
    $edit_snmp_comm = addslashes($edit_snmp_comm);
    $edit_comments = addslashes($edit_comments);
  }

  if (!$_POST["id"]) {
    if (!$edit_url) { $edit_url_sql = 'NULL'; } else { $edit_url_sql = "'$edit_url'"; }
    if (!$edit_snmp_comm) { $edit_snmp_comm_sql = 'NULL'; } else { $edit_snmp_comm_sql = $edit_snmp_comm; }
    if (!$edit_auth_user) { $edit_auth_user_sql = 'NULL'; } else { $edit_auth_user_sql = $edit_auth_user; }
    if (!$edit_auth_pass) { $edit_auth_pass_sql = 'NULL'; } else { $edit_auth_pass_sql = $edit_auth_pass; }
	$insert_node = "INSERT INTO objects VALUES ('','".$edit_dependency."','".$edit_description."','".$edit_ipaddress."','".$edit_port."','".$edit_query_type."','".$edit_server."','".$edit_enabled."','".$edit_mail_group."','".$edit_ptime."','".$edit_smon_time."','".$edit_emon_time."',".$edit_url_sql.",".$edit_snmp_comm_sql.",'".$edit_days."','".$edit_comments."',".$edit_auth_user_sql.",".$edit_auth_pass_sql.")";
	$result_node = db_query($insert_node);
	$query_recent_node = "SELECT id FROM objects WHERE description='".$edit_description."' AND ipaddress='".$edit_ipaddress."' ORDER BY id DESC LIMIT 1";
	$result_recent_node = db_query($query_recent_node);
	list($get_id) = db_fetch_array($result_recent_node);
	if ($result_node == 1) { $err_msg .= '<b><br>Node added successfully.  <a href="'.$_SERVER["PHP_SELF"].'">Clear this page</a> to add another node.</b><br>&nbsp;'; }
  } else {
    if (!$edit_url) { $edit_url_sql = ',url=NULL'; } else { $edit_url_sql = ",url='".$edit_url."'"; }
    if (!$edit_snmp_comm) { $edit_snmp_comm_sql = ',snmp_comm=NULL'; } else { $edit_snmp_comm_sql = ",snmp_comm='".$edit_snmp_comm."'"; }
    if (!$edit_auth_user) { $edit_auth_user_sql = ',auth_user=NULL'; } else { $edit_auth_user_sql = ",auth_user='".$edit_auth_user."'"; }
    if (!$edit_auth_pass) { $edit_auth_pass_sql = ',auth_pass=NULL'; } else { $edit_auth_pass_sql = ",auth_pass='".$edit_auth_pass."'"; }
    $update_node = "UPDATE objects SET dependency='".$edit_dependency."',description='".$edit_description."',ipaddress='".$edit_ipaddress."',port='".$edit_port."',query_type='".$edit_query_type."',server='".$edit_server."',enabled='".$edit_enabled."',mail_group='".$edit_mail_group."',ptime='".$edit_ptime."',smon_time='".$edit_smon_time."',emon_time='".$edit_emon_time."',days='".$edit_days."',comments='".$edit_comments."'".$edit_url_sql."".$edit_snmp_comm_sql."".$edit_auth_user_sql."".$edit_auth_pass_sql." WHERE id='".$_POST["id"]."'";
	$result_node = db_query($update_node);
	if ($edit_enabled == 'N') {
	  $update_alert_log = "UPDATE alert_log SET resolved='O' WHERE (description='".$edit_description."' AND resolved='N')";
	  $result_alert_log = db_query($update_alert_log);
	} else {
      $update_alert_log = "UPDATE alert_log SET dependency='".$edit_dependency."',description='".$edit_description."',ipaddress='".$edit_ipaddress."',port='".$edit_port."',query_type='".$edit_query_type."',server='".$edit_server."'".$edit_url_sql."".$edit_snmp_comm_sql." WHERE (description='".$edit_description."' AND resolved='N')";
	  $result_alert_log = db_query($update_alert_log);
	}
	if ($result_node == 1) { $err_msg .= '<b><br>Node updated successfully.  <a href="'.$_SERVER["PHP_SELF"].'">Clear this page</a> to add another node.</b><br>&nbsp;'; }
  }
  
  unset($edit_url_sql,$edit_snmp_comm_sql,$edit_auth_user_sql,$edit_auth_pass_sql);
  
  // stripslashes for re-display
  $edit_description = stripslashes($edit_description);
  $edit_snmp_comm = stripslashes($edit_snmp_comm);
  $edit_comments = stripslashes($edit_comments);
  
}


if (($_POST["submitit"]) && ($_POST["delete"] == "DELETE THIS NODE") && ($_POST["del_sure"] == 1) && ($_POST["id"])) {
	$del_id = rtrim(ltrim(strip_tags($_POST["id"])));
	$query_del = "DELETE FROM objects WHERE id='".$del_id."'";
	$result_del = db_query($query_del);
	if ($result_del == 1) { $err_msg .= '<b><br>Node removed successfully.</b><br>&nbsp;'; }
}


$title = "Add/Edit Nodes";
require_once("header.php");


function dropdown($name,$num,$selected) {
    //populates html drop down boxes
    echo '<select name="'. $name .'">';
    echo '<option value="';
    printf("%02.0f", $selected);
    echo '" selected>';
    printf("%02.0f", $selected);
    echo '</option>';
    for ($i=0;$i<$num;$i++) {
      echo '<option value="';
      printf("%02.0f", $i);
      echo '">';
      printf("%02.0f", $i);
      echo '</option>';
    }
    echo '</select>';
}


function list_of_includes($dir) {
    // Returns array of file names from $dir

    $i=0;
      if ($use_dir = @opendir($dir)) {
        while (($file = readdir($use_dir)) != false) {
          if (ereg("query_",$file)) {
            $includes_arr[$i] = "$file";
            $i++;
          }
        }
      closedir($use_dir);
    }

    return $includes_arr;
}

$query_type_includes = list_of_includes($path_to_include);
$queries_type_array = array();
foreach ($query_type_includes as $types) {
  include_once($path_to_include.$types);
}



if ($_POST["id"]) {
  $get_id = strip_tags(rtrim(ltrim($_POST["id"])));
} else if ($_GET["id"]) {
  $get_id = strip_tags(rtrim(ltrim($_GET["id"])));
}
  // Display the information for the node
  $query2 = "SELECT * FROM objects WHERE id='".$get_id."'";
  $result2 = db_query($query2);
  list($edit_id,$edit_dependency,$edit_description,$edit_ipaddress,$edit_port,$edit_query_type,$edit_server,$edit_enabled,$edit_mail_group,$edit_ptime,$edit_smon_time,$edit_emon_time,$edit_url,$edit_snmp_comm,$edit_days,$edit_comments,$edit_auth_user,$edit_auth_pass) = db_fetch_array($result2);
  
  if ($edit_id) {
    $query_children = "SELECT id FROM objects WHERE dependency='".$edit_id."'";
    $result_children = db_query($query_children);
    $num_rows_children = db_num_rows($result_children);
    if ($num_rows_children) {
	  $disallow_checking_due_to_child = 1;
    }
  }

  if (!$edit_ptime) { $edit_ptime = 5; } // default timeout value
  
  if (!$edit_port) { $port_disabled = 'disabled'; }
  if (!$edit_snmp_comm) { $snmp_comm_disabled = 'disabled'; }
  if (!$edit_url) { $url_disabled = 'disabled'; }
  if (!$edit_auth_user) { $auth_user_disabled = 'disabled'; }
  if (!$edit_auth_pass) { $auth_pass_disabled = 'disabled'; }


  if ($err_msg) {
    echo '<div align="center" class="errmsg">'.$err_msg.'</div><br><br>';
  }

  echo '<table class="addedit-nodes" width="90%" align="center">
        <form name="addedit" action="'.$_SERVER['PHP_SELF'].'" method="POST">
          <tr>
            <td align="left" valign="top" width="50%">
            <font size="2">
            <b>Node Name:</b>&nbsp;[<a href="help.php?topic=description" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=description\',250,70))">?</a>]<br><input type="text" name="description" size="35" value="'.$edit_description.'"><br><br>
            <b>Node is Dependent Upon:</b>&nbsp;[<a href="help.php?topic=dependency" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=dependency\',300,250))">?</a>]<br>
            <select style="width:70%" size="6" name="dependency">
       ';

  $dep = "SELECT id,description FROM objects WHERE id='".$edit_dependency."'";
  $dep_result = db_query($dep);
  list($edit_dep,$desc) = db_fetch_array($dep_result);

  if (!$desc) {
  	$edit_dep = 1;
  	$desc = 'NODE RUNNER';
  }
  
  echo '<option value="'.$edit_dep.'" selected>'.$desc.'</option>';

  $query_other_deps = "SELECT id,description FROM objects WHERE enabled='Y' ORDER BY description ASC";
  $result_other_deps = db_query($query_other_deps);
  while ($r = db_fetch_array($result_other_deps)) {
         $other_id = $r["id"];
		 $other_description = $r["description"];
         if (($other_description == $desc) || ($other_description == $edit_description)) { continue; }
         if (strlen($other_description) > 27) { $other_description = substr($other_description, 0 ,27)."..."; }
         print '<option value="'.$other_id.'">'.$other_description.'</option>';
  }

  echo '    </select><br><br>
            <b>IP Address:</b>&nbsp;[<a href="help.php?topic=ohplease" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=ohplease\',250,70))">?</a>]<br><input type="text" name="ipaddress" size="35" maxlength="15" value="'.$edit_ipaddress.'"><br><br>
            <b>Query Type:</b>&nbsp;[<a href="help.php?topic=query_type" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=query_type\',250,70))">?</a>]<br>
			<select onClick="javascript:disableAddEditFields();" style="width:70%" name="query_type" size="1">
	   ';
	   
  if ($edit_query_type) {
    echo '<option value="'.$edit_query_type.'" selected>'.$edit_query_type.'</option>';
  } else {
	echo '<option value="0">-- SELECT TYPE --</option>';
  }
	   
  for ($x=0; $x<sizeof($queries_type_array); $x++) {
    if ($queries_type_array[$x] == $edit_query_type) { continue; }
	echo '<option value="'.$queries_type_array[$x].'">'.$queries_type_array[$x].'</option>';
  }

  echo '
			</select><br><br>
			<b>Query Timeout (seconds):</b>&nbsp;[<a href="help.php?topic=ptime" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=ptime\',250,70))">?</a>]<br><input type="text" name="ptime" size="35" value="'.$edit_ptime.'"><br><br>
			<b>Port to Query:</b>&nbsp;[<a href="help.php?topic=port" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=port\',250,70))">?</a>]<br><input type="text" name="port" size="35" value="'.$edit_port.'" '.$port_disabled.'><br><br>
			<b>SNMP Community:</b>&nbsp;[<a href="help.php?topic=snmp_comm" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=snmp_comm\',280,70))">?</a>]<br><INPUT TYPE="text" name="snmp_comm" size="35" value="'.$edit_snmp_comm.'" '.$snmp_comm_disabled.'><br><br>
            <b>URL to Query:</b>&nbsp;[<a href="help.php?topic=url" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=url\',300,200))">?</a>]<br><INPUT TYPE="text" name="url" size="35" value="'.$edit_url.'" '.$url_disabled.'><br><br>
            <b>HTTP User (if URL is secure):</b>&nbsp;[<a href="help.php?topic=auth_user" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=auth_user\',250,70))">?</a>]<br><INPUT TYPE="text" name="auth_user" size="35" value="'.$edit_auth_user.'" '.$auth_user_disabled.'><br><br>
            <b>HTTP Password (if URL is secure):</b>&nbsp;[<a href="help.php?topic=auth_pass" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=auth_pass\',260,120))">?</a>]<br><INPUT TYPE="password" name="auth_pass" size="35" value="'.$edit_auth_pass.'" '.$auth_pass_disabled.'><br><br>
            
        </td>
       ';

  $edit_smon_time = sprintf("%04s",$edit_smon_time);
  $edit_emon_time = sprintf("%04s",$edit_emon_time);
  $edit_smin = substr($edit_smon_time, -2);
  $edit_shour = substr($edit_smon_time, -4, 2);
  $edit_emin = substr($edit_emon_time, -2);
  if ($edit_emin == '00') { $edit_emin = 59; }
  $edit_ehour = substr($edit_emon_time, -4, 2);
  if ($edit_ehour == '00') { $edit_ehour = 23; }

  echo '
        <td align="left" valign="top" width="50%">
        <table class="addedit-nodes-whichdays" width="90%" border="0" cellpadding="3">
		  <tr valign="top">
            <td width="40%" valign="top" align="left">
              <span style="border-bottom:1px solid #A00000;font-weight:bold;">Days to Monitor:</span>&nbsp;[<a href="help.php?topic=which_days" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=which_days\',260,70))">?</a>]<br><br>
       ';

  if ((!$get_id) && (!$edit_days)) {
	$edit_days = "Sun Mon Tue Wed Thu Fri Sat";
  }

  if(strstr($edit_days,"Sun")) {
    print "<input type='checkbox' name='Sun' value='Sun' checked>SUNDAY<br>";
  } else {
    print "<input type='checkbox' name='Sun' value='Sun'>SUNDAY<br>";
  }
  if(strstr($edit_days,"Mon")) {
     print "<input type='checkbox' name='Mon' value='Mon' checked>MONDAY<br>";
  } else {
     print "<input type='checkbox' name='Mon' value='Mon'>MONDAY<br>";
  }
  if(strstr($edit_days,"Tue")) {
     print "<input type='checkbox' name='Tue' value='Tue' checked>TUESDAY<br>";
  } else {
     print "<input type='checkbox' name='Tue' value='Tue'>TUESDAY<br>";
  }
  if(strstr($edit_days,"Wed")) {
     print "<input type='checkbox' name='Wed' value='Wed' checked>WEDNESDAY<br>";
  } else {
     print "<input type='checkbox' name='Wed' value='Wed'>WEDNESDAY<br>";
  }
  if(strstr($edit_days,"Thu")) {
     print "<input type='checkbox' name='Thu' value='Thu' checked>THURSDAY<br>";
  } else {
     print "<input type='checkbox' name='Thu' value='Thu'>THURSDAY<br>";
  }
  if(strstr($edit_days,"Fri")) {
     print "<input type='checkbox' name='Fri' value='Fri' checked>FRIDAY<br>";
  } else {
     print "<input type='checkbox' name='Fri' value='Fri'>FRIDAY<br>";
  }
  if(strstr($edit_days,"Sat")) {
     print "<input type='checkbox' name='Sat' value='Sat' checked>SATURDAY";
  } else {
     print "<input type='checkbox' name='Sat' value='Sat'>SATURDAY";
  }

  echo '    </td>
            <td width="60%" valign="top" align="right"><br>

        <table class="addedit-nodes-timeframe" cellpadding="3" border="0">
          <tr>
            <td><b>Monitor Timeframe:</b>&nbsp;[<a href="help.php?topic=timeframe" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=timeframe\',260,70))">?</a>]
            </td>
          </tr>
          <tr>
            <td align="right">
			   Start Time:&nbsp&nbsp';

              dropdown("shour","24",$edit_shour);

              dropdown("smin","60",$edit_smin);

  echo '    </td>
          </tr>
          <tr>
            <td align="right">End Time:&nbsp&nbsp
        ';

              dropdown("ehour","24",$edit_ehour);

              dropdown("emin","60",$edit_emin);

  echo '    </td>
          </tr>
        </table>&nbsp;&nbsp;


            </td>
          </tr>
        </table>
        <br><br>
        <b>Comments (Optional):</b>&nbsp;[<a href="help.php?topic=comments" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=comments\',260,70))">?</a>]<br><textarea name="comments" rows="4" cols="34">'.$edit_comments.'</textarea><br><br>
        <b>Network Endpoint:</b>&nbsp;[<a href="help.php?topic=endpoint" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=endpoint\',300,180))">?</a>]&nbsp;
        <select style="font-size:10px" name="server" size="1">';
        if ((!$edit_server) || ($edit_server == "Y")) {
            echo '<option value="Y" selected>YES</option>
			      <option value="N">NO</option>';
        } else {
            echo '<option value="N" selected>NO</option>
			      <option value="Y">YES</option>';
        }
        
  echo '</select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <b>Enabled:</b>&nbsp;[<a href="help.php?topic=enabled" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=enabled\',260,210))">?</a>]&nbsp;';

		if ($edit_dependency == 'NONE') {
		    echo '<input style="font-size:14px" type="checkbox" name="enabled" value="Y" checked disabled>';
		} else if ((!$edit_enabled) || ($edit_enabled == "Y")) {
		    if ($disallow_checking_due_to_child) {
		      echo '<input style="font-size:14px" type="checkbox" name="enabled_box" value="Y" checked disabled>';
		      echo '<input style="font-size:14px" type="hidden" name="enabled" value="Y">';
		    } else {
		      echo '<input style="font-size:14px" type="checkbox" name="enabled" value="Y" checked>';
		    }
        } else {
            echo '<input style="font-size:14px" type="checkbox" name="enabled" value="Y">';
        }
        
  if ($disallow_checking_due_to_child) {
	echo '<br><br><a href="help.php?topic=status_mon_dir_affect" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=status_mon_dir_affect&iid='.$edit_id.'\',300,200))"><b>NOTE:</b> This node cannot be disabled until the nodes<br>that depend upon it are disabled as well. Click here<br>to view a list of those nodes.</a>';
  }
        
  echo '<br><br>
        <b>Mail Group:</b>&nbsp;[<a href="help.php?topic=mail_group" style="text-decoration:none" onClick="return(openHelp(\'help.php?topic=mail_group\',300,120))">?</a>]&nbsp;<br>
        <select style="width:70%" size="1" name="mail_group">
       ';

  $mail_query = "SELECT name FROM mail_group WHERE id='".$edit_mail_group."'";
  $mail_result = db_query($mail_query);
  list($mname) = db_fetch_array($mail_result);
  if (!$mname) {
    $mail_query2 = "SELECT id,name FROM mail_group ORDER BY id ASC";
    $mail_result2 = db_query($mail_query2);
    list($edit_mail_group,$mname) = db_fetch_array($mail_result2);
  }
  
  echo '<option value="'.$edit_mail_group.'" selected>'.$mname.'</option>';

  $query_other_mail = "SELECT id,name FROM mail_group ORDER BY name DESC";
  $result_other_mail = db_query($query_other_mail);
  while ($r = db_fetch_array($result_other_mail)) {
         $other_mail_name = $r["name"];
         $other_mail_id = $r["id"];
         if ($other_mail_name == $mname) { continue; }
         echo '<option value="'.$other_mail_id.'">'.$other_mail_name.'</option>';
  }

  echo '</select><br><br>
		<input type="hidden" name="id" value="'.$get_id.'">
		<input type="hidden" name="submitit" value="1">';
		
		if ($get_id) {
		    echo '<input type="button" value="SUBMIT CHANGES TO NODE" onClick="javascript:verify();"><br><br>
			      <input type="submit" name="delete" value="DELETE THIS NODE">&nbsp;<input type="checkbox" name="del_sure" value="1">Confirm Delete<br><br>';
		} else {
		    echo '<input type="button" value="ADD NEW NODE" onClick="javascript:verify();"><p>&nbsp;</p>';
		}
        
  echo '
        <br>
        <table width="90%" align="left" class="addedit-nodes-select-for-edit" cellpadding="3">
        <tr>
        <td>
        <b>Modify a Different Node?</b><br>
        <select style="font-size:11px" name="select_for_edit" size="1" onChange="location.href=addedit.select_for_edit.options[selectedIndex].value">
		<option value="0">-- SELECT NODE TO EDIT --</option>';
        $query_other_nodes = "SELECT id,description FROM objects ORDER BY description ASC";
        $result_other_nodes = db_query($query_other_nodes);
        while ($r = db_fetch_array($result_other_nodes)) {
			   $select_id = $r["id"];
			   $select_description = $r["description"];
			   if (strlen($select_description) > 40) { $select_description = substr($select_description, 0 ,40)."..."; }
			   echo '<option value="http://'.$_SERVER["HTTP_HOST"].''.$_SERVER["PHP_SELF"].'?id='.$select_id.'">'.$select_description.'</option>';
        }
  echo '
        </select><br>
        <b>WARNING: Unsaved changes will be lost!</b>
        </td>
        </tr>
        </table>
        </font>
        </td>
        </tr>
        </form>
        </table>';


require_once("footer.php");

?>
