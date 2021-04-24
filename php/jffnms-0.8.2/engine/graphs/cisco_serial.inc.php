<?
/* Cisco Serial (Async) Port Usage Graph. This file is part of JFFNMS
 * Copyright (C) <2005> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_cisco_serial ($data) {

	$opts_DEF = rrdtool_get_def($data,array("cisco_free","cisco_dsx","cisco_async"));

	$opts_GRAPH = array(
	"AREA:cisco_free#00FF00:'Number of Connections Free         '",
	"GPRINT:cisco_free:MAX:'Max\:%5.0lf'",
	"GPRINT:cisco_free:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:cisco_free:LAST:'Last\:%5.0lf \\n'",

	"STACK:cisco_dsx#000000:'Number DSX line in use             '",
	"GPRINT:cisco_dsx:MAX:'Max\:%5.0lf'",
	"GPRINT:cisco_dsx:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:cisco_dsx:LAST:'Last\:%5.0lf \\n'",

	"STACK:cisco_async#0000FF:'Number Async line in use           '",
	"GPRINT:cisco_async:MAX:'Max\:%5.0lf'",
	"GPRINT:cisco_async:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:cisco_async:LAST:'Last\:%5.0lf \\n'"
	);

	$opts_header[] = "--vertical-label='Number of Lines'";

	return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}
?>
