<?php
error_reporting(E_ERROR | E_WARNING | E_PARSE);
include("../includes/database.php");
include("../includes/config.php");

if ($_GET["do"] == "install"){
	// run the MySQL queries
	$db = new Database($dbhost, $dbuser, $dbpass, $dbname);
	
	// run each of the commands
	$filename =  "install.sql";
	$contents = implode("", file($filename)); // join it into one string
	$contents = str_replace("pw_", $dbprefix, $contents);
	$contents = str_replace("\r\n", "\n", $contents); // convert to Unix EOL format if needed
	$queries = explode(";\n", $contents); // split into separate queries
	foreach ($queries as $query) {
	$result = $db->execute($query);
	}
	
	// run individual commands
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . $_POST["sitename"] . "' WHERE config_name = 'sitename'");
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . $_POST["mainsite"] . "' WHERE config_name = 'mainsite'");
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . $_POST["mainurl"] . "' WHERE config_name = 'mainurl'");
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . $_POST["root"] . "' WHERE config_name = 'rootpath'");
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . $_POST["rooturl"] . "' WHERE config_name = 'rooturl'");
	$db->execute("UPDATE " . $dbprefix . "config SET config_value = '" . time() . "' WHERE config_name = 'created'");
	
	// insert the admin user
	$sql = "INSERT INTO " . $dbprefix . "users (username, password, email, joindate, ";
	$sql .= "logindate, ipaddress, status) VALUES ('" . $_POST["username"] . "', '";
	$sql .= md5($_POST["password"]) . "', '" . $_POST["email"] . "', " . time() . ", ";
	$sql .= time() . ", '" . $_SERVER["REMOTE_ADDR"] . "', 2)";
	$db->execute($sql);
	
	// sign the user in
	$_SESSION["userid"] = mysql_insert_id();
	$_SESSION["username"] = $_POST["username"];
	$_SESSION["password"] = md5($_POST["password"]);
	
	// and redirect to confirmation
	Header("Location: install.php?do=step3");
	Die();
}

