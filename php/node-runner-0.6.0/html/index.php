<?php

require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=index.php");
	exit;
}

$title = "Main Page";
require_once("header.php");


####### Get Up/Down Percentile
function count_deps($parent) {
        GLOBAL $cnt;
        // Recursive function to count dependencies
        $sql = "SELECT id FROM objects WHERE dependency='$parent'";
        $result = db_query($sql);
        while ($r = db_fetch_array($result)) {
               $cnt++;
               count_deps($r['id']);
        }
return $cnt;
}

$down_count = 0;
$query1 = "SELECT description FROM alert_log WHERE resolved='N'";
$result1 = db_query($query1);
  while ($r = db_fetch_array($result1)) {
         $description = $r["description"];

         $query1a = "SELECT id FROM objects WHERE enabled='Y' AND description='$description'";
         $result1a = db_query($query1a);
         list($id1a) = db_fetch_array($result1a);
         $cnt = 1;
         $down_count += count_deps($id1a);
  }

$query2 = "SELECT count(description) FROM objects WHERE enabled='Y' and smon_time<='$mon_time' and emon_time>='$mon_time' and days like '%$today%'";
$result2 = db_query($query2);
list($tmp_total_nodes) = db_fetch_array($result2);

if ($down_count > 0) {
  $percent = 100 * (1 - ($down_count / $tmp_total_nodes));
  $percent = round($percent, 2);
  if ($percent < 0) { $percent = 0;  }
} else {
  $percent = 100;
}
####### End Up/Down Percentile


####### Get Endpoint Count
unset($server_count);
$query_server_count = "SELECT id FROM objects WHERE server='Y' and enabled='Y'";
$result_server_count = db_query($query_server_count);
$server_count = db_num_rows($result_server_count);
####### End Endpoint Count


####### Get Total Nodes Count
unset($total_nodes);
$query_nodes_count = "SELECT id FROM objects WHERE enabled='Y'";
$result_nodes_count = db_query($query_nodes_count);
$total_nodes = db_num_rows($result_nodes_count);
####### End Total Nodes Count


####### Get Oldest Alert Log Data
unset($oldest_data);
$query_oldest = "SELECT time FROM alert_log ORDER BY id ASC LIMIT 1";
$result_oldest = db_query($query_oldest);
list($oldest_timestamp) = db_fetch_array($result_oldest);
$oldest_timestamp = date("F j, Y", $oldest_timestamp);
####### End Oldest Alert Log Data


echo '
<table width="100%" border="0" align="center" cellpadding="5" cellspacing="0">
  <tr>
    <td valign="top">
	  <table class="usefulstats" width="400" border="0" align="center" cellpadding="3" cellspacing="0">
        <tr>
          <td class="usefulstats" align="center"><b>Statistics Snapshot</b></td>
        </tr>
        <tr>
          <td class="usefulstats"><p>&nbsp;&#8226;&nbsp;Network Status: '.$percent.'% (page does not refresh automatically)<br>
              &nbsp;&#8226; Network Endpoints: '.$server_count.' (Enabled)<br>
              &nbsp;&#8226;&nbsp;Total Network Nodes: '.$total_nodes.'<br>
              <br>
              <br>
              &nbsp;&#8226; Node Runner Query Interval: '.$qtime.' Minutes<br>
              &nbsp;&#8226;&nbsp;Oldest Historical Data: '.$oldest_timestamp.'</p></td>
        </tr>
      </table>
      <br>
      <table class="projectnews" width="400" border="1" align="center" cellpadding="3" cellspacing="0">
        <tr>
          <td class="projectnews" align="center"><b>Node Runner Project News</b></td>
        </tr>
        <tr>
          <td class="projectnews">';
          
          if ($allow_rss) {
            $xmlfile = fopen("http://node-runner.sourceforge.net/project_news.php", "r");
            if(!$xmlfile) {
            	echo ("XML Feed Not Found!");
            } else {
                $readfile = fread($xmlfile, 1024);
                $searchfile = eregi("<ITEM>(.*)</ITEM>", $readfile ,$arrayreg);
                $filechunks = explode("<ITEM>", $arrayreg[0]);
                $count = count($filechunks);
                for($i=1; $i<=($count-1) ;$i++) {
				  if ($i >= 2) { echo '<br><br>'; }
                  ereg("<TIDBIT>(.*)</TIDBIT>",$filechunks[$i], $tidbit);
                  ereg("<DATE>(.*)</DATE>",$filechunks[$i], $date);
                  echo '<font color="#A00000">'.$date[1].'</font> - '.$tidbit[1];
                }
            }
          } else {
			echo 'Node Runner project news has been disabled by your administrator.';
          }

echo '

		  </td>
        </tr>
      </table>
      <br>
    </td>
    <td align="center" valign="top">
	  <table class="recentfailures" width="300" border="1" cellspacing="0" cellpadding="3">
        <tr>
          <td class="recentfailures" align="center"><b>Recent Endpoint Failures</b></td>
        </tr>
        <tr>
          <td class="recentfailures">';

      $query = "SELECT description,time,downtime FROM alert_log WHERE downtime>0 ORDER BY lastnotif DESC LIMIT 3";
      $result = db_query($query);
      while ($r = db_fetch_array($result)) {
             $rec_desc = $r["description"];
             if (($truncate_at > 0) && (strlen($rec_desc) > ($truncate_at + 3))) {
               $trunc_rec_desc = substr($rec_desc,0,$truncate_at)."...";
             } else {
               $trunc_rec_desc = $rec_desc;
             }
             $rec_time = $r["time"];
             $rec_datetime = date("m-d-Y g:i:s a",$rec_time);
             $rec_downtime = $r["downtime"];
             if ($rec_downtime < 60) {
               $rec_downtime = $rec_downtime.' second(s)';
             } elseif (($rec_downtime >= 60) && ($rec_downtime < 3600)) {
               $rec_downtime = round($rec_downtime/60, 2) . ' minute(s)';
             } else {
               $rec_downtime = round($rec_downtime/3600, 2) . ' hour(s)';
             }

             echo '<span style="font-size:12px;">&nbsp;&#8226;&nbsp;<span style="font-size:12px;color:#A00000;">'.$trunc_rec_desc.'</span><br>&nbsp;&nbsp;'.$rec_datetime.'<br>
	            &nbsp;&nbsp;DOWNTIME: '.$rec_downtime.'<br><br></span>';

      }
          
echo '
        <div style="text-align:right;">
         [<a href="recent-failures.php">read more</a>]
        </div>
          </td>
        </tr>
      </table></td>
  </tr>
</table>
	 ';

require_once("footer.php");

?>
