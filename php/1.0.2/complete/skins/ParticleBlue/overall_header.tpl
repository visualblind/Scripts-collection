<html>
<head>
<title>{SITE_TITLE} :: {PAGE_TITLE}</title>
<link rel="stylesheet" type="text/css" href="{SKIN_ROOT}resources/style.css" />
</head>
<body>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
	<td colspan="5">
		<a href="{ROOT}"><img src="{SKIN_ROOT}images/logo.gif" width="227" height="50" border="0" alt="{SITE_TITLE}" /></a>
	</td>
<tr>
<tr>
	<td colspan="5">
		<table width="100%" cellspacing="1" cellpadding="5" border="0" class="mainbody">
		<tr class="row1">
			<td>
			<table width="100%" cellpadding="0" cellspacing="0" border="0"><tr>
			<td><a href="{ROOT}">{SITE_TITLE}</a></td>
			<td align="right"><a href="{ROOT}admin.php">Admin</a></td>
			</tr></table>
		</tr></table>
	</td>
<tr>
<tr>
	<td height="5"></td>
</tr>
	<td>
	<table width="100%" cellpadding="5" cellspacing="0" border="0"><tr valign="top"><td align="center">
			<form method="GET" action="index.php">
			 Run domain check: 
			 <input type="hidden" name="do" id="do" value="runcheck">
			 <input type="text" name="target" id="target" size="40" maxlength="63" value="{DEFAULT_SEARCH}">
			 <select id="ext" name="ext">
			 	<option value="all" selected="selected">ALL</option>
			 	<option value="com">.com</option>
			 	<option value="net">.net</option>
			 	<option value="org">.org</option>
			 	<option value="info">.info</option>
			 	<option value="biz">.biz</option>
			 </select>
			 <input type="submit" value="Check!">
		</form>
	</td></tr><tr><td>