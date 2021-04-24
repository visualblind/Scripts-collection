<?php
require_once("connect.php");

// This file contains help topics to be supplied to the help popup windows
// throughout the web interface system.

unset($topic);
if ($_GET["topic"]) {
  $topic = strip_tags(rtrim(ltrim($_GET["topic"])));
  echo '<div style="background-color:#efefef;border-style:solid;border-color:#A00000;border-width:1px;">
        <div style="margin-left:5px;margin-right:5px;margin-top:5px;margin-bottom:5px;">';
}

function list_deps($parent) {
        GLOBAL $cnt;
        // Recursive function to count dependencies
        $sql = "SELECT id,description,ipaddress,port,query_type FROM objects WHERE dependency='$parent'";
        $result = db_query($sql);
        echo "<ul>";
        while ($r = db_fetch_array($result)) {
               $description = $r["description"];
               $ipaddress = $r["ipaddress"];
               $port = $r["port"];
               $query_type = $r["query_type"];
			   echo '<li><span style="font-size:12px;color:#A00000;">'. $description .'</span><span style="font-size:12px;">&nbsp;&nbsp;('. $ipaddress .'&nbsp;-&nbsp;';
			   if (($query_type == 'SNMP') || ($query_type == 'ICMP')) {
			     echo $query_type .')</span></li>';
			   } else {
			     echo $query_type.'&nbsp;Port:&nbsp;'. $port.')</span></li>';
			   }
               list_deps($r["id"]);
        }
        echo "</ul>";
}



## Begin help topics

if ($topic) {
  switch ($topic) {
	case "description":
	echo 'This is simply the name you wish to specify for the node.';
	break;
	case "dependency":
	echo 'Think of this as the parent node that the node you\'re inserting is dependent upon for connectivity.  If the parent address is unreachable, it will check the parent\'s dependency recursively until it isolates the problem.  If node has no dependency, meaning it\'s a top level node, just choose \'NODE RUNNER\' as the dependency.<br><br>NOTE: Disabled nodes will <b>not</b> appear in this list.';
	break;
	case 'ohplease':
	echo 'If you need help on this one, you probably shouldn\'t be configuring nodes.';
	break;
	case 'ptime':
	echo 'Timeout period for querying nodes. It is recommended that you keep this low, like 5-10 seconds.';
	break;
	case 'port':
	echo 'Port to query on node. (Ex. Web Servers: 80, Telnet Servers: 23, FTP Servers: 21, etc.).';
	break;
	case 'query_type':
	echo 'Connection type to use for querying node.  This should be self explanatory.';
	break;
	case 'snmp_comm':
	echo 'Community string for SNMP queries.';
	break;
	case 'url':
	echo 'URL to query on HTTP servers. This only applies to HTTP servers, otherwise, it should be left blank. <i>Leave off hostname and beginning slash, just include the path.</i>. (ex. somedir/testpage.html)';
	break;
	case 'auth_user':
	echo 'Username for HTTP authentication on secured URLs (think .htaccess).';
	break;
	case 'auth_pass':
	echo 'Password for HTTP authentication on secured URLs (think .htaccess).  WARNING: This field is stored in clear text.';
	break;
	case 'which_days':
	echo 'Which days of the week do you wish to monitor this node?';
	break;
	case 'timeframe':
	echo 'During which hours of the day do you wish to monitor this node? (24-hour format)';
	break;
	case 'comments':
	echo 'Optional comments field.  Use for instructions, explanations, etc.';
	break;
	case 'endpoint':
	echo 'Is this node an endpoint in the network chain?  Endpoints (similarly referred to as servers) are queried constantly with every polling cycle.  Non-endpoints are only polled when an endpoint cannot be reached.  See documentation for more information.';
	break;
	case 'enabled':
	echo 'Nodes should be enabled by default, and disabled during planned maintenance.  Unless this node is not up yet, this box should be checked.<br><br>If this option is grayed out, there are dependant nodes that <b>must</b> be disabled prior to disabling this node.';
	break;
	case 'mail_group':
	echo 'Email recipients that will be notified when node is unreachable.  Every node will be assigned its own mail group.  See documentation for more information.';
	break;
	case 'admin_priv':
	echo 'Granting administrative privileges means that the user will have complete control over the Node Runner web interface.  If the user only needs to run reports or check information (read-only), leave this box unchecked.';
	break;
	case 'mail_group_syntax':
	echo 'For groups of email addresses, use a comma delimited list with no spaces.  Adding spaces or other types of delimiters will result in lost status notifications.';
	break;
	case 'status_mon_dir_affect';
	$iid = strip_tags(rtrim(ltrim($_GET["iid"])));
    $query_deps = "SELECT description FROM objects WHERE dependency='$iid'";
    $result_deps = db_query($query_deps);
    echo '<b>Nodes Directly Affected:</b><br><ul>';
    while ($s = db_fetch_array($result_deps)) {
           $desc = $s["description"];
           if (($truncate_at > 0) && (strlen($desc) > ($truncate_at + 3))) {
                $trunc_desc = substr($desc,0,$truncate_at)."...";
           } else {
                $trunc_desc = $desc;
           }
           echo '<li><span style="font-size:12px;color:#A00000;">'. $trunc_desc .'</span></li>';
    }
    echo '</ul>';
	unset($iid,$query_deps,$result_deps,$desc,$trunc_desc);
	break;
	case 'status_mon_total_affect';
	$iid = strip_tags(rtrim(ltrim($_GET["iid"])));
	echo '<b>Total Nodes Affected:</b><br>';
	$output = list_deps($iid);
	unset($iid,$output);
	break;
  }
  
  echo '</div></div>';
} // end if $topic


