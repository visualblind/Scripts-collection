<?php
// class for user authorisation, registration, etc
class UserSys{
	
	// variables up for grabs
	var $AuthInt;
	
	// user sign in and validation function
	function signin($username, $password){
		global $db, $config, $dbprefix;
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE username = '" . dbSecure($username) . "'";
		$userget = $db->execute($sql);
		
		// make sure username exists
		if ($userget->rows < 1){
			die("This username is not registered");
		}
		
		// make sure password is correct
		if ($userget->fields["password"] <> md5($password)){
			die("Your password was incorrect");
		}
		
		// make sure the account isn't locked
		if ($userget->fields["status"] == 0){
			die("Your account has been locked / inactive");
		}
		
		// user is cleared, update database
		$sql = "UPDATE " . $dbprefix . "users SET logindate = " . time() . ", ipaddress = '";
		$sql = $sql . $_SERVER["REMOTE_ADDR"] . "' WHERE ID = " . $userget->fields["ID"];
		$db->execute($sql);
		
		// load information into session
		$_SESSION["userid"] = $userget->fields["ID"];
		$_SESSION["username"] = $userget->fields["username"];
		$_SESSION["password"] = $userget->fields["password"];
		
		// set remember me cookie
		setcookie("remucookie", $userget->fields["username"], time()+2592000, $config["root"]);
		
		// echo username message
		Header("Location: " . $config["rootpath"] . "admin.php");
		Die();
	}
	
	// log user out, destroy sessions
	function signout(){
		$_SESSION = Array();
		session_destroy();
	}
	
	// user registration and such
	function register($username, $password, $password2, $email, $userlevel = 1){
		
		// globalise variables
		global $db, $config, $dbprefix;
		
		// ok, validation first
		if ($username == ""){
			die("You did not enter a username");
		} elseif ($password == ""){
			die("You did not enter a password");
		} elseif ($password <> $password2) {
			die("Your passwords did not match");
		} elseif ($email == ""){
			die("You did not enter an email address");
		}
		
		// email address validation
		if ($config["checkdnsrr"] == "1"){
			$emailsplit = split("@", $email);
			if (!(checkdnsrr($emailsplit[1], "MX"))){
				die("Your email address is not valid"); }
		}
		
		// is this username taken?
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE username = '" . dbSecure($username) . "'";
		$check1 = $db->execute($sql);
		if ($check1->rows > 0){
			die("This username is already taken, please try another"); }
		
		// is this email already used?
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE email = '" . dbSecure($email) . "'";
		$check2 = $db->execute($sql);
		if ($check2->rows > 0 && $config["uniqueemails"] == "1"){
			die("This email address is already used by an account"); }
		
		// work out user level
		if (intval($userlevel) == 2){
			$usrlvl = 2;
		} else {
			$usrlvl = 1;
		}
		
		// ok validation complete, insert into database
		$ctime = time();
		$sql = "INSERT INTO " . $dbprefix . "users (username, password, email, joindate, logindate";
		$sql = $sql . ", ipaddress, status) VALUES ('" . dbSecure($username) . "', '";
		$sql = $sql . md5($password) . "', '" . dbSecure($email) . "', " . $ctime . ", ";
		$sql = $sql . $ctime . ", '" . $_SERVER["REMOTE_ADDR"] . "', " . $usrlvl . ")";
		$db->execute($sql);
		
		// ok, send welcome email
		$msg = "Hi,\nThanks for joining " . $config["sitename"] . ". Your username is: ";
		$msg = $msg . $username . "\n\nYou can log in in at:\n";
		$msg = $msg . $config["rooturl"];
		$headers = "From: " . $config["serveremail"] . " \r\n";
		//mail($email, $config["sitename"] . " Registration", $msg, $headers);
		
		// and finally log user in
		//$this->signin($username, $password);
		DoAlert("User successfully created!");
		
	}
	
