<?php
function ptime( $p ) {
  list ($s_usec, $s_sec) = explode(" ", $p);
  list ($e_usec, $e_sec) = explode(" ", microtime());
  return $e_sec + $e_usec - $s_sec - $s_usec;
}
 
  echo "<hr>\n";
  echo "<table border=\"0\" width=\"100%\">\n<tr>" . 
       "<td align=left><a href=\"" . $version["homepage"] . "\">" . 
       $version["fullname"] . "</a> v" . $version["no"] . "<br>\n" .
       "</td>\n";
  echo "<td align=right>Processed: " . date("r") . "<br>\n" .
       "Processing time: ";
  printf("%2.4f", ptime($ptime));
  echo " sec</td></tr>\n" .
       "</table>\n<hr>\n".
       "<table border=\"0\" width=\"100%\">".
       "<tr valign=\"middle\">".
       "<td valign=\"middle\" align=\"center\">".
       "<a href=\"http://www.kpnadsl.nl\">".
       "<img alt=\"KPNaDSL\" border=\"0\" src=\"kpn_cb_colour.gif\"></a></td>".
       "<td align=\"center\"><a href=\"http://www.planet.nl/adsl/\">".
       "<img  alt=\"Planet internet\" border=\"0\" src=\"planet_logo.gif\">".
       "</a></td></tr></table>".
//       "</td></tr></table>".
       "</BODY>\n</HTML>\n";
?>

