<?
	######################################################################################
	##							SISTEMA DE CONTROL DE GESTION 							##
	##									$PCM	 										##
	##																					##
	##		Version:		1.1															##
	##		Documento:		correo.php													##
	##		Descripcion: 	Mensaje de Correo que envia al aparecer una alarma.			##
	##		Autor:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Creacion:		7/Julio/2003												##
	##		Ultima Modi:	7/Julio/2003												##
	##		Nombre:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Licencia:		GNU GENERAL PUBLIC LICENSE 									##
	##																					##
	##																					##
	######################################################################################
$mj = "<html><head>
<title>CRASH Ver. 1.1</title>
</head>
<body>
<h1 align=center><strong><font color=#FF0000>ALERTA CRASH</font></strong></h1>
<table width=15% border=0 align=right>
  <tr>
    <td>$fecha</td>
  </tr>
</table>
<p align=center><font size=5><strong><em>CRASH </em></strong><em>detecto una alerta 
  a las $hora </em></font></p>
<table width=28% border=0 align=center>
  <tr> 
    <td width=11%><font size=5><em><strong>Servidor</strong></em></font></td>
    <td width=89%><strong><em><font color=#FF0000>$ip</font></em></strong></td>
  </tr>
  <tr> 
    <td><font size=5><em><strong>Puerto</strong></em></font></td>
    <td><strong><em><font color=#FF0000>$puerto</font></em></strong></td>
  </tr>
</table>
<p>&nbsp;</p>
<p><em><strong>CRASH Ver. 1.1 </strong></em></p>
<p><strong>Autor:</strong> <em><font size=2> <a href=mailto:mtapia@acquamexico.com>Manlio Fabio Tapia Trigos</a></font></em></p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
</body>
</html>";
?>