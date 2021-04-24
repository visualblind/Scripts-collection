<?
$dbhost = "localhost";
$dbuser  = "root";
$dbpass   = "";
$db    = "traceroute";

    mysql_connect($dbhost,$dbuser,$dbpass) or die("could not connect");
    mysql_select_db("$db") or die("could not open database");

# let the traceroutes begin at top or bottom 
$valign='top';  # value is either top or bottom

?>
