<?
require_once("connect.php");

// Make sure user is really logged in, flush the session vars, then redirect.
if ($_SESSION["isloggedin"] == $glbl_hash) {
  unset($_SESSION["isloggedin"]);
  unset($_SESSION["username"]);
  unset($_SESSION["isadmin"]);
}

header("Location: ".$nr_url);
exit;

?>
