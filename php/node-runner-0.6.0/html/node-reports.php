<?
require_once("connect.php");
if ($_SESSION["isloggedin"] != $glbl_hash) {
	header("Location: ".$nr_url."login.php?referrer=node-reports.php");
	exit;
}

$title = "Node Reports";
require_once("header.php");



function dropdown($name,$num,$selected) {
    //populates html drop down boxes
    echo '<select name="'. $name .'">';
    echo '<option value="';
    printf("%02.0f", $selected);
    echo '" selected>';
    printf("%02.0f", $selected);
    echo '</option>';
    for ($i=0;$i<$num;$i++) {
      echo '<option value="';
      printf("%02.0f", $i);
      echo '">';
      printf("%02.0f", $i);
      echo '</option>';
    }
    echo '</select>';
}

function form() {
GLOBAL $PHP_SELF;

echo '
<table class="nodereports" width="780" border="0" cellspacing="0" cellpadding="5" align="center">
<form name="nodereports" action="'.$_SERVER['PHP_SELF'].'?nohead=1" method="POST" target="FormResults">
  <tr valign="middle">
    <td class="nodereports" width="50%" height="50" bgcolor="#efefef"><font size="2">
     <input type="radio" name="select_nodes" value="individual" checked>&nbsp;SELECT ONE OR MORE NODES:<br>
      <select name="node[]" size="5" multiple>
      ';
   $query1="SELECT id,description FROM objects WHERE description!='NODE RUNNER' ORDER BY description ASC";
   $result1=db_query($query1);
   $i=0;
    while ($r=db_fetch_array($result1)) {
       $id=$r["id"];
       $description=$r["description"];
       if ($i == 0) {
         echo '<option value='. $id .' selected>'. $description .'</option>';
	   } else {
         echo '<option value='. $id .'>'. $description .'</option>';
       }
       $i++;
    }
echo '
      </select>
      <br>(Hold <i>Ctrl</i> or <i>Shift</i> for multiple selections.)<br><br>
      </font></td>
     <td class="nodereports" width="50%" valign="top" bgcolor="#efefef"><font size="2">
     <input type="radio" name="select_nodes" value="all_servers">&nbsp;SELECT ALL ENDPOINTS<br>
     <input type="radio" name="select_nodes" value="all_non_servers">&nbsp;SELECT ALL NON-ENDPOINTS<br>
     <input type="checkbox" value="only_enabled" name="only_enabled">Exclude disabled nodes<br><br>
     NOTE: Using a CSS2-compatible browser, each entry will print on a separate page
     if multiple entries are selected.<br>
     </font></td>
  </tr>';

$tmp_end_yy = date("y", mktime());
$tmp_end_mm = date("m", mktime());

if ($tmp_end_mm == 1) {
  $tmp_st_mm = 12;
} else {
  $tmp_st_mm = $tmp_end_mm - 1;
}

$tmp_end_dd = date("d", mktime());
$tmp_max_days = date("t", mktime(0,0,0,$tmp_st_mm,1,$tmp_yy));

if ($tmp_end_dd > $tmp_max_days) {
  $tmp_st_dd = $tmp_max_days;
} else {
  $tmp_st_dd = $tmp_end_dd;
}

if ($tmp_st_mm == 12) {
  $tmp_st_yy = $tmp_end_yy - 1;
} else {
  $tmp_st_yy = $tmp_end_yy;
}


echo '
  <tr valign="top">
    <td height="130" class="nodereports" bgcolor="#efefef">
    <br><b>Report Start Date:</b>&nbsp;&nbsp;
    <input type="text" name="smonth" size="2" value="'.sprintf("%02d", $tmp_st_mm).'" maxlength="2">/
    <input type="text" name="sday" size="2" value="'.sprintf("%02d", $tmp_st_dd).'" maxlength="2">/
    <input type="text" name="syear" size="3" value="'.sprintf("%02d", $tmp_st_yy).'" maxlength="2">
    (MM / DD / YY)<br><br>
    HOUR:&nbsp;';

dropdown("shour","24","0");

echo '&nbsp;&nbsp;&nbsp;MINUTE:&nbsp;';

dropdown("sminute","60","0");

echo '&nbsp;&nbsp;&nbsp;SECOND:&nbsp;';

dropdown("ssecond","60","0");

echo '
    </td>
    <td height="130" class="nodereports" bgcolor="#efefef">
    <br><b>Report End Date:</b>&nbsp&nbsp;&nbsp;
    <input type="text" name="emonth" size="2" value="'.sprintf("%02d", $tmp_end_mm).'" maxlength="2">/
    <input type="text" name="eday" size="2" value="'.sprintf("%02d", $tmp_end_dd).'" maxlength="2">/
    <input type="text" name="eyear" size="3" value="'.sprintf("%02d", $tmp_end_yy).'" maxlength="2">
    (MM / DD / YY)<br><br>
    HOUR:&nbsp;
     ';
     
dropdown("ehour","24","23");

echo '&nbsp;&nbsp;&nbsp;MINUTE:&nbsp;';

dropdown("eminute","60","59");

echo '&nbsp;&nbsp;&nbsp;SECOND:&nbsp;';

dropdown("esecond","60","59");

echo '

    </td>
  </tr>
  <tr>
    <td class="nodereports" bgcolor="#dbdbdb" colspan="2"><font size="2">
    <span style="border-bottom:1px solid #00009E;font-weight:bold;color:#00009E;">Optional Parameters:</span><font size="1"><br><br></font>
    <input type="checkbox" value="op_OnlySum" name="op_OnlySum" onclick="javascript:disableFields();">&nbsp;
    Only summarize the total uptime percentage for all selected nodes.<hr>
    Weekdays to Report <i>(reports only the following days selected)</i>:<br><br>
    <input type="checkbox" value="op_Sun" name="op_Sun">SUN
    &nbsp;&nbsp;<input type="checkbox" value="op_Mon" name="op_Mon">MON
    &nbsp;&nbsp;<input type="checkbox" value="op_Tue" name="op_Tue">TUE
    &nbsp;&nbsp;<input type="checkbox" value="op_Wed" name="op_Wed">WED
    &nbsp;&nbsp;<input type="checkbox" value="op_Thu" name="op_Thu">THU
    &nbsp;&nbsp;<input type="checkbox" value="op_Fri" name="op_Fri">FRI
    &nbsp;&nbsp;<input type="checkbox" value="op_Sat" name="op_Sat">SAT
    <hr>Responsibility Timeframe:<br><i>(ex. Your holiday bonus depends on uptime from 7am to 5pm.)</i><br><br>
    <b>Start Time:</b>&nbsp;&nbsp;HOUR:&nbsp;';

dropdown("op_shour","24","0");

echo '&nbsp;&nbsp;MINUTE:&nbsp;';

dropdown("op_sminute","60","0");

echo '&nbsp;&nbsp;SECOND:&nbsp;';

dropdown("op_ssecond","60","0");

echo '<br><br><b>End Time:</b>&nbsp;&nbsp;&nbsp;HOUR:&nbsp;';

dropdown("op_ehour","24","23");

echo '&nbsp;&nbsp;MINUTE:&nbsp;';

dropdown("op_eminute","60","59");

echo '&nbsp;&nbsp;SECOND:&nbsp;';

dropdown("op_esecond","60","59");

echo '
  </font><br>&nbsp;</td>
  </tr>
  <tr>
    <td class="nodereports" bgcolor="#dbdbdb" colspan="2"><font size="2">
    <span style="border-bottom:1px solid #00009E;font-weight:bold;color:#00009E;">Downtime Logs:</span><font size="1"><br><br></font>
    <input type="checkbox" value="op_OnlyLog" name="op_OnlyLog" onclick="javascript:disableFields();">&nbsp;
    Display outages for each node during the selected reporting period.
	<br>&nbsp;
    </td>
  </tr>
  <tr valign="middle">
    <td bgcolor="#AD8802" class="nodereports" colspan="2" height="50"> <font size="2" color="#FFFFFF">
	  <input type="hidden" name="doit" value="1">
      &nbsp&nbsp<input type="button" value="  Generate Report  " onClick="javascript:verify();">&nbsp;&nbsp;<b>NOTE: Report will open in new window to preserve report settings.</b>
      </font></td>
  </tr>
</form>
</table>
      ';
} # end fuction form

