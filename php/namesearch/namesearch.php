<?php
 /***********************************************************************/
/* PHP .NAME PHP Domain Name Search Whois                               */
/* ===========================                                          */
/*                                                                      */
/*   Written by Steve Dawson - http://www.stevedawson.com               */
/*   Freelance Web Developer and PHP, Perl and Javascript programming   */
/*                                                                      */
/* This program is free software. You can redistribute it and/or modify */
/************************************************************************/

function perform_whois($domain, $tld)
{
$whois_servers = array(
"name" => "whois.nic.name",     );
$whois_avail_strings = array(
"whois.nic.name" => "No match",   );
$rawoutput = "";

## Oops looks like we gotta error
if(($ns = fsockopen($whois_servers[$tld], 43)) == false) { echo $tld; return 0; }
fputs($ns, $domain.".".$tld."\n");
while(!feof($ns)) { $rawoutput .= fgets($ns, 128); }
fclose($ns);
if(!strlen($rawoutput) || ereg($whois_avail_strings[$whois_servers[$tld]], $rawoutput)) { return 1; }
return 0;
}
function do_namesearch($error = false)
{
## First off, print the search box
?>
<HTML> 
<HEAD> 
<TITLE>Register a .name Domain Name</TITLE> <STYLE TYPE="text/css">
P {
    FONT-SIZE: 10pt; 
    FONT-FAMILY: Arial;
}
INPUT.BUTTON{
	FONT-WEIGHT: bold; 
	FONT-SIZE: 9pt; 
	FONT-FAMILY: Arial;
	border : hidden;
	background : #EEE8AA;
	CURSOR: hand;
}
INPUT{
	FONT-WEIGHT: normal; 
	FONT-SIZE: 9pt; 
	FONT-FAMILY: Arial;
	border : hidden;
}
</STYLE>
</HEAD> 
<BODY>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="400" BGCOLOR="#99B9D0" ALIGN="CENTER"> 
<TBODY>  <TR>  <TD><IMG SRC="cp-bcorn.gif" WIDTH="13" HEIGHT="12"></TD>
<TD WIDTH="100%"></TD> <TD ALIGN="right">
<IMG SRC="cp-bcorn2.gif" WIDTH="13" HEIGHT="12"></TD> 
</TR> <TR>  <TD COLSPAN="3" ALIGN="CENTER"><P>
<FONT FACE="Arial" SIZE="-1">Use our free service to see if your name is available to register. 
<BR>Simply enter your first and last name in to the spaces provided and click on the 'Search' button. </FONT></P>
<TABLE WIDTH="95%" BORDER="0" CELLPADDING="0" CELLSPACING="1" ALIGN="CENTER">
<?PHP
## Print this is error in domain name format
 if($error == true) { ?>
 <TR><TD ALIGN="CENTER"><P><B><FONT FACE="Arial" SIZE="-1" COLOR="#FF0000">
There was an error in the search for your chosen name</FONT></B><BR>
<FONT COLOR="#000000">Your first name and surname must contain only alphanumerical characters<BR> and each must be at least 2 characters in length. </FONT></P>
</TD></TR>
<?PHP } ?>
</TABLE><BR>
<TABLE WIDTH="95%" BORDER="0" CELLPADDING="0" CELLSPACING="2">
<TR VALIGN="MIDDLE"><TD VALIGN="MIDDLE" ALIGN="LEFT" HEIGHT="30"> 
<P ALIGN="CENTER"><B>Search for your name here</B></P><TABLE WIDTH="475" BORDER="0" CELLPADDING="0" CELLSPACING="0"> 
<TR VALIGN="MIDDLE"> <TD ALIGN="CENTER" HEIGHT="50" VALIGN="MIDDLE"> 
<FORM METHOD="post"><P>
<INPUT TYPE="TEXT" SIZE="25" MAXLENGTH="30" NAME="forename">
 . <INPUT TYPE="text" SIZE="25" MAXLENGTH="30" NAME="surname">
.name<INPUT TYPE="hidden" NAME="step" VALUE="2">
<INPUT TYPE="hidden" NAME="tld" VALUE="name">
<INPUT TYPE="submit" VALUE="Search" CLASS="button"></P></FORM></TD>
</TR> </TABLE></TD></TR></TABLE></TD> </TR> <TR> 
<TD><IMG SRC="cp-bcorn3.gif" WIDTH="13" HEIGHT="12"></TD> <TD></TD> 
<TD ALIGN="right"><IMG SRC="cp-bcorn4.gif" WIDTH="13" HEIGHT="12"></TD> 
</TR> </TBODY> </TABLE>
</BODY>
</HTML>
<?php
## Now the good part, do the stuff
}
function do_choosename()
{
global $forename;
global $surname;
global $tld;
$surname = str_replace(" ", "", $surname);
$domainname = "";
$emailaddress = "";

## check the forename
if((!ereg("^([a-z]|[A-Z]|[0-9]|\-)*$", $forename) || ereg("^\-", $forename) || ereg("\-$", $forename) || strlen($forename) < 2) || (!ereg("^([a-z]|[A-Z]|[0-9]|\-)*$", $surname) || ereg("^\-", $surname) || ereg("\-$", $surname) || strlen($surname) < 2)) {

do_namesearch(true);
exit();
	}

 if($tld == "name") 

{
if (perform_whois($forename.".".$surname, "name")) {
$domainname = $forename.".".$surname.".name";
$emailaddress = $forename."@".$surname.".name";

}

 }

## Show this page if Domain is already registered
if($domainname=="") {
?>
<HTML> 
<HEAD> 
<TITLE>Domain Name Unavailable</TITLE> <STYLE TYPE="text/css">
P {
    FONT-SIZE: 10pt; 
    FONT-FAMILY: Arial;
}
INPUT.BUTTON{
	FONT-WEIGHT: bold; 
	FONT-SIZE: 9pt; 
	FONT-FAMILY: Arial;
	border : hidden;
	background : #EEE8AA;
	CURSOR: hand;
}
INPUT{
	FONT-WEIGHT: normal; 
	FONT-SIZE: 9pt; 
	FONT-FAMILY: Arial;
	border : hidden;
}
</STYLE>
</HEAD> 
<BODY>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="475" BGCOLOR="#99B9D0" ALIGN="CENTER"> 
<TBODY>  <TR>  <TD><IMG SRC="cp-bcorn.gif" WIDTH="13" HEIGHT="12"></TD>
<TD WIDTH="100%"></TD> <TD ALIGN="right">
<IMG SRC="cp-bcorn2.gif" WIDTH="13" HEIGHT="12"></TD> 
</TR> <TR>  <TD COLSPAN="3" ALIGN="CENTER">
<TABLE WIDTH="95%" BORDER="0" CELLPADDING="0" CELLSPACING="2">
<TR VALIGN="MIDDLE"><TD VALIGN="MIDDLE" ALIGN="LEFT" HEIGHT="30"> 
<P ALIGN="CENTER"><FONT FACE="Arial" SIZE="-1" COLOR="#FF0000">
<B>Sorry - Your chosen name has already been registered</b><BR>
<FONT COLOR="#000000">Please use different variations of your name or try using your middle names. </FONT>
</FONT></P><P ALIGN="CENTER">Please enter a different variation of your name below</P>
<TABLE WIDTH="475" BORDER="0" CELLPADDING="0" CELLSPACING="0"> 
<TR VALIGN="MIDDLE"> <TD ALIGN="CENTER" HEIGHT="50" VALIGN="MIDDLE"> 
<FORM METHOD="post"><P>
<INPUT TYPE="TEXT" SIZE="25" MAXLENGTH="30" NAME="forename">
 . <INPUT TYPE="text" SIZE="25" MAXLENGTH="30" NAME="surname">
.name<INPUT TYPE="hidden" NAME="step" VALUE="2">
<INPUT TYPE="hidden" NAME="tld" VALUE="name">
<INPUT TYPE="submit" VALUE="Search" CLASS="button"></P></FORM></TD>
</TR> </TABLE></TD></TR></TABLE></TD> </TR> <TR> 
<TD><IMG SRC="cp-bcorn3.gif" WIDTH="13" HEIGHT="12"></TD> <TD></TD> 
<TD ALIGN="right"><IMG SRC="cp-bcorn4.gif" WIDTH="13" HEIGHT="12"></TD> 
</TR> </TBODY> </TABLE>
</BODY>
</HTML>
<?
exit;
}
## Print this page is the domain name is available to register
?>
<HTML> 
<HEAD> 
<TITLE>Domain Name Available</TITLE> <STYLE TYPE="text/css">
P {
    FONT-SIZE: 10pt; 
    FONT-FAMILY: Arial;
}
</STYLE>
</HEAD> 
<BODY>
<TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="475" BGCOLOR="#99B9D0" ALIGN="CENTER"> 
<TBODY>  <TR>  <TD><IMG SRC="cp-bcorn.gif" WIDTH="13" HEIGHT="12"></TD>
<TD WIDTH="100%"></TD> <TD ALIGN="right">
<IMG SRC="cp-bcorn2.gif" WIDTH="13" HEIGHT="12"></TD> 
</TR> <TR>  <TD COLSPAN="3" ALIGN="CENTER">
<TABLE WIDTH="98%" CELLPADDING="0" CELLSPACING="4">
<TR><TD ALIGN="CENTER"><?PHP 	if(strlen($domainname) && strlen($emailaddress)) { ?><P ALIGN="CENTER">
<FONT FACE="Arial" SIZE="-1"><FONT SIZE="+1" COLOR="#FF0000">Congratulations </FONT><BR><BR>Your chosen domain name <B>
<?PHP echo $domainname; ?></B> is available to register.</FONT></P>
<INPUT TYPE="hidden" NAME="domaindata" VALUE="<?php echo urlencode($domainname); ?> <?php echo urlencode($emailaddress); ?>">
<?PHP }?><BR></TD></TR><TR><TD ALIGN="CENTER">
<P><FONT FACE="Arial" SIZE="-1">Your website address and your email addresses will be in the format of :</FONT></P> 
<TABLE WIDTH="85%" BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#CCCCCC">
<TR><TD VALIGN="MIDDLE" ALIGN="RIGHT" WIDTH="85" BGCOLOR="#f3f3f3"> 
<P><FONT FACE="Arial" SIZE="-1">Website:</FONT></P></TD>
<TD VALIGN="MIDDLE" ALIGN="RIGHT" BGCOLOR="#f3f3f3"> 
<P ALIGN="LEFT"><FONT FACE="Arial" SIZE="-1">&nbsp;&nbsp;<B>www.<?PHP echo $domainname; ?></B></FONT></P></TD>
</TR><TR><TD VALIGN="MIDDLE" ALIGN="RIGHT" WIDTH="85" BGCOLOR="#f3f3f3"> 
<P><FONT FACE="Arial" SIZE="-1">Email:</FONT></P></TD>
<TD ALIGN="LEFT" BGCOLOR="#f3f3f3"> 
<P><FONT FACE="Arial" SIZE="-1">&nbsp;&nbsp;<B><?PHP echo $forename; ?>@<?PHP echo $surname ; ?>.name</B></FONT></P>
</TD></TR></TABLE><BR></TD> </TR> </TABLE></TD> </TR> <TR> 
<TD><IMG SRC="cp-bcorn3.gif" WIDTH="13" HEIGHT="12"></TD> 
<TD></TD> <TD ALIGN="right"><IMG SRC="cp-bcorn4.gif" WIDTH="13" HEIGHT="12"></TD> </TR> 
</TBODY> </TABLE>
</BODY>
</HTML>
<?php
}

if($submit == "Restart") { unset($step); }
switch($step) {
case 2:
do_choosename();
break;
default:
do_namesearch();
break;
}
?>