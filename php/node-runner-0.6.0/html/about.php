<?php

require_once("connect.php");

$title = "About Node Runner";
require_once("header.php");

echo '
<p>&nbsp;</p>
<table width="100%" border="0" cellpadding="3" cellspacing="0" align="center">
  <tr>
	<td>
	  <img src="images/runners.png" width="116" height="200" align="right" hspace="10">
	  <div style="font-size:11px;text-align:justify">
	  <a style="text-decoration:none;font-size:11px" href="http://sourceforge.net/projects/node-runner/" target="_blank">Node Runner v'.$nr_ver.'</a> is a PHP-based network monitor designed to contact nodes in a hierarchial fashion based on the configuration of the node. If a node does not respond, dependencies (parents) of that node are systematically polled until the problem is isolated.
      <br><br>
      Special thanks for the patience of those who have contributed bug reports and conducted testing.  Open source software would not be possible without the support and involvement of the Internet community.
      <br><br>
      Copyright &copy; 2001-2005 Brad Fears.  All Rights Reserved.
      <br><br>
      This software is made freely available under the <a style="text-decoration:none;font-size:11px" href="http://www.gnu.org/copyleft/gpl.html" target="_blank">GNU GPL</a> license.  See the README file for further information.
      </div>
      <br><br>
	  <center><a href="http://www.tricountywebdesign.com/" target="_blank"><img src="images/tcwd-logo.gif" alt="Tri-County Web Design, LLC" border="0" width="288" height="88"></a><br>
	  <div style="font-size:11px;">
	  Need custom web software?  <a style="text-decoration:none" href="http://www.tricountywebdesign.com" target="_blank">Visit us on the web!</a>
	  </div></center>
	</td>
  </tr>
</table>
	 ';

require_once("footer.php");

?>
