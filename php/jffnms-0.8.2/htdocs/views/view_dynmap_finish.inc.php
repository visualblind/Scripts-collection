<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
if (count($dynmap_objects) > 0) {
    
    $js_objects = "";
    
    foreach ($dynmap_objects as $id=>$object) { //process objects
	extract($object,EXTR_PREFIX_ALL,"obj");

	if ($obj_int_id > 1)
	    $js_objects .= " 
	    objects[$obj_int_id]=new Array();
	    objects[$obj_int_id][0]=$id;
	    objects[$obj_int_id][1]=new Array();
	    objects[$obj_int_id][2]=".$object[x].";
    	    objects[$obj_int_id][3]=".$object[y].";
	";
    }
    
    foreach ($dynmap_objects as $id=>$object) { //process connexions
	extract($object,EXTR_PREFIX_ALL,"obj");

	if ($obj_int_id == 1) {
	    $cant_cnx++;
	    $js_objects .= " 
	    objects[$obj_x][1][$id] = $obj_y;	
	    objects[$obj_y][1][$id] = $obj_x;
	    ";	
	}
    }

    echo script($js_objects);

    if ($action=="edit") {
	foreach ($dynmap_objects as $id=>$object)
	    if ($object[int_id]==1) echo "<div class='mapbox'><img id='conexion$id' src='' border=0></div>\n";
    
    } else if ($cant_cnx > 0)
		echo "<div class='mapbox'><img id='allconexions' src='' border=0></div>\n";

    echo "\n<div class='mapbox' onMouseMove='javascript: follow_object(event);'><table width='100%' height='100%'><tr><td>&nbsp</td></tr></table></div>\n";

    foreach ($dynmap_objects as $id=>$object) {

        $a_init = "<a <a_events>>";
	$a_end = "</a>";

	if ($action=="edit") { 
	    $object[image_events] = "
	    OnDblClick='javascript: link_to_object(\"".$object[int_id]."\");' 
	    OnMouseUp='javascript: select_object(\"".$object[int_id]."\");'  
	    OnMouseMove='javascript: follow_object(event);'";
	    unset ($object[a_events]);
	} 
	
	$a_init = str_replace ("<a_events>",$object[a_events],$a_init);
	$object["html"] = str_replace ("<image_events>",$object["image_events"],$object["html"]);
	
	if ($object[int_id] > 1) {
	    $top =  ($object[y]-($sizey/2));
	    $left = ($object[x]-($sizex/2));
	    if ($top < 1) $top = 1;
	    if ($left < 1) $left = 1;
	    echo 
        "\n\t<div id='object".$object["int_id"]."' style='position:absolute; top: $top; left: $left'>".
	"\n\t$a_init".$object["html"]."$a_end</div>\n".$object["toolbox"];
	}
    }

    echo "\n<div id='infobox' class='infobox'><table width='' height='' border=0 cellpadding=0 cellspacing=1 bgcolor=orange>".
    "<tr><td bgcolor=yellow valign='top' align='center' nowrap><p id='text'>ERROR</p></td></tr></table></div>\n";

    //Debug Box
    if ($debug==1) 
	echo "<div style='top:50;left:800;position:absolute;background-color:white'><p id='debugtext'><u>Debug Console</u></p></div>";
    else 
	$visibility = "visibility: hidden;";

    //savebox
    echo "
	<SCRIPT>
	document.write('\<div style=\"top: '+(totaly-30)+';left:'+(totalx-200)+';position:absolute;$visibility\">'+
	'<IFRAME id=savebox width=200 height=30></IFRAME></div>');
	</SCRIPT>";

    //Edit/View Box
    //permission FIXME
    echo script("document.write (\"<div style=\'top:5;left:\"+(totalx+5)+\";position:absolute;\'>\");");
	    
    if ($action=="edit") 
	echo 
	    linktext(image("refresh2.png"),$REQUEST_URI).
	    linktext(image("logoff.png"),$REQUEST_URI."&action=view");

    else 
	if (profile("ADMIN_HOSTS"))
	    echo linktext(image("edit.png"),$REQUEST_URI."&action=edit");

    echo tag_close("div");

    echo script("position_new_objects();");

    if ($action=="edit") {
	echo script("redraw_all_connections();");
	$norefresh=1;
    } else 
	echo script("draw_all_connections();");
}

?>
