<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    function calculate_percentile ($percentile, $values) {
    
	unset ($values["information"]);
    
	$dss = array_keys($values);
	$ids = array_keys($values[current($dss)]);
    
	foreach ($ids as $id) {
	    $aux = array();
	    foreach ($dss as $ds)
		$aux[$ds]=$values[$ds][$id];
		
	    $new_values[$id]=max($aux);
	    
	    //debug ($id.": ".join(", ",$aux). " = ".$new_values[$id]);
	}

	$cant = count($new_values);
	$cant_skip = round(((100-$percentile)*$cant-1)/100)+1; //get the N% of the total values
	
	$data_points = array($values, $new_values, $cant_skip);

	rsort($new_values); //sort the list from max->min
	$result = $new_values[$cant_skip]; //get the following value

	//debug ("cant: $cant, skip: $cant_skip, result: ".($result*8).", avg: ".round((array_sum($new_values)/$cant)*8));

	return array($result, $data_points);
    }
?>
