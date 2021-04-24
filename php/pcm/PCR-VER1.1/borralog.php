<? 
	######################################################################################
	##							SISTEMA DE CONTROL DE GESTION 							##
	##									$PCM	 										##
	##																					##
	##		Version:		1.1															##
	##		Documento:		borralog.php												##
	##		Descripcion: 	Limpia el archivo de log´s									##
	##		Autor:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Creacion:		7/Julio/2003												##
	##		Ultima Modi:	7/Julio/2003												##
	##		Nombre:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Licencia:		GNU GENERAL PUBLIC LICENSE									##
	##																					##
	##																					##
	######################################################################################
$archivo = "alertas_PCR_log"; 
$texto = "Log de Alertas CRASH CONACULTA Ver. 1.1\n";
$fp = fopen($archivo,'w+'); 
//fwrite($fp, $texto, 26); 
fwrite($fp,$texto); 
fclose($fp); 
header ("location:index.php");

?>