if ($_GET["do"] == "step3"){
	$inst = @mysql_connect($dbhost, $dbuser, $dbpass);
	if (!$inst){
		Header("Location: install.php");
		Die();
	} else {
		// can connect to the db
		$dbselt = mysql_select_db($dbname, $inst);
		if (!$dbselt) {
			Header("Location: install.php");
			Die();
		} else {
			// check to see if the data is in there
			$db = new Database($dbhost, $dbuser, $dbpass, $dbname);
			$test = mysql_query("SELECT * FROM " . $dbprefix . "config WHERE config_name = 'version'");
			if (!$test){
				Header("Location: install.php");
				Die();
			}
		}
	}
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Particle Whois Installer</title>
<link rel="stylesheet" type="text/css" href="../shared/admin.css" />
</head>
<body>
<table width="75%" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF" align="center" style="border: #666666 1px solid;"><tr><td>
<table width="100%" cellpadding="5" cellspacing="0" border="5">
<tr>
	<td>
		<p><span class="sub1">Installer</span><br />
		Hi, welcome to Particle Whois! All you need to do know is run through this short installer and you will be ready to begin.<!-- If you have already installed Particle Whois and are <strong>upgrading from a previous version</strong>, go <a href="upgrade.php">here</a> instead.--></p>
	</td>
</tr>
</table>
</td></tr></table><br />
<table width="75%" cellpadding="0" cellspacing="0" border="0" bgcolor="#FFFFFF" align="center" style="border: #666666 1px solid;"><tr><td>
<table width="100%" cellpadding="5" cellspacing="0" border="5">
<tr>
	<td>
		<?php if ($_GET["do"] == "step3"){ ?>
		<p align="center"><strong>Installation Complete</strong></p>
		<p>Congratulations, Particle Whois is now installed! All you need to do now is to <strong>delete the install folder</strong>. You will not be able to access to access the rest of the site until this is done for security reasons.</p>
		<p>You have been automatically signed in and can now make changes to the rest of the config <strong><a href="../admin.php?page=settings">here</a></strong>. Or you can go to the whois homepage <a href="../">here</a>.</p>
		<?php } elseif ($_GET["do"] == "step2"){ ?>
		<p align="center"><strong>Whois install information</strong></p>
		<form action="install.php?do=install" method="POST">
		<table width="75%" cellpadding="5" cellspacing="0" border="0" align="center">
			<tr>
				<td><strong>Site Name</strong><br />
				Give your whois site a cool name such as I love Particle Soft!</td>
				<td><input type="text" size="40" maxlength="255" id="sitename" name="sitename" /></td>
			</tr>
			<tr>
				<td><strong>Main Site</strong><br />
				Specify the sites main name or if none exists the site name again</td>
				<td><input type="text" size="40"  maxlength="255" id="mainsite" name="mainsite" /></td>
			</tr>
			<tr>
				<td><strong>Main URL</strong><br />
				Specify the URL of your main site or if none, the URL of the whois site</td>
				<td><input type="text" size="40"  maxlength="255" id="mainurl" name="mainurl" value="http://" /></td>
			</tr>
			<tr>
				<td><strong>Virtual Root</strong><br />
				The root path to the files such as /whoistool/ or just /</td>
				<td><input type="text" size="40"  maxlength="255" id="root" name="root" value="<?php echo(str_replace("install/install.php", "", $_SERVER["PHP_SELF"])); ?>" /></td>
			</tr>
			<tr>
				<td><strong>Domain</strong><br />
				The full http path to the script such as http://whois.example.com or http://www.example.com, no /folder/ no ending slash</td>
				<td><input type="text" size="40"  maxlength="255" id="rooturl" name="rooturl" value="http://<?php echo($_SERVER["SERVER_NAME"]); ?>" /></td>
			</tr>
			<tr>
				<td><strong>Admin Username</strong><br />
				Choose a username that you will use to log in to make posts and change settings</td>
				<td><input type="text" size="40"  maxlength="255" id="username" name="username" /></td>
			</tr>
			<tr>
				<td><strong>Admin Password</strong><br />
				This is the password for the admin user to make sure nobody can guess it</td>
				<td><input type="password" size="40"  maxlength="255" id="password" name="password" /></td>
			</tr>
			<tr>
				<td colspan="2" align="center">
					<input type="submit" value="Install Database!" />
				</td>
			</tr>
		</table>
		</form>
		<?php } else { ?>
		<p align="center"><strong>MySQL conenct information</strong></p>
		<?php if ($dbname == ""){ ?>
		<p>You have not filled out the database information. You need to edit config.php in the includes folder. You will need to enter the following values for your MySQL database:</p>
		<p>$dbtype = "mysql";<br />
		$dbhost = "localhost";<br />
		$dbuser = "";<br />
		$dbpass = "";<br />
		$dbname = "";<br />
		$dbprefix = "pbl_";</p>
		<p>You will need to enter the values for your database. Unless told otherwise you can leave dbhost, dbtype and dbprefix as default. However you will need to create a database and add a user to it with a username and password. For example:</p>
		<p>$dbuser = "iamauser";<br />
		$dbpass = "password";<br />
		$dbname = "mydatabase";</p>
		<p>Once you have filled out all the details in config.php, click the button below.</p>
		<form action="install.php" method="GET">
			<center><input type="submit" value="Continue" /></center>
		</form>
		<?php
		}  else {
		$inst = @mysql_connect($dbhost, $dbuser, $dbpass);
		if (!$inst){
		?>
		<p>Error! Could not connect to the database. Please review config.php. The error returned was:</p>
		<p style="background-color: #FFE26E;"><?php echo(mysql_error()); ?></p>
		<?php } else { ?>
		Connected fine!<br />
		<?php
		$dbselt = mysql_select_db($dbname, $inst);
		if ($dbselt) {
		?>
		Database selected fine!</p>
		<form action="install.php?do=step2" method="POST">
			<center><input type="submit" value="Continue" /></center>
		</form>
		<?php } else { ?>
		<p>Error: Could not select database. Check that the database exists and that the user has permission to use it.</p>
		<?php } ?>
		<?php } ?>
		<?php } ?>
		<?php } ?>
	</td>
</tr>
</table>
</td></tr></table>
<center>&nbsp;<br />&copy; 2004-2005 <a href="http://www.particlesoft.net/">Particle Soft</a></center>
</body>
</html>