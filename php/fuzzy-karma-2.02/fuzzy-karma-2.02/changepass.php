<?php
include_once("etc/conf.php");
class changepass
{
    function changepass()
    {
            $this->run();
    } // end constructor
    
    function run() 
    {
		$tdb = new DAB(SQL_HOST, SQL_USER, SQL_PASS, SQL_DB);
		$tdb->connect();
		echo "<td align=\"center\">";
		if ($_POST[change_pass])
		{
			$pass1 = mysql_escape_string($_POST[pass1]);
			$ppass = mysql_escape_string($_POST[ppass]);
			if($pass1 == $ppass)
			{
				if($tdb->query("UPDATE fuzzy_users SET password=PASSWORD('$ppass') WHERE username='admin'"))
					echo "Your password was updated successfully!";
				else
					echo "<font color=red >There was a problem updating your password.<br>Please try again.</font>";
			}//end if
			else
				echo "<font color=red >The passwords you entered did not match.<br>Please try again.</font>";
		}
		$tdb->close();
        echo "
	<form action='index.php?load=changepass.php' method='post' enctype='multipart/form-data'>
	<table align='center'>
	<tr>
		<td colspan=2><img src='".IMAGES."cp.gif' width=1 height=15></td>
	</tr>
	<tr>
		<td>New Password: </td>
		<td><input type='password' name='pass1'></td>
	</tr>
	<tr>
		<td>Password: </td>
		<td><input type='password' name='ppass'></td>
	</tr>
	<tr>
		<td colspan=3 align='center'><input type='submit' name='change_pass' value='Change Password'></td>
	</tr>
	</table>
	</form></td>
";
    return true;
    } //end run

} // end class
?>

