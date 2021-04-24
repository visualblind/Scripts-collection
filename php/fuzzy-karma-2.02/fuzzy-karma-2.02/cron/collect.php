<?
	/*
		This is to run the collector in the background.  To get this running,
		you will need to run this file as a cron job.  Edit your crontab file and
		add the following:
		* * * * * [path/to/php]/php [path/to/fuzzy/root]/cron/collect.php
	*/
	include_once("collector.php");
	while(true)
	{
		$temp = new collector();
		sleep(5);
	}//end while
	die();
?>