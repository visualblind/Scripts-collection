<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    //This poller just takes a parameter and returns it to the backend
    //Currently used to send the Last Poll Date to the db backend
    
    function poller_internal ($options) {

	return $options["poller_parameter"];
    }
?>
