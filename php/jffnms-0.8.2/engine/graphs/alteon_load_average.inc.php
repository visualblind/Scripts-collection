<?php
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_load_average($data) {

	$opts_DEF = rrdtool_get_def($data, array(
		'cpua_1sec', 'cpua_4secs', 'cpua_64secs',
		'cpub_1sec', 'cpub_4secs', 'cpub_64secs'));

	$opts_GRAPH = array(
		"LINE2:cpua_1sec#00FF00:' CPU A  1 Second Load Average'",
		"GPRINT:cpua_1sec:MAX:'Max\: %5.2lf'",
		"GPRINT:cpua_1sec:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpua_1sec:LAST:'Last\: %5.2lf\\n'",

		"LINE2:cpua_4secs#808000:' CPU A  4 Second Load Average'",
		"GPRINT:cpua_4secs:MAX:'Max\: %5.2lf'",
		"GPRINT:cpua_4secs:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpua_4secs:LAST:'Last\: %5.2lf\\n'",

		"LINE2:cpua_64secs#FFFF00:' CPU A 64 Second Load Average'",
		"GPRINT:cpua_64secs:MAX:'Max\: %5.2lf'",
		"GPRINT:cpua_64secs:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpua_64secs:LAST:'Last\: %5.2lf\\n'",

		"LINE2:cpub_1sec#0000FF:' CPU B  1 Second Load Average'",
		"GPRINT:cpub_1sec:MAX:'Max\: %5.2lf'",
		"GPRINT:cpub_1sec:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpub_1sec:LAST:'Last\: %5.2lf\\n'",

		"LINE2:cpub_4secs#800080:' CPU B  4 Second Load Average'",
		"GPRINT:cpub_4secs:MAX:'Max\: %5.2lf'",
		"GPRINT:cpub_4secs:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpub_4secs:LAST:'Last\: %5.2lf\\n'",

		"LINE2:cpub_64secs#FF00FF:' CPU B 64 Second Load Average'",
		"GPRINT:cpub_64secs:MAX:'Max\: %5.2lf'",
		"GPRINT:cpub_64secs:AVERAGE:'Average\: %5.2lf'",
		"GPRINT:cpub_64secs:LAST:'Last\: %5.2lf\\n'",

	);
	$opts_header[] = "--vertical-label='Load Average'";

	return array($opts_header, @array_merge($opts_DEF, $opts_GRAPH));
}
?>
