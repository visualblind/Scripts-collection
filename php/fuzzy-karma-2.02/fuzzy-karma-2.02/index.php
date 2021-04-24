<?php
	include_once("etc/conf.php");
	include_once(LIB."DAB.php");
	$db = new DAB(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB);
	$db->connect();
	session_start();
if ($_POST[submit]){
	$puser = mysql_escape_string($_POST[puser]);
	$ppass = mysql_escape_string($_POST[ppass]);
	$row = mysql_fetch_object($db->query("select username from fuzzy_users where username='$puser' AND password=password('$ppass');"));
	$suser = $row->username;
  if ($suser == $puser){
  	$_SESSION[loggedin] = true;
  }
}

if (isset($_GET["logout"]))
	{	
	    $_SESSION[loggedin] = false;
	}

if ($_SESSION[loggedin])
{
	if(!$_POST[change_pass])
	{
		if (isset($_GET["deletefrom"]) && isset($_GET["id"]))
		{
			$deletefrom = mysql_escape_string($_GET["deletefrom"]);
			$id = mysql_escape_string($_GET["id"]);
			$delete = 'DELETE FROM '.$deletefrom.' WHERE id = "'.$id.'";';
			$db->query($delete);
		}
		if (!isset($_GET["load"]))
		{
			$load = "default";
		}
		else 
		{
			$load = $_GET["load"];
			if($load != "changepass.php")
			{
				include_once(LIB."$load");
				$filter_object = substr($load,0,-4);
				$run_filter = new ${"filter_object"}($db);
				$protocol_html = $run_filter->getData($db);
				$load = $protocol_html;
			}//end if
		}
		include ("fuzzy_header.php");
		include ("fuzzy_topbar.php");
		include ("fuzzy_leftbar.php");
		include ("fuzzy_main.php");
		include ("fuzzy_rightbar.php");
		include ("fuzzy_bottombar.php");
		include ("fuzzy_footer.php");
		$fheader = new fuzzy_header();
		$ftopbar = new fuzzy_topbar(); 
		$fleftbar = new fuzzy_leftbar($db);
		$fmain = new fuzzy_main($db, $load);
		$frightbar = new fuzzy_rightbar();
		$fbottombar = new fuzzy_bottombar();
		$ffooter = new fuzzy_footer();
		$db->close();
	}//end if
	else
	{
		include ("fuzzy_header.php");
		include ("fuzzy_topbar.php");
		include ("changepass.php");
		include ("fuzzy_bottombar.php");
		include ("fuzzy_footer.php");
		$fheader = new fuzzy_header();
		$ftopbar = new fuzzy_topbar(); 
		$fpass = new changepass();
		$fbottombar = new fuzzy_bottombar();
		$ffooter = new fuzzy_footer();
		$db->close();
	}//end else
}//end if
else {
	include ("fuzzy_header.php");
	include ("fuzzy_topbar.php");
	include ("fuzzy_login.php");
	include ("fuzzy_bottombar.php");
	include ("fuzzy_footer.php");
	$fheader = new fuzzy_header();
	$ftopbar = new fuzzy_topbar(); 
	$flogin = new fuzzy_login();
	$fbottombar = new fuzzy_bottombar();
    $ffooter = new fuzzy_footer();
	$db->close();
}
?>
