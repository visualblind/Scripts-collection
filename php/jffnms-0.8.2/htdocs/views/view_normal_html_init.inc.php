<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
	unset($refresh);
    
	adm_header("Alarm Map","$map_color");
?>
<style>
.infobox { visibility: hidden; position: absolute; }
.img { position: relative; }
</style>
<SCRIPT SRC="views/infobox.js"></SCRIPT>
<script src="views/toolbox.js"></script>
<?
    echo script("
    function ir_url(url,url2){
	if (url!='') {
	    if (top.work && top.work.events) 
		top.work.events.location.href = url; //if events frame exists use it
	    else 
		if (url2=='') 
		    url2=url; //if it doesnt and this is the only url take it to the main frame
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
    }");
?>    
<div name="infobox" id="infobox" class="infobox">
<table width="" height="" border=0 cellpadding=0 cellspacing=1 bgcolor=orange>
<tr><td bgcolor=yellow valign="top" align="center" nowrap><p id="text">ERROR</p></td></tr></table>
</div>
<?
    echo 
	table("view_interfaces").
	tr_open("","",$map_color);
?>
