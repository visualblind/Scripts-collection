<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

function oid_cmp($a, $b) {
   if ($a == $b) return 0;
    
    $a1 = explode (".",$a);
    $b1 = explode (".",$b);

    if (count($a1) < count($b1)) return -1;
    if (count($a1) > count($b1)) return 1;
    
    for ($i = 0; $i < count($a1); $i++) {
	if ($a1[$i] < $b1[$i]) return -1;
	if ($a1[$i] > $b1[$i]) return 1;
    }    
}
		

function truncate_counter (&$value) {
    $max 	= pow(2,31);
    $max_pass 	= ($value/$max);
    $max_less	= ($max * floor($max_pass));

    if ($max_pass >= 1) $value = floor($value - $max_less);
}

function create_rama ($oid,$k,$data,$deep,&$tree) {
    if (!is_numeric(current(array_keys($data)))) $data = array_values ($data);

    while (list ($k1,$item) = each ($data)) {
	if (is_array($item)) create_rama ("$oid.$k",$k1,$item,++$deep,$tree);
	else 
	    if ($deep==0)
		$tree["$oid.$k.$k1"]=$item;
	    else 
		$tree["$oid.$k1.$k"]=$item;
    }
}

function create_tree ($oid,$data,&$tree) {
    $start = time();
    
    $data = array_values($data);

    foreach ($data as $k=>$v) {
	if (is_array($v)) 
	    create_rama ($oid,$k,$v,0,$tree);
	else 
	    $tree["$oid.$k"]=$v;
    }

    uksort($tree,"oid_cmp");
    reset ($tree);
    
    return time()-$start;
}

function secho ($oid,$var = NULL) {

    $out .= "$oid\n";

    if (!is_null($var)){ 

	$out .= ((is_numeric($var))?"integer":"string")."\n";
        $out .= $var."\n";
    }
    
    return $out;
}

function walk_tree ($start, &$tree) {
    $show_next = 0;

    reset ($tree);
    while (list ($k,$v) = each ($tree)) {

	if (($show_next == 1) || ((strpos($k, $start)===0) && ($k!==$start)))
	    return secho ($k,$v);
	
	if ($k===$start) 
	    $show_next = 1;
    }
    
    return "NONE\n";
}

    
    list ($myself, $tree_to_use, $base, $tree_refresh)  = $_SERVER["argv"];

    if (!is_numeric($tree_refresh)) 
	$tree_refresh = (1*60);

    include ($tree_to_use.".inc.php");

    $in = fopen("php://stdin","r");
    $step = 0;
    
    while ($line = fgets($in)) {

	$line = trim($line); 
	
	if ($tree_time+$tree_refresh < time()) {
	    $tree = array();
	    $creation_time = create_tree ($base,call_user_func("tree_".$tree_to_use),$tree);
	    $tree_time = time();
	}
	
	switch ($line) {
	
	    case "DEBUG":
		print_r($tree);
		echo "Tree creation time: $creation_time, Created ".(time()-$tree_time)." seconds ago.\n";
	    break;
	    
	    case "PING":
		$result = "PONG\n";
		$step = 0;
	    break;

	    default:
		
		switch ($step) {		
		    case 0: $oper = $line; $step = 1; break;
		    case 1: $oid  = $line; $step = 2; break;
		}

		if ($step==2) {
		    $step = 0;
		
		    switch ($oper) {
			case "getnext": 
	    		    $result = walk_tree ($oid, $tree); 
			    break;

			case "get": 
		    	    if (isset($tree[$oid])) 
			    $result = secho ($oid,$tree[$oid]); 
			break;
		    }
		    
		    if (!isset($result)) $result = "NONE\n";
		}
	} 
	
	if (isset($result)) {
	    echo $result;
	    unset ($result);
	}
    }

?>
