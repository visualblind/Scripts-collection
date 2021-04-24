<?php 
  header("Generator: " . $version["fullname"] . " v" . $version["no"]);
  header("Author: " . $version["author"]);
  header("Date: " . date("r") );
  header("Content-Type: text/html; charset=iso-8859-1");
  
  ob_implicit_flush();

  $ptime = microtime();

  echo "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\">\n";
  echo "<!-- ". $version["fullname"] ." v". $version["no"] ." by " . 
       $version["author"] ." <". $version["email"] ."> -->\n";
  echo "<HTML><HEAD><TITLE>" . $version["fullname"] . " v" . $version["no"] . "</TITLE>\n";
  echo "<link href=\"stylesheet.css\" rel=\"stylesheet\" type=\"text/css\">\n";
  echo "</HEAD><BODY>\n";
  echo "<h1>".$version["fullname"]."</h1>\n<h2>from ";
  if ( ($_SERVER["REMOTE_HOST"] == $_SERVER["REMOTE_ADDR"]) OR 
       !$_SERVER["REMOTE_HOST"] )
    echo $_SERVER["REMOTE_ADDR"];
  else
    echo $_SERVER["REMOTE_HOST"]." <small>[".$_SERVER["REMOTE_ADDR"]."]</small>";
  echo "</h2><hr>\n";

?>

