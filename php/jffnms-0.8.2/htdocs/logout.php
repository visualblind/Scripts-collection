<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
 @include_once ("../conf/config.php"); 
 @include_once ("../../conf/config.php"); 
?>
<HTML>
<HEAD><TITLE>JFFNMS</TITLE></HEAD>
<BODY>
<H1>You must enter a valid Username and Password to access this system.</H1>
<a href="<? echo "$jffnms_rel_path/index.php?$QUERY_STRING" ?>"> Login </a>
</BODY>
</HTML>
