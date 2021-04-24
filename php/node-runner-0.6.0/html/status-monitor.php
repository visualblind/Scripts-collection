<?
require_once("connect.php");
if (($secure_monitor) && ($_SESSION["isloggedin"] != $glbl_hash)) {
	header("Location: ".$nr_url."login.php?referrer=status-monitor.php");
	exit;
} else if (($secure_monitor) && ($_SESSION["isloggedin"] == $glbl_hash) && ($_SESSION["isadmin"] != $glbl_hash)) {
	header("Location: ".$nr_url);
	exit;
}



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

unset($total_down_count);
$query1 = "SELECT description FROM alert_log WHERE resolved='N'";
$result1 = db_query($query1);
  while ($r = db_fetch_array($result1)) {
         $description = $r["description"];

         $query1a = "SELECT id FROM objects WHERE enabled='Y' AND description='$description'";
         $result1a = db_query($query1a);
         list($id1a) = db_fetch_array($result1a);
         $cnt = 1;
         $total_down_count += count_deps($id1a);
  }

$now = mktime();
$today = date("D", $now);
$mon_time = intval(date("Hi", $now));
unset($now);

$query2 = "SELECT count(description) FROM objects WHERE enabled='Y' and smon_time<='$mon_time' and emon_time>='$mon_time' and days like '%$today%'";
$result2 = db_query($query2);
list($tmp_total_nodes) = db_fetch_array($result2);

if ($total_down_count > 0) {
  $percent = 100 * (1 - ($total_down_count / $tmp_total_nodes));
  $percent = round($percent, 2);
  if ($percent < 0) { $percent = 0;  }
} else {
  $percent = 100;
}
####### End Up/Down Percentile

####### Query DOWN nodes manually #######
function list_of_includes($dir) {
    // Returns array of file names from $dir

    $i=0;
      if ($use_dir = @opendir($dir)) {
        while (($file = readdir($use_dir)) !== false) {
          if (ereg("query_",$file)) {
            $includes_arr[$i] = "$file";
            $i++;
          }
        }
      closedir($use_dir);
    }

    return $includes_arr;
}

$query_type_includes = list_of_includes($path_to_include);
$queries_type_array = array();
foreach ($query_type_includes as $types) {
	include_once($path_to_include.$types);
}

function query_socket($description, $ipaddress, $port, $query_type, $snmp_comm, $url, $username, $pass, $ptime, $max_attempts) {
    GLOBAL $allow_refused;
    switch($query_type) {
	    case "HTTP":
		  $stat = http_query($description, $ipaddress, $port, $url, $username, $pass, $ptime);
		  break;
		case "ICMP":
		  $stat = icmp_query($description, $ipaddress, $ptime);
		  break;
		case "TCP":
		  $stat = tcp_query($description, $ipaddress, $port, $ptime);
		  break;
		case "SNMP":
		  $stat = snmp_query($description, $ipaddress, $snmp_comm, $ptime);
		  break;
		case "UDP":
		  $stat = udp_query($description, $ipaddress, $port, $ptime);
		  break;
	}
    return $stat;
}

function mailer($id, $mail_id, $status, $status_msg, $now, $sender, $downtime) {
 GLOBAL $detailed_email,$qtime;
 $query = "SELECT email FROM mail_group WHERE id='".$mail_id."'";
 $result = db_query($query);
 while ($r = db_fetch_array($result)) {
        $email=$r["email"];
		$query_comments = "SELECT description,ipaddress,comments FROM objects WHERE id='".$id."'";
        $result_comments = db_query($query_comments);
        list($id_description,$id_ipaddress,$id_comments) = db_fetch_array($result_comments);
        if ($detailed_email == 1) {

          if ($id_comments) { $comments = "Comments: ".$id_comments; }
          $query_affected = "SELECT description FROM objects WHERE dependency='$id'";
          $result_affected = db_query($query_affected);
          $num_rows_affected = db_num_rows($result_affected);
          unset($dir_affected);
          if ($num_rows_affected == 0) {
              $dir_affected = "NONE";
              $affected_cnt = 0;
          } else {
              $affected_cnt = count_deps($id);
              $dir_affected = "\n";
              while ($s = db_fetch_array($result_affected)) {
                     $each_affected = $s["description"];
                     $dir_affected .= $each_affected."\n";
              }
          }

          if (!$downtime) {
              $downtime = "Less than $qtime minute(s)";
          } else {
              if ($downtime < 60) {
                  $downtime = "$downtime Second(s)";
              } elseif (($downtime >= 60) && ($downtime < 3600)) {
                  $downtime = round($downtime/60, 2) . " Minute(s)";
              } else {
                  $downtime = round($downtime/3600, 2) . " Hour(s)";
              }
          }

          if (!$status) {
              mail("$email","$id_description DOWN","$status_msg\nIP: $id_ipaddress\n\n$now\n\nDowntime: $downtime\n\nNodes Directly Affected: $dir_affected\nTotal Nodes Affected: $affected_cnt\n\n$comments","From:$sender");
          } else {
              // Send a different message if up - we don't need as much info when it comes back up.
              mail("$email","$id_description UP","$status_msg\n$now\n\nTotal Downtime: $downtime","From:$sender");
          }

        } else {
		  if (!$status) {
		    $subject = $id_description." DOWN";
		  } else {
		    $subject = $id_description." UP";
		  }
          mail("$email","$subject","$status_msg\n$now","From:$sender");
        }
  }
}
######## End query of DOWN nodes ########