function summarize($pass_number,$description_x,$tot_u_rate,$now,$sdate,$edate,$num_days,$end_of_passes) {
  GLOBAL $nr_ver;
  if ($pass_number == 0) {
    echo '
    <table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
      <tr>
		<td height="40">&nbsp;</td>
      </tr>
      <tr align="center">
        <td bgcolor="#A00000">
          <a href="http://sourceforge.net/projects/node-runner/" target="external"><img src="images/nr_title.gif" width="364" height="45" border="0"></a>
        </td>
      </tr>
    </table>
    <table width="640" border="1" cellspacing="0" cellpadding="0" align="center">
      <tr>
        <td bgcolor="#CCCCCC" width="640" colspan="2" align="center" height="40">
          <span style="font-size:11px">This report, generated on '. $now .', describes the uptime percentile for each selected node from<br>'. $sdate .' to '. $edate .' (approx. '. $num_days .' days).</span>
        </td>
      </tr>
      <tr>';
  }

  echo '
    <tr>
      <td width="540" align="left"><font>&nbsp;'. $description_x .'</font>
      </td>
      <td width="100" align="left"><font>&nbsp;'. round($tot_u_rate, 5) .' %</font>
      </td>
    </tr>';

  if ($end_of_passes == 1) {
    echo '
    </table><br>    
    <table width="640" border="0" cellspacing="0" cellpadding="2" align="center">
      <tr align="center">
        <td align="center" width="480"><span style="font-size:11px">Generated
          by <a style="text-decoration:none" href="http://sourceforge.net/projects/node-runner/" target="_blank">Node Runner (v'.$nr_ver.')</a> open source
          network monitoring software.<br>This software is made freely available under the <a style="text-decoration:none" href="http://www.gnu.org/copyleft/gpl.html" target="_blank">GNU GPL</a> license.</span></td>
        <td valign="middle" align="left" width="160"><a href="#" onClick="window.print();return false"><img src="images/print.gif" alt="PRINT REPORT" border="0" width="15" height="11"></a>
        <font size="2"><a href="#" onClick="window.print();return false">PRINT REPORT</a></font></td>
      </tr>
    </table>
         ';
  }
} #end function summarize

