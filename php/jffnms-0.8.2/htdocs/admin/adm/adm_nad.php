<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include("../../auth.php");
    
    function nad_graph_get($params) {
	global $nad, $host_id;

	$params["get_data"]=true;
        $graph = $nad->graph($params);
	
	if (count($graph) > 1) {
	    list ($graph_data, $cmap, $data) = $graph;

	    $url = $GLOBALS["REQUEST_URI"];

	    $cmap = preg_replace ("/href=\"N(\d+)\"/", "href='".$url."&nad_type=net&nad_id=\$1'", $cmap);
	    $cmap = preg_replace ("/href=\"H(\d+)\"/", "href='".$url."&nad_type=host&nad_id=\$1'", $cmap);
	    $cmap = preg_replace ("/href=\"I(\d+)\"/", "href='".$url."&view_type=html&nad_type=host&nad_id=\$1'", $cmap);

	    $path_real = get_config_option("images_real_path");
	    $path_rel  = get_config_option("images_rel_path");
	    $file_name = uniqid("map").".png";
    
	    $file_real = $path_real."/".$file_name;
	    $file_rel  = $path_rel."/".$file_name;
	
	    $fp = fopen($file_real,"w+");
	    fputs($fp, $graph_data);
	    fclose($fp);
	
	    return array($cmap, $file_rel);
	} else
	    return false;
    }
    
    function nad_ip_type($type) {
	$types = array(1=>"ICMP", 6=>"Ethernet", 22=>"Serial", 23=>"PPP", 32=>"Frame Relay", 106=>"ATM", 159=>"ATM",
	    24=>"Loopback");
	
	return (isset($types[$type])?$types[$type]:"Unknown (".$type.")");
    }

    function nad_view_host($host_id, $host, $ips, $ints) {
	
	$host_ips = array();
	$ip_types = array();
	foreach ($host["ips"] as $net=>$net_ips)
	    foreach ($net_ips as $ip) 
		if (ip2long($ip)!=-1) {
		    $nets .= 
			tr(array(
			    linktext($net, $GLOBALS["REQUEST_URI"]."&nad_type=net&nad_id=".$net), 
			    $ip,
			    (!empty($ips[$ip]["dns"])?$ips[$ip]["dns"]:"&nbsp;"),
			    nad_ip_type($ips[$ip]["type"]))
			);
		    $host_ips[] = $ip;
		    $ip_types[$ip] = $ips[$ip]["type"];
		}


	reset($ints);
	$found_ips = array();
	while (list ($id, $data) = each ($ints))
	    if (in_array($data["address"], $host_ips))
		$found_ips[$data["address"]]=array("interface"=>$id, "host"=>$data["host"]);	

	$found_text_aux = array();
	foreach ($found_ips as $ip=>$data)
	    $found_text_aux[$data["host"]] = " as Host ".
		linktext($ints[$data["interface"]]["host_name"]." ".$ints[$data["interface"]]["zone_shortname"] , 
		    "adm_standard.php?admin_structure=hosts&filter=".$data["host"]);

	$found_text = join($found_text_aux, " or ");

	$best_ip = nad_best_ip($ip_types);
        $add_url = "adm_standard.php?admin_structure=hosts&action=add".
	    "&ip=".$best_ip.
	    "&zone=".$host["zone"].
	    "&rocommunity=".$host["snmp_community"].
	    "&name=".
		trim(substr(join(" ",
		array_values(array(
		    $host["snmp_name"],
		    substr($host["description"], 0, 20),
		    $ips[$best_ip]["dns"]))),0,60));
		

	echo tr(
	    table("","host").
	    tr("Host Information", "header", 2).
	    tr(array("Name", $host["snmp_name"]), array("field", "data")).
	    tr(array("Description", $host["description"]),array("field","data")).
	    tr(array("Date Added", date("Y-m-d H:i:s", $host["date_added"])), array("field", "data")).
	    tr(array("Forwards IP Packets",(($host["forwarding"]==1)?"Yes":"No")), array("field", "data")).
	    tr(array("Already Added",(count($found_ips)==0)
		?"No, ".linktext("Add it", $add_url)
		:"Yes, ".$found_text), array("field", "data")).
	    
	    tr("IP Addresses", "header", 2).
	    tr(
		table("ips").
		tr(array("Network", "IP", "DNS", "Type"), "header").
	        $nets.
		table_close(), "", 2).
	    table_close()
	    );
    }

    function nad_view_network ($network, $net, $hosts, $ips) {	
    
	foreach ($net["hosts"] as $host_id) {
	    $host = $hosts[$host_id];
	    foreach ($host["ips"][$network] as $ip)
		$hosts_data[$ip] = 
		    tr_open("","host").
		    td (linktext($ip, $GLOBALS["REQUEST_URI"]."&nad_type=host&nad_id=".$host_id), "ip").
		    td (!empty($ips[$ip]["dns"])?$ips[$ip]["dns"]:"&nbsp;","dns").
		    td (!empty($host["snmp_name"])?$host["snmp_name"]:"&nbsp;").
		    tag_close("tr");
	}

	$host_ips = array_keys($hosts_data);
	natsort($host_ips);
	foreach ($host_ips as $ip)
	    $output .= $hosts_data[$ip];	
				
	echo tr (
	    table("net").
	    table_row("Network ".$network." Hosts", "header" , 3 ,"", false).
	    tr_open("","header").
	    td("IP","ip").td("DNS").td("SNMP Name").
	    tag_close("tr").
	    $output.
	    table_close());
    }


    function nad_view_networks($networks) {

	$cell_max = 3;

	$output = 
	    table("nets").
	    table_row("Discovered Networks", "header", $cell_max, "", false);
	
	$cant = count($networks);
	$network_names = array_keys($networks);
	natsort($network_names);
	
	foreach ($network_names as $network) {
	    $net_data = $networks[$network];

	    if ($cell==0) $output .= tr_open();
	    
	    $output .=
	        td(linktext(
		    $network, 
		    $GLOBALS["REQUEST_URI"]."&nad_type=net&nad_id=".$network).
	    	    " has ".html("b",count($net_data["hosts"]))." Hosts");

	    $cell++;
	    $shown ++;

	    if ($cell==$cell_max) {
	        $output .= tag_close("tr");
	        $cell = 0;
	    }
	}
	$output .= table_close();
	
	echo tr($output);
	
	return $shown;
    }    

    function nad_best_ip ($host_ips) {

        switch (true) {
	    case (false !== ($res = array_search(22, $host_ips))):
	    case (false !== ($res = array_search(23, $host_ips))):
	    case (false !== ($res = array_search(32, $host_ips))):
	    case (false !== ($res = array_search(106, $host_ips))):
	    case (false !== ($res = array_search(156, $host_ips))):
	    case (false !== ($res = array_search(6, $host_ips))):
	        $ip = $res;
	    break;
		
	    default:
	        $ip = current(array_keys($host_ips));
	    break;
	}

	return $ip;
    }
    
    if (!isset($action)) $action = "view";
    if (!isset($view_type)) $view_type = "html";

    $nad = $jffnms->get("nad");
    $view_all = true;
    
    switch ($action) {
    
	case "view" :

	    adm_header("Network Discovery");

	    if (!is_numeric($zone) && is_numeric($filter)) $zone = $filter;
	    
	    echo 
		script("
		function change_zone(select){
		    var zone = select.options[select.selectedIndex].value;
		    location.href = location.href+'&zone='+zone;
    		    return true;
		}").
		table("nad").
	        tr("Network Discovery", "title").
	        tr(
		    "Zone: ".select_zones("zone", $zone, array(0=>"All Zones"),"javascript: change_zone(this);").
		    control_button("Networks", "", $GLOBALS["REQUEST_URI"]."&nad_type=nets&nad_id=", "world.png").
		    control_button("All Hosts", "", $GLOBALS["REQUEST_URI"]."&nad_type=hosts&view_type=html&only_snmp=0","host.png").
		    control_button("SNMP Hosts", "", $GLOBALS["REQUEST_URI"]."&nad_type=hosts&view_type=html&only_snmp=1","host.png").
		    (($view_type=="html")
			?control_button("Map View", "", $GLOBALS["REQUEST_URI"]."&view_type=map","map2.png")
			:control_button("Text View", "", $GLOBALS["REQUEST_URI"]."&view_type=html", "text.png")).
		    control_button("Refresh", "", $GLOBALS["REQUEST_URI"],"refresh2.png").
		    control_button("Config", "", "adm_standard.php?admin_structure=zones&action=edit&filter=".$zone."&actionid=".$zone,"tool.png")

		    , "options");

	    $params = array();
	
	    if ($nad_type=="host") $params["host_id"] = $nad_id;
	    if ($nad_type=="net")  $params["net_id"]  = $nad_id;
	    if (!empty($view_all)) $params["view_all"]= $view_all;

	    if ($zone!=="0") $params["zone"]=$zone;

	    $params["bgcolor"] = "white";

	    switch ($view_type) {
		case "map":
		    $result = nad_graph_get($params);

		    if (is_array($result)) {
	    		list ($cmap, $file_rel) = $result;
	
			echo tr(
			    tag("img", "map", "", "src='".$file_rel."' usemap='#map'", false).
	    		    html("map", $cmap, "", "", "name='map'")
			    );

		    } else
	    		echo tr("Error","error");
		
		break;
		
		case "html": 
		default:
	    
		    $data = $nad->get_data($params);
		    
		    if (empty($nad_type)) {
	    	    	if (!empty($host_id)) { $nad_type = "host"; $nad_id = $host_id; }
	    	    	if (!empty($net_id))  { $nad_type = "net";  $nad_id = $net_id;  }
		    }
		    
		    list ($hosts, $ips, $networks, $net_ids) = $data;
		    
		    $shown = 0;
		    
		    if (is_array($networks))
		    switch ($nad_type) {

			case "host": 
				
			    $interfaces = $jffnms->get("interfaces");
			    $ints = $interfaces->get_all(NULL,array("type"=>4));

			    if (isset($hosts[$nad_id])) {

				$host = $hosts[$nad_id];
				nad_view_host ($nad_id, $host, &$ips, &$ints);
				$shown++;
			    }
			    
			    break;
			    

			case "hosts": 
			    if (is_array($hosts)) {

			        $interfaces = $jffnms->get("interfaces");
			        $ints = $interfaces->get_all(NULL,array("type"=>4));

				foreach ($hosts as $host_id=>$host) 
				    if (($only_snmp==0) || !empty($host["snmp_community"])) {
					echo tr_open("", "hosts");
				        nad_view_host ($host_id, $host, &$ips, &$ints);
					echo tag_close("tr");
					$shown++;
				}
			    }
			    
			    break;

			case "net":
			    if (is_numeric($nad_id)) {
				$nets_id = array_rekey ($networks, "id", "network");
				$network = $nets_id[$nad_id]["network"];
			    } else {
				$nets_id = &$networks;
				$network = $nad_id;
			    }

			    if (isset($nets_id[$nad_id])) {
				nad_view_network ($network, $networks[$network], &$hosts, &$ips);
				$shown++;
			    }
			    
			break;
			
			case "nets":
    			default:
			
			    $shown += nad_view_networks($networks);
			break;
		    } else
			echo tr ("Error", "error");
			
		    if ($shown==0) echo tr("No Items Found", "error");
		break;
	    }
	    
	    echo 
		table_close();
		
	    adm_footer;
		
    	    break;
    }
    
    adm_footer();
?>