// If manually polling a node...
if ((strip_tags($_GET["poll"]) == 1) && ($_GET["desc"]) && ($monitor_polling)) {
  $poll_desc = strip_tags(rtrim(ltrim($_GET["desc"])));
  $query_poll = "SELECT id,description,ipaddress,port,query_type,mail_group,ptime,url,snmp_comm,auth_user,auth_pass FROM objects WHERE description='".$poll_desc."'";
  $result_poll = db_query($query_poll);
  list($id,$desc,$ip,$port,$query_type,$mail_group,$ptime,$url,$snmp_comm,$http_user,$http_pass) = db_fetch_array($result_poll);
  $query_poll2 = "SELECT time,lastnotif FROM alert_log WHERE description='".$desc."' AND resolved='N'";
  $result_poll2 = db_query($query_poll2);
  list($went_down,$lastnotif) = db_fetch_array($result_poll2);
  $poll = query_socket($desc, $ip, $port, $query_type, $snmp_comm, $url, $http_user, $http_pass, $ptime, 1);
  if ($poll[0]) {
    $downtime = (mktime() - $went_down);
    $query2 = "UPDATE alert_log SET downtime='".$downtime."',resolved='Y' WHERE description='".$desc."' AND resolved='N'";
    $result2 = db_query($query2);
    $stat = $poll[0];
    $stat_msg = $poll[1];
    $now = date("m-d-Y g:i:s a", mktime());

    if ($firstmail == 0) {
      $out = mailer($id, $mail_group, $stat, $stat_msg, $now, $sender, $downtime);
    } else if ($firstmail > 0 && ($al_lastnotif > $al_start_time)) {
      $out = mailer($id, $mail_group, $stat, $stat_msg, $now, $sender, $downtime);
    }

  }

unset($poll_desc,$poll_time,$desc,$ip,$port,$query_type,$mail_group,$ptime,$url,$snmp_comm,$http_user,$http_pass,$downtime,$went_down,$stat,$stat_msg,$id,$out);
if (!$_GET["iframe"]) { print '<META HTTP-EQUIV="Refresh" CONTENT="0; URL=status-monitor.php">'; }
}

if (!$_GET["iframe"]) {
echo '
<html>
<head>
<title>Node Runner - Network Dashboard</title>
<link rel="stylesheet" href="style.css" type="text/css">
<script language="Javascript">
function openInfoWindow(url,width,height)  {
   window.open(url, "NodeRunnerInfo", "width="+width+",height="+height+",menubar=no,status=no,location=no,toolbar=no,scrollbars=yes,resizable=yes");
   return false;
}
</script>
</head>
<body>
<META HTTP-EQUIV="Refresh" CONTENT="'. $dash_refrate .'; URL='.$_SERVER["PHP_SELF"].'">
<table width="100%" border="0" cellspacing="4" cellpadding="4" height="100%">
  <tr valign="top">
    <td class="dashboard" width="225">';
}
    
if (($status_stats == 1) && (!$_GET["iframe"])) {
  echo '
      <p><font size="2"><b>Node Statistics Snapshot:</b></font></p>

	  <div style="border-bottom:1px solid #AD8802;">
	  &#8226;&nbsp;Current Network Time: <span style="color:#A00000;">'.date("g:i:s a",mktime()).'</span><br>
	  &#8226; Network Endpoints: '.$server_count.' (Enabled)<br>
	  &#8226; Non-Endpoints: '.intval($total_nodes - $server_count).' (Enabled)<br>
      &#8226;&nbsp;Total Network Nodes: '.$total_nodes.'<br>
      <br><br>
      &#8226; Node Runner Query Interval: '.$qtime.' Minutes<br>
      &#8226;&nbsp;Oldest Historical Data: '.$oldest_timestamp.'<br><br></div>
		';
}





