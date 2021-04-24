<?
	######################################################################################
	##							SISTEMA DE CONTROL DE GESTION 							##
	##									$PCM	 										##
	##																					##
	##		Version:		1.1															##
	##		Documento:		config.inc.php												##
	##		Descripcion: 	Archivo de Configuracion del PCM							##
	##		Autor:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Creacion:		7/Julio/2003												##
	##		Ultima Modi:	7/Julio/2003												##
	##		Nombre:			Manlio Fabio Tapia Trigos (mtapia@acquamexico.com)			##
	##		Licencia:		GNU GENERAL PUBLIC LICENSE									##
	##																					##
	##																					##
	######################################################################################

//Configuracion de la Base de Datos 

$server         	= "localhost";			//direccion del Servidor de Base de Datos		                 
$db_user        	= "root";				//Nombre de usuario de la base de datos			
$db_pass        	= "";					//Password de la base de datos		
$database       	= "monitor";			//nombre de la base de datos 

//Datos del Correo Electronico 
$titulocorr	  = "Alerta PCM PHP	CRASH MONITOR";					//Titulo del Correo 
$encabezados  = "MIME-Version: 1.0\r\n";
$encabezados .= "Content-type: text/html; charset=iso-8859-1\r\n";
$encabezados .= "From:PCM PHP CRASH MONITOR\r\n";				//Remitente 
$encabezados .= "To: mtapia@correo.conaculta.gob.mx\r\n";		//Destinatario 


//NO MODIFICAR
$dia=date("j", strtotime("$fechar"));
$mes=date("n", strtotime("$fechar"));
$anno=date("Y", strtotime("$fechar"));
$title = "PCM.- PHP CRASH MONITOR";
$ver= "1.1";
        switch($mes){
        case 1:
                $mest="Enero"; 
        break;
        case 2:
                $mest="Febrero";   
        break;
        case 3: 
                $mest="Marzo";  
        break;
        case 4: 
                $mest="Abril";
        break;
        case 5: 
                $mest="Mayo";
        break;    
        case 6:
                $mest="Junio";
        break;
        case 7:
                $mest="Julio";
        break;
        case 8:
                $mest="Agosto";
        break;
		case 9: 
                $mest="Septiembre";
        break;
        case 10:
                $mest="Octubre";
        break;
        case 11:
                $mest="Noviembre";
        break;
        case 12:
                $mest="Diciembre";
        break; 
 		exit;
		}
		$hora = date("h:i:s A");
		$fecha ="$dia de $mest de $anno";

$conexion = mysql_connect("$server","$db_user","$db_pass");
$descriptor = mysql_select_db("$database", $conexion);

$name  = "$title Ver. $ver";
 
?>