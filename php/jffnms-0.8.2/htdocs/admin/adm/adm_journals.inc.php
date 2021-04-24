<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    if (!empty($journal_button) && is_array($checkedid)) { 
        $event_obj = $jffnms->get("events");

	foreach ($checkedid as $event) 
	    $event_obj->set_ack($event,0);
	
	unset($event_obj);
	
    }

    function journals_action_view ($id) {
	$GLOBALS["st"]["after_record_function"] = "journals_action_real_view";
	$GLOBALS["st"]["after_record_id"] = $id;
	$GLOBALS["filter"] = $id;
    }

    function journals_action_real_view($journal) {

	if ($journal["id"] == $GLOBALS["st"]["after_record_id"]) {
	    
	    echo
		tr_open("",""). 
		tag("td","","","colspan=6").
	    
		table("journal_view").
		table_row("Comments", "comments", "", 1, "", false).
		table_row(html("pre", $journal["comment"]), "", 1, "", false);

	    $events_obj = $GLOBALS["jffnms"]->get("events");
	    $events = $events_obj->get_all(NULL,"",1,"",0,100,"desc", 1 ,1, $journal["id"]);
		
	    if (count($events) > 0) {
		echo
		    table_row("Events", "events", "", 1, "", false).
		    tr_open("events").
		    tag("td"). 
		    table("body");
		    
		$GLOBALS["view_type"]="html";
		foreach ($events as $event)
		    show_event ($event, "", "", "" ,"");
		    

		echo
		    table_close().
		    tag_close("td").
		    tag_close("tr");
	    }
	    
	    echo
		table_close().
		tag_close("td").
		tag_close("tr");

	    unset ($GLOBALS["st"]["after_record_function"]);
	}
    }

?>
