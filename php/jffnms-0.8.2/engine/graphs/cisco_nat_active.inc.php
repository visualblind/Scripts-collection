<?
/* Cisco NAT Active Binds Graph. This file is part of JFFNMS.
 * Copyright (C) <2004> Karl S. Hagen <karl_s_hagen@bankone.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function graph_cisco_nat_active ($data) { 
    extract($data);
    
    $opts_DEF = rrdtool_get_def($data,array("cisco_nat_active_binds"));

    $opts_GRAPH = array(                                    
        "LINE3:cisco_nat_active_binds#00CC00:'Cisco NAT Active Binds '",
        "GPRINT:cisco_nat_active_binds:MAX:'Max\:%5.0lf'",
        "GPRINT:cisco_nat_active_binds:AVERAGE:'Average\:%5.0lf'",
        "GPRINT:cisco_nat_active_binds:LAST:'Last\:%5.0lf \\n'"
    );

    $opts_header[] = "--vertical-label='Active NAT Binds'";

    return array ($opts_header, array_merge($opts_DEF,$opts_GRAPH));    
}
?>