function report($description_x,
                $ipaddress_x,
                $port_x,
                $sdate,
                $edate,
                $num_days,
                $now,
                $tot_d_time,
                $min_d_time,
                $max_d_time,
                $avg_d_time,
                $tot_u_time,
                $tot_u_rate,
                $min_u_time,
                $max_u_time,
                $avg_u_time,
                $smon_time,
                $emon_time,
                $op_stime_x,
                $op_etime_x,
                $url,
                $daysofweek,
                $op_daysofweek) {
GLOBAL $nr_ver;
echo '
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr align="center">
    <td>
      <p>&nbsp;</p><p><span style="font-weight:bold;font-size:20px;color:#A00000">Network&nbsp;Report: <span style="color:#00009E">'. $description_x .'</span></span></p><br>
    </td>
  </tr>
</table>
<table border="1" cellspacing="0" cellpadding="2" align="center" width="660">
  <tr>
    <td width="340"><font size="2">Date &amp; Time
      This Report was Generated</font></td>
    <td width="320"><font size="2">'. $now .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Node Description</font></td>
    <td width="320"><font size="2">'. $description_x .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">IP Address</font></td>
    <td width="320"><font size="2">'. $ipaddress_x .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Port Queried</font></td>
    <td width="320"><font size="2">'. $port_x .'</font></td>
  </tr>
  ';
  
if ($url) {
  echo '
  <tr>
    <td colspan=2><font size="2">[URL Queried]&nbsp;&nbsp;
    <a href="http://'. $ipaddress_x .'/'. $url .'" target="external">http://'. $ipaddress_x .'/'. $url .'</a></font></td>
  </tr>
       ';
}
  
echo '
  <tr>
    <td width="340"><font size="2">Timeframe for Report</font></td>
    <td width="320"><font size="2">'. $sdate .' to '. $edate .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Monitor Schedule for Node</font></td>
    <td width="320"><font size="2">'. $smon_time .' to '. $emon_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Schedule Included in Report</font></td>
    <td width="320"><font size="2">'. $op_stime_x .' to '. $op_etime_x .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Days to Monitor Node</font></td>
    <td width="320"><font size="2">'. $daysofweek .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Days Included in Report</font></td>
    <td width="320"><font size="2">'. $op_daysofweek .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Length of Reporting
      Period</font></td>
    <td width="320"><font size="2">Approx. '. $num_days .' Day(s)</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Total Downtime for
      Reporting Period</font></td>
    <td width="320"><font size="2">'. $tot_d_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Minimum Downtime Duration</font></td>
    <td width="320"><font size="2">'. $min_d_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Maximum Downtime Duration</font></td>
    <td width="320"><font size="2">'. $max_d_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Average Downtime Duration</font></td>
    <td width="320"><font size="2">'. $avg_d_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Total Uptime for Reporting Period</font></td>
    <td width="320"><font size="2">'. $tot_u_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Total Uptime (Percentage)</font></td>
    <td width="320"><font size="2">'. $tot_u_rate .'%</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Minimum Uptime Duration</font></td>
    <td width="320"><font size="2">'. $min_u_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Maximum Uptime Duration</font></td>
    <td width="320"><font size="2">'. $max_u_time .'</font></td>
  </tr>
  <tr>
    <td width="340"><font size="2">Average Uptime Duration</font></td>
    <td width="320"><font size="2">'. $avg_u_time .'</font></td>
  </tr>
</table>
<br>
<table width="640" border="0" cellspacing="0" cellpadding="2" align="center">
  <tr align="center">
    <td align="center" width="480"><span style="font-size:11px">Generated
      by <a style="text-decoration:none" href="http://sourceforge.net/projects/node-runner/" target="_blank">Node Runner (v'.$nr_ver.')</a> open source
      network monitoring software.<br>This software is made freely available under the <a style="text-decoration:none" href="http://www.gnu.org/copyleft/gpl.html" target="_blank">GNU GPL</a> license.</span></td>
    <td valign="middle" align="left" width="160"><a href="#" onClick="window.print();return false"><img src="images/print.gif" alt="PRINT REPORT" border="0" width="15" height="11"></a>
    <font size="2"><a href="#" onClick="window.print();return false">PRINT REPORT</a></font></td>
  </tr>
</table>
<p class="break">&nbsp;</p>';


} # end function report


