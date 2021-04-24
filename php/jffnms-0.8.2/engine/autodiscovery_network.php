<?
/* Network Autodiscovery. This file is part of JFFNMS
 * Copyright (C) <2004-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $launcher_function = "discovery_network";
    $launcher_item_source = "nad_core";
    $launcher_init = "nad_init";
    $launcher_child_status ="nad_status";
    $launcher_status = "show_networks";

    $launcher_param_managed_handler = "nad_params_managed";
    
    $refresh_items = true;
    $refresh_time = 10;
    
    $timeout = 60*4;
    //$launcher_detach = false;

    require ("launcher.inc.php");

//-=-=-=-=-==-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    function nad_load_ips() {    

	$query_ips = "SELECT ip, type FROM nad_ips WHERE id > 1";
	$result_ips = db_query ($query_ips) or die ("Query Error - ".db_error());
    
	$ips = array();
	
	while ($rip = db_fetch_array ($result_ips)) 
	    $ips[$rip["ip"]] = $rip["type"];
    
	return $ips;
    }

    function ip_to_str2 ($ip_ip) {
	$ip_bin = decbin($ip_ip);
	$ip_bin = str_pad($ip_bin,32,"0",STR_PAD_LEFT);
	$parte1 = substr($ip_bin,0,8);
        $parte2 = substr($ip_bin,8,8);
	$parte3 = substr($ip_bin,16,8);
        $parte4 = substr($ip_bin,24,8);
	$string = bindec($parte1).".".bindec($parte2).".".bindec($parte3).".".bindec($parte4);
	return $string;
    }

    function str_to_ip ($strIP){
        $Arr = explode (".",$strIP);
	return ($Arr[3] + $Arr[2] * pow(2,8) + $Arr[1] * pow(2,16) + $Arr[0] * pow(2,24));
    }

    function ip_to_bitsmask ($mask){
	$r = pow(2,32) - $mask;
        $ret = round (32 - (log($r + 1)/log(2)));
	return $ret;
    }
    
    function bitsmask_to_mask ($bmask) {
	$b = round(pow(2,32) - pow(2,32 - $bmask));
	$b = ip_to_str2 ($b);
	return $b;
    }
    
    function ip_same_network ($ip1, $ip2, $mask) {
	$mask_bit = str_to_ip($mask);
    
	$ip1_bit = str_to_ip($ip1);
	$ip2_bit = str_to_ip($ip2);

	$net1_bit = $ip1_bit & $mask_bit;
	$net2_bit = $ip2_bit & $mask_bit;
    
	if ($net1_bit == $net2_bit) return true;
	
	return false;
    }

    function nad_private_net ($ip) {
	$private_nets = array("10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "127.0.0.0/8", "192.169.0.0/16");
	
	foreach ($private_nets as $priv) {
	    list ($private_net, $private_mask) = explode ("/", $priv);
	    list ($net, $net_mask) = explode ("/", $ip);
	    
	    if  (
		(ip_same_network($net, $private_net, bitsmask_to_mask($private_mask))) ||	// base net is the same network as a private net
		(ip_same_network($net, "0.0.0.0", bitsmask_to_mask($net_mask)))			// base net is 0.0.0.0
		)
		return true;
	}
	
	return false;
    }

    function nmap_pipe ($target, $data) {
    
	if (!is_array($data[$target])) {
    	    $data[$target]["res"] = proc_open(
		get_config_option("nmap_executable"). " -sP -PB --randomize_hosts -T3 -iL - -oG -",
                array(0=>array("pipe","r"), 1=>array("pipe","w"), 2=>array("pipe","r")), $data[$target]["pipes"]);

	    fwrite($data[$target]["pipes"][0], $target."\n");
	    fclose($data[$target]["pipes"][0]);
	}
	
	if (false !== ($ret = fgets($data[$target]["pipes"][1]))) 
	    if ($ret != "# Nmap run completed")
		return rtrim($ret,"\n");

	return false;
    }

    function discovery_network ($network, $output = true) {

	$nad_time_start = time();
	$hosts_up = 0;
	$hosts_unique = 0;
	
	$net_data = current(nad_load_networks($network));
	
	if (!$output) ob_start();
	
	logger ("N ".str_pad($net_data["id"], 4)." : ".
		"Scanning Network ".$network.", deep ".$net_data["deep"]."\n");	
	
	nad_network_status ($net_data["id"], 2); //Running

	while ($line = nmap_pipe($network, &$nmap_data)) 
	    if (preg_match ("/Host\: (.*) \((.*)\).*Status\: (.*)/", $line ,$parts)) {

		if (!$output) launcher_heartbeat(); 

		$host_ip = trim($parts[1]);
		$host_name = $parts[2];
		    
		$log =  "N ".str_pad($net_data["id"], 4)." : Scanning Host ".$host_ip;
		
		$host_ip_parts = explode(".",$host_ip);
		
				
		if (($host_ip_parts[3]!=0) && ($host_ip_parts[3]!=255)) {
		    if ($parts[3]=="Up") {
			$hosts_up++;
			
			if (array_key_exists($host_ip, nad_load_ips())==false) {

			    $host_id = nad_add_host ();
			    $hosts_unique++;

			    logger ($log." Responded to Ping added as H $host_id\n");
		
			    $ip_id = nad_add_ip ($host_ip);
			
			    $ips_found = discovery_host ($host_id, $host_ip, $net_data["communities"], $net_data, $ip_id);
		    
			    if (!$ips_found)
				nad_update_ip ($ip_id, $host_name, $host_id, $net_data["id"]);
			
			} else
			    logger ($log." Already Added\n");
		    } else
			logger ($log." Down\n");
		} else
		    logger ($log." Invalid\n");
	    }

	nad_network_status ($net_data["id"], 3); //done
	
	ob_end_clean();
	
	return array("OK", $hosts_up, $hosts_unique, time()-$nad_time_start);
    }

    function discovery_host ($host_id, $host_ip, $communities, $net, $host_ip_id) {

	$system_description_oid = ".1.3.6.1.2.1.1.1.0";
	$system_name_oid 	= ".1.3.6.1.2.1.1.5.0";
        $ipadent_oid = ".1.3.6.1.2.1.4.20.1.1";
	$ipadentmask_oid = ".1.3.6.1.2.1.4.20.1.3";
        $ipadentint_oid = ".1.3.6.1.2.1.4.20.1.2";
	$inttype_oid = ".1.3.6.1.2.1.2.2.1.3";
	$ipforwarding_oid = ".1.3.6.1.2.1.4.1.0";
	$ipnettomedia_oid = ".1.3.6.1.2.1.4.22.1.2";
	$intstatus_oid = ".1.3.6.1.2.1.2.2.1.8";

	$invalid_ips = array("127.0.0.1","0.0.0.0");
	if (!is_array($communities)) $communities = array();
	
	$result = false;

	while ((list (, $comm) = each ($communities)) && (!$snmp_name))
	    
	    if (($snmp_name = snmp_get($host_ip, $comm, $system_name_oid, 1))!==false) {

		$log =  "N ".str_pad($net["id"], 4)." : H ".str_pad($host_id,3)." : ";
		logger ($log." Has SNMP $comm - $snmp_name\n");

		$snmp_ips_data = snmp_walk ($host_ip, $comm, $ipadent_oid);

		if ($snmp_ips_data!==false) {

		    $host_ips = array();

		    // Create IPs Table
		    foreach ($snmp_ips_data as $key=>$aux_ip) {
			list(,$aux_ip) = explode (" ",$aux_ip);

			if (!in_array($aux_ip,$invalid_ips)) {

			    if ($aux_ip!=$host_ip) 					// If IP is different than the host IP
				$ip_id = nad_add_ip($aux_ip);				// Add IP to DB
			    else
				$ip_id = $host_ip_id;					// Use ID of the Already added IP
				
			    $host_ips[$aux_ip] = array("ip_id"=>$ip_id , "pos"=>$key); 	//add IP to the Array
			}
		    }
		    unset ($snmp_ips_data);

		    // Do other SNMP reads
		    $snmp_mask_data = snmp_walk ($host_ip, $comm, $ipadentmask_oid);
		    $snmp_int_data  = snmp_walk ($host_ip, $comm, $ipadentint_oid);

		    // Populate the IPs table with Mask and Type data
		    foreach ($host_ips as $aux_ip=>$ipd) {
	
			list(,$aux_mask) = explode (" ",$snmp_mask_data[$ipd["pos"]]);
			if (empty($aux_mask)) $aux_mask = "255.255.255.0"; // Fix for broken IP-MIB implementations
					
			$if_index = $snmp_int_data[$ipd["pos"]];
			list(,$if_status) = split("[()]",snmp_get($host_ip, $comm, $intstatus_oid.".".$if_index));
			
			//$if_status = 1;
			if ($if_status == 1) { // Its UP
			    unset ($if_type);
			    list(,$if_type) = split("[()]",snmp_get($host_ip, $comm, $inttype_oid.".".$if_index));
			    
			    $host_ips[$aux_ip]["mask"] = $aux_mask;
			    $host_ips[$aux_ip]["type"] = $if_type;
			
			} else {	// Its Down
			
			    nad_del_ip($host_ips[$aux_ip]["ip_id"]);  	// Delete the IP from the DB
			    unset ($host_ips[$aux_ip]);			// remove it from the list used to add networks
			}
		    }
		    unset ($snmp_mask_data);
		    unset ($snmp_int_data);

		    // Add other IP addresses based on the ARP table (mine not remote)
		    $snmp_physical  = snmp_walk ($host_ip, $comm, $ipnettomedia_oid, 1);

		    if ($snmp_physical != false) {
			
			$snmp_net_to_media = array();	
		    
		        // Make Net-To-Media Table
			foreach ($snmp_physical as $k=>$aux_mac) {
			    $k = explode (".",$k);
			    $aux_ip = join(".",array_slice($k,count($k)-4,4));
			    $snmp_net_to_media[$aux_ip]=$aux_mac;
			    $snmp_media_to_net[$aux_mac][]=$aux_ip;
		        }
			unset ($snmp_physical_data);
		    
			// Find out if there are others ips on the same network with my IP's MAC address (more than 1 IP on the same network)
		        // And add it to the IPs list
			foreach ($host_ips as $ip=>$ipd)
			    if (array_key_exists($ip, $snmp_net_to_media))
				foreach ($snmp_media_to_net[$snmp_net_to_media[$ip]] as $new_ip) 
				    if (!array_key_exists($new_ip,$host_ips) && ip_same_network($ip, $new_ip, $ipd["mask"])) {
					
					$host_ips[$new_ip] = $ipd; 				//copy the other type and mask
					$host_ips[$new_ip]["ip_id"] = nad_add_ip ($new_ip);	//put in my own IP id
				    }
				    
			unset ($snmp_net_to_media);
			unset ($snmp_media_to_net);
		    }
		    
		    foreach ($host_ips as $ip=>$ipd) {
		    
		    	$ipd["dns"] = gethostbyaddr($ip);		// Resolve Reverse DNS for this IP
			if ($ipd["dns"]==$ip) unset ($ipd["dns"]); 	// Do not add the DNS if this IP doesn't have a reverse

			logger ($log." Has IP $ip - ".$ipd["mask"]." - ".$ipd["dns"]."\n");
			
			$new_net_id = nad_add_network ($ip, $ipd["mask"], $net["deep"]+1, $net["id"], $net["seed"]);

			if (!is_numeric($new_net_id)) $new_net_id = $net["id"];
			    
			nad_update_ip ($ipd["ip_id"], $ipd["dns"], $host_id, $new_net_id, $ipd["type"]);	// Update the IP DB

			$result = true; //we found some ip's
		    }
		}	

		// Get Description
		$snmp_description = snmp_get ($host_ip, $comm, $system_description_oid);

		// Findout if the Host has IP Forwarding (Router) Enabled
		list(,$host_forwarding) = split("[()]",snmp_get($host_ip, $comm, $ipforwarding_oid));
	
		if ($host_forwarding==2) $host_forwarding = 0;
		
		// Update Host information
		nad_update_host ($host_id, array("description"=>$snmp_description, "snmp_name"=>$snmp_name,
			"snmp_community"=>$comm, "forwarding"=>$host_forwarding));
	    }

	return $result;
    }


    function nad_add_network ($ip, $mask, $deep, $parent_net, $seed_id, $id=NULL) {

	if (empty($mask)) { // /24
	    list($ip, $bitmask) = explode("/",$ip);
	    $mask = bitsmask_to_mask ($bitmask);
	}
    
	    $ip_bit = str_to_ip($ip);
	    $mask_bit = str_to_ip($mask);

	    $net_bit = $ip_bit & $mask_bit;
	    $net = ip_to_str2 ($net_bit);

	    if ($net != "127.0.0.0") {
		$oper_status = 0;

		$mask_prefix = ip_to_bitsmask ($mask_bit);
	    
		if ($mask_prefix < 22) $mask_prefix = 22;
		
		if ($mask_prefix == 31) $mask_prefix = 32;
	
		if (($mask_prefix == 32) && ($parent_net!=1)) $oper_status = 3;
	    
		$aux ="$net/$mask_prefix";
	
		$networks = nad_load_networks();
		
		/*
		logger ("***** Trying to add Path to network $aux ".
		    (isset($networks["aux"])?"(Alredy added as ".$networks["aux"]["id"].") ":"").
		    "via NET_ID $parent_net, Deep $deep\n");
		*/
		
		if (!isset($networks[$aux]))
		    return db_insert("nad_networks",array("network"=>$aux, "deep"=>$deep, "parent"=>$parent_net, 
			"oper_status"=>$oper_status, "seed"=>$seed_id, "oper_status_changed"=>time(), "id"=>$id));
		else
		    return $networks[$aux]["id"];	// return the network id
	    }
    }

    function nad_load_networks($network="") {    

	$query_networks = "
	    SELECT nad_networks.*, zones.max_deep, zones.communities, zones.admin_status, zones.refresh, zones.allow_private
	    FROM nad_networks, zones
	    WHERE nad_networks.id > 1 AND nad_networks.seed = zones.id ".(!empty($network)?" AND network = '$network'":"");
	$result_networks = db_query ($query_networks) or die ("Query Error - ".db_error());
    
	$networks = array();
	
	while ($rnet = db_fetch_array ($result_networks))
	    $networks[$rnet["network"]] = array ("deep"=>$rnet["deep"], 
		"oper_status"=>$rnet["oper_status"], "admin_status"=>$rnet["admin_status"], "parent"=>$rnet["parent"],
		"id"=>$rnet["id"], "communities"=>explode(",",$rnet["communities"]), "max_deep"=>$rnet["max_deep"],
		"seed"=>$rnet["seed"], "oper_status_changed"=>$rnet["oper_status_changed"], "refresh"=>$rnet["refresh"],
		"allow_private"=>$rnet["allow_private"]);

	return $networks;
    }

    function nad_add_ip ($ip, $dns = "", $host = 1, $network = 1, $type = 1) {
	$data = compact("ip","dns","host","type","network");
	return db_insert ("nad_ips",$data);
    }

    function nad_update_ip ($ip_id, $dns, $host, $network, $type = 1) {
	$data = compact("ip","dns","host","type","network");
	return db_update ("nad_ips",$ip_id, $data);
    }

    function nad_del_ip ($ip_id) {
	return db_delete ("nad_ips",$ip_id);
    }

    function nad_add_host () {
	return db_insert ("nad_hosts",array("date_added"=>time()));
    }	

    function nad_update_host ($host_id, $host_data) {
	return db_update("nad_hosts", $host_id, $host_data);
    }

    function nad_network_status($net_id, $status) {
	return db_update("nad_networks",$net_id, array("oper_status"=>$status, "oper_status_changed"=>time()));
    }

    function nad_cleanup_network ($net_id) {
	$hosts_query = "
	    SELECT nad_hosts.id 
	    FROM nad_hosts, nad_ips 
	    WHERE nad_ips.host = nad_hosts.id AND nad_ips.network = ".$net_id;
	$hosts_result = db_query ($hosts_query) or die ("Query Error - ".db_error());

	$hosts = array();
	while ($rhost = db_fetch_array($hosts_result))
	    $hosts[]=$rhost["id"];
    
	if (count($hosts) > 0) {
	    $hosts_query = "DELETE FROM nad_hosts WHERE id = ".join(" OR id = ",$hosts);
	    $hosts_result = db_query ($hosts_query) or die ("Query Error - Hosts Delete - ".db_error());
	}
	
	$ips_query = "DELETE FROM nad_ips WHERE network = ".$net_id;
	$ips_result = db_query ($ips_query) or die ("Query Error - IPs Delete - ".db_error());

	$net_query = "DELETE FROM nad_networks WHERE id = ".$net_id;
	$net_result = db_query ($net_query) or die ("Query Error - Net Delete - ".db_error());

	db_repair("nad_networks");
	db_repair("nad_hosts");
	db_repair("nad_ips");

	return ($ips_result && $hosts_result && $net_query);
    }

    function nad_params_managed($params) {
	$params[1] = false;
	return $params;
    }

    function nad_load_seeds ($networks = array()) {

	$seeds_query = "SELECT id, seeds, refresh FROM zones where id > 1 and seeds != '' and admin_status = 1";
	$seeds_result = db_query ($seeds_query) or die ("Query Error - ".db_error());

	$something_changed = false;

	while ($rseed = db_fetch_array($seeds_result)) { 	//read each seed
	    $seeds = explode (",",$rseed["seeds"]);

	    foreach ($seeds as $seed) {				//foreach seed
		$seed = trim($seed);

		$total_seeds++;
		
		if (!isset($networks[$seed])) {			//if its not already in the networks list
		    nad_add_network($seed,"",1,1,$rseed["id"]);	//its new, then add it to the DB.
		    $something_changed = true;			//tell the caller that something has changed
		} 
	    }
	}

	if ($total_seeds==0) $something_changed = true;
	
	return $something_changed;	
    }

    function nad_init () {

	db_repair("nad_networks");
	db_repair("nad_hosts");
	db_repair("nad_ips");

	nad_load_seeds(nad_load_networks());
	
	return true;
    }

    function nad_status ($child, $result) {
    
	list (,$status, $hosts_total, $hosts_new, $time) = explode (" ", $result);
	
	$ok = $status=="OK"?true:false;
	
	logger (
	    "NAD ".$child["pid"]." ".
	    ($ok
	    ?"finished discovering network ".$child["item"]." in ".time_hms($time).", Hosts $hosts_new/$hosts_total"
	    :"failed when discovering network ".$child["item"].": ".$result)
	.".\n");

	return $ok;
    }

    function show_networks () {
    
	$network_admin_status=array(0=>"stopped","started");

	$network_oper_status=array(0=>"pending",1=>"starting",2=>"running",3=>"done", 4=>"other path", 5=>"error");
	
	$networks = nad_load_networks();
	
	logger ("Number      Network          Deep/Max         Status       Changed           IDs\n");

	foreach ($networks as $network=>$net_data) {
	    logger (
		str_pad(++$i,5," ",STR_PAD_LEFT).
		"\t".str_pad($network,18).
		"\t".str_pad($net_data["deep"]."/".$net_data["max_deep"],7).
		str_pad($network_admin_status[$net_data["admin_status"]].
		"/".$network_oper_status[$net_data["oper_status"]],16).
		" ".str_pad((time()-$net_data["oper_status_changed"])." secs ago",15," ",STR_PAD_LEFT).
		"\tNID ".str_pad($net_data["id"],5).
		"PID ".$net_data["parent"].
		"\n");
	}

	logger(str_repeat("=-",45)."\n");
    }
    
    function nad_core () {
    	global $pending_items, $timeout;

	$pending = array();
	$nets = nad_load_networks();

	while (list($network, $net_data) = each ($nets)) {

	    if (($net_data["admin_status"]==1) &&					// admin up 
		($net_data["deep"] <= $net_data["max_deep"]))	{			// deep is less than max deep

		// First Start
		if ($net_data["oper_status"]==0)				// oper status pending
		    if (($net_data["allow_private"]==1) || !nad_private_net($network)) {// seed allows private or this IP is not private

	    	        nad_network_status ($net_data["id"], 1); 			// mark it as Starting
    
			logger("Changing Network ".$network." status to Starting.\n");

		        $pending[]=$network;

		    } else {								//Private IP

			nad_network_status ($net_data["id"], 5); 			// mark it as error
		        logger("Discarded Network $network, because its private space.\n");
		    }	

		// Hanged Starting
		if (($net_data["oper_status"] == 1) && 					// oper starting
		    (time()-$net_data["oper_status_changed"] > $timeout)) {		// it didn't start correctly 

		    nad_network_status ($net_data["id"], 0); 				// mark it as Pending
		    logger("Changed Network $network to Pending, because it was hanged starting\n");
		} 

		// Hanged Running
		if (($net_data["oper_status"] == 2) && 					// if its Running
		    !isset($pending_items[$network])) {					// and its not in the pending list
		
		    nad_network_status ($net_data["id"], 5); 				// mark it as error
		    logger("Changed Network $network to Error, because it was hanged running\n");
		}

		// Refresh
		if (($net_data["oper_status"] >= 3) && 					// oper done or error
		    (time()-$net_data["oper_status_changed"] > $net_data["refresh"])) {	// and has been for more time than refresh
	
		    logger ("Cleaning Network ".$network."\n");
		    nad_cleanup_network ($net_data["id"]);				// Cleanup this network data
		
		    logger("Reloading Network ".$network."\n");
		    nad_add_network ($network, "", $net_data["deep"], $net_data["parent"], $net_data["seed"], $net_data["id"]);

		    $net_data["oper_status"] = 0;					// do not count as done now
		}
	    } else 								// Admin Down or Max Deep	
		if ($net_data["oper_status"] != 5) {				// Not already Error

    		    nad_network_status ($net_data["id"], 5); 			// mark it as error
		    logger("Discarded Network $network, because its admin/down or out of reach because of deep.\n");
		}	
	
	    // Done or Error
	    if (($net_data["oper_status"] == 3) || ($net_data["oper_status"] == 5))	// if its Done or Error
		$done_networks++;
	}
	
	if ((count($pending)==0) && ($done_networks==count($nets)))			// Nothing else to do
	    $GLOBALS["refresh_items"] = false;						// stop refreshing the list/exit

	return $pending; 
    }

?>
