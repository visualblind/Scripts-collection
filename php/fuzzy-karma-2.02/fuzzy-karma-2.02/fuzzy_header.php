<?php
/* This is the header file */
include_once("etc/conf.php");
class fuzzy_header
{
    function fuzzy_header()
    {
            $this->run();
    } // end constructor
    
    function run() 
    {
        echo '
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
	<link type="text/css" rel="stylesheet" href="'.BASE_URL.'fuzzy.css">
	<title>'.TITLE.'</title>
	<script language="javascript">
		<!--
		-->
	</script>
</head>
<body topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0" marginheight="0" marginwidth="0">
';
    return true;
    } //end run

} // end class
?>

