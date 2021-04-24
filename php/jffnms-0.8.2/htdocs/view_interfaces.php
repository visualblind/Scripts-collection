<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    require ("auth.php");  

    $sources = array ( //information sources
	"interfaces"=>array(
	    "get"=>1,
	    "urls"=>1,
	    "init"=>1,
	    
	    "normal"=>1,
	    "performance"=>1,
	    "text"=>1,
	    "dhtml"=>1
	),
	"hosts" => array(
	    "get"=>1,
	    "urls"=>1,
	    "init"=>1,
	    
	    "dhtml"=>1,
	    "normal"=>1,
	    "text"=>1
	),
	"maps" => array(
	    "get"=>1,
	    "urls"=>1,
	    "init"=>1,
	    
	    "dhtml"=>1,
	    "normal"=>1,
	    "text"=>1
	)
    );

    $views = Array( //views
	"normal"=>Array(
	    "init"=>1,
	    "html_init"=>1,
	    "break_init"=>1,
	    "break_by_host"=>1,
	    "break_by_card"=>1,
	    "break_by_zone"=>1,
	    "break_show"=>1,
	    "break_finish_row"=>1,
	    "break_next_line_span"=>1,
	    "interface_show"=>1,
	    "finish"=>1,
	    "no_interfaces"=>1
	),	   
	"graphviz"=>Array(
	    "init"=>1,
	    "html_init"=>"normal",
	    "break_by_host"=>1,
	    "interface_show"=>1,
	    "finish"=>1,
	    "no_interfaces"=>"normal"
	),
	"text"=>Array(
	    "html_init"=>1,
	    "interface_show"=>1,
	    "finish"=>1,
	    "no_interfaces"=>1
	),
	"performance"=>Array(
	    "init"=>1,
	    "html_init"=>"normal",
	    "break_finish_row"=>"normal",
	    "interface_show"=>1,
	    "no_interfaces"=>"normal"
	),
	"dhtml"=>array(
	    "init"=>1,
	    "html_init"=>1,
	    "break_by_card"=>1,
	    "break_by_zone"=>1,
	    "break_show"=>1,
	    "break_finish_row"=>1,
	    "break_next_line_span"=>1,
	    "interface_show"=>1,
	    "no_interfaces"=>1,
	),
	"dynmap"=>Array(
	    "html_init"=>1,
	    "interface_show"=>"normal",
	    "interface_process"=>1,
	    "finish"=>1,
	    "no_interfaces"=>1,
	    "save"=>1
	)
    );
    
    function call_view ($step) {

	$views = $GLOBALS[views];
	$vtype = $GLOBALS[view_type];
	if (is_string($views[$vtype][$step])) $vtype = $views[$vtype][$step];
	if ($views[$vtype][$step]==1) $callstep=$vtype."_".$step;

	if (!$callstep) $callstep = "none";

	//debug ("View Step: $step - $vtype: $step - $callstep");
	
	$file = "views/view_$callstep.inc.php";
	return $file;
    }    

    function call_source ($step) {

	$sources = $GLOBALS[sources];
	$source = $GLOBALS[source];
	if (is_string($sources[$source][$step])) $step = $sources[$source][$step];
	if ($sources[$source][$step]==1) $callstep=$source."_".$step;

	if (!$callstep) $callstep = "none";

	//debug ("Source Step: Source: $source Step: $step ==> $callstep");
	
	$file = "views/source_$callstep.inc.php";
	return $file;
    }    
    
    //set defaults
    if (!$source) $source = "interfaces";
    if (!$action) $action = "view";
    if (!$view_type) $view_type="normal";

    if (!$screen_size) 
	$screen_size = 980;
    else
	$screen_size -= 40; //decrease 10 pixels
 
    if ($only_rootmap=="") $only_rootmap = 1;
    
    if ($map_id == "") $map_id = 1; //root map;
    if ($map_profile = profile("MAP")) $map_id = $map_profile; //fixed map

    if (empty($client_id)) $client_id = 0;
    if ($client_id_profile = profile("CUSTOMER")) $client_id = $client_id_profile; //fixed customer

    //get refresh from profile if its set
    if ($aux_refresh = profile("MAP_REFRESH")) $map_refresh = $aux_refresh;
    
    $interfaces_shown = 0; //number of interfaces shown

    require(call_view("init")); //init view's internal data

    require(call_source("init")); //init source's internal data

    if ($action=="save") require(call_view("save")); //if there is something to save

    require(call_view("html_init"));
    
    //load items source
    $items = array();
    require(call_source("get"));

    if (count($items) > 0) //if there were items returned
    while (list(,$item) = each ($items)) //go thru them
    if ($item["show_rootmap"] > 0) { //if its meant to be shown

	unset($alarm);
	unset($alarm_name);
	extract($item);
	//debug ($item);

	//clean the interface name
	$interface = str_replace("\"","",$interface);
	$interface = str_replace("'","",$interface);

	list ($int, $card) = interface_shortname_and_card ($interface, $type, $db_break_by_card); //get short names for interface and card
    
	//break the current row because something has changed
	if (($break_by_zone==1)  && ($old_zone != $zone_id)) 	$cols_count = $cols_max; //if break by zone is enabled and zone changed
	if (($break_by_host==1)  && ($old_host != $host)) 	$cols_count = $cols_max; //if break by host is enabled and host changed
	if (($break_by_card==1)  && ($old_card != $card)) 	$cols_count = $cols_max; //if break by card is enabled and card changed

	if ($cols_count==$cols_max) { //when we get to the end of the row
	    require(call_view("break_finish_row"));
	    $cols_count=1; //set current column count to 1
	}

	if ($cols_count==1) { //if this is the first column in a new row
	    if (
	    (($break_by_zone==1)  && ($old_zone!=$zone_id)) || 	//if break by zone is enabled and zone changed
	    (($break_by_host==1)  && ($old_host!=$host)) || 	//if break by host is enabled and host changed
	    (($break_by_card==1)  && ($old_card!=$card)) ) {	//if break by card is enabled and card changed
    		    
		require(call_view("break_init")); //start a new row
		
		//include the new row header
		if ($break_by_zone==1) require(call_view ("break_by_zone")); 
		if ($break_by_card==1) require(call_view ("break_by_card")); 
		if ($break_by_host==1) require(call_view ("break_by_host"));

		require(call_view ("break_show")); //show the header

	    } else 
		require(call_view ("break_next_line_span")); //if new row but not because of a break
	} //cols = 1

	require(call_source("urls")); //call url processing
	
	if (!$alarm_name) $alarm_name= "OK"; //if alarm is not set then its OK
	
	if ($alarm!=NULL) { //interface is alarmed
	    $bgcolor = $bgcolor_aux; 	//take colors from the item
	    $fgcolor = $fgcolor_aux;
	    if ($make_sound==1) $alarms_actual[$alarm][]=$id; //if make_sound active for this interface, put the id in the alarms list
	} else {
	    $bgcolor="64FF64"; //use standard colors for non alarmed interfaces (green)
	    $fgcolor="000000";
	}
	
	if ($show_rootmap==2) { //if its "Mark Disabled"
	    $bgcolor_status = $bgcolor; //set small box color to the real bgcolor
	    $bgcolor="777777"; //set disabled colors (gray)
	    $fgcolor="222222";
	}
    
	require(call_view ("interface_show")); //show the interface
	
	//save current zone, host or card to compare it to a new one
	if ($break_by_zone==1) $old_zone = $zone_id;
	if ($break_by_host==1) $old_host = $host;
	if ($break_by_card==1) $old_card = $card;

	$cols_count++;
    }//items loop
    
    require(call_view ("finish")); 	//final processing

    if ($interfaces_shown == 0) 		//if no interface were shown
	require(call_view ("no_interfaces")); 	//call the "no interfaces" sign
    
    // ALARM SOUND PROCESSING        
    if (($action == "view") && ($sound==1)) { //if action is view (normal) and sounds are enabled
	
	$alarms_diff = array();
	$alarms_last = unserialize(stripslashes($alarms_last)); //get alarm list from last time

	if ((time() > $alarms_time+($map_sound_renew_time*60)) && ($map_sound_renew_time > 0)) //if the alarms are expired 
	    unset($alarms_last); //delete the last alarms so we play the currents again

	if (!isset($alarms_last)) 	$alarms_last=array();
	if (!isset($alarms_actual)) 	$alarms_actual=array();

	$array_aux = array_merge(array_keys($alarms_actual),array_keys($alarms_last)); //merge both keys

	foreach ($array_aux as $key){ //every different alarm_state id (new or old)
	    if (!isset($alarms_last[$key])) 	$alarms_last[$key]=array(); 	//if not set, set it empty
	    if (!isset($alarms_actual[$key])) 	$alarms_actual[$key]=array(); 	//if not set, set it empty
	    
	    //get the diff of both alarms list (in = exists in actual, and not in last), (out = exists in last but not in actual)
	    $alarms_diff[$key]["out"] = array_diff($alarms_last[$key],$alarms_actual[$key]);
	    $alarms_diff[$key]["in"] = array_diff($alarms_actual[$key],$alarms_last[$key]);
	}

	//debugging
	//debug($alarms_actual);
	//debug($alarms_last);
	//debug($alarms_diff);
	
	unset($alarm_api);
	if ((count($alarms_diff) > 0) && ($alarms_time)) //if there is a diff and this is not the first call 
	    foreach ($alarms_diff as $alarm_state_id=>$diff_items) //go thru all diffs
	
		if ((count($diff_items["in"]) > 0) || (count($diff_items["out"]) > 0)) { //if there's something to do

		    if (!isset($alarm_api)) $alarm_api = $jffnms->get("alarm_states"); //get the api handler
		    $sounds = current($alarm_api->get_all($alarm_state_id)); //get the record for this alarm state id
	
		    if (count($diff_items["in"]) > 0) //if there are IN items in this alarm state
			echo "<!-- Alarm: IN $alarm_state_id -->\n".play_sound($sounds["sound_in"])."\n"; //play the sound

		    if (count($diff_items["out"]) > 0) //if there are OUT items in this alarm state
			echo "<!-- Alarm: OUT $alarm_state_id -->\n".play_sound($sounds["sound_out"])."\n"; //play the sound
		    
		    $alarms_time=time(); //set alarm last time to now
		}

	if (!$alarms_time) $alarms_time=time(); //if this is the first time we've been called set the alarm last time to now

	//get the new values in the url for the refresh
	$url=array();
	$url["alarms_last"] = serialize($alarms_actual);
	$url["alarms_time"] = $alarms_time;

	clean_url($url);
    }//alarm sound processing

    if ($norefresh!=1) //dont refresh if we're ask not to
	echo javascript_refresh("if (self.no_refresh!=1) location.href=\"$REQUEST_URI\";",$map_refresh); 

    adm_footer();
?>
