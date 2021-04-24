<?
require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=db-maintenance.php");
	exit;
} else if (($_SESSION["isloggedin"] == $glbl_hash) && ($_SESSION["isadmin"] != $glbl_hash)) {
	header("Location: ".$nr_url);
	exit;
}

$title = "Database Maintenance";
require_once("header.php");




if (($_POST["submit"] == "Proceed w/ Removal") && ($_POST["del_sure"] == 1)) {
  // Records older than '$old' will be deleted according to 'time' field
  $now = mktime();
  $old = $now - (intval($_POST['timespan']) * intval($_POST['num']));
  $query1 = "SELECT id,time FROM alert_log WHERE resolved<>'N'";
  $result1 = db_query($query1);
  $count = 0;
  while ($r = db_fetch_array($result1)) {
    $id = $r["id"];
    $time = $r["time"];
    if ((int)$time < $old) {
      $query2 = "DELETE FROM alert_log WHERE id='$id'";
      $result2 = db_query($query2);
      $count++;
    }
  }
  
  if (!$count) {
    echo '<div align="center" class="errmsg">There were no records that old.</div><br><br>';
  } else {
    echo '<div align="center" class="errmsg">'.$count.' Record(s) Successfully Deleted.</div><br><br>';
  }


}


echo '
<table width="760" border="0" cellspacing="0" cellpadding="3" align="center">
<form action="'.$_SERVER['PHP_SELF'].'" method="post">
  <tr valign="top">
    <td height="42">
      <span style="border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">HISTORICAL LOG CLEANUP:</span><font size="1"><br><br></font>
	  <font color="red"><b>CAUTION: This function will PERMANENTLY remove historical log records.  This is the data that is collected to display downtime statistics for each node.  It is recommended that you do not use this feature unless you are running low on disk space.  Proceed with caution.</b></font>
	</td>
  </tr>
  <tr>
    <td>
      <p>Remove ALL records
        <input type="text" name="num" size="2" value="90">
        <select name="timespan">
          <option value="60">MINUTE(S)</option>
          <option value="3600">HOUR(S)</option>
          <option value="86400" selected>DAY(S)</option>
        </select>
        older than today\'s date and time.</p>
      <p>Today\'s Date: <b>'. date("m/d/Y H:i:s", mktime()) .'</b></p>
      <p><input type="checkbox" name="del_sure" value="1">
        I\'m sure.
        <input type="submit" name="submit" value="Proceed w/ Removal">
        </form></p>
    </td>
  </tr>
</table>
     ';


require_once("footer.php");

?>
