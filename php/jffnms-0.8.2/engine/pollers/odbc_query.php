<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    function poller_odbc_query ($options) {

	$connection = odbc_connect ($options["dsn"], $options["username"], $options["password"]);

	if (is_resource($connection)) {
	    
	    $result = odbc_exec ($connection, $options["query"]);
	    
	    if (is_resource($result)) {	    
	
		$num_rows = odbc_num_rows($result);
		
		if (($num_rows == 1) or ($num_rows == -1)) {
		    
		    if (odbc_fetch_row($result,1))
			$num_rows = odbc_result($result,1); //Current Value (if it was a Count(*) Query)
		    else
			return -3;
		}
		
		if ($options["absolute"]==1)
		    return "|".$num_rows; //Return the number of rows
		else
		    return $num_rows."|"; //Return the number of rows
	
	    } else
		return -2; // Query Failed.
	} else
	    return -1; // Connection Failed.
    }

?>
