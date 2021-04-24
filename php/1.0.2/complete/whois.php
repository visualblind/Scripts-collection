<?php
require("includes/global.php");

// check for no domain offering
if ($_GET["domain"] == ""){
	Header("Location: index.php");
}

// initialise whois class
include("includes/whois.php");
$whois = new Whois;

// ok, go ahead and draw page
$pagetitle = "Whois - " . $_GET["domain"];
include("includes/page_header.php");

// doing something?
if ($_GET["domain"] <> ""){
	$t->set_var("RESULT", $whois->Lookup($_GET["domain"], 1));
}

// set the pages content
$t->set_file("page_body", "whois.tpl");
$t->parse("page_all", "page_body", true);

// and page footer
include("includes/page_footer.php");
?>