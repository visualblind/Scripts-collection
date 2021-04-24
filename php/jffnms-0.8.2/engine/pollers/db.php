<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
function poller_db ($options) {
	list ($field,$option) = explode (",",$options["poller_parameters"]);
	
	$value = $options[$field];

	if ($option=="to_bytes") $value = $value / 8;
	return $value;
}
?>
