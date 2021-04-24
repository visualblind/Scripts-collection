<?
/* Livingston Portmaster Serial Graph. This file is part of JFFNMS
 * Copyright (C) <2004> Javier Szyszlican <javier@szysz.com>
 * Copyright (C) <2004> Thomas Mangin <thomas.mangin@exa-networks.co.uk>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_pm_serial ($data) {

    $opts_DEF = rrdtool_get_def($data,array("pm_serial_free","pm_serial_connecting","pm_serial_established","pm_serial_disconnecting","pm_serial_command","pm_serial_noservice"));

    $opts_GRAPH = array(
	"AREA:pm_serial_free#00FF00:'Number of Connections Free          '",
 	"GPRINT:pm_serial_free:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_free:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_free:LAST:'Last\:%5.0lf \\n'",

	"STACK:pm_serial_connecting#000066:'Number of Connections               '",
	"GPRINT:pm_serial_connecting:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_connecting:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_connecting:LAST:'Last\:%5.0lf \\n'",

	"STACK:pm_serial_established#0000FF:'Number of Connections Established   '",
	"GPRINT:pm_serial_established:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_established:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_established:LAST:'Last\:%5.0lf \\n'",

	"STACK:pm_serial_disconnecting#006666:'Number of Disconnections            '",
	"GPRINT:pm_serial_disconnecting:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_disconnecting:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_disconnecting:LAST:'Last\:%5.0lf \\n'",

	"STACK:pm_serial_command#FF0000:'Number in Command                   '",
	"GPRINT:pm_serial_command:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_command:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_command:LAST:'Last\:%5.0lf \\n'",

	"STACK:pm_serial_noservice#000000:'Number in No Service                '",
	"GPRINT:pm_serial_noservice:MAX:'Max\:%5.0lf'",
	"GPRINT:pm_serial_noservice:AVERAGE:'Average\:%5.0lf'",
	"GPRINT:pm_serial_noservice:LAST:'Last\:%5.0lf \\n'"
    );

    $opts_header[] = "--vertical-label='Number of Lines'";

    return array ($opts_header, @array_merge($opts_DEF,$opts_GRAPH));
}
?>
