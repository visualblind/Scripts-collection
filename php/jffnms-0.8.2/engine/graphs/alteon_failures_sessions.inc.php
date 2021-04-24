<?php
/* This file is part of JFFNMS
 * Copyright (C) <2005> Craig Small <csmall@enc.com.au>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_alteon_failures_sessions($data)
{
	$opts_DEF = rrdtool_get_def($data,array('failures','total_sessions'));

	$opts_GRAPH = array(
		"CDEF:fail_pct=failures,100,*,total_sessions,/",
		"LINE3:fail_pct#FF0000:'Failures\:   '",
		"GPRINT:fail_pct:MAX:'Max\: %8.4lf %s%%'",
		"GPRINT:fail_pct:AVERAGE:'Average\: %8.4lf %s%%'",
		"GPRINT:fail_pct:LAST:'Last\: %8.4lf %s%%\\n'",
	);

	$opts_header[] = "--vertical-label='Failures by Sessions Rate'";

	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}


