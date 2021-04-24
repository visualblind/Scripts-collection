<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    $news_url = "http://www.jffnms.org/news.php"; //just return some HTML to be included in the start page (no body tags)
    
    $jffnms_init_classes = 1;

    include("auth.php");

    $map_id = 1; 
    if ($map_profile = profile("MAP")) $map_id = $map_profile; 

    $client_id = 0;
    if (empty($client_id)) $client_id = 0;
    if ($client_id_profile = profile("CUSTOMER")) $client_id = $client_id_profile; //fixed customer

    if (!$view_stats) $view_stats = profile("VIEW_STARTPAGE_STATS");

    adm_header("Start Page");
    
    echo 
	table("startpage").
	table_row("JFFNMS $jffnms_version Start Page","title",2,"",false).
	table_row($jffnms_site." Network Management System","subtitle",2,"",false);

    if ($view_stats==1) {
    
	$alarms = ($map_id==1) 
	    ?$jffnms->interfaces->status(NULL,array("in_maps"=>1,   "client"=>$client_id, "only_visible"=>true)) //all interfaces in rootmap
	    :$jffnms->interfaces->status(NULL,array("map"=>$map_id, "client"=>$client_id, "only_visible"=>true)); //all interfaces in map
	
	foreach ($alarms as $key=>$value) 
    	    if ($key!="total") $alarms_text .= "<b>".$key.":</b> ".$value["qty"]."<br>";
    
	if ($alarms_text=="") $alarms_text = "All OK";
    
	$info[]=array("title"=>"Alarms", "data"=>$alarms_text);

	if (($map_id==1) && ($client_id==0)) {	//only users with no filtered map
	    $info["hosts"] 	= array(	"title"=>"Hosts",	"data"=>$jffnms->hosts->count());
	    $info["interfaces"] = array(	"title"=>"Interfaces",	"data"=>$jffnms->interfaces->count());
	    $info["maps"] 	= array(	"title"=>"Maps",	"data"=>$jffnms->maps->count_all()-1);
	    $info["customers"] 	= array(	"title"=>"Customers",	"data"=>$jffnms->clients->count_all()-1);
	    $info["users"] 	= array(	"title"=>"Users",	"data"=>$jffnms->users->count_all());
	    $info["journals"] 	= array(	"title"=>"Journals",	"data"=>$jffnms->journal->count_all());
	}

	$news = news_get($news_url);

	foreach ($info as $aux)
	    if ($aux) 
		$infos.= 
		    tr_open().
		    td("&nbsp;","spacer").
		    td($aux["title"].": ","cat").
		    td($aux["data"],"data").
		    td("&nbsp;","spacer").
		    tag_close("tr");

	if (is_array($news))
	foreach ($news as $item) 
	    $news_data .= table_row($item,"","","",false);
	
    	echo 
	    tr_open("data").
	    td (table("stats").
		tr_open().
		    td("&nbsp;","spacer").
		    td("Statistics","sectitle","",2).
		    td("&nbsp;","spacer").
		tag_close("tr").
		$infos.
		table_close()).
	    (is_array($news)
		?td (
		    table("news").
		    table_row("News","sectitle",2,"",false).
		    $news_data.
		    table_close())
		:"").
	    tag_close("tr");
	
    } else 
	table_row(linktext("View Statistics","start.php?view_stats=1"),"view_stats",2);

    table_row("by Javier Szyszlican","author",2);
    echo table_close();
        
    adm_footer();
?>
