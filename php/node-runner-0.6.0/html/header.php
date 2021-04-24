<?php

echo '
<html>
<head>';

if (!$title) {
  echo '<title>Node Runner - Open Source Network Monitor</title>';
} else {
  echo '<title>Node Runner - '.$title.'</title>';
}

echo '<META NAME="ROBOTS" CONTENT="NOINDEX, NOFOLLOW">';


if (!$_GET["nohead"]) { // used for printable reports

echo '
<script type="text/javascript">

/***********************************************
* AnyLink Drop Down Menu- © Dynamic Drive (www.dynamicdrive.com)
* This notice MUST stay intact for legal use
* Visit http://www.dynamicdrive.com/ for full source code
***********************************************/

//Contents for menu 1
var menu1=new Array()
menu1[0]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="addedit-nodes.php">&nbsp;&nbsp;&#8226;&nbsp;Add/Edit&nbsp;Nodes</a></div>\'

//Contents for menu 2, and so on
var menu2=new Array()
menu2[0]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="addedit-users.php">&nbsp;&nbsp;&#8226;&nbsp;Configure&nbsp;User&nbsp;Groups</a></div>\'
menu2[1]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="addedit-mail.php">&nbsp;&nbsp;&#8226;&nbsp;Configure&nbsp;Mail&nbsp;Groups</a></div>\'

var menu3=new Array()
menu3[0]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="index.php">&nbsp;&nbsp;&#8226;&nbsp;Main&nbsp;Page</a></div>\'
menu3[1]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="recent-failures.php">&nbsp;&nbsp;&#8226;&nbsp;Recent&nbsp;Failures</a></div>\'
menu3[2]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="node-reports.php">&nbsp;&nbsp;&#8226;&nbsp;Historical&nbsp;Reports</a></div>\'

var menu4=new Array()
menu4[0]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="db-maintenance.php">&nbsp;&nbsp;&#8226;&nbsp;DB&nbsp;Maintenance</a></div>\'

var menu5=new Array()
menu5[0]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="help.php?contents=1">&nbsp;&nbsp;&#8226;&nbsp;Contents</a></div>\'
menu5[1]=\'<div style="border-style:solid;border-width:1px;border-color:#AD8802 #A6091C #A6091C #A6091C;"><a class="dropmenu" href="about.php?nohead=1" onClick="AboutNR(400,450);return false" onfocus="this.blur()">&nbsp;&nbsp;&#8226;&nbsp;About&nbsp;NR</a></div>\'


var menuwidth=\'155px\' //default menu width
var menubgcolor=\'#AD8802\'  //menu bgcolor
var disappeardelay=250  //menu disappear speed onMouseout (in miliseconds)
var hidemenu_onclick="yes" //hide menu when user clicks within menu?

/////No further editting needed

var ie4=document.all
var ns6=document.getElementById&&!document.all

if (ns6) {
document.write(\'<div id="dropmenudiv" style="visibility:hidden;width:\'+menuwidth+\';background-color:\'+menubgcolor+\'" onMouseover="clearhidemenu()" onMouseout="dynamichide(event)"></div>\')
} else {
document.write(\'<div id="dropmenudivIE" style="visibility:hidden;width:\'+menuwidth+\';background-color:\'+menubgcolor+\'" onMouseover="clearhidemenu()" onMouseout="dynamichide(event)"></div>\')
}

function getposOffset(what, offsettype){
var totaloffset=(offsettype=="left")? what.offsetLeft : what.offsetTop;
var parentEl=what.offsetParent;
while (parentEl!=null){
totaloffset=(offsettype=="left")? totaloffset+parentEl.offsetLeft : totaloffset+parentEl.offsetTop;
parentEl=parentEl.offsetParent;
}
return totaloffset;
}


function showhide(obj, e, visible, hidden, menuwidth){
if (ie4||ns6)
dropmenuobj.style.left=dropmenuobj.style.top=-500
if (menuwidth!=""){
dropmenuobj.widthobj=dropmenuobj.style
dropmenuobj.widthobj.width=menuwidth
}
if (e.type=="click" && obj.visibility==hidden || e.type=="mouseover")
obj.visibility=visible
else if (e.type=="click")
obj.visibility=hidden
}

function iecompattest(){
return (document.compatMode && document.compatMode!="BackCompat")? document.documentElement : document.body
}

function clearbrowseredge(obj, whichedge){
var edgeoffset=0
if (whichedge=="rightedge"){
var windowedge=ie4 && !window.opera? iecompattest().scrollLeft+iecompattest().clientWidth-15 : window.pageXOffset+window.innerWidth-15
dropmenuobj.contentmeasure=dropmenuobj.offsetWidth
if (windowedge-dropmenuobj.x < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure-obj.offsetWidth
}
else{
var windowedge=ie4 && !window.opera? iecompattest().scrollTop+iecompattest().clientHeight-15 : window.pageYOffset+window.innerHeight-18
dropmenuobj.contentmeasure=dropmenuobj.offsetHeight
if (windowedge-dropmenuobj.y < dropmenuobj.contentmeasure)
edgeoffset=dropmenuobj.contentmeasure+obj.offsetHeight
}
return edgeoffset
}

function populatemenu(what){
if (ie4||ns6)
dropmenuobj.innerHTML=what.join("")
}


function dropdownmenu(obj, e, menucontents, menuwidth){
if (window.event) event.cancelBubble=true
else if (e.stopPropagation) e.stopPropagation()
clearhidemenu()
if (ns6) {
dropmenuobj=document.getElementById? document.getElementById("dropmenudiv") : dropmenudiv
} else {
dropmenuobj=document.getElementById? document.getElementById("dropmenudivIE") : dropmenudivIE
}
populatemenu(menucontents)

if (ie4||ns6){
showhide(dropmenuobj.style, e, "visible", "hidden", menuwidth)
dropmenuobj.x=getposOffset(obj, "left")
dropmenuobj.y=getposOffset(obj, "top")
dropmenuobj.style.left=dropmenuobj.x-clearbrowseredge(obj, "rightedge")+"px"
dropmenuobj.style.top=dropmenuobj.y-clearbrowseredge(obj, "bottomedge")+obj.offsetHeight+"px"
}

return clickreturnvalue()
}

function clickreturnvalue(){
if (ie4||ns6) return false
else return true
}

function contains_ns6(a, b) {
while (b.parentNode)
if ((b = b.parentNode) == a)
return true;
return false;
}

function dynamichide(e){
if (ie4&&!dropmenuobj.contains(e.toElement))
delayhidemenu()
else if (ns6&&e.currentTarget!= e.relatedTarget&& !contains_ns6(e.currentTarget, e.relatedTarget))
delayhidemenu()
}

function hidemenu(e){
if (typeof dropmenuobj!="undefined"){
if (ie4||ns6)
dropmenuobj.style.visibility="hidden"
}
}

function delayhidemenu(){
if (ie4||ns6)
delayhide=setTimeout("hidemenu()",disappeardelay)
}

function clearhidemenu(){
if (typeof delayhide!="undefined")
clearTimeout(delayhide)
}

if (hidemenu_onclick=="yes")
document.onclick=hidemenu

</script>';

} // end if (!$_GET["nohead"])
	 
echo '
<link rel="stylesheet" href="style.css" type="text/css">
<script language="Javascript">

function openHelp(url,width,height)  {
   window.open(url, "NodeRunnerHelp", "width="+width+",height="+height+",menubar=no,status=no,location=no,toolbar=no,scrollbars=no,resizable=yes");
   return false;
}

function AboutNR(width,height)  {
   var LeftPosition=(screen.width)?(screen.width-width)/2:100;
   var TopPosition=(screen.height)?(screen.height-height)/2:100;
   window.open("about.php?nohead=1", "AboutNodeRunner", "width="+width+",height="+height+",top="+TopPosition+",left="+LeftPosition+",menubar=no,status=no,location=no,toolbar=no,scrollbars=no,resizable=yes");
   return false;
}
     ';
	 
if ($title == "Add/Edit Nodes") {

echo '
// Disable certain fields for certain query_types.
function disableAddEditFields() {
   document.addedit.snmp_comm.disabled=true;
   document.addedit.snmp_comm.value="";
   document.addedit.port.disabled=true;
   document.addedit.port.value="";
   document.addedit.url.disabled=true;
   document.addedit.url.value="";
   document.addedit.auth_user.disabled=true;
   document.addedit.auth_user.value="";
   document.addedit.auth_pass.disabled=true;
   document.addedit.auth_pass.value="";

   if ((document.addedit.query_type.value == "TCP") || (document.addedit.query_type.value == "UDP")) {
     document.addedit.port.disabled=false;
   } else if (document.addedit.query_type.value == "SNMP") {
     document.addedit.snmp_comm.disabled=false;
   } else if (document.addedit.query_type.value == "HTTP") {
     document.addedit.port.disabled=false;
     if (document.addedit.port.value == "") {
       document.addedit.port.value="80";
     }
     document.addedit.url.disabled=false;
     document.addedit.auth_user.disabled=false;
     document.addedit.auth_pass.disabled=false;
   }
}


// Form validation
function verify() {
var themessage = "You are required to complete the following fields: ";
if (document.addedit.description.value=="") {
themessage = themessage + "\n - Node Name";
}
if (document.addedit.ipaddress.value=="") {
themessage = themessage + "\n - IP Address";
}
if (document.addedit.query_type.value==0) {
themessage = themessage + "\n - Query Type";
}
if (document.addedit.ptime.value=="") {
themessage = themessage + "\n - Query Timeout";
}
if ((document.addedit.port.disabled==false) && (document.addedit.port.value=="")) {
themessage = themessage + "\n - Port to Query";
}
if ((document.addedit.url.disabled==false) && (document.addedit.url.value=="")) {
themessage = themessage + "\n - URL to Query";
}
if ((document.addedit.snmp_comm.disabled==false) && (document.addedit.snmp_comm.value=="")) {
themessage = themessage + "\n - SNMP Community";
}

  //alert if fields are empty and cancel form submit
  if (themessage == "You are required to complete the following fields: ") {
    document.addedit.submit();
  } else {
    alert(themessage);
    return false;
  }
}

	 ';

} // end if Add/Edit Nodes


if ($title == "Add/Edit Users") {
echo '
// Form validation
function verify() {
var themessage = "You are required to complete the following fields: ";
var passwordconfirm = "Password Confirmed";
if (document.addedit.add_username.value=="") {
themessage = themessage + "\n - Username";
}
if (document.addedit.add_password.value=="") {
themessage = themessage + "\n - Password";
}
if (document.addedit.add_confirm_password.value=="") {
themessage = themessage + "\n - Re-Type Password";
}
//alert if fields are empty and cancel form submit
if (themessage == "You are required to complete the following fields: ") {

    if (document.addedit.add_password.value != document.addedit.add_confirm_password.value) {
        passwordconfirm = "The passwords do not match!";
    }

    if (passwordconfirm == "Password Confirmed") {
        document.addedit.submit();
	} else {
        alert(passwordconfirm);
	    return false;
	}


} else {
alert(themessage);
return false;
}
}

function verify2() {
var themessage = "You are required to complete the following fields: ";
var passwordconfirm = "Password Confirmed";
if (document.addedit2.edit_password.value=="") {
themessage = themessage + "\n - Password";
}
if (document.addedit2.edit_confirm_password.value=="") {
themessage = themessage + "\n - Re-Type Password";
}
//alert if fields are empty and cancel form submit
if (themessage == "You are required to complete the following fields: ") {

    if (document.addedit2.edit_password.value != document.addedit2.edit_confirm_password.value) {
        passwordconfirm = "The passwords do not match!";
    }

    if (passwordconfirm == "Password Confirmed") {
        document.addedit2.submit();
	} else {
        alert(passwordconfirm);
	    return false;
	}


} else {
alert(themessage);
return false;
}
}

	 ';
} // end if Add/Edit Users


if ($title == "Configure Mail Groups") {
echo '
// Form validation
function verify() {
var themessage = "You are required to complete the following fields: ";
if (document.mailgroups.add_groupname.value=="") {
themessage = themessage + "\n - Group Name";
}
if (document.mailgroups.add_addresses.value=="") {
themessage = themessage + "\n - Email Addresses";
}
  //alert if fields are empty and cancel form submit
  if (themessage == "You are required to complete the following fields: ") {
    document.mailgroups.submit();
  } else {
    alert(themessage);
    return false;
  }
}
	 ';
	 
} // end if Configure Mail Groups



if ($title == "Node Reports") {
echo '
// Form validation
function verify() {
var themessage = "You are required to complete the following fields: ";
if (document.nodereports.smonth.value=="") {
themessage = themessage + "\n - Report Start Date - Month";
}
if (document.nodereports.sday.value=="") {
themessage = themessage + "\n - Report Start Date - Day";
}
if (document.nodereports.syear.value=="") {
themessage = themessage + "\n - Report Start Date - Year";
}
if (document.nodereports.emonth.value=="") {
themessage = themessage + "\n - Report End Date - Month";
}
if (document.nodereports.eday.value=="") {
themessage = themessage + "\n - Report End Date - Day";
}
if (document.nodereports.eyear.value=="") {
themessage = themessage + "\n - Report End Date - Year";
}
  //alert if fields are empty and cancel form submit
  if (themessage == "You are required to complete the following fields: ") {
    document.nodereports.submit();
  } else {
    alert(themessage);
    return false;
  }
}

function disableFields() {
   if (document.nodereports.op_OnlySum.checked==true) {
     document.nodereports.op_OnlyLog.disabled=true;
     document.nodereports.op_OnlyLog.value="";
   } else {
     document.nodereports.op_OnlyLog.disabled=false;
     document.nodereports.op_OnlyLog.value="";
   }
   if (document.nodereports.op_OnlyLog.checked==true) {
     document.nodereports.op_OnlySum.disabled=true;
     document.nodereports.op_OnlySum.value="";
   } else {
     document.nodereports.op_OnlySum.disabled=false;
     document.nodereports.op_OnlySum.value="";
   }
}

	 ';

} // end if Node Reports


echo '
</script>
</head>
<body topmargin="0">';

if (!$_GET["nohead"]) { // used for printable reports
echo '
<table align="center" width="780" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="410" align="right" valign="middle" bgcolor="#A000000"><font color="#FFFFFF" size="2"><strong><a href="http://sourceforge.net/projects/node-runner/"><font color="white">Node
      Runner v'.$nr_ver.'</font></a> is licensed under the <a href="http://www.gnu.org/copyleft/gpl.html" target="_blank"><font color="white">GNU
      GPL</font></a>.&nbsp;&nbsp;&nbsp;<br>';
      
      if ($_SESSION["isloggedin"] == $glbl_hash) {
        echo 'You are currently logged in as: <i>'.$_SESSION["username"].'</i> / <a href="logout.php"><font color="white">LOGOUT</font></a>';
      } else {
        echo 'You are not currently logged in.  Please <a href="login.php"><font color="white">LOGIN</font></a>.';
      }

echo '
	  </strong></font>&nbsp;&nbsp;&nbsp;</td>
    <td width="370" align="right" bgcolor="#A00000"><img src="images/nr_title.gif" width="364" height="45"></td>
  </tr>
</table>
<table align="center" width="780" border="0" cellspacing="0" cellpadding="1">
  <tr>
	<td width="125" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #A6091C;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
      <a class="topdropmenu" href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu(this, event, menu1, \'126px\')" onMouseout="delayhidemenu()">Network&nbsp;Nodes</a>
	</td>
    <td width="152" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #AD8802;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
	  <a class="topdropmenu" href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu(this, event, menu2, \'153px\')" onMouseout="delayhidemenu()">User&nbsp;Administration</a>
	</td>
    <td width="156" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #AD8802;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
	  <a class="topdropmenu" href="status-monitor.php" target="_blank">Network&nbsp;Dashboard</a>
	</td>
    <td width="135" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #AD8802;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
	  <a class="topdropmenu" href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu(this, event, menu3, \'136px\')" onMouseout="delayhidemenu()">Status&nbsp;Reporting</a>
	</td>
    <td width="122" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #AD8802;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
	  <a class="topdropmenu" href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu(this, event, menu4, \'122px\')" onMouseout="delayhidemenu()">Misc.&nbsp;Utilities</a>
	</td>
    <td width="90" style="border-style:solid;border-color:#AD8802 #A6091C #A6091C #AD8802;border-width:1px;" align="center" bgcolor="#AD8802" height="25">
	  <a class="topdropmenu" href="#" onClick="return clickreturnvalue()" onMouseover="dropdownmenu(this, event, menu5, \'87px\')" onMouseout="delayhidemenu()">Help</a>
	</td>';


echo '
  </tr>
</table>
<table align="center" width="780" border="0" cellspacing="0" cellpadding="5">
  <tr>
    <td valign="top">
	  <p>&nbsp;</p>
	 ';
	 
} // end if (!$_GET["nohead"])
	 
?>
