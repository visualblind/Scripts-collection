<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    /* Basic HTML Structures */

    function tag ($name, $id = "", $class = "", $others = "", $indent = true, $keep_lines = false) {
	return  
	    html_indenter().
	    "<".$name.
	    (!empty($id)?" id='".$id."'":"").
	    (!empty($class)?" class='".$class."'":"").
	    (!empty($others)?" ".trim($others):"").
	    ">".
	    (($keep_lines)?"":"\n").
	    (($indent)?html_indent_more():"");
    }

    function tag_close($name, $indent = true, $indent_after = true) {
	return 
	    (($indent)?html_indent_less():"").
	    (($indent_after)?html_indenter():"").
	    "</".$name.">\n";
    }

    function html ($name, $content, $id = "", $class = "", $others = "", $indent = true, $keep_lines = false)  {
	return
	    tag ($name, $id, $class, $others, $indent, $keep_lines).
	    (!empty($content)
		?re_indent($content,$keep_lines)
		:"").
	    tag_close($name, $indent, $indent);
    }

    function re_indent($text, $keep_lines = false) {

	if ($keep_lines) return $text;

	$ind = html_indenter();

        $lines = explode("\n",$text);
    
	foreach ($lines as $line)
	    if ($line!=="") {
		$line = rtrim($line);
		if (++$i==1) $cant = @substr_count("\t",$line);
	    
		$line = substr($line,$count);
	        $result .= $ind.$line."\n";
	    }

	return rtrim($result)."\n";
    }

    /* Complex HTML Structures */

    function table ($id="", $class = "") {
	return tag("table", $id, $class, "", false);
    }
    
    function table_close() {
	return tag_close ("table", false);
    }

    function tr_open($id = "", $class = "", $bgcolor = "", $rowspan = "", $style = "") {
	return
	    tag("tr", $id, $class, 
		(!empty($bgcolor)?" bgcolor='$bgcolor'":"").
		(!empty($rowspan)?" rowspan=$rowspan":"").
		(!empty($style)?" style='$style'":""));
    } 

    function td ($content="", $class = "", $id = "", $colspan = "", $rowspan = "", $keep_lines = false) {
	return
	    html ("td", $content, $id, $class, 
		(is_numeric($colspan)?" colspan='$colspan'":"").
		(is_numeric($rowspan)?" rowspan='$rowspan'":""), true, $keep_lines);
    }

    function table_row($text = "", $class = "", $colspan="", $rowspan="", $echo = true) {
    
	$result = 
	    tr_open("", "", "", $rowspan).
	    td($text, $class, "", $colspan).
	    tag_close("tr");
    
	if ($echo) 
	    echo $result;

	return $result;
    }

    function tr ($tds = "", $classes = "", $colspans="", $rowspan="") {
	
	$tds = !is_array($tds)?array($tds):$tds;
	$classes = !is_array($classes)?array($classes):$classes;
	$colspans = !is_array($colspans)?array($colspans):$colspans;

	$result = tr_open("", "", "", $rowspan);
	
	foreach ($tds as $key=>$td_content) 
	    $result .= td ($td_content, 
		(isset($classes[$key])?$classes[$key]:current($classes)), "", 
		(isset($colspans[$key])?$colspans[$key]:current($colspans)));

	$result .= tag_close("tr");
    
	return $result;
    }

    function script ($content) {
	return 
	    tag ("script","","","type='text/javascript'").
	    re_indent($content,true)."\n".
	    tag_close("script");
    }

    function br() {
	return tag ("br","","","",false);
    }

    function memobox($name,$rows,$cols,$value) {
        return 
	    html ("textarea", $value, "", "", "rows='$rows' cols='$cols' name='$name'", false, true);
    }

    function checkbox($name, $var, $form = true) {
	return checkbox_value($name,1,$var,$form);
    }

    function checkbox_value($name,$value, $check = false, $form = true, $onclick="") {
	if ($form==false) {
	    $name = "checkbox_".rand(1000,9999);
	    $disabled = " disabled";
	}
    
	if ($check==true) $checked=" checked";
        if (!empty($onclick)) $js = " onClick=\"$onclick\"";
    
	return 
	    tag("input", $name, "", 
	    "type='checkbox' name='$name' value='$value'".$checked.$js.$disabled, false);
    }

    function textbox($name, $var, $len = 0, $maxsize = 0, $disabled = 0) {
	return tag("input", $name, "", 
	    "type='text' name='$name' value='$var' size='".(($len==0)?strlen($var):$len)."'".
	    (($maxsize>0)?" maxsize='$maxsize'":"").
	    (($disabled==1)?" disabled":""), false);
    }

    function form ($id = "", $action = "", $method = "POST", $target = "_self", $class = "") {
	return	
        tag ("form", $id, $class,
		(!empty($action)?" action='".$action."'":"").
		(!empty($method)?" method='".$method."'":"").
		(!empty($target)?" target='".$target."'":"")
	    ,false);
    }

    function adm_form_submit($value = "Submit", $name = "") {
	return 
	    tag ("input", "" ,"", 
	    (!empty($name)?"name='$name'":""). 
	    " type='submit' value='$value'", false);
    }
    
    function form_close() {
	return tag_close("form", false);
    }

    function image($src, $w = "", $h = "", $title = "", $class="", $id = "", $onclick="", $others = "") {
	
	if (!empty($src) && (strpos($src,"/")===false)) { //when we were given a file without a path
	    if (($w==="") && ($h==="")) //only when w and h are not set, but if you use NULL you will avoid the w/h fields
		list($w, $h) = getimagesize($GLOBALS["jffnms_real_path"]."/htdocs/images/".$src);

	    $src = $GLOBALS["jffnms_rel_path"]."/images/".$src;	//add default path
	}
	
	return 
	    tag ("img", $id, $class, 
	        "src='".$src."'".
		" title='".$title."' alt='".$title."'".
		(!empty($w)?" width='".$w."'":"").
		(!empty($h)?" height='".$h."'":"").
		(!empty($onclick)?" OnClick='javascript: ".$onclick."'":"").
		(!empty($others)?" ".$others:"")
		, false);
    }

    function linktext ($text, $url, $target="" ,$class = "", $on_click = "", $id = "", $style = "") {
	return
	    html ("a", $text, $id, $class, 
		(!empty($target)?" target='".$target."'":"").
	        (!empty($url)?" href=\"".htmlspecialchars($url)."\"":"").
		(!empty($on_click)?" onClick=\"".$on_click."\"":"").
		(!empty($style)?" style='".$style."'":"")
	    );
    }

    function radiobutton($name, $selected, $value) {
	return tag ("input", $name, ""," type='radio' name='".$name."' value='".$value."'".
	    (($selected==1)?" checked":""), false);
    }

    function hidden($name,$value) { 
	return tag ("input","","","type='hidden' name='".$name."' value='".$value."'", false);
    }

    function select_custom ($control_name,$options,$mark_values,$onclick="", $size = 1, $echo = false, $class = "", $ondblclick = "") {

	if ($size > 1) {
	    $multi = "multiple size='".$size."'";
	    $control_name.="[]";
	}  

	if (!is_array($mark_values)) $mark_values=explode(",",$mark_values);
    
	$result .= tag ("select", $control_name, $class, "name='".$control_name."'".
	    (($onclick)?" onChange=\"".$onclick."\"":"").
	    (($ondblclick)?" onDblClick=\"".$ondblclick."\"":"").
	    (!empty($multi)?" ".$multi:""));

        foreach ($options as $key=>$value){
	    //debug ($key." - ".in_array($key,$mark_values)." - ".$mark_values[0]." - ".($mark_values[0]==="SELECT_ALL"));
	
	    $encoded_key = ((strpos($key,"=")===false) && (strlen($key) > 3))?urlencode($key):$key;

	    $result .= html("option",$value,"","","value='".$encoded_key."'".
		((in_array($key,$mark_values) or ($mark_values[0]==="SELECT_ALL"))?" selected":"")
		, false, true);
	}

	$result .= tag_close("select");

	if ($echo) 
	    echo $result;
	return $result;
    }

    /* HTML Automatic Indenting Functions */

    function html_indent_none() {
	html_indent_init();
	$GLOBALS["html_indents"][$GLOBALS["html_indent"]]=0;
    }

    function html_indent_more () {
	$GLOBALS["html_indent"]++;
	return html_indent_none();
    }

    function html_indent_less () {
	$GLOBALS["html_indent"]--;
	return html_indent_none();
    }

    function html_indent_init () {
	if (!isset($GLOBALS["html_indent"]) || !isset($GLOBALS["html_indents"])) {
	    $GLOBALS["html_indent"] = 0;
	    $GLOBALS["html_indents"] = array($GLOBALS["html_indent"]=>0);
	}
    }

    function html_indent_already() {
	html_indent_init();
	return $GLOBALS["html_indents"][$GLOBALS["html_indent"]];
    }

    function html_indenter ($verify = 0, $count = 1) {
	if ((html_indent_already()==0) || (!$verify)) {

	    $result = "";
	    for ($i = 0; $i < $GLOBALS["html_indent"]; $i++) $result .= "\t";

	    if ($count) $GLOBALS["html_indents"][$GLOBALS["html_indent"]]=1;

	    return $result;
	} else 
	    echo "!";
    }

?>
