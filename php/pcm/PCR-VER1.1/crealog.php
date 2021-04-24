<?
	######################################################################################
	##							SISTEMA DE CONTROL DE GESTION 							##
	##									$PCM	 										##
	##																					##
	##		Version:		1.1															##
	##		Documento:		crealog.php													##
	##		Descripcion: 	Registra en archivo de log´s cada alarma del sistema.		##
	##		Autor:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Creacion:		7/Julio/2003												##
	##		Ultima Modi:	7/Julio/2003												##
	##		Nombre:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Licencia:		GNU GENERAL PUBLIC LICENSE 									##
	##																					##
	###################################################################################### 
$archivo = "alertas_PCR_log"; 
$texto = "$fecha -- $hora -- Alerta en $ip puerto $desc \n";
$fp = fopen($archivo,'a+'); 
//fwrite($fp, $texto, 26); 
fwrite($fp, $texto); 
fclose($fp); 

?>
