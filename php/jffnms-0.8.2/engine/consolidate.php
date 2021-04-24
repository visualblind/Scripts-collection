<?
/* Consolidator. This file is part of JFFNMS
 * Copyright (C) <2002> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */

    $jffnms_functions_include="engine";
    include_once("../conf/config.php");
    
    $total_run_time = 60; //60 seconds
    $interval = 15; //15 seconds interval between runs

    if (!isset($times)) $times = $_SERVER["argv"][1];
    if (empty($times)) $times = 3;

    $i = 0;
    $date_start = time();

    if (is_process_running(NULL,2) === false) {	//check if a process named as myself is already running (one instance is me)

	detach();
	
	include_once("consolidate/traps.php");

	logger ("Consolidator Starting...\n");
	do {
	    $aux_start = time();
	    $i++;    

	    //FIXME replace this calls with functions
	    include("consolidate/syslog.php"); flush();
	    include("consolidate/tacacs.php"); flush();	
	    
	    consolidate_traps();
	    flush();
	    
	    include("consolidate/events.php"); flush();
	    include("consolidate/events_latest.php"); flush();
	    include("consolidate/alarms.php"); flush();
    
	    $run_time = time() - $aux_start;

	    logger ("Partial time: $run_time sec.\n");

	    if ($i < $times) sleep($interval);
	    $time_elapsed = time() - $date_start;
	    logger ("Elapsed time $time_elapsed sec.\n");
	} while (($i < $times) && ($time_elapsed < $total_run_time)); 

	$time_total = time() - $date_start;
        logger("Total time: $time_total sec.\n");

    } else
	logger ("Another instance of Consolidator is running, aborting...\n");

    db_close();
?>
