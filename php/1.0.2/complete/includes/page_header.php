<?php
// set up the template
include("template.php");

// create template from class
$t = new Template("skins/" . $_GLOBALS["skin"] . "/");

// set up some variables
$t->set_var("SITE_TITLE", $config["sitename"]);
$t->set_var("PAGE_TITLE", $pagetitle);
$t->set_var("ROOT", $config["rootpath"]);
$t->set_var("SKIN_ROOT", $config["rootpath"] . "skins/" . $_GLOBALS["skin"] . "/");

// try to work out the domain
if ($_GET["domain"] <> ""){
	$dsplit = explode(".", $_GET["domain"]);
	$t->set_var("DEFAULT_SEARCH", $dsplit[0]);
} elseif ($_GET["target"] <> ""){
	$t->set_var("DEFAULT_SEARCH", $_GET["target"]);
}

// compile top page section
if (defined("SIMPLE_PAGE")){
	$t->set_file("page_header", "simple_header.tpl");
} else {
	$t->set_file("page_header", "overall_header.tpl"); }
$t->parse("page_all", "page_header", true);
?>