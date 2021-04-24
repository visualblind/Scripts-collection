<?php
/* Brocade Sensor Values. This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_brocade_sensor($data) {

	switch($data['sensor_type']) {
		case 'fan':
			$legend = 'Speed';
			$vlabel = 'RPM';
			$graph_type='LINE2';
			$colour='FF00FF';
			break;
		case 'temperature':
			$legend = 'Temperature in DegC';
			$vlabel = 'Degrees C';
			$graph_type='AREA';
			$colour='FF0000';
			break;
		case 'power':
			$legend = 'Power';
			$vlabel = 'Volts?';
			$graph_type='AREA';
			$colour='FF0000';
			break;
		default:
			return;
	}
	$opts_DEF = rrdtool_get_def($data,array('value'=>'sensor_value'));
	$opts_GRAPH = array(
		"$graph_type:value#$colour:'$legend\:'",
		"GPRINT:value:MAX:'Max\:%5.0lf'",
		"GPRINT:value:AVERAGE:'Average\:%5.0lf'",
		"GPRINT:value:LAST:'Last\:%5.0lf \\n'"
		);
	$opts_header[] = "--vertical-label='$vlabel'";

	return array($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}