// Show currently down

  $query4 = "SELECT id,description,downtime,ipaddress,port,query_type,url FROM alert_log WHERE resolved='N' ORDER BY description ASC";
  $result4 = db_query($query4);
  $disp_downcount = db_num_rows($result4);
  if ($disp_downcount>0) {
  $down_desc_array = array();
  if (!$_GET["iframe"]) {
  echo '<div style="border-bottom:1px solid #AD8802;">
        <br><font size="2"><b>Current Outages:</b></font><br><br>
       ';
  }
	  $i=1;
      while ($r = db_fetch_array($result4)) {
             $id = $r["id"];
             $description = $r["description"];
             if (($truncate_at > 0) && (strlen($description) > ($truncate_at + 3))) {
               $trunc_description = substr($description,0,$truncate_at)."...";
             } else {
               $trunc_description = $description;
             }
             
             array_push($down_desc_array, $trunc_description);

             $desc = urlencode($description);
             $downtime = $r["downtime"];
             $ipaddress = $r["ipaddress"];
             $port = $r["port"];
             $query_type = $r["query_type"];
             $url = $r["url"];

             if ($monitor_polling) { // polling may be disabled on the status monitor
               $out .= '<b>'.$i.'.&nbsp;<a target="_top" style="font-size:12px;text-decoration:none;" href="status-monitor.php?poll=1&desc='. $desc .'">'. $trunc_description .'</a></b><br>';
               $out .= '<span style="font-size:10px">(CLICK TO POLL MANUALLY)</span>';
             } else {
               $out .= '<font color="#A00000"><b>'. $trunc_description .'</b></font><br>';
             }

             $out .= '<p><span style="font-size:12px">IP:&nbsp;'. $ipaddress .'&nbsp;-&nbsp;';
             if (($query_type == 'SNMP') || ($query_type == 'ICMP')) {
               $out .= $query_type;
             } else {
               $out .= $query_type.'&nbsp;Port:&nbsp;'. $port;
             }
			 $out .= '</span><br>';
             $out .= '<span style="font-size:12px">';
             if ($downtime < 60) {
               $downtime = "Less than $qtime Minute(s)";
             } else if (($downtime >= 60) && ($downtime < 3600)) {
               $downtime = round($downtime/60, 2) . " Minute(s)";
             } else {
               $downtime = round($downtime/3600, 2) . " Hour(s)";
             }
             $out .= 'DOWNTIME: '. $downtime .'</span></p>';
             $out .= '<p><span style="font-size:12px">';

             $query4a = "SELECT id FROM objects WHERE description='$description'";
             $result4a = db_query($query4a);
             list($id4a) = db_fetch_array($result4a);

             $query4b = "SELECT description FROM objects WHERE dependency='$id4a'";
             $result4b = db_query($query4b);
             $num_rows4b = db_num_rows($result4b);
             if ($num_rows4b>0) {
               $out .= "DIRECTLY AFFECTED: <a href=\"help.php?topic=status_mon_dir_affect&iid=".$id4a."\" style=\"font-weight:bold;text-decoration:none;\" onClick=\"return(openInfoWindow(\\'help.php?topic=status_mon_dir_affect&iid=".$id4a."\\',300,200))\">".$num_rows4b."</a><br>";
               unset($cnt);
               $cnt2 = count_deps($id4a);
               $out .= "TOTAL AFFECTED: <a href=\"help.php?topic=status_mon_total_affect&iid=".$id4a."\" style=\"font-weight:bold;text-decoration:none;\" onClick=\"return(openInfoWindow(\\'help.php?topic=status_mon_total_affect&iid=".$id4a."\\',500,500))\">". $cnt2 ."</a><br><br><br>";
             } else {
               $out .= '</span><br>';
             }
             
             $i++;
             
      } // end while
      
      if ($_GET["iframe"]) { echo '<html><body bgcolor="#c0c0c0" link="#A00000" alink="#A00000" vlink="#A00000"><span style="font-family:Arial;font-size:12px;">
                                   <div id="datacontainer" style="position:absolute;left:1px;top:10px;width:100%" onMouseover="scrollspeed=0" onMouseout="scrollspeed=cache">
								   '.$out.'<br><br>'.$out.'<br><br>'.$out.'
								   </div>
								   <script type="text/javascript">

                                   /***********************************************
                                   * IFRAME Scroller script- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
                                   * This notice MUST stay intact for legal use
                                   * Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
                                   ***********************************************/

                                   //Specify speed of scroll. Larger=faster (ie: 5)
                                   var scrollspeed=cache=2

                                   //Specify intial delay before scroller starts scrolling (in miliseconds):
                                   var initialdelay=1000

                                   function initializeScroller(){
                                   dataobj=document.all? document.all.datacontainer : document.getElementById("datacontainer")
                                   dataobj.style.top="5px"
                                   setTimeout("getdataheight()", initialdelay)
                                   }

                                   function getdataheight(){
                                   thelength=dataobj.offsetHeight
                                   if (thelength==0)
                                   setTimeout("getdataheight()",10)
                                   else
                                   scrollDiv()
                                   }

                                   function scrollDiv(){
                                   dataobj.style.top=parseInt(dataobj.style.top)-scrollspeed+"px"
                                   if (parseInt(dataobj.style.top)<thelength*(-1))
                                   dataobj.style.top="5px"
                                   setTimeout("scrollDiv()",40)
                                   }

                                   if (window.addEventListener)
                                   window.addEventListener("load", initializeScroller, false)
                                   else if (window.attachEvent)
                                   window.attachEvent("onload", initializeScroller)
                                   else
                                   window.onload=initializeScroller


                                   </script>
								   </span>
								   </body></html>'; }
      
             if (($disp_downcount>4) && (!$_GET["iframe"])) {
                // Set up scrolling marquee because list will be too long.
                
				echo '
                <script type="text/javascript">

                /***********************************************
                * IFRAME Scroller script- © Dynamic Drive DHTML code library (www.dynamicdrive.com)
                * This notice MUST stay intact for legal use
                * Visit Dynamic Drive at http://www.dynamicdrive.com/ for full source code
                ***********************************************/

                //specify path to your external page:
                var iframesrc="'.$_SERVER["PHP_SELF"].'?iframe=1"

                //You may change most attributes of iframe tag below, such as width and height:
                document.write(\'<iframe id="datamain" src="\'+iframesrc+\'" width="220px" height="430px" marginwidth="0" marginheight="0" hspace="0" vspace="0" frameborder="0" scrolling="no" allowtransparency="true" background-color="transparent"></iframe>\')

                </script>
				     ';
                
             } else if (!$_GET["iframe"]) {
                // Just echo the output.
                echo $out;
             }
             
             

  if (!$_GET["iframe"]) { echo  ' </div>'; }
  }



// Show recently failed

if (($show_recent) && ($disp_downcount <= 3) && (!$_GET["iframe"])) {

  if ($disp_downcount == 3) {
  	$recent_limit = 1;
  } else if ($disp_downcount == 2) {
  	$recent_limit = 2;
  } else if ($disp_downcount == 1) {
    $recent_limit = 3;
  } else if (!$disp_downcount) {
    $recent_limit = 7;
  }

    echo  ' <div style="border-bottom:1px solid #AD8802;">
           <br><font size="2"><b>Recent Outages:</b></font><br><br>
          ';

      $query = "SELECT description,time,downtime FROM alert_log WHERE downtime>0 ORDER BY lastnotif DESC LIMIT ".$recent_limit."";
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

             echo '<span style="font-size:12px;">&#8226;&nbsp;<span style="font-size:12px;color:#A00000;">'.$trunc_rec_desc.'</span><br>&nbsp;&nbsp;'.$rec_datetime.'<br>
	            &nbsp;&nbsp;DOWNTIME: '.$rec_downtime.'<br><br></span>';

      }

    echo  ' </div>';

}


if (!$_GET["iframe"]) {
  echo '
      </td>
      <td valign="top">
        <table width="100%" height="100%" bgcolor="#000000">
	      <tr>';
}

if (!$percent) {

    $bgcolor = "#FF0000";
    $fontcolor = "#FFFFFF";
    $comment = "FUBAR";
    
} else {

	switch ($percent) {
	    case ($percent == 100):
	    $bgcolor = "#00FF00";
	    $fontcolor = "#000000";
	    $comment = "BLISS";
	    break;
	    case (($percent < 100) && ($percent >= 75)):
	    $bgcolor = "#FFFF00";
	    $fontcolor = "#000000";
	    $comment = "CONCERN";
	    break;
	    case (($percent < 75) && ($percent >= 50)):
	    $bgcolor = "#FF8000";
	    $fontcolor = "#000000";
	    $comment = "PANIC";
	    break;
	    case ($percent <= 49):
	    $bgcolor = "#FF0000";
	    $fontcolor = "#FFFFFF";
	    $comment = "FUBAR";
	    break;   
	} //end switch
	
}

if (!$_GET["iframe"]) {
  echo '
        <td valign="middle" bgcolor='. $bgcolor .'><div align="center">
        <p><span style="font-size:70px;color:'.$fontcolor.';font-weight:bold;">NETWORK:&nbsp;'. $percent .'%</span></p>
		<p><span style="font-size:55px;color:'.$fontcolor.';font-weight:bold;">('. $comment .')</span></p></div>
        </td>
       </tr>
       <tr>
       ';
}



if (($percent != 100) && (!$_GET["iframe"])) {

  echo '
  <td bgcolor="#FF0000" height="50" align="center" valign="top"><br>


<SCRIPT LANGUAGE="JavaScript">

<!-- This script and many more are available free online at -->
<!-- The JavaScript Source!! http://javascript.internet.com -->
<!-- Original:  Bob Simpson (webmaster@maryjanebrown.net) -->
<!-- Web Site:  http://www.maryjanebrown.net/webmaster -->

<!-- Begin
var beforeMsg = "<center><span style=\"font-size:55px;color:#FFFFFF;font-weight:bold;\">";
var afterMsg = "</span></center>";
var msgRotateSpeed = 2000; // Rotate delay in milliseconds
var textStr = new Array();';

$sizeof_down_desc_array = sizeof($down_desc_array);
for ($x=0; $x<$sizeof_down_desc_array; $x++) {
	 echo 'textStr['.$x.'] = "'.$down_desc_array[$x].'";';
}

echo '
if (document.layers) {
document.write(\'<ilayer id="NS4message" bgcolor=#FF0000 height=35 width=100%><layer id="NS4message2" height=25 width=100%></layer></ilayer>\')
temp = \'document.NS4message.document.NS4message2.document.write(beforeMsg + textStr[i++] + afterMsg);\'+\'document.NS4message.document.NS4message2.document.close()\';
}
else if (document.getElementById) {
document.write(beforeMsg + \'<div id="message" style="background-color:#FF0000;position:relative;">IE division</div>\' + afterMsg);
temp = \'document.getElementById("message").firstChild.nodeValue = textStr[i++];\';
}
else if (document.all) {
document.write(beforeMsg + \'<div id="message" style="background-color:#FF0000;position:relative;">IE division</div>\' + afterMsg);
temp = \'message.innerHTML = textStr[i++];\';
}
var i = 0;
function msgRotate() {
eval(temp);
if (i == textStr.length) i = 0;
setTimeout("msgRotate()", msgRotateSpeed);
}
window.onload = msgRotate;
//  End -->
</script>
';



} else if (($percent == 100) && (!$_GET["iframe"])) {

  echo '
  <td bgcolor="#FFFFFF" height="50" align="center" valign="top"><br>
  
        <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#c0c0c0">
         <tr>
          <td height="25" bgcolor="#00FF00" width="25%">
            <div align="center">100%&nbsp;&nbsp;BLISS</div>
          </td>
          <td height="25" bgcolor="#FFFF00" width="25%">
            <div align="center">99-75%&nbsp;&nbsp;CONCERN</div>
          </td>
          <td height="25" bgcolor="#FF8000" width="25%">
            <div align="center">74-50%&nbsp;&nbsp;PANIC</div>
          </td>
          <td height="25" bgcolor="#FF0000" width="25%">
            <div align="center"><font color="#FFFFFF">49-0%&nbsp;&nbsp;FUBAR</font></div>
          </td>
         </tr>
        </table>
	   ';
}


if (!$_GET["iframe"]) {
  echo '
          <br><span style="font-size:10px">Powered&nbsp;by&nbsp;<a style="font-size:10px;color:#000000;" href="http://sourceforge.net/projects/node-runner/" target="_blank">Node&nbsp;Runner&nbsp;v'.$nr_ver.'</a>&nbsp;Open&nbsp;Source&nbsp;Network&nbsp;Monitor.&nbsp;&nbsp;This&nbsp;page&nbsp;will&nbsp;refresh&nbsp;every&nbsp;'. $dash_refrate .'&nbsp;seconds.</span>
        </td>
       </tr>
       </table>
       </td>
     </tr>
   </table>
   </body>
   </html>';
}

?>