if ($_GET["contents"] == 1) {

  $title = "Help Contents";
  require_once("header.php");
  
  unset($tid,$tid_text);
  if ($_GET["tid"]) {
    $tid = strip_tags(rtrim(ltrim($_GET["tid"])));
  } else {
    $tid = 'sysdoc_overview';
  }
  
  switch ($tid) {
	case 'sysdoc_overview':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Overview</span><font size="1"><br><br></font>Node Runner is a PHP-based network monitor designed to contact nodes in a hierarchial fashion based on the configuration of the node. If a node does not respond, dependencies (parents) of that node are systematically checked until the problem is isolated.<br><br>Node Runner uses a shell script for its basic network polling, a PHP web interface for node information, reports, etc., and and abstraction layers for multi-platform database support.<br><br>Why bother?  Well, most network monitor packages available on the market today are commercially distributed and Windows-based.  Of the open source network monitors I\'ve seen, few seem to have the capability to query dependant nodes if a primary node is unreachable, and those that do include this functionality are difficult to set up or maintain.  Node Runner strives to exceed both of these goals and more.';
	break;
	case 'sysdoc_sysreqs':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">System Requirements</span><font size="1"><br><br></font>1. PHP 4.3+ (compiled w/ cgi, socket and SNMP support highly recommended)<br>2. MySQL 3.x<br>3. Available Web server with PHP support (does not need to be local machine)<br><br>NOTE 1: If you do not compile PHP with cgi, socket, and SNMP support, you will likely see errors if you attempt to query nodes of these types.  Node Runner has <b>NOT</b> been designed to check for proper compilation of these features before it attempts to poll a node.  Therefore, based on the operating system, it may generate errors or simply fail if you do not have these features compiled properly.  To check for proper compilation, you will need to create a script that outputs the configuration of php using the <a href="http://www.php.net/manual/en/function.phpinfo.php" target="_blank">phpinfo()</a> function.  <br><br>That script could be as simple as the following code:<br><br><code>&lt;&#63;php<br>phpinfo();<br>&#63;&gt;</code><br><br>Save it as any filename you like, and upload it to your web documents root.  When you pull it up in the browser, you should see sections for socket, SNMP, etc.<br><br>NOTE 2: Due to the nature of the query script (node.start), it is recommended that you adjust the error reporting levels of PHP to prevent warnings.  The decision is completely up to you, but if you don\'t, you will likely see a number of WARNING messages in your debugging output if nodes fail to respond to network queries.  To adjust the error reporting level, modify the error_reporting line in your php.ini file to the following:<br><br><b>error_reporting  =  E_ALL & ~E_NOTICE & ~E_WARNING</b>';
	break;
	case 'sysdoc_mod_queries':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Modular Network Queries</span><font size="1"><br><br></font>As of version 0.6.0, network queries have been extracted from the node.start script and moved to the \'include\' directory.  The scripts you will find in that directory each serve their own purpose, such as polling SNMP or ICMP.  There is a template file for creating your own query scripts in the \'contribs\' directory, but you should have a good understanding of sockets before attempting to write your own custom queries.';
	break;
	case 'sysdoc_cron_scheduling':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Considerations for Cron Scheduling</span><font size="1"><br><br></font>My primary development environment for Node Runner is configured to run the \'node.start\' script every three minutes, but you can use your own judgement, bearing in mind that more servers take more time to poll, so don\'t set your cron jobs too close together.<br><br>(My production setup uses about 150 servers, and takes less than 3 minutes to execute even with multiple failing nodes.)  Your <span style="color:#A00000">$max_attempts</span> variable (nr.inc) is an important factor to consider also.  Put some thought into your configuration, and check your total execution time using the <span style="color:#A00000">$debug</span> option if you think your cron jobs are bleeding into one another.';
	break;
	case 'sysdoc_debugging':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Debugging Node Runner\'s Output</span><font size="1"><br><br></font>Beginning in version 0.4.4, I\'ve added a level of debugging that can be used when troubleshooting the node.start script.  Set the <span style="color:#A00000">$debug</span> variable to 1 in the \'nr.inc\' file, and change your cron to output to a file.<br><br>You also have the option of running the node.start script manually, (which will give you screen output), but because of the anal nature of my timing functions within the script, I would not recommend it.<br><br>The output should give you a status of each server.  If a server does not respond, it will display the status of its dependency (parent), and so on.  Execution time is also summarized at the end of each cycle.<br><br>In the early stages of development, while getting a feel for my own network, I enabled the debugging option and added one more cron job to delete the text file (created by the output) at the end of each day.  This way, if I get a strange alert, I\'d be able to track it down.';
	break;
	case 'sysdoc_endpoints':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Endpoints vs. Non-endpoints</span><font size="1"><br><br></font>"Endpoints" are defined as nodes that will be contacted on a regular schedule (eg. each time the cron job executes the \'node.start\' script).  In most cases, people will use actual servers in this list, but if you need to continually monitor another node, you should classify it as an endpoint.  An example of this might be an an ethernet interface of a router.  Treat it as an endpoint, and it will be polled each time.  "Non-endpoints" are only polled when an endpoint doesn\'t respond, at which time Node Runner starts polling backward up the chain of parent nodes (think traceroute) that you defined as you added each node to the web interface.  Be careful not to create endpoint-to-endpoint dependencies (one endpoint depends on another), as it wastes resources and slows down the scripts.';
	break;
	case 'sysdoc_correcttime':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Keep Correct Time</span><font size="1"><br><br></font>It is very important to have the correct time on your Node Runner (localhost) machine.  All logging features (such as measuring downtime) are dependent upon a consistent time.  The best way to keep time consistent is to keep the system clock up to date.  Most people set up a cron job or NTP service to handle that.';
	break;
	case 'sysdoc_dbsupport':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">Database Support</span><font size="1"><br><br></font>The original Node Runner code (pre v0.4) has been revised to allow use of database abstraction layers instead of hardcoded <a href="http://www.mysql.com" target="_blank">MySQL</a> support.  While MySQL is still the default database supported by Node Runner, it\'s fairly easy to build abstraction layers for other databases as well.  There are really only 4-5 functions that need to run, so it\'s not a huge undertaking to make the layers.  This is also the reason Node Runner was not built around other, popular database abstraction packages -- simplicity is golden, bloat is bad.<br><br>I\'ll post the development layers and .sql import files on <a href="http://www.sourceforge.net/projects/node-runner/" target="_blank">Sourceforge</a> if anyone would like to take a crack at testing/fixing them.  If anyone is interested in making one or more of them [really] work, I\'d be glad to give them all the credit for doing so, but I won\'t distribute those files until I know they\'ve been thoroughly tested.';
	break;
	case 'sysdoc_license':
	$tid_text = '<span style="font-size:14px;border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">License Information</span><font size="1"><br><br></font>Copyright (C) 2001-2005 Brad Fears.  Email: <a href="mailto:brad@tricountywebdesign.com">brad@tricountywebdesign.com</a><br><br>This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version.<br><br>This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.<br><br>You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.';
	break;
  }
  
  
  
  echo '
  <table width="780" border="0" cellpadding="5" cellspacing="0">
	<tr>
	  <td colspan="2" height="40">
		<span style="font-size:20px;color:#A00000">Node Runner Help Contents</span><br>
	  </td>
	</tr>
  </table>
  <table class="helpcontents" width="780" border="0" cellpadding="5" cellspacing="0">
	<tr>
	  <td width="200" class="helpcontents" valign="top">
	    <br><span style="border-bottom:1px solid #A00000;font-weight:bold;color:#A00000;">System Documentation:</span><font size="1"><br><br></font>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_overview">Overview</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_sysreqs">System Requirements</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_mod_queries">Modular Node Queries</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_cron_scheduling">Cron Scheduling</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_debugging">Debugging</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_endpoints">Endpoints</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_correcttime">Keep Correct Time</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_dbsupport">Database Support</a><br>
        &nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="help.php?contents=1&tid=sysdoc_license">License Information</a><br>
        <br>
		<br><span style="border-bottom:1px solid #4F9E00;font-weight:bold;color:#4F9E00;">Online Support:</span><font size="1"><br><br></font>
		&nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="http://sourceforge.net/projects/node-runner/" target="_blank">Project Page</a><br>
		&nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="http://sourceforge.net/forum/?group_id=28430" target="_blank">Support Forums</a><br>
		&nbsp;&#8226;&nbsp;<a style="text-decoration:none" href="http://sourceforge.net/tracker/?group_id=28430" target="_blank">Bug/Patch Tracker</a><br>
		<p>&nbsp;</p>
	  </td>
	  <td width="580" class="helpcontents" valign="top">
		<br>'.$tid_text.'<p>&nbsp;</p>
	  </td>
	</tr>
  </table>
	   ';
	   
  require_once("footer.php");
  
}


?>

