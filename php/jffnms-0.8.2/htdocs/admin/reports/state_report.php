<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php"); 

    if (!$view_mode) $view_mode = "html";
    
    if (!profile("VIEW_REPORTS") && (!$client_id)) die ("<H1> You dont have Permission to access this page.</H1></HTML>");

    if ($view_mode=="html") {
	adm_header("State Report");    
    }
    
    if ($view_mode=="csv")
	echo tag("pre").
	    "# Save this file as .txt and then open it on your Spreadsheet, import it as CSV (Comma Separated Values)\n".
	    "Interface Description,RTT msec.,Packet Loss %,Unavailable Time,Availability %".
	    (($detail)?",Start,Stop,Duration,Type,Counted":"")."\n";

    if ($interface_id) unset($use_interfaces); //dont use use_interfaces if only one is asked for

    $object = $jffnms->get("interfaces");
    
    unset($types_url);
    
    //generate the URL
    if (is_array($types))
	foreach ($types as $value) 
	    $types_url .= "&types[]=".$value;
    else 
	$types = array(3,6,22,38); //by default select only this ids FIXME
    
    $today = date("Y-m-d",time());
    $yesterday = date("Y-m-d",time()-(60*60*24));
    $seconds_today = time()-strtotime($today);

    $seconds_today = round(($seconds_today/1800))*1800; //take half hour
    
    if (!$date_from) $date_from = $yesterday;
    if (!$date_to) $date_to = $today;

    if (!$date_from_hour)
	if ($seconds_today < (60*60*12)) { //12am pivot
	    $date_from_hour=$seconds_today;
	    $date_to_hour=$date_from_hour;
	} else
	    $date_from_hour=0;

    if (!$date_to_hour) $date_to_hour=$seconds_today; //was 0, set to now
    
    $date_from_unix = strtotime($date_from) + $date_from_hour;
    $date_to_unix = strtotime($date_to) + $date_to_hour;

    //debug ("$seconds_today $date_from_hour hours: ".($seconds_today/60/60));
    //debug (date("Y-m-d H:i:s",$date_from_unix)." ($date_from_unix) ".date("Y-m-d H:i:s",$date_to_unix)." ($date_to_unix)");
    
    if (is_array($use_interfaces)) { //handle use_interfaces URL
	$use_interfaces = array_unique($use_interfaces);
	if (!$_SERVER["QUERY_STRING"]) $interfaces_url = "&use_interfaces[]=".join("&use_interfaces[]=",$use_interfaces); //to pass it along
    }

    //select interfaces id's based on the filter (from URL)
    $interfaces_data = $object->get_all($use_interfaces,reports_make_interface_filter());
    $interfaces_ids = array_keys ($interfaces_data);
    $interfaces_count = count($interfaces_ids);

    //get availability of each requested interface
    $avail = array();
    if ($interfaces_count > 0) 
	$avail = $object->get_availability($interfaces_ids, $date_from_unix, $date_to_unix, $types, $detail);

    if ($view_mode=="html")
	echo 
	    tag("div","state_report").
	    table("options").
	    form().
	    reports_pass_options().
	    
	    table_row("State Report", "title", 4, "", false).
	    tr_open().    
	    td ("From").
    	    td(select_date("date_from",$date_from,7,true,$date_from_hour)).
	    td(select_event_types_alarms("types",$types,3),"","",1,2).
	    td("View Details ".checkbox("detail",$detail)).
	    tag_close("tr").

	    tr_open().
	    td("To").
	    td(select_date("date_to",$date_to,7,true,$date_to_hour)).
	    td(
		adm_form_submit("View").
		linktext(image("csv.png","","","Export to CSV"), $REQUEST_URI."&view_mode=csv","_new").
	        " | ".linktext(image("edit.png","","","Edit"),
	        $jffnms_rel_path."/admin/adm/adm_interfaces.php?".$_SERVER["QUERY_STRING"].$interfaces_url).
	        " | ".linktext(image("graph.png","","","Performance"),
	        $jffnms_rel_path."/view_performance.php?".$_SERVER["QUERY_STRING"].$interfaces_url)).

	    tag_close("tr").
	    form_close().
	    table_close().
	    table("report").
	
	    (($interfaces_count > 0)?
		tr_open("header").
		td("Interface","","",2).
    	        td("Round Trip Time").
		td("Packet Loss").
		tag_close("tr")
		:"");

    
    if (is_array($interfaces_ids))
    foreach ($interfaces_ids as $interface_id) { 
	$interface_data = $interfaces_data[$interface_id];
	$avail_data = $avail["interfaces"][$interface_id];

	if (($interface_data["type"]==4) || ($interface_data["type"]==14)) //FIXME make this modular
	    $perf_data = $object->get_rtt_pl($interface_id,$date_from_unix,$date_to_unix,$interface_data["sla_threshold"],$interface_data["bandwidthin"],$interface_data["bandwidthout"],$interface_data["flipinout"]);
	else
	    unset($perf_data);
	    
	if ($view_mode=="html")
	    echo 
		tr_open("", "interface").
		
		td(linktext(image("graph.png"), 
		    $jffnms_rel_path."/view_performance.php?interface_id=".$interface_id."&graph_time_start=".$date_from.
		    "&graph_time_stop=".$date_to."&graph_time=nopreset&graph_time_start_hour=".$date_from_hour.
		    "&graph_time_stop_hour=".$date_to_hour,"_new"),"","",1,2).

		td(linktext(
		    substr($interface_data["client_name"],0,30).": ".
		    substr($interface_data["host_name"],0,30)." ".
		    substr($interface_data["interface"],0,30)." - ".
		    substr($interface_data["description"],0,20),
	    	    $REQUEST_URI."&view_all=0&interface_id=".$interface_id."&detail=1".$types_url,"_new"),"","",1,2).
		    
		(($perf_data)
		    ?td($perf_data["rtt"]." msec.", "info").
		     td($perf_data["pl"]." %", "info")
		    :"").//td("&nbsp","","",2)).
		tag_close("tr").
		
		tr_open().
		tag("td", "", "", "colspan='2'").
		table("details");
	
	//FIXME add the degraded seconds information
	
	if ($view_mode=="csv") 
	    echo "\"".$interface_data["client_name"]." - ".$interface_data["description"]."\",".
		$perf_data["rtt"].",".round($perf_data["pl"],2)."%,".
		"\"".time_hms($avail_data["unavail_seconds"])."\",".
		round(100-$avail_data["unavail_percent"],2)."%\n";
	
	if (is_array($avail_data["detail"])) { // if we have alarm details
	
	    if ($view_mode=="html")
		echo 
		    tr_open("header").
		    td("Start").
		    td("Stop").
		    td("Duration").
		    td("Type").
		    tag_close("tr");
	

	    foreach ($avail_data["detail"] as $detail_data) { 
		if ($view_mode=="html") 
		    echo 
			tr_open().
			td($detail_data["date_start"]).
			td($detail_data["date_stop"]).
			td(time_hms($detail_data["duration"])." hs").
			td($detail_data["type"]." ".($detail_data["counted"]=="1"?"X":"O")).
			tag_close("tr");

		if ($view_mode=="csv") 
		    echo ",,,,,\"".$detail_data["date_start"]."\",\"".$detail_data["date_stop"]."\",\"".
			time_hms($detail_data["duration"])."\",\"".
			$detail_data["type"]."\",".($detail_data["counted"]=="1"?"X":"O")."\n"; 
	    }
	}

	if (($view_mode=="csv") && ($detail)) echo "\n";

	if ($view_mode=="html") 
	    echo 
		tr_open("totals").
		td("Unavailable Time:").
		td(time_hms($avail_data["unavail_seconds"])." hs").
		td("Availability:").
		td(100-$avail_data["unavail_percent"]." %").
		tag_close("tr").
		table_close(). //details
		tag_close("td").
		tag_close("tr");

    } //for each interface

    if (is_array($avail["summary"])) {
	if ($view_mode=="html")
	    echo
		tr_open("summary").
		td("Total Unavailable Time: ".time_hms($avail["summary"]["unavail_seconds"])." Hs","","",3).
		td("Total Availability: ".(100-$avail["summary"]["unavail_percent"])." %").
		tag_close("tr");
	
	if ($view_mode=="csv") 
	    echo "\n\n\"Summary\"\n\n".
	    "\"Total Unavailable Time: ".time_hms($avail["summary"]["unavail_seconds"])." Hs\"\n".
	    "\"Total Availability: ".(100-$avail["summary"]["unavail_percent"])." %\"";
    }
    
    if ($interfaces_count < 1) 
	table_row("No Interfaces Found.","no_records_found",4);
    
    echo 	
	table_close(). 	//report
	tag_close("div"); 	//state report
    
    adm_footer();
?>
