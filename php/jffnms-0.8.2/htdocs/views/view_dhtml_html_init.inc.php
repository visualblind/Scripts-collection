<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    unset($refresh);
    adm_header("Alarm Map", $map_color);

    // Popup Delays
    $base_delay = 1000;
    $show_delay = $base_delay*1;
    $hide_delay = $show_delay*4; //take 4 times more time to hide than to show

    echo 
	script("
var shown_objects = new Array();
var lastzIndex = 1;

function show_info(o,text) {
    oid = o.id;
    
    //hide all other boxes. already shown or not
    for (var i in shown_objects)
	if ((shown_objects[i]!=null) && (i!=oid)) {
	
	    if (shown_objects[i]['state']==0) 	//if it was not shown yet
		shown_objects[i] = null;	//just delete it, to avoid it to be shown
	    else
		window.setTimeout (\"real_hide_info('\"+i+\"');\",".$hide_delay."); //hide it normally
	}
	
    if (!shown_objects[oid]) { //if not's already created
    	shown_objects[oid] = Array();
    	shown_objects[oid]['obj'] = o;
    	shown_objects[oid]['state'] = 0;

    	window.setTimeout (\"real_show_info('\"+text+\"','\"+oid+\"');\",".$show_delay."); //delay real show
    }
}

function real_show_info(text,oid) { 
    a = shown_objects[oid];
    if (!a) return 1; //if exists
    
    o = a['obj'];
    if (!o) return 2; //if its valid;
    
    if (shown_objects[oid]['state']!=0) return 3; //don't do it again

    shown_objects[oid]['state']=1;

    //save values for restore
    shown_objects[oid]['old_x'] = o.style.left;
    shown_objects[oid]['old_y'] = o.style.top;
    shown_objects[oid]['old_w'] = o.style.width;
    shown_objects[oid]['old_h'] = o.style.height;
    shown_objects[oid]['old_text'] = o.innerHTML;
    shown_objects[oid]['old_size'] = o.style.fontSize;
    shown_objects[oid]['old_border'] = o.style.borderStyle;

    //save current position values
    x = parseInt(o.style.left.replace('px',''));
    y = parseInt(o.style.top.replace('px',''));
    w = parseInt(o.style.width.replace('px',''));
    h = parseInt(o.style.height.replace('px',''));

    o.style.width = 'auto' ;
    o.style.height = 'auto' ;
    o.style.overflow = 'visible';
    o.style.zIndex = lastzIndex++;

    o.innerHTML = text;
    o.style.fontSize = '".round($charsize*1.6)."px';
    o.style.lineHeight = o.style.fontSize;

    o.style.borderStyle = 'solid';

    //re-center the box
    o.style.left = 0;
    o.style.top = 0;

    new_w = o.offsetWidth;
    new_h = o.offsetHeight;
    
    new_x = x + (w/2) - (o.offsetWidth/2)
    new_y = y + (h/2) - (o.offsetHeight/2)
    o.style.left = new_x ;
    o.style.top  = new_y;


    //Fix Position
    win_w = window.document.body.clientWidth;
    win_h = window.document.body.clientHeight;
    win_t = window.document.body.scrollTop;
    win_l = window.document.body.scrollLeft;
    dif = 2;
    
    //fix the scroll values
    new_y -= win_t;
    new_x -= win_l;
    
    if ((new_x + new_w) >= win_w)
	o.style.left = win_w - new_w - dif + win_l;

    if ((new_y + new_h) >= win_h)
	o.style.top = win_h - new_h - dif + win_t;
    
    if (new_x <= dif) 
	o.style.left = win_l + dif;

    if (new_y <= dif) 
	o.style.top  = win_t + dif;

    x = parseInt(o.style.left.replace('px',''));
    y = parseInt(o.style.top.replace('px',''));

    toolbox_show(oid,x,new_w,y+new_h);
    return 0;
}

function hide_info(o) {
    window.setTimeout (\"real_hide_info('\"+o.id+\"');\",".$hide_delay."); //delay real hide
}

function real_hide_info(oid) {
    a = shown_objects[oid]
    if (!a) return 1; //if exists

    o = a['obj'];
    if (!o) return 2; //if its valid

    if (shown_objects[oid]['state']!=1) return 3; //if is shown
    
    o.innerHTML = shown_objects[oid]['old_text'];
    o.style.fontSize = shown_objects[oid]['old_size'];
    o.style.lineHeight = o.style.fontSize;
        
    o.style.borderStyle = shown_objects[oid]['old_border'];

    o.style.width = shown_objects[oid]['old_w'];
    o.style.height = shown_objects[oid]['old_h'];
    o.style.left = shown_objects[oid]['old_x']
    o.style.top  = shown_objects[oid]['old_y']

    o.style.overflow = 'hidden';
    o.style.zIndex = 0;
    
    shown_objects[oid] = null;

    toolbox_hide(oid);

    return 0;
}

function ir_url(url,url2){
    if (url!='') {
	if (top.work && top.work.events) 
	    top.work.events.location.href = url; //if events frame exists use it
	else 
	    if (url2=='') 
		url2=url; //if it doesnt and this is the only url take it to the main frame
//	    else
//		window.open(url); //if the events frame doesn't exists, but we have to show 2 urls, show this one in a new window
    }
    
    if (url2!='') {
	if (top.work && top.work.map)
	    top.work.map.location.href = url2;
	else
	    if (top.work)
		top.work.location.href = url2; //y esto que si no esta map salga en work
	    else
		window.open(url2); //esto hace que si no esta la frame salga una window
    }
}").

    html ("script", "", "", "", "src='views/toolbox.js'").

    html ("style","
.interface {
    position:absolute; 
    border-width: 1px; 
    border-color: black;
    border-style: solid;
    font-size: ".$charsize."px; 
    line-height: ".$charsize."px; 
    font-family: sans-serif,monospace,arial; 
    letter-spacing: 0px; 
    white-space: nowrap;
    margin: 0px 0px 0px 0px; 
    padding: 3px 0px 0px 0px;
    overflow: hidden; 
    float: right;
    align: left;
    word-wrap: none;
    text-align: center;
    cursor: pointer;
}","","","type='text/css'").

    script("
    //FIX IE Things
    if (document.all) {
	document.styleSheets[0].rules[0].style.paddingTop = '0px';
        document.styleSheets[0].rules[0].style.cursor = 'hand';
    }");
?>
