<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include("../auth.php"); 

    if (!profile("ADMIN_HOSTS")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");

    function tool_info_render($name, $info, $value, $allow_set) {

	switch ($info["type"]) {

	    case "text":
		    $result = textbox($name,$value,$info["param"]["size"],0,($allow_set==0))." ".$info["param"]["label"];
		break;

	    case "select":
		if (!empty($value)) 
		    $result = select_custom($name,$info["param"],$value);
		else
		    $result = select_custom($name,array(),$value);
		break;

	    case "table":
		if (is_array($value)) {
		    $result = table();
		
		    if (count($value) > 0) {
			$result .= tr_open();
			foreach ($info["param"]["fields"] as $fn)
			    $result .= td ($fn);

			$result .= td ($info["param"]["action_field"]);
		
			$result .= tag_close("tr");
		    }		
		
		    foreach ($value as $key=>$data) {
			$result .= tr_open();
			foreach ($data as $fv)
			    $result .= td($fv);

			$result .= td(checkbox_value ($name."[]",$key));
			$result .= tag_close("tr");
		    }
		    
		    $result .= table_close();
		} else
		    $result = "No Information\n";
		break;

	    case "separator":
		$result = false;
		break;
	}
	return $result;
    }

    function head() {
	echo
	    tr_open("","top").
	    td("&nbsp;","","",2).
	    td(
		linktext("Refresh","javascript: tool_execute(true);")."&nbsp; | &nbsp;".
		linktext("Set","javascript: tool_execute(false);")).

	    td( linktext("Close","javascript: window.close();")).
	    tag_close("tr");
    }

    $tools = $jffnms->get("tools");
    $interfaces_obj = $jffnms->get("interfaces");

    // Specific Get
    if (isset($tool_get_data)) {
	list ($int_id, $tool_name,$tool_allow_set) = explode(",",$tool_get_data);
	
	echo tool_info_render("value-$int_id-$tool_name",
	    $tools->info($tool_name),
	    $tools->get_value($tool_name,
		$interfaces_obj->get_all($int_id,array("host_fields"=>1))),
	    $tool_allow_set);
	
	die();
    }

    // Specific Set
    if (isset($tool_set_data)) {
	list ($int_id, $tool_name, $value) = explode(",",$tool_set_data);

	list ($result, $value) = 
	    $tools->set_value($tool_name,
		$interfaces_obj->get_all($int_id,array("host_fields"=>1)),
		$value,
    	        $auth_user_name, false);

	echo ($result==true)?"<font color=green>OK</font>":"<font color=red>ERROR</font>";
	die();
    }

    $iframe = html("iframe","","NAME","", "name='NAME' OnLoad=\" if (src!='') { 
	frame = (parent.map)?parent.map:((parent.work)?parent.work:((parent.frame2)?parent.frame2:parent)); 
	frame.show(this); }\"");

    $refresh=0;
    adm_header("Tools");

    echo 
	script(
	"function tool_get (intid,tool,set) {\n".
	"	iframe_name = 'buffer_'+intid+'_'+tool;\n".
	"	ifr = document.getElementById(iframe_name);\n".
	"	url = document.location+'&tool_get_data='+intid+','+tool+','+set;\n".
	"	document.getElementById('result_'+intid+'_'+tool).innerHTML = '<font color=blue>Fetching</font>';\n".
	"	ifr.set = false;\n".
	"	ifr.src = url;\n".
	"}\n".

	"function tool_set (intid,tool,set) {\n".
	"	if (set==1) {\n".
	"		value = document.getElementById('value-'+intid+'-'+tool).value;\n".
	"		ifr = document.getElementById('buffer_'+intid+'_'+tool);\n".
	"		ifr.set = true;\n".
	"		document.getElementById('result_'+intid+'_'+tool).innerHTML = '<font color=blue>Setting</font>';\n".
	"		ifr.src = document.location+'&tool_set_data='+intid+','+tool+','+value;\n".
	"	}\n".
	"}\n".
	
	"function show (iframe) {\n".
	"	name = iframe.name;\n".
	"	if (iframe.set == true) { \n".
	"		result = 'result'+name.substr(6,name.length);\n".
	"		document.getElementById(result).innerHTML = this.frames[name].document.body.innerHTML;\n".
	"	} else {\n".
	"		div = 'tool'+name.substr(6,name.length);\n".
	"		document.getElementById(div).innerHTML = this.frames[name].document.body.innerHTML;\n".
	"		result = 'result'+name.substr(6,name.length);\n".
	"		document.getElementById(result).innerHTML = '<font color=green>DONE</font>'\n".
	"	}\n".
	"}\n".
    
	"function check() {
	    field=document.forms[0].elements['action'];
    	    for (i = 0; i < field.length; i++) { 
    		if (field[i].checked==true)
		    field[i].checked = false; 
		else
		    field[i].checked = true; 
	    }
	}\n".
	
	"function tool_execute(get) {
	    eles = document.forms[0].elements['action'];
	    for (i=0; i < eles.length; i++) {
		ele = eles[i];
		if (ele.checked) { 
		    vars = ele.value.split('-');
		    if (get) 
			tool_get (vars[0],vars[1],vars[2]);
		    else
			tool_set (vars[0],vars[1],vars[2]);
		}
	    }
	}").
	table("tools").
	form("","","GET");

    table_row("Tools", "title", 4);
    
    if (isset($use_interfaces) && !isset($interface_id)) $interface_id = $use_interfaces;

    if (!isset($host_id) && !isset($interface_id)) die ("Interface Not Selected");

    $shown_interfaces = 0;

    $interface_filters = array("host_fields"=>1);
    if (isset($host_id)) $interface_filters["host"]=$host_id;

    $ints = $interfaces_obj->get_all($interface_id,$interface_filters);

    if (is_array($ints) && (count($ints)>0)) {
	head();

	echo
	    tr_open("","header").
	    td("Tool Description").
	    td("Value").
	    td("Action ".linktext("[all]","javascript: check();")).
	    td("Result").
	    tag_close("tr");

	foreach ($ints as $int_id=>$int) { //Each Interface
	    
	    $tool_answer_ok = true;
	    
	    if (!is_array($tools_list[$int["type"]])) //if we didn't have it already
		$tools_list[$int["type"]] = $tools->get_all(NULL,array("itype"=>$int["type"])); //get this interface type tools

	    reset($tools_list[$int["type"]]);

    	    if (count($tools_list[$int["type"]]) > 0) { //if this interface type has tools

		table_row(
		    $int["host_name"]." ".$int["zone_shortname"]." ".$int["interface"]." ".$int["description"],
		    "interface", 4);
		
		while (list(,$tool) = each($tools_list[$int["type"]])) { //Each Tool of this interface Type

		    $tool_info = $tools->info($tool["name"]);
		    
		    $name = "value-$int_id-".$tool["name"];
		    unset ($result);
		
		    $info_render = tool_info_render($name,$tool_info,$tool_values[$int_id][$tool["name"]],$tool["allow_set"]);
		    
		    if ($info_render!==false) {
			
			$div_name = "tool_".$int_id."_".$tool["name"];
			$result_name = "result_".$int_id."_".$tool["name"];
		
			$iframe_name = "buffer_".$int_id."_".$tool["name"];
			$iframe_aux = str_replace("NAME",$iframe_name,$iframe);

			echo 
			    tr_open().
	    		    td($tool["description"]).
			    td(html("div", $info_render, $div_name).$iframe_aux).
			    td(checkbox_value("action",$int_id."-".$tool["name"]."-".$tool["allow_set"])).
		    	    td(html("div","&nbsp;", $result_name)).	//result
			    tag_close("tr");
		    } else
			table_row ($tool["description"],"",4);
		
		    flush();    
		}
		
		$shown_interfaces++;
	    } else
		if (count($ints)==1) //only if we were requested one interface
		    table_row ("There are no Tools defined for this Interface Type.","no_records_found",4);
	}
    } else
	table_row ("Bad Interface selection.","no_records_found",4);

    if ($shown_interfaces > 0)
	head();

    echo 
	form_close().
	table_close();

    adm_footer();
?>
