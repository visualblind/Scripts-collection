<?	
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../auth.php"); 

    function list_color($color) {
	return
	    tr_open("", "", "#".$color).
	    td(linktext("Select", "javascript: selectColor('".$color."');")).
	    tag_close("tr");
    }

    adm_header("Color Select");

    echo 
	script("
    function selectColor(color) {
    
	select = opener.document.getElementById(opener.select);

	select.value = color;
        select.style.backgroundColor = '#'+color;

	self.close();
    }").

	table("color_select").

	list_color($actual_color).
        list_color("000000").
        list_color("FFFFFF").
        list_color("FF0000").
        list_color("00FF00").
        list_color("0000FF");

    $color_array = array("0","9","F");
    $a = 0; $b = 0; $c=0; $d=0; $e=0; $f=0;
    
    foreach ($color_array as $a) 
    //foreach ($color_array as $b)
    foreach ($color_array as $c) 
    //foreach ($color_array as $d)
    foreach ($color_array as $e) 
    //foreach ($color_array as $f) 
	echo list_color($a.$b.$c.$d.$e.$f);
    
    echo 
	table_close();

    adm_footer();
?>
