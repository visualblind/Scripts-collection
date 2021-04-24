<html>
<head>
<title>phpGlobalWhois</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

<body bgcolor="#FFFFFF" text="#000000">
<form name="form1" method="post" action="example.php">
  Domain: <input type="text" name="dom">
  <input type="submit" name="Submit" value="Submit">
</form>
<?
if ($dom){
	include "./whois.inc";
	$whoisresult = lookup($dom);
	$isavail = $whoisresult[0]; // Contains "1" is it's available, blank if it's registered
	$whotext = $whoisresult[1]; // Contains the full response from the server.
	#The PRE tags are there to display the results in web browsers without replacing \n with <br>..its just cleaner and quicker that way. ;)
	if ($isavail=="1"){
		print "<b>This domain is available!</b>";
	}
		else
	{
		print "<b>This domain has been registered.</b>";
	}
	print "<pre>".$whotext."</pre>";
}
?>
</body>
</html>
