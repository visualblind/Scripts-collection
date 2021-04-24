<?

require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=recent-failures.php");
	exit;
}

$title = "Recent Failures";
require_once("header.php");



echo '<table align="center" width="760" border="0" cellspacing="0" cellpadding="3">
        <tr>
          <td colspan="3">
		    <span style="border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">RECENT FAILURES:</span><font size="1"><br><br></font>
		  </td>
		  <td colspan="2" align="right">
            <form name="recentlist" action="'.$_SERVER["PHP_SELF"].'" method="POST">
			  No.&nbsp;of&nbsp;Listings:&nbsp;
              <select style="font-size:11px" name="recentnum" size="1" onChange="location.href=recentlist.recentnum.options[selectedIndex].value">
              <option value="http://'.$_SERVER["HTTP_HOST"].''.$_SERVER["PHP_SELF"].'?recentnum=30">30</option>
              <option value="http://'.$_SERVER["HTTP_HOST"].''.$_SERVER["PHP_SELF"].'?recentnum=60">60</option>
              <option value="http://'.$_SERVER["HTTP_HOST"].''.$_SERVER["PHP_SELF"].'?recentnum=90">90</option>
              <option value="http://'.$_SERVER["HTTP_HOST"].''.$_SERVER["PHP_SELF"].'?recentnum=ALL">ALL</option>
              </select>&nbsp;&nbsp;&nbsp;&nbsp;
            </form>
		  </td>
	    </tr>
        <tr>
          <td width="170">
            <b>Date / Time</b>
          </td>
		  <td width="265">
            <b>Node Name</b>
          </td>
		  <td width="110">
            <b>Downtime</b>
          </td>
		  <td width="120">
            <b>IP Address</b>
          </td>
		  <td width="95">
            <b>Port</b>
          </td>
	    </tr>
     ';

$recent_sql = ltrim(rtrim(strip_tags(($_GET["recentnum"]))));
if ($recent_sql == '30') {
  $recent_sql = ' LIMIT 30';
} else if ($recent_sql == '60') {
  $recent_sql = ' LIMIT 60';
} else if ($recent_sql == '90') {
  $recent_sql = ' LIMIT 90';
} else if ($recent_sql == 'ALL') {
  unset($recent_sql);
} else {
  $recent_sql = ' LIMIT 30';
}


         
$query = "SELECT * FROM alert_log WHERE downtime>0 ORDER BY lastnotif DESC".$recent_sql;
$result = db_query($query);
while ($r = db_fetch_array($result)) {
       $description = $r["description"];
       $query2 = "SELECT id FROM objects WHERE description='$description'";
       $result2 = db_query($query2);
       list($id) = db_fetch_array($result2);
       $ipaddress = $r["ipaddress"];
       $port = $r["port"];
       $query_type = $r["query_type"];
       if (($query_type == 'SNMP') || ($query_type == 'ICMP')) {
            $port = $query_type;
       } else {
            $port = $query_type.'&nbsp;Port:&nbsp;'. $port;
       }
       $time = $r["time"];
       $datetime = date("m-d-Y g:i:s a",$time);
       $downtime = $r["downtime"];
       $url = $r["url"];
       if ($downtime < 60) {
       $downtime="$downtime second(s)";
       } elseif (($downtime >= 60) && ($downtime < 3600)) {
       $downtime=round($downtime/60, 2) . " minute(s)";
       } else {
       $downtime=round($downtime/3600, 2) . " hour(s)";
       }

	   $description = '<a style="text-decoration:none;" href="addedit-nodes.php?id='.$id.'">'.$description.'</a>';

       echo '<tr>
               <td>'.$datetime.'</td>
               <td>'.$description.'</td>
               <td>'.$downtime.'</td>
               <td>'.$ipaddress.'</td>
            ';
      
    if (($query_type == 'HTTP') && ($url)) {
      echo '   <td><a href="http://'. $ipaddress .'/'. $url .'" target="_blank">'.$port.'</a></td>
             </tr>
           ';
    } else {
      echo '<td>'.$port.'</td></tr>';
    }
	
  }

echo '</table>';

require_once("footer.php");
?>