function downlogs($datetime_array,$downtime_array,$description) {
  GLOBAL $nr_ver;

  $sizeof_datetime_array = sizeof($datetime_array);
  
  echo '
  <table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr align="center">
      <td>
        <p>&nbsp;</p><p><span style="font-weight:bold;font-size:20px;color:#A00000">Outage&nbsp;Report: <span style="color:#00009E">'. $description .'</span></span></p><br>
      </td>
    </tr>
  </table>
  <table border="1" cellspacing="0" cellpadding="2" align="center" width="660">';

  for ($x=0; $x<$sizeof_datetime_array; $x++) {
    $downtime = format($downtime_array[$x]);
    echo '
      <tr>
        <td width="340"><font size="2">'.date("l, M j, Y g:i a", $datetime_array[$x]).'</font></td>
        <td width="320"><font size="2">'.$downtime.'</font></td>
      </tr>
         ';
	unset($downtime);
  }

  echo '
  </table>
  <br>
  <table width="640" border="0" cellspacing="0" cellpadding="2" align="center">
    <tr align="center">
      <td align="center" width="480"><span style="font-size:11px">Generated
        by <a style="text-decoration:none" href="http://sourceforge.net/projects/node-runner/" target="external">Node Runner (v'.$nr_ver.')</a> open source
        network monitoring software.<br>This software is made freely available under the <a style="text-decoration:none" href="http://www.gnu.org/copyleft/gpl.html">GNU GPL</a> license.</span></td>
      <td valign="middle" align="left" width="160"><a href="#" onClick="window.print();return false"><img src="images/print.gif" alt="PRINT REPORT" border="0" width="15" height="11"></a>
      <font size="2"><a href="#" onClick="window.print();return false">PRINT REPORT</a></font></td>
    </tr>
  </table>
  <p class="break">&nbsp;</p>';

} # end function downlogs



