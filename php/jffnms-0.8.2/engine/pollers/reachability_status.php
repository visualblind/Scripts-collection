<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_reachability_status ($options) {

    $temp = get_config_option ("engine_temp_path");
    $buffer = $GLOBALS["session_vars"]["poller_buffer"];
    $pl = $buffer["packetloss-".$options["interface_id"]]; //get PacketLoss from reachability_pl

    unset ($temp);
    unset ($buffer);

    $num_ping = $options["pings"];
    $interval = $options["interval"];
    $threshold = $options["threshold"];

    $pl_percent = ($pl * 100) / $num_ping;
    unset ($pl);
    unset ($num_ping);
    unset ($interval);
    
    $result = "reachable";
    if ($pl_percent > $threshold) $result = "unreachable";

    $result .= "|$pl_percent% Packet Loss";

    unset ($pl_percent);
    unset ($threshold);
    
    return $result;
}
?>
