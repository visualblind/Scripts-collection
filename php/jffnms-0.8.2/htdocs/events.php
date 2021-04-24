<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("auth.php"); 

    function generate_filter() {
	global $filter_id,$express_filter,$jffnms;

	$filter = " and 1=1 ";    
        $have_filter = 0;
    
	//Express Filter Processing
        if ($express_filter) {
	    $filtro_array = explode("^",$express_filter);
	
	    for ( $i=0 ; $i < count($filtro_array) ; $i++ ) {
		if ($filtro_array[$i]) { 
	
		    list ($filtrorow, $filtrovalue, $filtrooper) = explode (",",$filtro_array[$i]);

		    if ($filtrooper=="!=") 
			$oper = "NOT";
		    else 
			$oper = "";

		    //Express Filter Fields
	    	    if ($filtrorow=="date") $filter = "$filter and $oper (<events_table>.date >= '$filtrovalue 00:00:00' and <events_table>.date <= '$filtrovalue 23:59:59')";
	    	    if ($filtrorow=="date_start") $filter = "$filter and $oper (<events_table>.date >= '$filtrovalue')";
	    	    if ($filtrorow=="date_stop") $filter = "$filter and $oper (<events_table>.date <= '$filtrovalue')";
		    if ($filtrorow=="host") $filter = "$filter and $oper (<events_table>.host = $filtrovalue)";
		    if ($filtrorow=="zone") $filter = "$filter and $oper (hosts.zone = $filtrovalue)";
		    if ($filtrorow=="type") $filter = "$filter and $oper (<events_table>.type = $filtrovalue)";
		    if ($filtrorow=="username") $filter = "$filter and $oper (<events_table>.username LIKE '%$filtrovalue%')";
		    if ($filtrorow=="severity") $filter = "$filter and $oper (types.severity = $filtrovalue)";
		    if ($filtrorow=="interface") $filter = "$filter and $oper (<events_table>.interface LIKE '%$filtrovalue')";
		    if ($filtrorow=="info") $filter = "$filter and $oper (<events_table>.info LIKE '%$filtrovalue%')";
		    if ($filtrorow=="ack") $filter = "$filter and $oper (<events_table>.ack > 0)";

		    if ($filtrorow=="types") {
			$types_filter = explode("!",$filtrovalue);
		        foreach ($types_filter as $type) 
			    if ($type) 
				$filtro_value_aux[] =" (<events_table>.type = $type) ";
			$filtro_value_aux2=join(" or ",$filtro_value_aux); 
			$filter = "$filter and $oper ($filtro_value_aux2)";
		    }	
		}
	    }

	    $filter_options[0] = "Express Filter";
	    $have_filter = 1;
	}

	// Static Filters Processing
	
        $filter_obj = $jffnms->get("filters");
        $filter_obj->get();
    
	if (!$filter_id) $filter_id = profile("EVENTS_DEFAULT_FILTER");

	while ($reg = $filter_obj->fetch()) {
	    if ($filter_id == $reg["id"]) { // this is the choosen filter
	
		if ($aux = $filter_obj->generate_sql($reg["id"])) $filter .= " and $aux";

	        if ($express_filter) $reg["description"] .= htmlentities(" <APPLIED>"); // to show this filter is applied even that the Express filter is shown selected
	    }
	    
	    $filter_options[$reg["id"]]=$reg["description"];
	}
	
	if (is_numeric($filter_id) && ($filter_id!=1)) $have_filter = 1;

	return array($have_filter, $filter, "options"=>$filter_options);
    } // function generate_filter

    function add_journal ($journal_id, $checked_ids = array(), $subject= "", $comment = "", $ticket = false) {  
	global $jffnms, $events_obj;
	
	$journal = $jffnms->get("journal");
	
	$event_ids = array();
	
	if (!is_array($checked_ids))
	    $checked_ids=array();

	foreach ($checked_ids as $aux) { 
	    $aux2 = explode (",",$aux);
	    foreach ($aux2 as $checked_id)
		if (is_numeric($checked_id))
		    $event_ids[]=$checked_id;
	}

	$event_ids = array_unique($event_ids);

	if (!empty($comment)) { 
	    $comment = trim ($comment);
    	
	    $now = date("Y-m-d H:i:s",time());

    	    $timed_comment = "|".$now.",".$_SERVER["PHP_AUTH_USER"]."|\n".$comment."\n";
	
    	    if (($journal_id==1) && (!empty($subject))) { //new journal
		$journal_data = array("date_start"=>$now, "subject"=>$subject);
		$journal_id = $journal->add();

	    } else 
		if ($journal_id > 2) { //update journal
		    unset($journal_data);
		    $journal_data["date_stop"] = $now;
		}
	    
	    if (is_array($journal_data) && ($journal_id > 1)) 
		$journal->update ($journal_id,$journal_data,$timed_comment);
	}

	if (($journal_id > -1) && is_array($event_ids) && (count($event_ids) > 0)) {

    	    foreach ($event_ids as $event_id) 
		$events_obj->set_ack($event_id, $journal_id);
	    
	    if ($ticket && ($journal_id > 1)) 
		$journal->create_ticket($journal_id); 
	}
	
	return $journal_id;
    }

    function show_journal($journal_id) {
	global $jffnms,$REQUEST_URI_ORIGINAL;

	$journal = $jffnms->get("journal");
	
	if ($journal_id > 1) 
	    $journal_active = current($journal->get_all($journal_id,1));
	
	$output .= 
	    table("journal").
	    table_row("Journal","title", 4, "", false).

	    tr_open("selector").
	    td (select_journal("journal_id",$journal_id,array(1=>"New Journal"))).
	    td (adm_form_submit("View","view_button")).
	    td (adm_form_submit("Acknowledge","journal_button")).

	    td (((!$journal_active["ticket"])
		?adm_form_submit("Send to Ticket","ticket_button")
		:linktext("Ticket ".$journal_active["ticket"],$journal->view_ticket_url($journal_id),"map"))).

	    tag_close("tr").
	
	    tr_open().
	    td("Subject: ".textbox("subject",$journal_active["subject"],30),"","",4).
	    tag_close("tr").

	    tr_open ().
	    (($journal_id > 1)
		?td(nl2br($journal_active["comment"]), "", "", 2, true):"").
	    td(memobox("comment",7,40,""),"text","",($journal_id > 1)?2:4).
	    tag_close("tr").
	    table_close();

	return $output;
    } 

    function event_table_header ($refresh, $express_filter, $filter_id, $init, $span, $sound) {
	global $REQUEST_URI, $order_type, $view_type, $jffnms_rel_path, $view_all;

	if ($order_type=="desc") {
	    $order_change="asc";
	    $order_image="a-up.png";
	} else {
	    $order_change = "desc";
	    $order_image = "a-down.png";
	}

	$filter = generate_filter();

	switch ($view_type) {
	    case "html":
		$output .= 
		    tr_open ("","header").
		    td ("Date". linktext(image($order_image),$REQUEST_URI."&order_type=".$order_change).
			html("span",date("H:i:s",time()),"","hour"),"date").
		
		    td ("Ack", "ack").
		    td ("Type", "type").
		    td ("Host & Zone", "host", "", 2).
		
		    tag ("td").
		    table ("","buttons").
		    tr_open ().
		    td (linktext(image("a-top.png"), $REQUEST_URI."&init=0&refresh=")).

		    td (($init > 0)
			    ?linktext(image("a-left.png"), $REQUEST_URI."&init=".($init-$span)."&refresh=0")
			    :"").

		    td (linktext(image("a-right.png"), $REQUEST_URI."&init=". ($init+$span)."&refresh=0")).
		    
		    td ((empty($refresh)
			    ?linktext(image("refresh.png"), $REQUEST_URI."&refresh=")
			    :image("refresh2.png", NULL, NULL,"Refresh","","",
				"if (self.no_refresh!=1) {
				    self.no_refresh = 1; 
				    this.src = \"images/refresh.png\"; 
				} else 
				    document.location = \"".htmlspecialchars($REQUEST_URI)."\";
				"))).
			
		    td (linktext(image("plus.png"), $REQUEST_URI."&span=".($span*2))).
		    td (linktext(image("minus.png"), $REQUEST_URI."&span=".($span/2))).

		    td ((($view_all==0)
			?linktext(image("all.png"), $REQUEST_URI."&view_all=1&refresh=0")
			:linktext("- ".image("all.png"), $REQUEST_URI."&view_all=0"))).

		    td ((($sound==1)
			?linktext(image("sound.png"), $REQUEST_URI."&sound=0")
			:linktext(image("nosound.png"), $REQUEST_URI."&sound=1"))).

		    td ("Event", "detail").
	
		    td (
			linktext(image("csv.png"), $REQUEST_URI."&view_type=csv&view_all=1", "_new").
			linktext(image("filter4.png"), 
			    "javascript: popUp('".$jffnms_rel_path."/admin/event_filter.php?order_type=".
			    $order_type."&express_filter=".$express_filter."');").
			select_custom("filter_list",$filter["options"],(isset($filter["options"][0])?"":$filter_id),"go_filter(this);"),
			"filters").
	
		    tag_close("tr").
		    table_close().
		    tag_close("td").
		    tag_close("tr");
	
		unset ($filter["options"]);
	    break;
	
	    case "csv":
		$output = tag("pre");
	        $output .= "# Save this file as .txt and then open it on your Spreadsheet, import it as CSV (Comma Separated Values)\n";
		$output .= "Day,Hour,Host,Zone,Username,Interface,Event Type,State,Info,Severity\n";
	    break;
	
	    case "rss":
	    case "rdf": 
    		header ("Content-Type: text/xml");
		$output .=
		    "<?xml version='1.0' encoding='ISO-8859-1' ?>\n".
		    tag ("rss", "", "", "version='2.0'").
		    tag ("channel").
			html("title", "JFFNMS", "", "", "", false, true).
		        html("link", current_host().$jffnms_rel_path, "", "", "", false, true).
			html("description", "JFFNMS Events", "", "", "", false, true).
		    html("ttl",$refresh, "", "", "", false, true);
		break;
	}

	return array($output, $filter);
    } //function event_table_header


    function events_verify_summary ($event) {

	$result = NULL;
	$summary = &$GLOBALS["events_summary"];
	
	$index =    $event["host_id"]."-".
	    	    $event["type_id"]."-".
		    $event["user"]."-".
		    $event["interface"]."-".
		    $event["state"]."-".
		    $event["info"]."-".
		    $event["ack"];

	if ($summary["index"]==$index) {

	    $summary["count"]++; //count 1 more
	    $summary_ids = $summary["event"]["summary_ids"];
	    $summary_ids[] = $event["id"];
	
	    $summary["event"] = $event; 
	
	    $summary["event"]["summary_ids"] = $summary_ids ;

	} else {
	
	    if (is_array($summary["event"])) {
		$result = $summary["event"]; //old event
		
		if ($summary["count"] > 1)
		    $result["text"].=" (Message repeated ".$summary["count"]." times)";
	    }
	    
	    $summary["index"] = $index; //save event
	    $summary["event"] = $event; 
	    $summary["event"]["summary_ids"][] = $event["id"];
	    $summary["count"] = 1; 
	}

	return $result; //return event
    }

    // ------ EVENTS CORE

    $REQUEST_URI_ORIGINAL = $REQUEST_URI;	    //guarda el URI para algunos casos

    $events_obj = $jffnms->get("events");

    clean_url (array(), 
	array("journal_id","journal_button", "ticket_button","comment","subject", "checkedid","filter_list"));

    if (isset($journal_button))
	$journal_id = add_journal($journal_id, $checkedid, $subject, $comment, (isset($ticket_button)?true:false));

    //FIXME view Journals

    //for scrolling
    if ($init=="") $init = 0;
    if ($span=="") $span = 15;
    if ($view_all=="") $view_all = 0;
    
    $show_all = 0;

    $sound = profile("EVENTS_SOUND", $sound);

    if ($map_profile = profile("MAP")) $map_id = $map_profile; //fixed map

    if (empty($client_id)) $client_id = 0;
    if ($client_id_profile = profile("CUSTOMER")) $client_id = $client_id_profile; //fixed customer

    if ($refresh!="0") { //if refresh is not set to disable (0)
	if (!$refresh) $refresh=profile("EVENTS_REFRESH"); //get refresh from profile
        if (!$refresh) $refresh=$events_refresh; //if it was not set use the default
    } else 
	$refresh="";
    
    if (!$order_type) $order_type = "desc";
    if (!$view_type) $view_type = "html";
    if (!$view_mode) $view_mode = "normal";

    list($header_html,$filter_aux) = event_table_header ($refresh, $express_filter, $filter_id, $init, $span, $sound); 

    if ($view_type=="html") { 
	//Disable Refresh in adm_header()
	$refresh_aux = $refresh;
	$refresh="";

	adm_header ($title." Event Viewer");

	$refresh=$refresh_aux;

 	list($have_filter,$filter) = $filter_aux;

	echo script (
"    function go_filter(select) {
	var id = select.options[select.selectedIndex].value;
        location.href = location.href + '&express_filter=&filter_id='+id;
	return true;
    }

    function check(field_aux) {
	fields=document.forms[0].elements;

        for (i = 0; i < fields.length; i++) 
	    if (fields[i].name==field_aux) { 
    		if (fields[i].checked==true)
		    fields[i].checked = false; 
		else
		    fields[i].checked = true; 
	    }
	return true;
    }

    function popUp(URL) {
	day = new Date();
        id = day.getTime();
	eval(\"window1 = window.open(URL, '\" + id + \"', 'toolbar=0,scrollbars=0,location=0,statusbar=0,menubar=0,resizable=0,width=600,height=380');\");
        if (!window1.opener) window1.opener = self;
    }").
    
	form().
	table("events"); // main table
    }
    
    echo $header_html;
    
    if ($view_type=="html")
	echo tag("tbody", "body");
    
    //list events
    $span_extended = $span * 2; //expanded for summary
    
    $events_raw = $events_obj->get_all(NULL,$map_id,$have_filter,$filter,$init,$span_extended,"desc",$view_all,$show_all, 0, $client_id);
    $cant_events = count($events_raw);

    if ($cant_events > 0) { //if there are events to be shown

	//events summary (identical events)
	$events=array();
	$events_summary = array();
	
	foreach ($events_raw as $event) 
	    if ($summary = events_verify_summary($event)) 
		$events[]=$summary;

	if ($events_summary["count"] > 0) //take care of the last event
	    $events[] = events_verify_summary(NULL);

	//debug ($events);

	unset($events_summary);

	unset($events_raw);

	$first = true;
	$cant_events = count($events);

	if ($cant_events > $span) $cant_events = $span;    

	if ($order_type=="desc") 
	    $event_pos=0; 
	else 
	    $event_pos=$cant_events-1;

	for ($i = 0; ($i < $cant_events) || (($view_all==1) && (is_array($events[$event_pos]))) ; $i++)
	    if (is_array($events[$event_pos])) {    
		$event = $events[$event_pos];

		if ($first) { //save first event id for sound comparation
		    $events_actual=$event["id"]; 
		    $first=false; 
		}
	
		//if (($expand == $event["id"]) && ($event["ack"] > 1)) $journal_id = $event["ack"]; //save journal id 
	
		show_event ($event, $color, $map_id, $filter_id);

		if ($order_type=="desc") 
		    $event_pos++; 
		else 
		    $event_pos--;
	
		flush();
	    }

	if ($view_type=="html") {
	    echo 
		tr_open("general").
	    	td ("General").
		td (tag("input","","","type='checkbox' onClick=\"this.value=check('checkedid[]');\"",false)."All").
		td (show_journal($journal_id),"","",4, true).
		tag_close("tr");

	    echo 
		tag_close("tbody").
		(($view_mode=="normal")
		    ?(current(event_table_header($refresh, $express_filter, $filter_id, $init, $span, $sound))):"").
		table_close().
		form_close();
	} //html
    
    } else { //if we didn't find any events
	$no_events_found = "No Events Found";
	
	switch ($view_type) {
	    case "html":	
	        table_row($no_events_found,"no_events_found",6);
	    break;
	
	    case "csv":
		echo $no_events_found."\n";
	    break;
	    
	    case "rss":
	    case "rdf":
	    default:
		echo
		    html("item", 
			html("title", $no_events_found, "", "", "", false, true).
			html("pubDate", date("Y-m-d H:i:s"), "", "", "",false, true).
			html("link", 
			    htmlspecialchars(current_host().$REQUEST_URI."&view_type=html"), "", "", "",false, true)
			);
	    break;
	}
    }

    // Page End
    switch ($view_type) {
	case "html":

	    // Sound Execution
    	    if ($sound==1)
    		if (($events_actual > $events_last) && ($events_last))
		    echo play_sound($events_sound);

	    // Recode URL for JS refresh
    	    if ($_GET) 
		$url = $_GET; //suport for PHP 4.1.0 and older
	    else 
		$url = $HTTP_GET_VARS;
    
	    $url["events_last"] = $events_actual;

	    foreach ($url as $key => $value) 
		$url_aux .= "&$key=".$value;

	    $url = $SCRIPT_NAME."?".$url_aux;

	    echo javascript_refresh("if (self.no_refresh!=1) location.href=\"$url\";",$refresh);
	    
	    adm_footer();
	break;
	    
	case "rss":
	case "rdf": 
	    echo
		tag_close("channel").
		tag_close("rss");
	break;
    }
?>
