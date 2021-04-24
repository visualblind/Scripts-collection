<?
	/*
		This is to run the analyzer in the background.  To get this running,
		you will need to run this file as a cron job.  Edit your crontab file and
		add the following:
		* * * * * [path/to/php]/php [path/to/fuzzy/root]/cron/analyze.php
	*/
	include_once('/usr/local/apache2/htdocs/jkarma/etc/conf.php');
	$db = new DAB(SQL_HOST,SQL_USER,SQL_PASS,SQL_DB);
	$db->connect();
	while(true)
	{
		sleep(45);
		$temp = new msn($db);
		$temp->run($db);
		$temp = new http($db);
		$temp->run($db);
		$temp = new pop($db);
		$temp->run($db);
	}//end while
	die();
?>