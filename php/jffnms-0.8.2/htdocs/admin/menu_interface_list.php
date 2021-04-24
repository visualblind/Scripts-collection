<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../auth.php"); 
    
    adm_header("Interface Selector".(!empty($field_name)?" - ".$field_name:""));
    
    if ($map_profile = profile("MAP")) //fixed map
        $map_id = $map_profile; 

    if ($client_profile = profile("CUSTOMER")) //fixed Customer
        $client_id = $client_profile; 

    $select_size = 10;
    $popup_w = 550;
    $popup_h = 295;
    
    echo 
	script ("
        function select_all(field_aux) {
	    field = document.getElementById(field_aux);
	    for (i = 0; i < field.length; i++)
		field[i].selected = ! field[i].selected;
	}");

    if (!empty($field) && !empty($field_id)) {

	$api = $jffnms->get("interfaces");
	
	if ($field_id!=="all")
	    $filters = array($field=>$field_id);

	if (isset($map_id)) $filters["map"]=$map_id;
	if (isset($client_id)) $filters["client"]=$client_id;

	$cant = $api->get(NULL,$filters);
	$interfaces = array();
	$max_options = 20;

	if ($cant > 0)
	while ($int = $api->fetch()) {

	    $description = array();
	    switch ($field) {
		case "host":
		    $description = array($int["type_description"], $int["interface"], 
			$int["client_shortname"], $int["description"]);
		    break;
		    
		case "type":
		default:
		    $description = array($int["host_name"], $int["zone_shortname"],
			$int["interface"], $int["client_shortname"], $int["description"]);
	    }
	    
	    $final_description = join(" ",$description);
	    $final_description = str_replace(" ", "&nbsp;", $final_description);
	    
	    $interfaces[$int["id"]] = $final_description;
	}
	asort ($interfaces);
	
	echo 
	    script("
	    function operation (op) {
		orig = document.getElementById('selector[]');
		size = orig.length;
		for (i=0; i < size; i++) 
		    if (orig.options[i] && orig.options[i].selected == true) {
			if (op=='add') {
			    opener.add(orig.options[i].text, orig.options[i].value);
			    orig.options[i].className='select_mark';
			} else {
			    opener.del(orig.options[i].value);
			    orig.options[i].className='';
			}
		    }
	    }
	    
	    function view_now (field) {
		if (document.getElementById('selector[]').selectedIndex==-1) 	// Nothing selected
		    opener.go_select(field);					// Show all host interfaces
		else {
		    operation('add');						// add selected interface
		    opener.document.getElementById('selector_form').submit();	// submit form
		    close_popup();
		}
	    }
	    
	    function close_popup() {
		opener.popups[window.name] = null;			// remove myself from the popups list
		this.close();						// close this window
	    }
	    
	    ").
	    tag("div","popup_selector").
	    table("popup_selector").
	    tr_open().
	    td( $field_name, "title").
	    td(	control_button("View Now","_self", "javascript: view_now('".$field."');","world.png")).
	    td( control_button("Select All","_self", "javascript: select_all('selector[]');","world.png")).
	    td( control_button("Add","_self", "javascript: operation('add'); ","new2.png")).
	    td( control_button("Remove","_self", "javascript: operation('del'); ","delete.png")).
	    td( control_button("","_self", "javascript: close_popup(); ","logoff.png")).
	    tag_close("tr").
	    table_close().
	    (($cant>0)
		?select_custom("selector", $interfaces, "", "", $max_options, false, "", "javascript: operation('add'); ")
		:br().html("span","No Interfaces Found","no_interfaces_found")).
	    tag_close("div").
	    script("document.getElementById('selector[]').focus();");
	
	adm_footer();
	die();	
    }

    
    $view_types = array (
	"alarms"=>"/admin/adm/adm_alarms.php",
	"performance"=>"view_performance.php",
	"state_report"=>"/admin/reports/state_report.php",
	"interfaces"=>"/admin/adm/adm_interfaces.php"
    );
    
    //defaults
    if (empty($type)) $type = "performance";

    if (empty($view_types[$type]))
	die ("ERROR");
	
    $action = get_config_option ("jffnms_rel_path")."/".$view_types[$type];
    $action = str_replace ("//","/",$action);

    echo script ("

    popups = new Array();
    
    function ClosePopups() {
	for (var name in popups)
	    if (popups[name])
		popups[name].close();
    }

    window.onunload = ClosePopups;

    function go_select(field) {
	select = document.getElementById(field);
	
	if (select.selectedIndex == 0) return;
	
	id = select.options[select.selectedIndex].value;
	text = select.options[select.selectedIndex].text;
	name = field+'_'+id;
	
	if (!popups[name]) {
	    rand = new Date().getTime();

	    url = '".$REQUEST_URI."&field='+field+'&field_id='+id+'&field_name='+text;
	    popups[name] = window.open(url, name+'_'+rand, 'toolbar=no,scrollbars=no,location=no,status=no,menubar=no,screenX=250px,width=".$popup_w.",height=".$popup_h."');

	    if (!popups[name].opener) popups[name].opener = self;

	} else {

	    popups[name].close();
	    popups[name]=null;
	    url = '".$action."'+'?'+field+'_id='+id+'&name='+text;
	    parent.frames['".$frame."'].location=url;
	}
	return false;
    }
    
    function add (name, value) {
	select = document.getElementById('use_interfaces[]');
	size = select.length;
	
	already_added = false;
	
	for (i=0; i < size; i++)
	    if (select.options[i] && select.options[i].value == value)
		already_added = true; 

	if (!already_added) {
	    select[size] = new Option(name, value);
	    select[size].selected = true;
	}
    }
    
    function del (value) {
	select = document.getElementById('use_interfaces[]');
	size = select.length;
	
	for (i=0; i < size; i++)
	    if (select.options[i] && select.options[i].value == value)
		select.options[i]=null;
    }
    
    function del_selected() {
	select = document.getElementById('use_interfaces[]');
	size = select.length;
	
	for (i=size; i > -1; i--)
	    if (select.options[i] && (select.options[i].selected == true))
		select.options[i]=null;
    }

    function addlink(link, part, source) {
	field = document.getElementById(link);
	if (field) {
	    value = source.checked==true?1:0;
	    field.href = field.href+part+value;
	}
    }

    // IE FIX
    if (document.all) 
	parent.document.getElementById('interface_list').cols='275,*';

    old_size = -1;
    
    function toggle_menu(image_name,img_hidden, img_show) {
        fs = parent.document.getElementById('interface_list');
	img = document.getElementById(image_name);
	
	if (old_size==-1)
	    old_size = fs.cols;

	showed = old_size;
	hidden = '12,*';
	
        img.src = (fs.cols!=showed)?img_hidden:img_show;
        fs.cols = (fs.cols!=showed)?showed:hidden;
    }

    
    ").
        table("interface_selector").
        tr_open("header").
        td(linktext(image("b-left.png","","","Back","","back"),
	    "javascript: toggle_menu('back','../images/b-left.png','../images/b-right.png');").
        "&nbsp;"."&nbsp;".html("span","Interface Selector", "","title"),"","",2).
        td(linktext(image("refresh.png"),$REQUEST_URI),"action").
        tag_close("tr").

	tr_open().
	td("").
	td("").
	td("").
	tag_close("tr");
	    
    if (empty($map_id) && empty($client_id))
	$groups = array(
	    "host"=>array("select_hosts", "Hosts"), 
	    "client"=>array("select_clients", "Customers"), 
	    "map"=>array("select_maps", "Maps"), 
	    "type"=>array("select_interface_types", "Types")
	);
    else
	$groups = array(
	    "host"=>array("select_hosts_filtered", "Hosts", array("map"=>$map_id, "client"=>$client_id))
	);    
    	
    foreach ($groups as $group=>$group_data) {
        list ($func, $name, $filters) = $group_data;
	    
        $js = "javascript: go_select('".$group."');";
	    
        echo 
    	    tr_open().
	    td(
	        call_user_func_array($func, array($group, 0, 1, array(0=>$name), $js, $filters)),
	        "select", "", 2).
	    td(linktext(image("bullet6.png"), "#", "_self", "", $js),"action").
	    tag_close("tr");
    }
	
    echo form("selector_form",$action,"GET",$frame);
	
    table_row("&nbsp","spacer",3);
    
    echo
	hidden("name", "Selected").
	tr_open().
        td("Selected".br()."Interfaces", "selected_header","",1).
	td( control_button("Mark All","_self", "javascript: select_all('use_interfaces[]'); ","world.png").
	    control_button("Del","_self", "javascript: del_selected(); ","delete.png"),"buttons","",2).
	tag_close("tr");
    
    table_row(select_custom ("use_interfaces", array(), "", "", $select_size),"selector",3);

    table_row(adm_form_submit("View Selected Interfaces"),"view_selected",3);

    if (profile("REPORTS_VIEW_ALL_INTERFACES")) {
        table_row(linktext("View All Interfaces",$action."?&view_all=1",$frame),"view_all",3);
        $show_only_top = true;
    }

    if ($show_only_top && ($type=="performance"))
        table_row(
    	    checkbox_value("only_top",1,($GLOBALS["only_top"]==1)?1:0,1,
	        "javascript: addlink('view_all_group','&only_top=',this); addlink('view_all','&only_top=',this);").
	        "Show Only the Options&nbsp;","show_only_top",3);

    echo
	form_close().
	table_close();

    adm_footer(); 
?>
