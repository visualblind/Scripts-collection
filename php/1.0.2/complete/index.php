<?php
require("includes/global.php");

// initialise whois class
include("includes/whois.php");
$whois = new Whois;

// ok, go ahead and draw page
$pagetitle = "Homepage";
include("includes/page_header.php");

// doing something?
if ($_GET["do"] == "runcheck"){
	$t->set_var("RESULT", "<p class=\"sub1\">Results</p>\n" . $whois->RunCheck($_GET["target"], $_GET["ext"]));
}

// set the pages content
$t->set_file("page_body", "homepage.tpl");
$t->parse("page_all", "page_body", true);

// and page footer
include("includes/page_footer.php");
?>