function format($var) {
  if ($var < 60) {
  $var=(int)$var;
  $output="$var Second(s)";
  return $output;
  } elseif (($var >= 60) && ($var < 3600)) {
  $minutes=(int)($var / 60);
  $seconds=($var % 60);
  $output="$minutes Minute(s) $seconds Second(s)";
  return $output;
  } elseif (($var >= 3600) && ($var < 86400)) {
  $hours=(int)($var / 3600);
  $remainder=($var % 3600);
  $minutes=(int)($remainder / 60);
  $seconds=($remainder % 60);
  $output="$hours Hour(s) $minutes Minute(s) $seconds Second(s)";
  return $output;
  } else {
  $days=(int)($var / 86400);
  $remainder=($var % 86400); //remainder of days
  $hours=(int)($remainder / 3600);
  $remainder=($remainder % 3600); //remainder of hours
  $minutes=(int)($remainder / 60);
  $seconds=($remainder % 60); //remainder of seconds
  $output="$days Day(s) $hours Hour(s) $minutes Minute(s) $seconds Second(s)";
  return $output;
  }
}


if ($_POST['doit'] == 1) {

$stime = mktime($_POST['shour'],$_POST['sminute'],$_POST['ssecond'],$_POST['smonth'],$_POST['sday'],$_POST['syear']); //unix start time
$etime = mktime($_POST['ehour'],$_POST['eminute'],$_POST['esecond'],$_POST['emonth'],$_POST['eday'],$_POST['eyear']); //unix end time

##### Option for printing all servers or all non-servers #######
if ($_POST['select_nodes'] == "all_servers") {
   if ($_POST['only_enabled']) {
     $query5="SELECT id FROM objects WHERE server='Y' AND description!='NODE RUNNER' AND enabled='Y' ORDER BY description ASC";
   } else {
     $query5="SELECT id FROM objects WHERE server='Y' AND description!='NODE RUNNER' ORDER BY description ASC";
   }
   $result5=db_query($query5);
   $m = 0;
   while ($r=db_fetch_array($result5)) {
       $node[$m]=$r[0];
       $m++;
   } #end while
} else if ($_POST['select_nodes'] == "all_non_servers") {
   if ($_POST['only_enabled']) {
     $query5="SELECT id FROM objects WHERE server='N' AND description!='NODE RUNNER' AND enabled='Y' ORDER BY description ASC";
   } else {
     $query5="SELECT id FROM objects WHERE server='N' AND description!='NODE RUNNER' ORDER BY description ASC";
   }
   $result5=db_query($query5);
   $m = 0;
   while ($r=db_fetch_array($result5)) {
       $node[$m]=$r[0];
       $m++;
   } #end while
} else if ($_POST['select_nodes'] == "individual") {
    $node = $_POST['node'];
}
################################################################

$last_record = sizeof($node) - 1;
for($n=0; $n<sizeof($node); $n++) {
$tot_d_time = $min_d_time = $max_d_time = $avg_d_time = 0; //error trapping

$op_daysofweek = "";
if ($_POST['op_Sun'])
  $op_daysofweek.="Sun ";
if ($_POST['op_Mon'])
  $op_daysofweek.="Mon ";
if ($_POST['op_Tue'])
  $op_daysofweek.="Tue ";
if ($_POST['op_Wed'])
  $op_daysofweek.="Wed ";
if ($_POST['op_Thu'])
  $op_daysofweek.="Thu ";
if ($_POST['op_Fri'])
  $op_daysofweek.="Fri ";
if ($_POST['op_Sat'])
  $op_daysofweek.="Sat";

$op_stime = (int)"".$_POST['op_shour']."".$_POST['op_sminute']."".$_POST['op_ssecond']."";
$op_etime = (int)"".$_POST['op_ehour']."".$_POST['op_eminute']."".$_POST['op_esecond']."";

$num_days = ((int)round(($etime - $stime) / 86400)); //number of days
$sdate = date("D M d, Y", $stime); //start date
$edate = date("D M d, Y", $etime); //end date
$now=date("D M d, Y g:ia T", mktime()); //current time

   $query3="SELECT * FROM objects WHERE id='$node[$n]'";
   $result3=db_query($query3);
   $num_rows3=db_num_rows($result3);
    while ($r=db_fetch_array($result3)) {
       $id_x=$r["id"];
       $description_x=$r["description"];
       $ipaddress_x=$r["ipaddress"];
       $port_x=$r["port"];
       $query_type=$r["query_type"];
       $snmp_comm=$r["snmp_comm"];
       if (($query_type != 'SNMP') && ($query_type != 'ICMP')) {
         $query_type = $query_type.'&nbsp;Port:&nbsp;'. $port_x;
       } else if ($query_type == 'SNMP') {
         $query_type = $query_type.'&nbsp;(Community:&nbsp;'.$snmp_comm.')';
       }
       $smon_time_x=$r["smon_time"];
       $emon_time_x=$r["emon_time"];
       $url=$r["url"];
       
       $days=$r["days"];

        if(strstr($days,"Sun"))
            $daysofweek.="SUN ";
        if(strstr($days,"Mon"))
            $daysofweek.="MON ";
        if(strstr($days,"Tue"))
            $daysofweek.="TUE ";
        if(strstr($days,"Wed"))
            $daysofweek.="WED ";
        if(strstr($days,"Thu"))
            $daysofweek.="THU ";
        if(strstr($days,"Fri"))
            $daysofweek.="FRI ";
        if(strstr($days,"Sat"))
            $daysofweek.="SAT";
        if(!$daysofweek)
            $daysofweek = "NONE";

       $smon_time_x = sprintf("%04s",$smon_time_x);
       $emon_time_x = sprintf("%04s",$emon_time_x);
       $smin=substr($smon_time_x, -2);
       $shour=substr($smon_time_x, -4, 2);
       if ($shour == "0") { $shour = "12"; }
       $emin=substr($emon_time_x, -2);
       $ehour=substr($emon_time_x, -4, 2);
       if ($ehour == "0") { $ehour = "12"; }
       if ((int)$shour > 12) {
           $shour=(int)$shour - 12;
           $smon_time="$shour:".$smin."pm";
       } else {
           $shour=(int)$shour;
           $smon_time="$shour:".$smin."am";
       }
       if ((int)$ehour > 12) {
           $ehour=(int)$ehour - 12;
           $emon_time="$ehour:".$emin."pm";
       } else {
           $ehour=(int)$ehour;
           $emon_time="$ehour:".$emin."am";
       }
       if ((int)$_POST['op_shour'] > 12) {
           $op_shour_tmp=(int)$_POST['op_shour'] - 12;
           $op_stime_x="$op_shour_tmp:".$_POST['op_sminute']."pm";
       } else if ((int)$_POST['op_shour'] == 0) {
           $op_stime_x="12:".$_POST['op_sminute']."am";
       } else {
           $op_shour_tmp=(int)$_POST['op_shour'];
           $op_stime_x="$op_shour_tmp:".$_POST['op_sminute']."am";
       }
       if ((int)$_POST['op_ehour'] > 12) {
           $op_ehour_tmp=(int)$_POST['op_ehour'] - 12;
           $op_etime_x="$op_ehour_tmp:".$_POST['op_eminute']."pm";
       } else {
           $op_ehour_tmp=(int)$_POST['op_ehour'];
           $op_etime_x="$op_ehour_tmp:".$_POST['op_eminute']."am";
       }

        $query4="SELECT time,downtime FROM alert_log WHERE description='$description_x' AND downtime>0";
        $result4=db_query($query4);
        $i=0;
        $downlog_array_datetime = array();
        $downlog_array_downtime = array();
         while ($r=db_fetch_array($result4)) {
             $time_y=(int)$r["time"];
             $downtime_y=$r["downtime"];
	         if(($time_y>$stime) && ($time_y<$etime)) {
               $rep_time=(int)date("His", $time_y);
               if ($op_daysofweek) { // if 'days' options were set
                 if (strstr($op_daysofweek,date("D", $time_y))) {
                   if (($op_stime < $rep_time) && ($op_etime > $rep_time)) {
                   //optional responsibility time is always checked
                     $utime_tmp[$i] = $time_y;
                     $dtime[$i] = $downtime_y;
                     $tot_d_time += $downtime_y;
                     array_push($downlog_array_datetime, $time_y);
			         array_push($downlog_array_downtime, $downtime_y);
                     $i++;
                   }
                 }
               } else { // assume optional 'days' parameters were not used
                 if (($op_stime < $rep_time) && ($op_etime > $rep_time)) {
                   $utime_tmp[$i] = $time_y;
                   $dtime[$i] = $downtime_y;
                   $tot_d_time += $downtime_y;
                   array_push($downlog_array_datetime, $time_y);
			       array_push($downlog_array_downtime, $downtime_y);
                   $i++;
                 }
               }
	         } #if time_y greater than stime but less than etime
         }
         


         if ($dtime > 0) {
         $min_d_time = min($dtime);
         $max_d_time = max($dtime);
         }
         if ($tot_d_time > 0) {
         $avg_d_time = $tot_d_time / $i;
         }
         $tot_u_time = ($etime - $stime) - $tot_d_time;
         $tot_u_rate = ($tot_u_time / ($etime - $stime)) * 100;
         $tot_d_time = format($tot_d_time);
         $tot_u_time = format($tot_u_time);
         if ($tot_u_rate < 100) {
            $min_d_time = format($min_d_time);
            $max_d_time = format($max_d_time);
            $avg_d_time = format($avg_d_time);
         } else {
            $min_d_time = $max_d_time = $avg_d_time = "N/A";
         }

         //requires PHP4 for array_push
         if (sizeof($utime_tmp) < 1) {
             $utime_tmp = array($stime, $etime);
         } else {
             array_push($utime_tmp, $stime);
             array_push($utime_tmp, $etime);
         }
         rsort($utime_tmp);
         for ($x=0; $x<(sizeof($utime_tmp)-1); $x++) {
         $utime[$x] = ($utime_tmp[$x] - $utime_tmp[$x+1]);
         $utime_increment += $utime[$x];
         }
         $avg_u_time = $utime_increment / (sizeof($utime_tmp)-1);
         $min_u_time = min($utime);
         $max_u_time = max($utime);
         if ($tot_u_rate < 100) {
            $avg_u_time = format($avg_u_time);
            $min_u_time = format($min_u_time);
            $max_u_time = format($max_u_time);
         } else {
            $avg_u_time = $min_u_time = $max_u_time = "N/A";
         }
         if ($op_daysofweek) {
           $op_daysofweek = strtoupper($op_daysofweek);
         } else {
           $op_daysofweek = $daysofweek;
         }

         // Used (for page breaks) to determine if end of records
         if ($n == $last_record) {
             $no_more = 1;
         } else {
             $no_more = 0;
         }
         
	 if ($_POST['op_OnlySum']) {
	   summarize($n,$description_x,$tot_u_rate,$now,$sdate,$edate,$num_days,$no_more);
	 } else {
	   report($description_x,
                  $ipaddress_x,
                  $query_type,
                  $sdate,
                  $edate,
                  $num_days,
                  $now,
                  $tot_d_time,
                  $min_d_time,
                  $max_d_time,
                  $avg_d_time,
                  $tot_u_time,
                  $tot_u_rate,
                  $min_u_time,
                  $max_u_time,
                  $avg_u_time,
                  $smon_time,
                  $emon_time,
                  $op_stime_x,
                  $op_etime_x,
                  $url,
                  $daysofweek,
                  $op_daysofweek);
	   if (($_POST['op_OnlyLog']) && (!empty($downlog_array_datetime))) {
	     downlogs($downlog_array_datetime,$downlog_array_downtime,$description_x);
	     unset($downlog_array_datetime,$downlog_array_downtime);
	   }
	 }

   } # first while
unset($smon_time_x,
      $emon_time_x,
      $smon_time,
      $emon_time,
      $op_stime_x,
      $op_etime_x,
      $utime_tmp,
      $dtime,
      $tot_d_time,
      $min_d_time,
      $max_d_time,
      $avg_d_time,
      $tot_u_time,
      $tot_u_rate,
      $utime_increment,
      $avg_u_time,
      $min_u_time,
      $max_u_time,
      $op_daysofweek,
      $daysofweek);
} # end for


} else {
form();
}

require_once("footer.php");

?>
