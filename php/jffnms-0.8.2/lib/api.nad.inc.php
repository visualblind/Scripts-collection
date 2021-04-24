<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function nad_get_data ($params = array()) {
	$query_nad = "
	    SELECT  nad_networks.network, nad_networks.id as net_id, nad_ips.ip, nad_ips.dns, nad_hosts.id as host_id, 
	    	    nad_hosts.snmp_name, nad_hosts.description, nad_hosts.forwarding, nad_ips.type as if_type,
		    nad_hosts.snmp_community, zones.id as zone, nad_hosts.date_added
	    FROM	nad_networks, nad_hosts, nad_ips, zones
	    WHERE	nad_ips.host = nad_hosts.id AND nad_ips.network = nad_networks.id and zones.id = nad_networks.seed
			AND nad_ips.id > 1 AND nad_hosts.id > 1 ".
			(!empty($params["zone"])?" AND zones.id = ".$params["zone"]:"").
			"
	    ORDER BY 	nad_networks.network, nad_hosts.date_added desc, nad_hosts.id, nad_ips.ip
	";
	$result_nad = db_query($query_nad);
    
	while ($rnad = db_fetch_array($result_nad))
	    if (strpos($rnad["network"],"/32")==false) {
    
		if (!isset($hosts[$rnad["host_id"]]))
		    $hosts[$rnad["host_id"]] = array("ips"=>array(),"snmp_name"=>$rnad["snmp_name"], 
			"description"=>$rnad["description"],"forwarding"=>$rnad["forwarding"], 
			"snmp_community"=>$rnad["snmp_community"], 
			"zone"=>$rnad["zone"], "date_added"=>$rnad["date_added"]);
	
	        $ips[$rnad["ip"]]["dns"] = $rnad["dns"];
	        $ips[$rnad["ip"]]["type"] = $rnad["if_type"];
	
		$hosts[$rnad["host_id"]]["ips"][$rnad["network"]][]=$rnad["ip"];
	        $networks[$rnad["network"]]["id"]=$rnad["net_id"];
	        $networks[$rnad["network"]]["zone"]=$rnad["zone"];
		$networks[$rnad["network"]]["hosts"][] = $rnad["host_id"];
	        $net_ids[$rnad["net_id"]]=$rnad["network"];
	    }

	$result = array($hosts, $ips, $networks, $net_ids);
	return $result;
    }
    
    function nad_graph_host_id ($id, &$hosts) {
	return (($hosts[$id]["forwarding"]==1)?"H":"I").$id;
    }
    
    function nad_graph_host ($id, $hosts, $ips) {

	$idg = nad_graph_host_id($id, &$hosts);

	$top = $hosts[$id]["snmp_name"];
	$a = $hosts[$id]["ips"];
	$b = @current($a);
	$c = @current($b);
	$bottom = $c;
	if (empty($top)) $top = $ips[$bottom]["dns"];
	$top = current(explode(".",$top));

	if (empty($top)) $top = "Host";

	$text = "\t$idg\t[shape=record, label=\" { $top | $bottom } \", URL=\"$idg\", style=filled ".
		"color=".	(($hosts[$id]["forwarding"]==1)?"black":		"dodgerblue1").",".
		"fillcolor=".	(($hosts[$id]["forwarding"]==1)?"mediumseagreen":	"dodgerblue1").",".
		"fontcolor=".	(($hosts[$id]["forwarding"]==1)?"black":		"white").
		"]";
		
	return array($idg, $text);
    }

    function nad_graph_net ($id, $name) {
	$idg = "N$id";
	$text = "\tN$id\t[shape=doubleoctagon, label=\"$name\", URL=\"$idg\", color=black, style=filled, fillcolor=green]";

	return array($idg, $text);
    }

    function nad_graph_data ($graph) {

	$graph_output = join("\n",array_unique($graph));
	
	$neato_path = get_config_option("neato_executable");
        $path_real = get_config_option("engine_temp_path");
    
        $file = uniqid(rand());
	$file_real = $path_real."/".$file;
        $file_dot = $file_real.".dot";
	$file_cmap = $file_real.".cmap";
	$file_real_png = $path_real."/".$file.".png";

	$fp = fopen ($file_dot,"w+");
        fputs($fp, $graph_output);
	fclose($fp);

        $command = "$neato_path -Tpng -o $file_real_png $file_dot";
	exec($command);
    
        $command = "$neato_path -Tcmap -o $file_cmap $file_dot";
	exec($command);
    
        $cmap = join("",file($file_cmap));

        unlink($file_cmap);
	unlink($file_dot);
	
	$graph_data = join("",file($file_real_png));
    
	return array($graph_data, $cmap);
    }

    function nad_graph_init ($bgcolor = "white") {

	return array(
	"graph A {
	    ratio=compress;
	    overlap=false;
	    center=true;
	    bgcolor=$bgcolor;
	    node [fontsize=8, width=0.25, height=0.125, fontname=Helvetica, fixedsize=false];
	    edge [fontname=Helvetica, labeldistance=3, labelfontsize=7];
	");
    }

    function nad_graph_by_host ($hosts, $ips, $networks, $host_id="", $show_all = 0) {

	$hosts_ids = array();

	if (isset($host_id))
	    $hosts1 = array($host_id=>$hosts[$host_id]);
	else
	    $hosts1 = $hosts;
	    
	if (is_array($hosts1))
	while (list ($host_id, $host_data) = each ($hosts1)) 
	    if (($host_data["no_more"] < 1) && (count($host_data["ips"]) > 1))
		    foreach ($host_data["ips"] as $net=>$net_data)
			if (nad_get_bitmask($net) < 30)
			    $host_cnx[$host_id]["networks"][$net]=1;
			else { 
			    $aux = $networks[$net]["hosts"];
			
			    if (count($aux)==2) {
				unset ($aux[array_search($host_id,$aux)]);
			        $other_host_id = current($aux);
			    
				if ((count($hosts[$other_host_id]["ips"]) > 1) || ($show_all==1)) {
				    $host_cnx[$host_id]["hosts"][$other_host_id]=$net;
				
				    if (!isset($hosts1[$other_host_id]) || ($show_all==1)) {
					$hosts1[$other_host_id]=$hosts[$other_host_id];
				        $hosts1[$other_host_id]["no_more"]=1;
					$host_cnx[$other_host_id]=array();
				    }
				}
			    }
			}

	if (is_array($host_cnx))
	foreach ($host_cnx as $host_id=>$host_data) {
	    
	    list ($host_idg, $graph[]) = nad_graph_host($host_id, &$hosts, &$ips);
	    
	    if (isset($host_data["networks"]))
	    foreach ($host_data["networks"] as $net=>$aux) {
		
		list($net_idg, $graph[]) = nad_graph_net($networks[$net]["id"],$net);
	    
		$graph[] = "$host_idg -- $net_idg";
	    }

	    if (isset($host_data["hosts"]))
		foreach ($host_data["hosts"] as $host2_id=>$net)
		    $graph[] = "$host_idg -- ".nad_graph_host_id($host2_id, &$hosts);
        }
	
	return $graph;
    }

    function nad_graph_by_network ($hosts, $ips, $networks, $network = "") {

	$hosts_ids = array();
	
	$net_cnx[$network]=$networks[$network];
	while (list ($net1,$aux1) = each ($net_cnx))
	    if ($aux1["no_more"] != 1)
    	    foreach ($aux1["hosts"] as $aux2=>$host_id) 
		foreach ($hosts[$host_id]["ips"] as $net2=>$aux3)
	    	    if ($net1!=$net2)
			if ((nad_get_bitmask($net2) < 30) && ($net2!=$network)) 
			    $net_cnx[$net2]=array("hosts"=>array($host_id));
			else {
			    $net_cnx[$net2]["hosts"] = $networks[$net2]["hosts"];
			    $net_cnx[$net2]["no_more"]=1;
			}
	    
	reset($net_cnx);
	foreach ($net_cnx as $net1=>$aux)
	    if (nad_get_bitmask($net1)==30) {
	        if (count($aux["hosts"])==2) {
	    	    $h1 = $aux["hosts"][0];
	    	    $h2 = $aux["hosts"][1];
		    $graph[] = nad_graph_host_id($h1,&$hosts)." -- ".nad_graph_host_id($h2,&$hosts)." [headlabel=\"$net1\"]";

		    $hosts_ids[$h1]=1;
		    $hosts_ids[$h2]=1;
		}
	    } else {
		list ($net1_idg, $graph[]) = nad_graph_net($networks[$net1]["id"], $net1);

		foreach ($aux["hosts"] as $host_id) {
		    $graph[] = "$net1_idg -- ".nad_graph_host_id ($host_id, &$hosts);
		    $hosts_ids[$host_id]=1;
		}
	    }

    	foreach ($hosts_ids as $host_id=>$aux)
	    list(,$graph[]) = nad_graph_host($host_id, &$hosts, &$ips);

	return $graph;
    }

    function nad_get_bitmask ($prefix) {
	list (,$mask) = explode ("/",$prefix);
	return $mask;
    }

    function nad_graph_finish() {
	return array("}");
    }

    function nad_graph($params = array()) {

	if (!is_array($params["data"]))    
    	    $params["data"] = nad_get_data();

	list ($hosts, $ips, $networks, $net_ids) = $params["data"];

        if (isset($params["net_id"]))
    	    $params["network"] = $net_ids[$params["net_id"]];

	$graph_init = nad_graph_init($params["bgcolor"]);

	if (isset($params["network"]))
	    $graph_core = nad_graph_by_network (&$hosts, &$ips, &$networks, $params["network"]);
	else 
	    $graph_core = nad_graph_by_host (&$hosts, &$ips, &$networks, $params["host_id"], $params["view_all"]);

        $graph_finish = nad_graph_finish();

	if (count($graph_core)!=0) {

	    $graph = array_merge($graph_init, $graph_core, $graph_finish);
	
	    $output = nad_graph_data($graph);

	    if ($params["get_data"]==true) $output[]=$params["data"];
	    
	    return $output;
	} else
	    return false;
    }

?>
