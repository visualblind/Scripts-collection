<?php

//----------------------------------------------------------------------
//						 2005, Shield Tech
//							The Pinger
//						   Rowan Shield
//				email: shieldtech@thesilv3rhawks.com
//----------------------------------------------------------------------
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  at your option) any later version.
//
//----------------------------------------------------------------------

require "requires.php";

$self = $_SERVER['PHP_SELF'];

function login_form($param,$power) {
	echo "<title>The Pinger :: Administration</title><form method='POST' action='$self'><p align='center'>";
	if ($param == "w") {
		echo "<b><font face='Verdana, Arial, Helvetica, sans-serif' color='red' size='2'>Wrong username or password. Please try again</font></b><br>";
	}
	echo "Username: <input type='text' name='username' size='20'><br>
		Password: <input type='password' name='password' size='20'><br>
		<input type='submit' name='login' value='Login'><br><br>$power</p>
	</form>";
}

function unset_login() {
	unset($_SESSION['username']);
	unset($_SESSION['password']);
}

function check_login($dbprefix) {
$query = sprintf("SELECT * FROM " . $dbprefix . "users WHERE username=%s AND password=%s",
            quote_smart($_POST['username']),
            quote_smart(md5($_POST['password'])));

$result = mysql_query($query);

if (!$result) {
    $message  = 'Invalid query: ' . mysql_error() . "\n";
    $message .= 'Whole query: ' . $query;
    die($message);
}

if (mysql_num_rows($result) == 0) {
    $status = "w";
	
}

// Use result
// Attempting to print $result won't allow access to information in the resource
// One of the mysql result functions must be used
// See also mysql_result(), mysql_fetch_array(), mysql_fetch_row(), etc.
while ($row = mysql_fetch_assoc($result)) {
	$_SESSION['username'] = $row['username'];
	$_SESSION['password'] = $row['password'];
}
	if($_SESSION['password'] == md5($_POST['password'])) { 
		$logged_in = 1;
	} else {
		$logged_in = 0;
		$status = "w";
		unset_login();
	}
}

session_start();

if (isset($_POST['login'])) {
	check_login($dbprefix);
}

if (!isset($_SESSION['username']) || !isset($_SESSION['password'])) {
	$logged_in = 0;
} else {
	$logged_in = 1;
}

if ($logged_in == 0) {
	login_form($status,$power);
}

if ($logged_in == 1) {
	if (empty($_REQUEST['framename'])) {
		echo "<frameset cols='175,*' border='0' framespacing='2' frameborder='0'>
				<frame name='nav' src='admin.php?framename=nav' noresize='0' frameborder='0' />
				<frame name='main' src='admin.php?framename=main' noresize='0' frameborder='0' />
				<noframes><body>Your browser does not support frames.<br />
				Please download a browser like Internet Explorer or Firefox that supports frames.<br />
				</body></noframes>
				</frameset>";
	}
}

if ($_REQUEST['framename'] == "nav") {
	echo "<center><h2>The Pinger</h2></center>
<table border='0' width='100%'>
	<tr><td><p align='center'><b>Administration</b></td></tr>
	<tr><td><a href='admin.php?framename=main' target='main'>Admin Index</a></td></tr>
	<tr><td><a href='index.php' target='_parent'>The Pinger Index</a></td></tr>
	<tr><td><a href='index.php' target='main'>Preview The Pinger</a></td></tr>
</table><br>
<table border='0' width='100%'>
	<tr><td><p align='center'><b>Ping Admin</b></td></tr>
	<tr><td><a href='admin.php?framename=main&do=addman' target='main'>Management</a></td></tr>
</table><br>";
/*
// Coming in future versions hopefully! :P
echo "<table border='0' width='100%'>
	<tr><td><p align='center'><b>View Admin</b></td></tr>
	<tr><td>Index View</td></tr>
</table><br>";
// Coming in future versions hopefully as well! :P
echo "<table border='0' width='100%'>
	<tr><td><p align='center'><b>User Admin</b></td></tr>
	<tr><td><a href='admin.php?framename=main&do=userman' target='main'>Management</a></td></tr>
</table>";
*/
echo "<table border='0' width='100%'>
	<tr><td><p align='center'><b>Options</b></td></tr>
	<tr><td><a href='admin.php?do=logout' target='_parent'>Log-Out</a></td></tr>
</table><br>";
}

if ($_REQUEST['do'] == "logout") {
	if ($logged_in == 0) {
		die('You are not logged in so you cannot log out.');
	}
	
	unset($_SESSION['username']);
	unset($_SESSION['password']);
	$_SESSION = array();
	session_destroy();
	header('Location: admin.php');
}

