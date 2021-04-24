<?
	######################################################################################
	##							SISTEMA DE CONTROL DE GESTION 							##
	##									$PCM	 										##
	##																					##
	##		Version:		1.1															##
	##		Documento:		index.php													##												##
	##		Autor:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Creacion:		7/Julio/2003												##
	##		Ultima Modi:	7/Julio/2003												##
	##		Nombre:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Licencia:		GNU GENERAL PUBLIC LICENSE 									##
	##																					##
	##																					##		
	######################################################################################
include ("config.ini.php");
?>
<html>
<head>
<title><?php echo "$name "; ?></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>
<body bgcolor="#075276" text="#FFFFFF">

  <table width="100%" border="0" align="center">
    <tr> 
      
    <td width="27%">&nbsp;</td>
      <td width="48%"><div align="center"><strong><font size="5">PCR ESTA MONITOREANDO</font></strong></div></td>
      <td width="25%"><div align="right"><font size="5"><strong><?php echo "$fecha"; ?><br>
          <?php echo "$hora"; ?></strong></font></div></td>
    </tr>
  </table>
  
</div>
<div align="center">
  <script language="JavaScript">
//Refresh page script- By Brett Taylor (glutnix@yahoo.com.au)
//configure refresh interval (in seconds)
var countDownInterval=1200;
//configure width of displayed text, in px (applicable only in NS4)
var c_reloadwidth=200
</script>
</div>
<ilayer id="c_reload" width=&{c_reloadwidth}; > 
<layer id="c_reload2" width=&{c_reloadwidth}; left=0 top=0></layer>
</ilayer>
<div align="center">
  <p>
    <script>
var countDownTime=countDownInterval+1;
function countDown(){
countDownTime--;
if (countDownTime <=0){
countDownTime=countDownInterval;
clearTimeout(counter)
window.location.reload()
return
}
if (document.all) //if IE 4+
document.all.countDownText.innerText = countDownTime+" ";
else if (document.getElementById) //else if NS6+
document.getElementById("countDownText").innerHTML=countDownTime+" "
else if (document.layers){ //CHANGE TEXT BELOW TO YOUR OWN
document.c_reload.document.c_reload2.document.write('Próximo <a href="javascript:window.location.reload()">REFRESH</a> en <b id="countDownText">'+countDownTime+' </b> segundos')
document.c_reload.document.c_reload2.document.close()
}
counter=setTimeout("countDown()", 1000);
}
function startit(){
if (document.all||document.getElementById) //CHANGE TEXT BELOW TO YOUR OWN
document.write('Próximo <a href="javascript:window.location.reload()">REFRESH</a> en <b id="countDownText">'+countDownTime+' </b> segundos')
countDown()
}
if (document.all||document.getElementById)
startit()
else
window.onload=startit
</script>
  </p>
  <p> <font color="#CCCCCC" size="3"> 
   
    <img src="img/radar.gif" width="75" height="75">

    </font></p>
</div>
<table width="50%" border="0" align="center">
  <tr> 
    <td><div align="center"><a href="alertas_PCR_log" target="_blank"><font color="#000000"><strong>VER 
        LOG DE ALARMAS</strong></font></a> </div></td>
    <td><div align="center"><a href="borralog.php"><strong><font color="#000000">BORRAR 
        LOG DE ALARMAS</font></strong></a></div></td>
  </tr>
</table>



<?php 
$res=mysql_query("SELECT * FROM ip order by ip ;",$conexion);
  while($row=mysql_fetch_array($res)){  
  $ip=$row["ip"]; 
  $puerto=$row["puerto"];
  $desc=$row["descripcion"];

if(!($fp = fsockopen ("$ip", $puerto, $errno, $errstr, 10))){
echo "<embed src=wav/alarma.wav autostart=true loop=true hidden=true height=0 width=0>
	<table width=75% border=1 align=center>
  	<tr bgcolor=#CCFFFF> 
    <td><div align=center><font color=#333333 size=4><strong>ALERTA</strong></font></div></td>
	<td><div align=center><font color=#333333 size=4><strong>Host</strong></font></div></td>
    <td><div align=center><font color=#333333 size=4><strong>Puerto</strong></font></div></td>
    <td><div align=center><font color=#333333 size=4><strong>Descripcion</strong></font></div></td>
    <td><div align=center><font color=#333333 size=4><strong>Status</strong></font></div></td>
  	</tr><tr bgcolor=#FFFFFF>  
    <td><div align=center><img src=img/calavera.gif width=75 height=75></div></td>
	<td><div align=center><font size=4 color=RED>$ip</font></div></td>
    <td><div align=center><font size=4 color=RED><strong>$puerto</strong></font></div></td>
    <td><div align=center><font size=4 color=RED><strong>$desc</strong></font></div></td>
    <td><div align=center><font size=4 color=RED><strong>DOWN</strong></font></div></td>
    </tr>";
include ("correo.php");
mail ($to, $titulocorr, $mj, $encabezados);
include ("crealog.php");
		}
else
		{

		}
				} 
?>
</table>
<p><br>
</p>
<p><br></div>
  </p>

<p>&nbsp; </p>
</body>
</html>
