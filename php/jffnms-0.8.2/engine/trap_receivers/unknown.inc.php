<?
/* This file is part of JFFNMS
 * Copyright (C) <2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function trap_receiver_unknown ($params) {
    
	$info_aux = array();
	foreach($params["trap_vars"] as $id => $value)
	    $info_aux[] = $id.": ".$value;
	    
	$res = array(
	    "info" 	=> "Trap OID ".$params["trap"]["trap_oid"]." Values: ".join(", ", $info_aux),
    	    "date" 	=> date("Y-m-d H:i:s", $params["trap"]["date"]),
	    "referer" 	=> $params["trap"]["id"]
	);
        
	return array(true, $res);
    }
?>
