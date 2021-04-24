<?php

// Sanitize incoming referrer variable
unset($referrer);
if (($_POST["referrer"]) && (is_file("./".strip_tags(rtrim(ltrim($_POST["referrer"])))))) {
  $referrer = strip_tags(rtrim(ltrim($_POST["referrer"])));
}else if (($_GET["referrer"]) && (is_file("./".strip_tags(rtrim(ltrim($_GET["referrer"])))))) {
  $referrer = strip_tags(rtrim(ltrim($_GET["referrer"])));
} else {
  $referrer = 'index.php';
}

require_once("connect.php");
if ($_SESSION["isloggedin"] == $glbl_hash) {
	header("Location: ".$nr_url.$referrer);
	exit;
}

if (($_POST["submit"] == "LOGIN") && ($_POST["username"]) && ($_POST["password"])) {
	unset($username,$password,$userid,$admin,$err_msg);
	$username = strip_tags($_POST["username"]);
	$password = md5(strip_tags($_POST["password"]));
	$query_auth = "SELECT userid,admin FROM users WHERE username='".$username."' AND password='".$password."'";
	$result_auth = db_query($query_auth);
	list($userid,$admin) = db_fetch_array($result_auth);
	if ($userid) { // username and password must be valid
	  $_SESSION["isloggedin"] = $glbl_hash;
	  $_SESSION["username"] = $username;
	  $_SESSION["userid"] = $userid;
	  if ($admin == 1) { // user must be an admin
	    $_SESSION["isadmin"] = $glbl_hash;
	  }
	  header("Location: ".$nr_url.$referrer);
	  exit;
	} else { // username and/or password were incorrect, generate error
	  $err_msg = '<br><br><font color="#A00000"><b>Username or password incorrect.  Please try again.</b></font>';
	}
}


$title = "User Login";
require_once("header.php");

echo '
<div align="center" class="loginnotice">
<br>
<b><font color="#A00000">NOTICE:</font> The Node Runner web interface requires a user login.<br>Please see your network administrator for access rights to this system.</b>
<br><br>
<form name="userlogin" action="'.$_SERVER["PHP_SELF"].'" method="POST">
<table align="center" width="100%" border="0">
  <tr>
    <td align="center" valign="top">
      <font size="2">USERNAME:&nbsp;<input type="text" name="username" size="25">&nbsp;&nbsp;PASSWORD:&nbsp;<input type="password" name="password" size="25"><input type="hidden" name="referrer" value="'.$referrer.'"><input type="submit" name="submit" value="LOGIN"></font>
      '.$err_msg.'
    </td>
  </tr>

</table>
</form>
<script language="JavaScript">
<!--
document.userlogin.username.focus();
//-->
</script>
</div>

	 ';

require_once("footer.php");

?>

