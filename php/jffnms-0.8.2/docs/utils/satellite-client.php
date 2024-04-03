<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    /*
	    How to use this file
	    --------------------
    
	This example shows how to interact with JFFNMS via the Satellites RPC system.
	You will have access to all the JFFNMS API, including graph functions.

	To enable the satellite server in your JFFNMS:
    
    	    - go to the /admin/setup.php and clean the Satellite URI field, and click in Save 
    		to make it autodiscover it.
    
    	    - paste the contents of the Field into the $jffnms_sat_uri field of the jffnms_call in this file,
    		followed by ?capabilties=S to force PHP serialize usage.
    
    	    - go to the Administration->Host & Interfaces->Satellites
		
		- Edit the Satellite 1 (Local) and save it (with no changes), this will make JFFNMS autodiscover
		    the Local Satellte URI (the same as the field in setup.php)
		    
		- Add a new Satellite and put the IP address or DNS name of the computer that will be accessing,
		    if its different than the same server, select the 'Client' Satellite Type. 


	Please read this file, is only an example, to see all the functions and parameters you will have to read the lib/api.* files.
	
    */

    function jffnms_call ($object, $method, $params = array()) {
        $jffnms_sat_uri = "http://nms.yourserver.com/jffnms/admin/satellite.php?capabilities=S";

        $call_url = $jffnms_sat_uri . "&class=$object&method=$method&params=".urlencode(serialize($params))."&sat_id=1";

        //var_dump($call_url);
        $result_raw = file ($call_url);
        //var_dump($result_raw);

        if (is_array($result_raw))
            $result = unserialize(current($result_raw));

        return $result;
    }

    $hosts = jffnms_call ("hosts","get_all");
    //var_dump($hosts);

    $interfaces = jffnms_call ("interfaces","get_all",array(NULL,array("client"=>10)));
    //var_dump($interfaces);

    foreach ($interfaces as $int) {
        //$id, $graph_function, $sizex, $sizey, $title, $graph_time_start, $graph_time_stop, $aux = ""
        list ($ok, $data) = jffnms_call ("interfaces","graph",array($int["id"],"traffic",500,200,"Graph ".$int["description"],-60*60*12,-60*5));

        if ($ok==true) {
            $data = base64_decode($data);

            $file = "graph-".$int["id"].".png";

            $fp = fopen ($file,"w+");
            fwrite($fp,$data);
            fclose($fp);
        }
    }

?>