	// password reset function
	function GetPassword($email){
		
		// globalise some stuff
		global $db, $config, $dbprefix;
		
		// generate a new password and email it to the user
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE email = '" . dbSecure($email) . "'";
		
		$grabpass = $db->execute($sql);
		if ($grabpass->rows < 1){
			die("This email address is not linked to any account"); }
		
		// sign user out
		$this->signout();
		
		// ok now generate a new password
		$nupass = GeneratePassword();
		
		// update the database
		$sql = "UPDATE " . $dbprefix . "users SET password = '" . md5($nupass) . "' WHERE ID = " . $grabpass->fields["ID"];
		$db->execute($sql);
		
		// send the user an email
		$msg = "Hi,\nYour password has been changed. Your new password is: ";
		$msg = $msg . $nupass . "\n\nYou can log in in at:\n";
		$msg = $msg . $config["rooturl"];
		$headers = "From: " . $config["serveremail"] . " \r\n";
		mail($email, $config["sitename"] . " Password", $msg, $headers);
		
		// and redirect user
		Header("Location: " . $config["root"] . "recover.php?step=2");
		Die();
	
	}
	
	// user authorisation function
	function Auth($level){
	
		if ($_SESSION["userid"] <> ""){
		
			// validate users login
			global $db, $dbprefix;
			$sql = "SELECT * FROM " . $dbprefix . "users WHERE ID = " . $_SESSION["userid"];
			$userd = $db->execute($sql);
			if ($userd->rows < 1){
				// user account not found
				$this->signout();
				$authlevel = 0;
			} else {
				// user account found
				if ($_SESSION["username"] <> $userd->fields["username"] || $_SESSION["password"] <> $userd->fields["password"]){
					// incorrect details
					$this->signout();
					$authlevel = 0;
				} else {
					// user is actually ok, supringly
					$authlevel = $userd->fields["status"];
				}
			}
			
		} else {
			// user is just a visitor
			$authlevel = 0;
		}
		
		// set auth level
		$this->AuthInt = $authlevel;
		
		// finally, check if user has access
		if ($level > $authlevel){
			if ($authlevel > 0){
				die("You do not have access to this page");
			} else {
				global $config;
				Header("Location: " . $config["rootpath"] . "admin.php");
				die();
			}
		}
	
	}
	
	// preferences function for updating them
	function Preferences($email){
		
		// globalise variables
		global $db, $config, $dbprefix;
		
		// check the user is signed in
		$this->Auth(1);
		
		// standard data validation
		if ($email == ""){
			die("You did not enter an email address"); }
	
		// email address validation
		if ($config["checkdnsrr"] == "1"){
			$emailsplit = split("@", $email);
			if (!(checkdnsrr($emailsplit[1], "MX"))){
				die("Your email address is not valid"); }
		}
		
		// check email isn't already in use
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE email = '" . dbSecure($email) . "' AND ID <> " . dbSecure($_SESSION["userid"]);
		$echeck = $db->execute($sql);
		if ($echeck->rows > 0 && $config["uniqueemails"] == "1"){
			die("This email address is already in use"); }
		
		// ok, everything seems fine, do the update
		$sql = "UPDATE " . $dbprefix . "users SET email = '" . dbSecure($email) . "' WHERE ID = " . $_SESSION["userid"];
		$db->execute($sql);
		DoAlert("Your email has been updated!");
	}
	
	// update password function
	function ChangePass($pass1, $pass2, $pass3){
		
		// globalise variables
		global $db, $config, $dbprefix;
		
		// ok, lets begin with validation
		if ($pass1 == "") {
			die ("You did not enter your old password");
		} elseif ($pass2 == ""){
			die ("You did not enter a new password");
		} elseif ($pass3 == ""){
			die ("You did not confirm your new password");
		} elseif ($pass2 <> $pass3){
			die ("Your new passwords did not match");
		}
		
		// check user is logged in
		$this->Auth(1);
		
		// validate the current password
		$sql = "SELECT * FROM " . $dbprefix . "users WHERE ID = " . $_SESSION["userid"];
		$check3 = $db->execute($sql);
		if ($check3->rows < 1){
			die("Your user account cound not be found"); }
		
		// ok, validate the passwords match
		if (md5($pass1) <> $check3->fields["password"]){
			die("Your old password was incorrect"); }
		
		// everything seems fine, run update
		$sql = "UPDATE " . $dbprefix . "users SET password = '" . md5($pass2) . "' WHERE ID = " . $check3->fields["ID"];
		$db->execute($sql);
		
		// now sign user out
		$this->signout();
		
		// restart session
		StartSession();
		
		// sign user back in again
		$this->signin($check3->fields["username"], $pass2);
		
		// and kill script
		DoAlert("Your password has been changed!");
		Die();
	
	}

}
?>