<?
/* HOST-MIB Sensors implentation as part of JFFNMS.
 * Information from: http://people.redhat.com/harald/snmp-lmsensors/HOWTO-SENSORS-SNMPD.html
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function discovery_sensors ($ip,$community, $host_id, $param) {
         
	$sensors = array();
	
	$hrSensorEntry 	= ".1.3.6.1.2.1.25.8.1";
	$hrSensorMapping= $hrSensorEntry.".1";
	$hrSensorName	= $hrSensorEntry.".3";
	$hrSensorLabel	= $hrSensorEntry.".4";
	$hrSensorValue	= $hrSensorEntry.".5";

	if ($ip && $community && $host_id) { //check for required values

	    $mappings = snmp_walk ($ip, $community, $hrSensorMapping, INCLUDE_OID_1);

	    if (is_array($mappings)) {

        	$labels = snmp_walk ($ip, $community, $hrSensorLabel, INCLUDE_OID_1);
		$names  = snmp_walk ($ip, $community, $hrSensorName,  INCLUDE_OID_1);
		$values = snmp_walk ($ip, $community, $hrSensorValue, INCLUDE_OID_1);

		while (list ($key,$mapping) = each ($mappings))
		    if (($mapping=="-1") && 	// Its a parent sensor
			isset($values[$key]))	// it has a value

			$sensors[$key] = array (
			    "interface" => "Sensor ".$names[$key],
		    	    "description" => $labels[$key],
		    	    "oper" => "up"
			);
	    }
	}

	return $sensors;
    }
?>
