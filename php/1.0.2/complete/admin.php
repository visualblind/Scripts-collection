<?php
require("includes/global.php");

// check for doing something
if ($_GET["do"] == "signin"){
	$usr->signin($_POST["signin1"], $_POST["signin2"]);
} elseif ($_GET["do"] == "preferences"){
	$usr->Preferences($_POST["email"]);
} elseif ($_GET["do"] == "changepass"){
	$usr->ChangePass($_POST["pass1"], $_POST["pass2"], $_POST["pass3"]);
}

// basic page title
$pagetitle = "Particle Whois Admin";

if ($_GET["page"] == "profile"){
	$pagesect = 1;
	$usr->Auth(1);
	$pagetitle .= " :: My Profile";
} elseif ($_GET["page"] == "signout"){
	$pagesect = 2;
	$usr->Auth(1);
	$pagetitle .= " :: Sign Out";
	$usr->SignOut();
} elseif ($_GET["page"] == "settings"){
	$pagesect = 3;
	$usr->Auth(2);
	$pagetitle .= " :: Change Settings";
} elseif ($_GET["page"] == "history"){
	$pagesect = 4;
	$usr->Auth(1);
	$pagetitle .= " :: History Log";
	
	// check for log pruning
	if ($_POST["prune"] >= 1 && $_POST["prune"] < 1000){
		$prunedays = intval($_POST["prune"]);
		$prunedays = ($prunedays * 86400);
		$ctime = (time() - $prunedays);
		$sql = "DELETE FROM " . $dbprefix . "results WHERE postdate < " . $ctime;
		$db->execute($sql);
	}
} elseif ($_GET["page"] == "code"){
	$pagesect = 5;
	$usr->Auth(0);
	$pagetitle .= " :: Form Code";
} else {
	$usr->Auth(0);
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title><?php echo($pagetitle); ?></title>
<link rel="stylesheet" type="text/css" href="shared/admin.css" />
</head>
<body>
<?php if ($pagesect == 1){ ?>
<p class="sub1">My Profile</p>
<?php
$myprofile = $db->execute("SELECT * FROM " . $dbprefix . "users WHERE ID = " . dbSecure($_SESSION["userid"]));
if ($myprofile->rows < 1){ die("Unable to locate your user profile"); }
?>
<form action="admin.php?page=profile&do=preferences" method="POST">
Change email:<br />
<input type="text" size="30" name="email" id="email" value="<?php echo($myprofile->fields["email"]); ?>" />
<input type="submit" value="Update!" />
</form>
<form action="admin.php?page=profile&do=changepass" method="POST">
Change password:<br />
<table cellpadding="0" cellspacing="0" border="0">
<tr>
	<td>Old Password:</td>
	<td><input type="password" size="30" id="pass1" name="pass1" />
</tr>
<tr>
	<td>New Password:</td>
	<td><input type="password" size="30" id="pass2" name="pass2" />
</tr>
<tr>
	<td>Confirm New:</td>
	<td><input type="password" size="30" id="pass3" name="pass3" />
</tr>
<tr>
	<td colspan="2">
		<input type="submit" value="Change Password!" />
	</td>
</tr>
</table>
</form>

<?php } elseif ($pagesect == 2){ ?>
<p class="sub1">Sign Out</p>
<p>You have been signed out of the admin panel.</p>

<?php } elseif ($pagesect == 3){ ?>
<p class="sub1">Change Settings</p>
<form action="shared/backend/settings.php" method="POST">
<table width="600" cellpadding="5" cellspacing="0" border="1">
<tr>
	<td colspan="2" bgcolor="#CCCCCC"><strong>Site Information</strong></td>
</tr>
<tr valign="top">
	<td><strong>Site Name</strong><br />
	The name of the whois site such as Particle Whois Demo</td>
	<td><input type="text" size="40" maxlength="255" id="c_sitename" name="c_sitename" value="<?php echo($config["sitename"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Main Site</strong><br />
	If the whois site is part of a site then name that site here. If not then just name the whois section.</td>
	<td><input type="text" size="40" maxlength="255" id="c_mainsite" name="c_mainsite" value="<?php echo($config["mainsite"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Main URL</strong><br />
	If you have a main site then put the URL here. If not but the whois URL here. It should be in the format of http://www.example.com/whatever/</td>
	<td><input type="text" size="40" maxlength="255" id="c_mainurl" name="c_mainurl" value="<?php echo($config["mainurl"]); ?>" /></td>
</tr>
<tr>
	<td colspan="2" bgcolor="#CCCCCC"><strong>Site Setup</strong></td>
</tr>
<tr valign="top">
	<td><strong>Virtual Root</strong><br />
	This is the path to the whois site such as /whois/ or if it is on the root just enter /.</td>
	<td><input type="text" size="40" maxlength="255" id="c_root" name="c_root" value="<?php echo($config["rootpath"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Domain</strong><br />
	The domain the whois is on including http such as http://whois.example.com or http://www.example.com, no /folder/, no slash at the end.</td>
	<td><input type="text" size="40" maxlength="255" id="c_rooturl" name="c_rooturl" value="<?php echo($config["rooturl"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Default Skin</strong><br />
	This is the skin that will be used if nothing overrides it. The default is ParticleBlue.</td>
	<td><?php echo(SkinList($config["defaultskin"])) ?></td>
</tr>
<tr valign="top">
	<td><strong>Date Format</strong><br />
	This is how the dates will be formatted according to PHP's <a href="http://www.php.net/date">date function</a>. The default is D j M Y, H:i A</td>
	<td><input type="text" size="40" maxlength="255" id="c_dateformat" name="c_dateformat" value="<?php echo($config["dateformat"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Sever Port</strong><br />
	The port number the whois requests are sent on. Probably a good idea not to go messing with this. The default is 43.</td>
	<td><input type="text" size="40" maxlength="255" id="c_serverport" name="c_serverport" value="<?php echo($config["serverport"]); ?>" /></td>
</tr>
<tr valign="top">
	<td><strong>Log Results</strong><br />
	If turned on, each domain searched for will be logged along with the time and availability. Set it to 1 for logging on, 0 to turn logging off. The default is 1.</td>
	<td><input type="text" size="40" maxlength="255" id="c_logresults" name="c_logresults" value="<?php echo($config["logresults"]); ?>" /></td>
</tr>
<tr>
	<td colspan="2" bgcolor="#CCCCCC"><strong>Your Done...</strong></td>
</tr>
<tr>
	<td colspan="2" align="center"><input type="submit" value="Update Settings!" /></td>
</tr>
</table>
</form>

<?php } elseif ($pagesect == 4){ ?>
<p class="sub1">History Log</p>
<?php
$sql = "SELECT * FROM " . $dbprefix . "results ORDER BY postdate DESC LIMIT 0, 1000";
$history = $db->execute($sql);
if ($history->rows < 1){
	echo("There is no history!");
} else {
	// ok loop through the different things
	echo("<p>Total results in log: <strong> " . $history->rows . "</strong><br />");
	echo("Only the first 1,000 results of a log are shown<br />");
	echo("<a href=\"admin.php?page=history\">Refresh log</a></p>");
	echo("<table cellpadding=3 cellspacing=0 border=1");
	echo("<tr><td bgcolor=#CCCCCC><strong>Domain</strong></td>");
	echo("<td bgcolor=#CCCCCC><strong>Status</strong></td>");
	echo("<td bgcolor=#CCCCCC><strong>Date</strong></td></tr>");
	do {
	
		// looping code goes here
		echo("<tr>\n<td>" . $history->fields["domain"] . "</td>\n<td>");
		$avtext = ($history->fields["available"] == 1) ? "<strong>available</strong>" : "unavailable";
		echo($avtext . "</td>\n<td>" . date($config["dateformat"], $history->fields["postdate"]));
		echo("</td>\n</tr>\n");
	
	} while ($history->loop());
	echo("</table>");
}
?><form action="admin.php?page=history" method="POST">
<p><strong>Prune Log:</strong><br />
Delete results over 
<input type="text" size="3" maxlength="3" id="prune" name="prune" value="30" /> days old 
<input type="submit" value="Prune!" /></p>
</form>

<?php } elseif ($pagesect == 5){ ?>
<p class="sub1">Form Code</p>
<p>Use this code to add domain search forms to other parts of your website:</p>
<p>&lt;form method=&quot;GET&quot; action=&quot;<?php echo($config["rooturl"] . $config["rootpath"]); ?>&quot;&gt;<br>
Run domain check: <br>
&lt;input type=&quot;hidden&quot; name=&quot;do&quot; id=&quot;do&quot; value=&quot;runcheck&quot;&gt;<br>
&lt;input type=&quot;text&quot; name=&quot;target&quot; id=&quot;target&quot; 
size=&quot;40&quot; maxlength=&quot;63&quot; value=&quot;{DEFAULT_SEARCH}&quot;&gt;<br>
&lt;select id=&quot;ext&quot; name=&quot;ext&quot;&gt;<br>
&lt;option value=&quot;all&quot; selected=&quot;selected&quot;&gt;ALL&lt;/option&gt;<br>
&lt;option value=&quot;com&quot;&gt;.com&lt;/option&gt;<br>
&lt;option value=&quot;net&quot;&gt;.net&lt;/option&gt;<br>
&lt;option value=&quot;org&quot;&gt;.org&lt;/option&gt;<br>
&lt;option value=&quot;info&quot;&gt;.info&lt;/option&gt;<br>
&lt;option value=&quot;biz&quot;&gt;.biz&lt;/option&gt;<br>
&lt;/select&gt;<br>
&lt;input type=&quot;submit&quot; value=&quot;Check!&quot;&gt;<br>
&lt;/form&gt;</p>

<?php } else { ?>
<?php if ($usr->AuthInt > 0){ ?>
<p>You are currently signed in <strong><?php echo($_SESSION["username"]); ?></strong>!</p>
<p>User Options:<br />
<a href="admin.php?page=history">View History Log</a><br />
<a href="admin.php?page=code">Get Form Code</a><br />
<a href="admin.php?page=profile">My Profile</a></p>
<?php if ($usr->AuthInt > 1){ ?>
<p>Admin Options:<br />
<a href="admin.php?page=settings">Change settings</a></p>

<p>Version information:<br />
<i><?=versioninfo()?></i></p>
<?php } ?>
<?php } else { ?>
<p class="sub1">Sign in</p>
<form action="admin.php?do=signin" method="POST">
<p>Username:<br />
<input type="text" size="30" name="signin1" username="signin1" /></p>
<p>Password:<br />
<input type="password" size="30" name="signin2" username="signin2" /></p>
<p><input type="submit" value="Sign in!" /></p>
</form>
<?php } ?>
<?php } ?>

<hr />
<a href="./">Whois Home</a> | <a href="admin.php">Admin Home</a>
<?php if ($usr->AuthInt > 0){ ?>
 | <a href="admin.php?page=signout">Sign Out</a>
<?php } ?>
</body>
</html>