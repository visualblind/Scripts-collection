<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    var_dump($conexion);
    include ("../../conf/config.php");
    var_dump($conexion);
    
    
	while ( 1 ) { //main loop
	    $now = time();
	    
	    $query_hosts="
		SELECT 
		    t1.id as host_id, t2.id as interface_id, 
		    (t2.last_poll_date + it.rrd_structure_step) as next_poll
    		FROM 
		    hosts t1,interfaces t2,interface_types as it 
		WHERE 
		    t2.host = t1.id and t2.type = it.id and t2.id > 1 and t1.poll > 0 and t2.poll > 0 and
                    $now > (t2.last_poll_date + it.rrd_structure_step)
		ORDER BY
		    next_poll asc
	    ";
            
	    if (!$result_hosts = db_query ($query_hosts)) {
	        echo "Query failed - test - ".db_error()."\n";
		break;
	    }
	
	    $num = db_num_rows($result_hosts);
	    echo $num."\n";
	    sleep(1);
	}

?>
