<? 
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../../auth.php"); 

    if (!profile("ADMIN_HOSTS")) die ("<H1> You dont have Permission to access this page.</H1></HTML>");
    
    adm_header("Hosts Config");

    $api = $jffnms->get("hosts_config");

    if (!$span) $span = 30;
    $cant = $api->get(NULL, $filter, $init, $span);
    $fields = 6;    

    echo 
	adm_table_header("Hosts Config (Cisco running-config) Viewer", $init, $span, $fields, $cant, "hosts_config", false).
	(($action!="diff")
	    ?form().
	    hidden("action","diff").
            tag("tr","","header").
	    td ("Action", "field", "action").
	    td ("ID", "field", "field_id").
	    td ("Date", "field").
	    td ("Host", "field").
	    td ("Config", "field").
	    td ("Size", "field").
	    tag_close("tr")
	    :"").
	tag("tbody");

    while ($rec = $api->fetch()) {
	
	if ($action!="diff")
	    echo 
		tr_open("row_".$rec["id"],(($row++%2)!=0)?"odd":"").
		td(
		    radiobutton("diff1", ($diff1==$rec["id"])?1:0, $rec["id"]).
		    radiobutton("diff2", ($diff2==$rec["id"])?1:0, $rec["id"]).
		    linktext("Read",$REQUEST_URI."&action=read&actionid=".$rec["id"]."&init=".$init)
		    , "action").

		td($rec["id"], "field_id").
		td($rec["date"], "field").
		td($rec["host_description"]." ".$rec["zone_description"], "field").
		td(substr($rec["config"], 0, 50), "field").
		td(strlen($rec["config"]), "field").
		tag_close("tr");
	
	if (($actionid==$rec["id"]) && ($action=="read")) 
	    echo 
		tr_open().
		td(memobox("", 20, 80, $rec["config"]), "field", "field_config", $fields, "", true).
		tag_close("tr");
    }

    echo
	tr(
	    (($action=="diff")
		?linktext("Go Back",$REQUEST_URI."&diff1=".$diff1."&diff2=".$diff2."&filter=".$filter."&action=")
		:adm_form_submit("View Diff")),
	    "action", $fields);

    echo
        ($action=="diff")
	    ?tr("Difference Between Configurations","header",$fields).
	    tr_open().
	    td(memobox("", 20, 80, $api->diff($diff1, $diff2)), "field", "field_config", $fields, "", true)
	    :form_close();

    adm_footer();
?>