if ($_REQUEST['framename'] == "main") {
	if (empty($_REQUEST['do'])) {
		echo "<b>Welcome to the Pinger</b><br><br>Thank you for choosing The Pinger as a tool to add to your network or system. You can get back to this page by clicking on the <u>Admin Index</u> link in the navigation pane to the left. To return to the index of your board, click the <u>Pinger Index</u> link also in the navigation pane. The other links in the navigation pane allow you to customise The Pinger to how you would like it to work. Each screen will have instructions on how to use the tools.";
		echo "<br><br><br><b>Version Information</b><br><br>";
		$handle = fopen("http://stech.thesilv3rhawks.com:6080/version/?prog=pngr", "r");
		$version = fread($handle, 8192);
		if (!$version) {
			echo "<font color='#0000FF'>Sever could not be reached, you will have to manually check for updates if this update checker keeps displaying this message.</font>";
		} else {
			if ($pngr_version < $version) {
				echo "<font color='#FF0000'><b>There is a newer version of the Pinger Available</b></font>";
			} else {
				echo "<font color='#33CC33'>Your version of The Pinger is up to date</font>";
			}
		}
		echo "<br><br>".$power;
	}

	if ($_REQUEST['do'] == "addman") {
		echo "<b>Address Management</b><br><br>";
		if (empty($_REQUEST['func'])) {
			echo "From this panel you can add, delete and edit Addresses stored in the database";
			echo "<br><br><a href='admin.php?framename=main&do=addman&func=add'>Add a record</a><br><table border='0' width='100%'>
			<tr><td width='40%'><b>System Name</b></td><td width='40%'><b>IP or URL Address</b></td><td width='20%'><b>Options</b></td></tr>";
	
			$query = sprintf("SELECT * FROM " . $dbprefix . "ips");
	
			$result = mysql_query($query);
			
			if (!$result) {
			    $message  = 'Invalid query: ' . mysql_error() . "\n";
			    $message .= 'Whole query: ' . $query;
			    die($message);
			}
			
			if (mysql_num_rows($result) == 0) {
			    $status = "w";
				
			}
			
			// Use result
			// Attempting to print $result won't allow access to information in the resource
			// One of the mysql result functions must be used
			// See also mysql_result(), mysql_fetch_array(), mysql_fetch_row(), etc.
			while ($row = mysql_fetch_assoc($result)) {
				echo "<tr><td>".$row['name']."</td><td>".$row['address']."</td><td><a href='admin.php?framename=main&do=addman&func=edit&id=".$row['id']."'><img src='images/edit.gif' border='0' alt='Edit'></a><a href='admin.php?framename=main&do=addman'><img src='images/delete.gif' border='0' alt='Delete'></a></td></tr>";
			}
		}

		if ($_REQUEST['func'] == "edit") {
			if (!isset($_POST['edit'])) {
				echo "From this panel you can edit an address stored in the database";
				$query = sprintf("SELECT * FROM " . $dbprefix . "ips WHERE id=%s", quote_smart($_REQUEST['id']));
		
				$result = mysql_query($query);
				
				if (!$result) {
				    $message  = 'Invalid query: ' . mysql_error() . "\n";
				    $message .= 'Whole query: ' . $query;
				    die($message);
				}
				
				if (mysql_num_rows($result) == 0) {
				    $status = "w";
					
				}
				
				// Use result
				// Attempting to print $result won't allow access to information in the resource
				// One of the mysql result functions must be used
				// See also mysql_result(), mysql_fetch_array(), mysql_fetch_row(), etc.
				while ($row = mysql_fetch_assoc($result)) {
					echo "<form method='POST' action='admin.php?framename=main&do=addman&func=edit'>
						<p align='center'>System Name:<input type='text' name='name' size='20' value='".$row['name']."'><br>
						IP or URL Address: <input type='text' name='address' size='20' value='".$row['address']."'><br>
						<input type='hidden' name='id' value='".$row['id']."'>
						<input type='submit' value='Submit' name='edit'><input type='reset' value='Reset'></p>
					</form>";
				}
			} else {
				// Make a safe query
				$query = sprintf("UPDATE " . $dbprefix . "ips SET name = %s, address = %s WHERE id = %s LIMIT 1", quote_smart($_POST['name']), quote_smart($_POST['address']), quote_smart($_POST['id']));
		
				$result = mysql_query($query);
		
				if (!$result) {
				    $message  = 'Invalid query: ' . mysql_error() . "\n";
				    $message .= 'Whole query: ' . $query;
				    die($message);
				} else {
					echo "<br><br><center>Record in database has been successfully updated<br><br>Click <a href='admin.php?framename=main&do=addman'>here</a> to go back to Address Management</center>";
				}
			}
		}

		if ($_REQUEST['func'] == "add") {
			if (!isset($_POST['add'])) {
				echo "<form method='POST' action='admin.php?framename=main&do=addman&func=add'>
					<p align='center'>System Name:<input type='text' name='name' size='20'><br>
					IP or URL Address: <input type='text' name='address' size='20'><br>
					<input type='submit' value='Submit' name='add'><input type='reset' value='Reset'></p>
				</form>";
			} else {
				// Make a safe query
				$query = sprintf("INSERT INTO " . $dbprefix . "ips (name, address) VALUES (%s, %s)", quote_smart($_POST['name']), quote_smart($_POST['address']));
		
				$result = mysql_query($query);
		
				if (!$result) {
				    $message  = 'Invalid query: ' . mysql_error() . "\n";
				    $message .= 'Whole query: ' . $query;
				    die($message);
				} else {
					echo "<br><br><center>Addeed ".$_POST['name']." to the database<br><br>Click <a href='admin.php?framename=main&do=addman'>here</a> to go back to Address Management</center>";
				}
			}
		}
	}
}

?>