<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    class jffnms_access_api { 
	var $session;
	
	function jffnms_access_api ($init_type = NULL) {
	    if (isset($init_type)) $this->init_type = $init_type;
	}
    
	function get($class_name) {
	    $new_class_name = "jffnms_remote_$class_name";
	    $obj = NULL;
	    
	    if (!class_exists($new_class_name)) {
	
		$methods = $this->_call($class_name,"get_methods",NULL);
	    	    
	        $class_code.=" class $new_class_name extends jffnms_access_api {\n";
		if (is_array($methods)) {
		    foreach ($methods as $meth) 
			if (!(($class_name=="jffnms") and ($meth=="get"))) { //don't overwrite the jffnms->get method
			    $class_code.=" function $meth() {\n";
		    	    $class_code.=" \$params = func_get_args();\n";
			    $class_code.=" return parent::_call('$class_name','$meth',\$params);\n";
		    	    $class_code.=" }\n";
			}
		    $class_code.=" }\n";

		    eval ($class_code);
		}
	    }
	    
	    if (class_exists($new_class_name)) { //class created
		$obj = new $new_class_name;
		$obj->session = &$this->session;
	    
		if ($class_name=="jffnms") { //special mail class
		    $jffnms_classes = $obj->jffnms ($this->init_type);
		
		    if ($this->init_type==1) //init all classes
			foreach ($jffnms_classes as $aux) 
			    if ($aux!="access_api")
				$obj->$aux = $this->get($aux);
		}
	    }
	    
	    return $obj;
	}
	
	function _call ($class,$method,$params) {
	    $server = get_config_option("jffnms_satellite_server_uri");
	    
	    if (empty($this->session)) $this->session = "get";
	        
	    $message = array(
		"sat_id"=>1,
		"class"=>$class,
		"method"=>$method,
		"params"=>$params,
		"session"=>$this->session
	    );

	    $ret = satellite_query ($server,$message,"GUIClient",0);
	    //debug (array(request=>$message,response=>$ret));

	    if (is_array($ret) && (isset($ret["session"]))) {
		$this->session = $ret["session"];
		unset ($ret["session"]);
	    }
	
	    return $ret;
	}
    }

    function clean_url_array (&$list, $key,$value,$deep = 0) {
	if (is_array($value))
	    foreach ($value as $k=>$v) {
		//debug ("DEEP $deep - $key - $k - $v");
		$key_aux = (is_array($value)&&!empty($key))?"[$k]":$k;
		
		clean_url_array($list,$key.$key_aux,$v,$deep+1);
	    }
	else {
	    //debug ("VALUE $deep - $key - $value");
	    $list[] = urlencode($key)."=".urlencode($value);
	}
    }
    
    function clean_url($extra_vars = array(),$no_vars = array()) {
	if ($GLOBALS["_GET"]) 
	    $REQUEST_URI_VARS = array_merge($GLOBALS["_GET"],$GLOBALS["_POST"],$extra_vars); //suport for PHP 4.1.0 and older
    	else 
	    $REQUEST_URI_VARS = array_merge($GLOBALS["HTTP_GET_VARS"],$GLOBALS["HTTP_POST_VARS"],$extra_vars);

	foreach ($no_vars as $delete)
	    unset($REQUEST_URI_VARS[$delete]);

	$url_aux=array();
	clean_url_array($url_aux,"",$REQUEST_URI_VARS);
    
        $REQUEST_URI_CLEAN = $GLOBALS["SCRIPT_NAME"]."?".join("&",$url_aux);

	$GLOBALS["REQUEST_URI"]=$REQUEST_URI_CLEAN; //cleaning up the URL
    }    

    function http_authenticate() {
	global $jffnms_version,$jffnms_real_path,$jffnms_rel_path;
	header( "WWW-Authenticate: Basic realm=\"JFFNMS $jffnms_version\"");
	header( "HTTP/1.0 401 Unauthorized");
	include("$jffnms_real_path/htdocs/logout.php");
	exit;
    }

    function show_license($title) {

	return 
"<!--
/* $title\n
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 *
 * This file is part of JFFNMS.
 *
 * JFFNMS is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * JFFNMS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with JFFNMS; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */
-->\n";

    }

    function adm_header($title = "", $bgcolor = "", $body_others="", $just_head = false) {
	global $refresh,$REQUEST_URI;
    
	echo 
	    ((!$just_head)?tag("!DOCTYPE", "", "","HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\"", false):"").
	    show_license($title).
	    tag("html","","","",false).
	    tag("head").
	    html("title", (!empty($title)?$title." - ":"")."JFFNMS").
	    tag("meta","","","HTTP-EQUIV='Pragma' CONTENT='no-cache'", false).
	    tag("meta","","","HTTP-EQUIV='Content-Type' CONTENT='text/html; charset=iso-8859-1'", false).
    	    tag("meta","","","HTTP-EQUIV='Content-language' CONTENT='en'", false).
	    tag("meta","","","HTTP-EQUIV='Content-Style-Type' CONTENT='text/css'", false).
	    tag("meta","","","HTTP-EQUIV='Content-Script-Type' CONTENT='text/javascript'", false).

	    (($refresh)
		?tag("meta","","","HTTP-EQUIV='Refresh' CONTENT='".$refresh.";".$REQUEST_URI."'", false)
		:"").

	    tag("link","","","rel='shortcut icon' type='image/x-icon' href='".$GLOBALS["jffnms_rel_path"]."/images/jffnms.ico'", false).
	    tag("link","","","rel='icon' type='image/x-icon' href='".$GLOBALS["jffnms_rel_path"]."/images/jffnms.ico'", false).
	    tag("link","","","rel='stylesheet' href='".$GLOBALS["jffnms_rel_path"]."/default.css'", false).
	    (!empty($GLOBALS["jffnms_custom_css"])?tag("link","","","rel='stylesheet' href='".$GLOBALS["jffnms_custom_css"]."'", false):"").
	    tag("link","","","rel='alternate' type='application/rss+xml' title='".$GLOBALS["jffnms_site"]." Events Feed' href='".$GLOBALS["jffnms_rel_path"]."/events.php?view_type=rss'", false).
	    tag_close("head"). 
	    ((!$just_head)
		?tag ("body","","",
		    (!empty($bgcolor)?" style='background-color: #$bgcolor;'":"").
		    (!empty($body_others)?" ".$body_others:"")
		    ,false)
		:"");
    }

    function adm_footer () {
	echo
	    tag_close("body").
	    tag_close("html");
    }

    function news_get ($news_url) {
	$news = http_post_message($news_url,news_parse());
        if (!empty($news))
    	    return @explode("\n",$news);
	else 
	    return false;
    }

    function control_button ($text, $frame = "", $url = "" ,$image = "", $control_name = "", $onclick = "") { 

	if (empty($image)) $image = "bullet3.png";	// So people call it with an empty value

	$result = 
	    linktext ("\n".
		(($image!="none")?image($image)."&nbsp;":"")
		.$text."\n"
		,$url, $frame, "controlbutton", $onclick, $control_name);
    
	return $result;
    }

    function javascript_refresh($url,$time) {
	$time_usec = $time*1000;
	if (($url) && ($time > 1)) 
	    $value = script("refresh_timeout = window.setTimeout ('$url',$time_usec);");
	
	return $value;
    }

    function play_sound($file) {
	$file = $GLOBALS["jffnms_rel_path"]."/sounds/".$file;

	return 
	    html("embed", "", "", "", "src='".$file."' autostart='true' hidden='true' loop='false'"). 	    // MOZ

	    html ("object", tag("param", "", "", "name='Filename' value='".$file."'")
	    ,"", "", "hidden='true' classid='clsid:22D6F312-B0F6-11D0-94AB-0080C74C7E95' style='display: none;'"); 	    // IE

    }
    
    function show_event ($event,$color,  $map_id,$filter_id) {
	global $REQUEST_URI, $express_filter, $jffnms_rel_path, $view_type, $journal_id;

	$image_ack = (($event["ack"]>0)?"ok.png":"alert2.gif");

	$filter_url = $_SERVER["SCRIPT_NAME"]."?filter_id=$filter_id";
	
	$date_unix = strtotime($event["date"]);
	$day = date ("j M",$date_unix);
	$hour = date ("H:i:s",$date_unix);
	$event_text = $event["text"];

	switch ($view_type) {

	    case "html":
		$day_filter = date ("Y-m-d",$date_unix-(60*60*24));
		$fgcolor = $event["fgcolor"];
		$bgcolor = $event["bgcolor"];
		$id = $event["id"];
		$ack_image = image($image_ack);
		
		$summary_ids = (is_array($event["summary_ids"])?join(",",$event["summary_ids"]):$event["id"]);

		$output =
		tr_open("event$id", (($event["ack"]!=0)?"ack":"event"), $bgcolor, "", "color: ".$fgcolor).

		//Date + Hour
		td(linktext($day, $filter_url."&express_filter=date,$day_filter,=")." ".html("a",$hour), "date").

		// Checkbox + Detail		
		td( checkbox_value("checkedid[]", $summary_ids, 
		    ((($event["ack"]!=0) && ($journal_id > 1) &&($journal_id==$event["ack"]))?1:0)). //check
		    linktext($ack_image,$REQUEST_URI."&journal_id=".(($event["ack"]==0)?1:0)."&journal_button=Ack&checkedid[]=".$summary_ids),
		    "ack_check").
		
		// Type
		td (linktext($event["type_description"], $filter_url."&express_filter=".$express_filter."^type,".$event["type_id"].",=&map_id=".$map_id), 
		    "type", "", (($event["show_host"]==0)?3:""));
		
		if ($event["show_host"] == 1) //Host + Zone
		    $output .= 
			td(
			    linktext("&nbsp;".substr($event["host_name"],0,20)." ".$event["zone"]."&nbsp;", 
				$filter_url."&express_filter=".$express_filter."^host,".$event["host_id"].",=&map_id=".$map_id),
			    "host", "", (empty($event["zone_image"])?2:"")).
	
		    (!empty($event["zone_image"])
			?td(linktext(image($event["zone_image"]), 
				$filter_url."&express_filter=".$express_filter."^zone,".$event["zone_id"].",=&map_id=".$map_id),
			    "zone"):"");

		// Event Text
		$output .= td($event_text, "detail");
		
		//closing
		$output .=
		    tag_close("tr");
		
	    break;

	    case "csv":
		$day_only = date ("Y-m-d",$date_unix);

		$fields = array($day_only,$hour,$event["host_name"],$event["zone_name"],$event["user"],$event["interface"],
		    $event["type_description"],$event["state"],$event["info"],$event["severity"]);
		
		foreach ($fields as $key=>$aux)
		    $fields[$key] = "\"".$aux."\"";
		
		$output = join(",",$fields)."\n";
	    break;
	
	    case "rss":
	    case "rdf":
		$output .=  
		    html("item", 
			html("title", $event["severity"]." - ".$event["host_name"]." ".$event["zone"].": ".$event_text, "", "", "", false, true).
			html("pubDate", $event["date"], "", "", "",false, true).
			html("link", 
			    htmlspecialchars(current_host().$REQUEST_URI."&view_type=html"), "", "", "",false, true)
			);
	    break;
	}

	echo $output;
    } //function show_event

    function interface_shortname_and_card ($interface,$type_description,$break_by_card) {

	$interface_len = strlen($interface);
	
	for ($pos = 0; ($pos < $interface_len) && (!is_numeric($interface[$pos])); $pos++);
	    
        $space_pos = strpos($interface," ");

	if ($interface_len > 9) {
	    if ($pos <= 0) $pos = 1;
	    if ($pos == $interface_len) $pos = 1; //if there was no numbers in the interface name
	    
	    if ($space_pos!==FALSE) { //if the interface has a space in it
		$int = substr($interface,0,$space_pos)." ".$interface[$space_pos+1]; // from Real Memory take Real M
		$pos = $space_pos;
	    } else 
		$int = $interface[0].substr($interface,$pos,$interface_len); //from Serial9/3/4 take S9/3/4
	} else $int = $interface;

	if (strpos($interface,"/")===FALSE) $pos--; //if the interface is not part of a card Serial3/4 | Tunnel0 then pos-- because card will not include the number
	

	if ($break_by_card==1) {
	    if (is_numeric($interface[$pos])) //Card Number Numeric Serial9 interface[pos]="9"
		$card = substr(substr($interface,0,$pos),0,8).$interface[$pos]; //use Serial9
	    else 
		$card = substr(substr($interface,0,$pos+1),0,9); //interface[pos] not numeric, use all 9 chars from interface name
	} else 
	    $card = substr($type_description,0,9);
	
	$int = trim($int);
	$card = trim ($card);
	
	//debug ("inter: $interface -- int: $int -- card: $card -- len: $interface_len -- pos: $pos -- pos1: $pos1");// continue;
	return Array ($int, $card);
    }

    //Get the Graph File from object and store it in a local (public) place
    function performance_graph ($interface_object, $id, $graph_filename, $graph_function, $sizex, $sizey, $title, $graph_time_start, $graph_time_stop, $other_data = "") {

	list ($value, $graph_data, $other_data) = $interface_object->graph($id, $graph_function, $sizex,$sizey, $title,$graph_time_start,$graph_time_stop, $other_data);

	$graph_data = base64_decode ($graph_data);
	$fp = fopen ($graph_filename, "wb+");
	fputs($fp,$graph_data);
	fclose ($fp);
	
	return $value;
    }

    function news_parse () {
	return array("site"=>$GLOBALS["jffnms_site"],"version"=>$GLOBALS["jffnms_version"],"h"=>$GLOBALS["info"]["hosts"]["data"],"i"=>$GLOBALS["info"]["interfaces"]["data"],"f"=>$_SERVER["REMOTE_ADDR"],"php"=>phpversion(),"apache"=>$_SERVER["SERVER_SOFTWARE"]);
    }

    function alarms_get_status ($alarms) {
	$lower_alarm=256;
	$lower_alarm_id = 2;
	
	if (is_array($alarms))
	foreach ($alarms as $alarm_name=>$data) 
	    if ($data["alarm_level"] < $lower_alarm) {
		$lower_alarm = $data["alarm_level"];
		$lower_alarm_name = $alarm_name;
		$bgcolor = $data["bgcolor"];
		$fgcolor = $data["fgcolor"];
	    }
	    
	$alarms_parsed = array();
	$alarms_long = array();
	
	if (is_array($alarms))
	foreach($alarms as $key=>$alarm) {
	    if ($key=="total") $alarms_parsed[$key]="T=".$alarm[qty];
		else $alarms_parsed[$key]=strtoupper($key[0]).$alarm[qty];
	    
	    $alarms_long[$key]=$alarm["qty"];
	}
	$status = join("/",$alarms_parsed);

	return array($status,$bgcolor,$fgcolor,$alarms_long,$lower_alarm_name);
    }

    function profile ($tag, $set_value = NULL) {

        $profile = $GLOBALS["jffnms"]->get("profiles");
	
	if ($set_value !== NULL)
	    $profile->update($GLOBALS["auth_user_id"], $tag, $set_value);

	$value = $profile->get_value($tag,$GLOBALS["auth_user_id"]);

	return $value;
    }
    
    function cookie ($tag, $set_value = NULL) {
	
	session_start();
	
	if ($set_value !== NULL)
	    $_SESSION[$tag] = $set_value;

	$value = $_SESSION[$tag];
	
	session_write_close();
	
	return $value;
    }

    function ImageStringCenter($im,$color,$y,$text,$big = 0) {

	if (!is_array($text)) $text = array($text);

	if ($big==0) {
	    $size = 2;
	    $charsize = 6;
	    $line_span = 9;
	}

	if ($big==1) {
	    $size = 4;
	    $charsize = 8;
	    $line_span = 13;
	}
	
	$len = (strlen($text)*$charsize);
	$sizex = imagesx($im);
	$sizey = imagesy($im);

	$cant_lines = count($text);
	$lines_space = ($cant_lines * $line_span);
	$space_left = ($sizey - $lines_space);
	$y_span = floor(($space_left/($cant_lines*2)));

	//echo "$sizey $lines_space $space_left $cant_lines $y_span ----";

	$line_number = 0;
	foreach ($text as $align=>$aux) {
	    $aux = substr($aux,0,($sizex/$charsize));
	    $len = (strlen($aux)*$charsize);

	    if (is_numeric($align)) $align = "center";
	    
	    switch ($align) {
		case "center" 	: $x=($sizex/2)-($len/2); break;
		case "left" 	: $x=($sizex-$len); break;
		case "right" 	: $x=0; break;
	    }
	    
	    ImageString ($im, $size, $x, $y+$y_span+($line_number*($line_span+$y_span)), $aux,$color);
	    $line_number++;
	}
    }
    
    function current_host() {
	return "http".(isset($_SERVER["HTTPS"])?"s":"")."://".$_SERVER["HTTP_HOST"];
    }
    
?>
