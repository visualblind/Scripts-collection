<?php
// set the variables for page header
$t->set_var("MAIN_SITE", $config["mainsite"]);
$t->set_var("MAIN_URL", $config["mainurl"]);
$t->set_var("VERSION", $config["version"]);
$t->set_var("CURRENT_TIME", date($config["dateformat"]));

// parser footer template
if (defined("SIMPLE_PAGE")){
	$t->set_file("page_footer", "simple_footer.tpl");
} else {
	$t->set_file("page_footer", "overall_footer.tpl"); }
$t->parse("page_all", "page_footer", true);

// output entire page
$t->p("page_all");
?>