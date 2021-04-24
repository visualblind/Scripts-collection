<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    if ($active_only==1) $text = "<H3> No Alarmed ".ucfirst($source)." Found </H3>";
    else  $text = "<H3> No ".ucfirst($source)." Found </H3>";
    echo "<div class='mapbox'><center>$text</center></div>";
?>
