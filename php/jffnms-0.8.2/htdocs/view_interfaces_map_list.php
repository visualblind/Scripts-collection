<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("auth.php"); 

    $api = $jffnms->get("maps");

    if ($active_only=="") $active_only = 0; //active alarms

    if ($only_rootmap=="") $only_rootmap = 1; //active alarms
    
    //map
    if ($map_id=="") $map_id = 1;	
    if ($map_id_profile = profile("MAP")) $map_id = $map_id_profile; //fixed map

    if (empty($client_id)) $client_id = 0;
    if ($client_id_profile = profile("CUSTOMER")) $client_id = $client_id_profile; //fixed customer
    
    if ($break_by_zone=="") $break_by_zone = 1;

    //View Type Selection
    $view_type = cookie("VIEW_TYPE", $view_type); // Query/Set (if its not '') view_type session cookie

    if (($view_type=="") && ($aux = profile("VIEW_TYPE_DEFAULT"))) 	//User had not selected any view type yet
        $view_type = $aux;						//get the default from the profile 
    
    if ($view_type=="") 	//If we coudn't get the view_type from the cookie or the profile 
	$view_type = "dhtml"; 	//use the 'DHTML' view type
    
    $events_update = ($events_update=="")?1:0;
    
    //source type
    if ($source=="") $source = "interfaces";
    
    $sound = profile("MAP_SOUND", $sound);

    switch ($source) { 
    
	case "interfaces": 	$view_types = array (
				    "normal"=>"Normal",
				    "normal-big"=>"Normal Big",
				    "text"=>"Text",
				    "performance"=>"Performance",
				    "graphviz"=>"GraphViz",
				    "dhtml"=>"DHTML",
				    "dhtml-big"=>"DHTML Big"
				);
				break;

	case	"maps"	:	
	case	"hosts"	:	$view_types = array (
				    "normal"=>"Normal",
				    "normal-big"=>"Normal Big",
				    "text"=>"Text",
				    "dhtml"=>"DHTML",
				    "dhtml-big"=>"DHTML Big"
				);
				break;
    }

    $old_view_type = $view_type;	// for Select
    
    switch ($view_type) {
	case "normal":		$big_graph=0;
				$image = "normal.png";
				break;

	case "text":		 
				$image = "text.png";
				break;
				
	case "performance":	$break_by_host=0; 
				$break_by_card=0;
				$image = "graph.png";
				break;

	case "graphviz":	$break_by_card=0;
				$break_by_host=1; 
				$break_by_zone=0; 
				$image = "";
				break;

	case "normal-big":	$big_graph=1;
				$view_type = "normal";
				$image = "normal.png";
				break;

	case "dhtml":		$big_graph=0;
				$image = "normal.png";
				break;

	case "dhtml-big":	$big_graph=1;
				$image = "normal.png";
				$view_type="dhtml";
				break;
    }

    $map = current($api->get_all($map_id));

    $maps = $api->get(NULL,$map_id);
	
    $maps_list = array($REQUEST_URI=>"Choose Map");
    
    while ($rmaps = $api->fetch())
	if ($rmaps["id"] != 1) 
	    $maps_list[$REQUEST_URI."&events_update=".$events_update."&map_id=".$rmaps["id"]."&host_id=&break_by_card=0&map_color=".$rmaps["color"]]=$rmaps["name"];

    $select_maps = (count($maps_list) > 1)
        ?select_custom("map", $maps_list, 0, "change_map_url(this)", 1, 0)
        :"None";

    $options = 
	"&map_id=".$map_id."&map_color=".$map["color"]."&mark_interface=".$mark_interface."&active_only=".$active_only.
	"&break_by_card=".$break_by_card."&break_by_host=".$break_by_host."&break_by_zone=".$break_by_zone."&break_by_card=".$break_by_card.
	"&view_type=".$view_type."&host_id=".$host_id."&sound=".$sound."&big_graph=".$big_graph."&only_rootmap=".$only_rootmap."&source=".$source."&client_id=".$client_id;
    $url = "view_interfaces.php?$options";
    
    adm_header("Interface Map List");

    echo 
	script(
"
    function change_view_type(select){
	var url = select.options[select.selectedIndex].value;
	location.href = location.href+'&view_type='+url;
        return true;
    }

    function change_map_url(select){
	var url = select.options[select.selectedIndex].value;
	location.href = url;
	return true;
    }

    function change_client(select) {
	var client_id = select.options[select.selectedIndex].value;
	location.href = location.href + '&no_refresh=0&events_update=1&client_id='+client_id;
	return true;
    }").
	table("map_list").
	tr_open().
	td(control_button ($map["name"],"_self","$REQUEST_URI&map_id=".$map["parent"]."&host_id=&break_by_card=0&events_update=".$events_update,"world.png")).

	((($client_id_profile==0) && ($map_id_profile==0))
	    ?td(control_button ("Submaps: ".$select_maps,"","","none")).
	     td(control_button ("Customers: ".select_clients("", $client_id, 1, array(0=>"All"),"change_client(this)"),"","","none"))
	    :"").

	td(control_button ( "Options:".
	    linktext(image($image)."&nbsp;",$url,"map_viewer").
	    select_custom("view_type",$view_types,$old_view_type,"change_view_type(this)",1,0),"","","none")).
    
	td(($no_refresh==1) 
	    ?control_button("","_self","$REQUEST_URI$options&no_refresh=0&events_update=0","refresh.png")
	    :control_button("","_self","$REQUEST_URI$options&no_refresh=1&events_update=0","refresh2.png")).

	td(($active_only==1)
	    ?control_button("","_self","$REQUEST_URI$options&active_only=0&events_update=0","all.png")
	    :control_button("","_self","$REQUEST_URI$options&active_only=1&events_update=0","alert.png")).

	td(control_button("","_new",$url,"popup.png")).

	td(($sound==1)
	    ?control_button("","_self","$REQUEST_URI$options&sound=0&events_update=0","sound.png")
	    :control_button("","_self","$REQUEST_URI$options&sound=1&events_update=0","nosound.png")).
	
	tag_close("tr").
	table_close().

	script(($no_refresh==1)
		?"parent.map_viewer.no_refresh = 1;"
		:"parent.map_viewer.location.href = '$url'+'&screen_size='+window.document.body.clientWidth;").
    
	(($events_update==1)
	    ?script("parent.parent.events.location.href = 'events.php?map_id=$map_id&refresh=&client_id=$client_id';")
	    :"");

    adm_footer();
?>
