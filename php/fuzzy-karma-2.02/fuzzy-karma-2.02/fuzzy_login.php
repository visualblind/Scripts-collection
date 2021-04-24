<?php
/* This is the login file */
include_once("etc/conf.php");
class fuzzy_login
{
    function fuzzy_login()
    {
            $this->run();
    } // end constructor
    
    function run() 
    {
        echo "
	<form action='index.php' method='post' enctype='multipart/form-data'>
	<table align='center'>
	<tr>
		<td colspan=2><img src='".IMAGES."cp.gif' width=1 height=15></td>
	</tr>
	<tr>
		<td>Username: </td>
		<td><input type='text' name='puser'></td>
	</tr>
	<tr>
		<td>Password: </td>
		<td><input type='password' name='ppass'></td>
	</tr>
	<tr>
		<td colspan=3 align='center'><input type='submit' name='submit' value='Login'></td>
	</tr>
	</table>
	</form>
";
    return true;
    } //end run

} // end class
?>

