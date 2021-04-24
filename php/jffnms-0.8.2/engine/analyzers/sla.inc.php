<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    function replace_vars ($text, $values = NULL) {
	
	if (is_array($values)) {
	
	    if (isset($values["input"])) {
		//addtions and aliases
	        $values["in"]=$values["input"]*8;
		$values["out"]=$values["output"]*8;
	        $values["inerrors"]=$values["inputerrors"];
	        $values["outerrors"]=$values["outputerrors"];
	    }
	    //print_r($values);
	    
	    foreach ($values as $key=>$value)
		if (!is_array($value))
    		    $text = str_replace("<$key>",$value,$text);
	}
	
	return $text;
    }


    function analyzer_sla ($interface, $values) {
	
	$sla_cond_active = array();
	$output = array();
	$cond_num = -1;

	$interface_data = interface_values($interface["id"],array("exclude_types"=>20));
	$values = array_merge($values,$interface_data["values"][$interface["id"]]);

	unset ($interface_data);

	$query_sla="
	    SELECT 
		slas_cond.condition, slas_cond.description, slas_cond.event,
		slas_sla_cond.show_in_result, slas_cond.variable_show, slas_cond.variable_show_info
	    FROM 
		slas_cond, slas_sla_cond
	    WHERE
		slas_sla_cond.sla = ".$interface["sla"]." and slas_sla_cond.cond = slas_cond.id order by slas_sla_cond.pos";
		
	$result_sla = db_query ($query_sla) or die ("Query failed - analyzer_sla() - ".db_error());
	//logger("$query_sla\n");
	
	while ($sla = db_fetch_array($result_sla)) {

	    $sla_cond 			= replace_vars(trim($sla["condition"]),$values);
	    $sla_variable_show 		= replace_vars(trim($sla["variable_show"]),$values);
	    $sla_variable_show_info 	= replace_vars(trim($sla["variable_show_info"]),$values);
	    $sla["event"]		= replace_vars(trim($sla["event"]),$values);

	    //Execute the Variable show expression, and round it
	    if ($sla_variable_show) {
		$eval_express = "\$sla_variable_show = round(($sla_variable_show),2);";
	    	eval($eval_express);
	    }

	    if (($sla_cond!="AND") and ($sla_cond!="OR")) { //If its not AND or OR
		
		//Execute the SLA condition 
		$cond_num++;
		
		$sla_cond_activate = 0;
		$test_cond = "if ($sla_cond) \$sla_cond_activate = 1;";
		eval($test_cond);
		
		$show_info[$cond_num] = $sla["event"].": $sla_variable_show $sla_variable_show_info";

		$output[] = str_pad("Cond$cond_num: $sla_cond",45)." = $sla_cond_activate ".(($sla_cond_activate==1)?" -TRUE- ":" -FALSE- ").$show_info[$cond_num];

		if (($sla_cond_activate==0) or  //if the test condition was TRUE
		    ($sla["show_in_result"]==0)) //and the condition state that it was to show
			unset ($show_info[$cond_num]);

		$sla_cond_active[$cond_num] = $sla_cond_activate;

	    } else { //if it was OR or AND
		
		$cond_num--;
	
		$output[] = str_pad("Cond".($cond_num)."= Eval ".($cond_num+1)." vs ".($cond_num).": ".
		    $sla_cond_active[$cond_num+1]." $sla_cond ".$sla_cond_active[$cond_num]."",45);
	
		if (
		    (($sla_cond=="AND") and (($sla_cond_active[$cond_num+1]) && ($sla_cond_active[$cond_num]))) or
		    (($sla_cond=="OR")  and (($sla_cond_active[$cond_num+1]) || ($sla_cond_active[$cond_num])))) { //Eval was true

		    unset($sla_cond_active[$cond_num+1]);
	
		    $sla_cond_active[$cond_num]=1;
	
		} else { //Eval was False
		    unset($sla_cond_active[$cond_num+1]);
		    
		    //delete both conditions information
		    unset($show_info[$cond_num+1]);
		    unset($show_info[$cond_num]);
		    
		    $sla_cond_active[$cond_num]=0;
		}
		$output[count($output)-1] .= " = ".$sla_cond_active[$cond_num];
	    }
	} //while conditions

	if (count($sla_cond_active)==1) {  // if there is only one result left

	    if ($sla_cond_active[0]==1) { //if all conditions are true(1)
	
		$show_info = $interface["info"]." ".join(", ",$show_info);

		insert_event(date("Y-m-d H:i:s",time()),$interface["event_type"],$interface["host"],$interface["interface"],
		    $interface["state"],"rrd_analizer_sla",$show_info,$interface["sla"]);

		$output[] = "Final Eval: True. INFO: $show_info";

	    } else
		$output[] = "Final Eval: False.";
	
	} else
	    if (count($sla_cond_active) > 1)
		$output[] = "STACK UNDERFLOW, REVIEW THE SLA ".$interface["sla"]." !!, stack elements: ".(count($sla_cond_active));
	    else 
		$output[] = "STACK OVERFLOW,  REVIEW THE SLA ".$interface["sla"]." !!, stack elements: ".(count($sla_cond_active));

	return $output;
    }
?>
