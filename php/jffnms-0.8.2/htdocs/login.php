<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    adm_header($jffnms_site." - Login");

    $jffnms_login_width = 400;
    $jffnms_login_height = 230;

    echo 
	html ("style","
	#login #box {
	    width: ".$jffnms_login_width."px;
	    height: ".$jffnms_login_height."px;
	    margin-left: -".($jffnms_login_width/2)."px; 
	    margin-top: -".($jffnms_login_height/2)."px;
	}","","","type='text/css'").

	script ("
    if (this.location!=top.location) //if we're in a frame
	top.location = '".$jffnms_rel_path."';
    
    function fix_focus() {
	if (document.all) {
	    username = document.all['user'];
	    password = document.all['pass'];
	} else {
	    username = document.getElementById ('user');
	    password = document.getElementById ('pass');
	}
	
	if (username.value=='')
	    username.focus(); 
	else
	    password.focus();
    }

    window.onload = function() {
	if (document.layers)
    	    document.captureEvents(Event.KEYDOWN);
   
	document.onkeydown = function(e) {
	    d = document.getElementById('jffnms_login');
    
	    if(e)
    		kC = e.which;
    	    else
    		kC = event.keyCode;
	    
	    switch(kC) {
        	case 13 : d.submit(); return false;
        	default : return true;
    	    }
	}
    }").
    
    tag("div", "login").
	tag("div", "box").
	    table("top").
	    tr_open().
	    td(image($logo_image, "","", "Logo","logo")).
	    td(linktext($jffnms_site, $logo_image_url).
		br().
		linktext("JFFNMS Login","http://www.jffnms.org"), "title").
	    tag_close("tr").
	    table_close().
    	    tag("div", "", "","align='center'"),
    		tag("div", "controls").
		    form("jffnms_login").
			html("label", "Username").
		        textbox("user", $_REQUEST["user"]).
			br().
	    	    	html("label", "Password").
			tag("input", "pass", "", "type='password' name='pass'").
    		    form_close().
		tag_close("div").
	    tag_close("div").
	    html("span",$error,"error").
        tag_close("div").
    	linktext("Developed by ".br()."Javier Szyszlican".br()."javier@jffnms.org", "http://www.szysz.com", "", "author").
    tag_close("div").
    script ("fix_focus();");

    adm_footer();
?>
