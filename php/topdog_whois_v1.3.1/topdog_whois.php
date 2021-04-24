<?php
/*
*
	AUTHOR
	NAMES				: ANDREW COLIN KISSA
	EMAIL				: andrew@topdog-software.com
	WEB					: http://www.topdog-software.com


	LICENCE
	THIS CODE HAS NO WARRANTY AND IS DISTRIBUTED UNDER THE GNU LICENCE I CANNOT BE
	HELD LIABLE FOR ANY LOSSES THAT YOU MAY INCUR BY EITHER DIRECTLY OR OTHERWISE
	BY USING THIS SCRIPT.

	INSTALLATION
	SEE THE INSTALLATION.TXT FILE
	
	VERSION 3.1.1 2004-03-10
	Added some TLD's and made changes to renamed whois servers


	VERSION 3.1 2003-12-28
	Implemented better error handing messages to be printed right into the template
	Implemented support to the server less .co.za domain using both socket and curl
	based functions to query the co.za domain zone
	Rewrite in the core to use a multi dimensional array for the server definitions
	thanks to [  ] for pointing this out this eliminates the variable definitions
	for all tlds and also the if block that supported the old decision structure
	Implemented support for checking of all the supported domains at a go although
	it slows performance a bit
	

	VERSION 3  2003- 05 -20
	THIS UPGRADED TO SUPPORT GLOBALS OF SERVERS
	BETTER DISPLAY IN THE TEMPLATE
	UPDATES TO .ORG DOMAIN WHOIS NOW TRANSFERED TO whois.publicinterestregistry.net
	THANKS TO CHRIS graphic@ev1.net FOR POINTING OUT THE CHANGE TO ME SHOULD YOU FIND
	A PARTICULAR WHOIS SERVER NOT WORKING PLEASE POST THAT ON THE FORUM FOR ME TO
	MAKE GLOBAL CHANGES FOR THE BENEFIT OF EVERY ONE --

	VERSION 2
	THIS IS THE TOTALLY REWRITTEN VERSION WHICH HAS BEEN UPGRADED TO INCLUDE
	1.SUPPORT FOR THE NEW REFERAL WHOIS SYSTEM.
	2.ACCESS CONTROL TO AVOID BANDWIDTH THEFT
	3.CHECKS FOR EXISTENCE OF TEMPLATE
	4.RETURN OF FULL WHOIS DETAILS
	5.REMOVAL OF ALL INTERPRETATIONS OF MATT'S WHOIS
	6.RENAMED TO TOPDOG DOMAIN CHECK AND WHOIS SCRIPT FROM UGANDA DOMAIN CHECK AND WHOIS
	THIS TO REFLECT OVERWHELMING INTREST FROM USERS OF INTERNATIONAL TLD's

	WEBSITE ADDRESS
	VISIT US @ WWW.TOPDOG-SOFTWARE.COM FOR MORE FREE SCRIPTS AND CUSTOM CODING IN PHP,ASP
	AND PERL WHILE THERE VISIT OUR FORUM AND TELL US OF HOW WE CAN MAKE THIS SCRIPT
	BETTER OR GIVE IDEAS OF NEW SCRIPTS YOU WOULD LIKE TO SEE ON OUR SITE (feedback)

	SUPPORT
	SHOULD YOU REQUIRE SUPPORT FOR THIS SCRIPT PLEASE TRY CHECKING OR POSTING YOUR
	QUERIES ON THE OUR SUPPORT FORUM @ www.topdog-software.com/forum/ BEFORE EMAILING
	ME BECAUSE I RECEIVE MANY EMAILS FROM DIFFERENT USERS ASKING SIMILAR QUESTIONS
	SO IF YOU POST IT ON THE BOARD AND I ANSWER IT OTHER USERS CAN USE THAT TO SOLVE
	THEIR QUERIES IN THE FUTURE. By the way if you don't know anything about scripts
	don't dispair we can setup custom scripts for you at a minimal fee.

	Do not change the server definitions unless you know what you are doing should you
	require to implement new extentions then check with iana to find out the registrar
	of the extention you want then find out the address of their whois server and the
	string it returns if a record is not found. You can the create a new entry under the
	server definitions to reflect this. 
*
*/

/******	THIS SECTION SHOULD BE CUSTOMISED BY YOU TO REFLECT YOUR SITE		***********/
$template = "temp.html";           //this is the page where the results will be displayed
                                    //this page must contain this "<!--DOMAIN RESULTS-->"
                                    //where ever you want the results to be displayed

$registerlink = "signup.php";       //this is the page a user is taken to if they want to
                                    //register the domain name from you or your affiliate
                                    //it should be a script preferably because this script
                                    //will pass it the $domain variable using the get method
                                    //for example signup.php?domain=topdog-software.com
                                    
$restrict = 0;                      //set to 0 if you don't want to restrict access
                                    //set to 1 if you want to restrict access remember to
                                    //change $REFERERS below to reflect your site.

$REFERERS = array('topdog-software.com', 'www.topdog-software.com');
                                    //These are the domains allowed to access the script
                                    //if you decide to restrict access
error_reporting(0);
/************************	END CUSTOMISATIONS	************************************/

/************************	SERVER DEFINITIONS	************************************/
$serverdefs= array(
						"com" => array("whois.crsnic.net","No match for"),
						"net" => array("whois.crsnic.net","No match for"),				
						"org" => array(" whois.pir.org","NOT FOUND"),					
						"biz" => array("whois.biz","Not found"),					
						"info" => array("whois.afilias.net","NOT FOUND"),					
						"co.uk" => array("whois.nic.uk","No match"),					
						"co.ug" => array("wawa.eahd.or.ug","No entries found"),	
						"or.ug" => array("wawa.eahd.or.ug","No entries found"),
						"ac.ug" => array("wawa.eahd.or.ug","No entries found"),
						"ne.ug" => array("wawa.eahd.or.ug","No entries found"),
						"sc.ug" => array("wawa.eahd.or.ug","No entries found"),
						"nl" 	=> array("whois.domain-registry.nl","not a registered domain"),
						"ro" => array("whois.rotld.ro","No entries found for the selected"),
						"com.au" => array("whois.ausregistry.net.au","No data Found"),
						"ca" => array("whois.cira.ca", "AVAIL"),
						"org.uk" => array("whois.nic.uk","No match"),
						"name" => array("whois.nic.name","No match"),
						"us" => array("whois.nic.us","Not Found"),
						"ws" => array("whois.website.ws","No Match"),
						"be" => array("whois.ripe.net","No entries"),
						"com.cn" => array("whois.cnnic.cn","no matching record"),
						"net.cn" => array("whois.cnnic.cn","no matching record"),
						"org.cn" => array("whois.cnnic.cn","no matching record"),
						"no" => array("whois.norid.no","no matches"),
						"se" => array("whois.nic-se.se","No data found"),
						"nu" => array("whois.nic.nu","NO MATCH for"),
						"com.tw" => array("whois.twnic.net","No such Domain Name"),
						"net.tw" => array("whois.twnic.net","No such Domain Name"),
						"org.tw" => array("whois.twnic.net","No such Domain Name"),
						"cc" => array("whois.nic.cc","No match"),
						"nl" => array("whois.domain-registry.nl","is free"),
						"pl" => array("whois.dns.pl","No information about"),
						"pt" => array("whois.ripe.net","No entries found")


					);
/*********************** 	END SERVER DEFINITIONS	*********************************/


if ($_SERVER['REQUEST_METHOD'] == 'GET'){
    $domain = $_GET['domain'];
    $ext = $_GET['ext'];
    $option = $_GET['option'];
}else{
    $domain = $_POST['domain'];
    $ext = $_POST['ext'];
    $option = $_POST['option'];
}

if($restrict ==1){
    check_referer();
}
/************* 	Perform checks domain x-ters			*************************************/
namecheck($domain);

/*************		Check domain zone					************************************/
	if ($serverdefs[$ext]){
	    $server = $serverdefs[$ext][0];
	    $nomatch = $serverdefs[$ext][1];
	    if($option=="check")
	    {
	        $layout = check_domain($domain,$ext);
	        print_results($layout);
	    }
	    if($option=="whois")
	    {
	        whois($domain,$ext);
	    }
    }
    elseif($ext == "co.za"){
    	if($option == "check"){
    	   if(function_exists(curl_init)){
					$layout = cozacurlcheck($domain);
			}else{
					$layout = cozacheck($domain);
			}
			print_results($layout);
		}elseif($option=="whois"){
			if(function_exists(curl_init)){
				cozacurlwhois($domain);
			}else{
				cozawhois($domain);
			}
		}
    }
    elseif($ext == "all"){
	    $layout = "<tr>\n<td>\n<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>\n";
	    foreach($serverdefs as $ext => $servers)
	    {
		    $server = $servers[0];
		    $nomatch = $servers[1];
		    $available = check_domain($domain, $ext);
		    if ($available == 0)
		    {
			    $layout .= sprintf("<tr>\n<td>\n%s.%s</td>\n<td>\n<font color=\"green\">\n<b>Available!</b>\n</font>\n</td>\n", $domain, $ext);
			    $layout .= sprintf("<td>\n<a href=\"%s?domain=%s.%s\">register now</a>\n</td>\n</tr>\n", $registerlink, $domain, $ext);
			}
			elseif ($available == 2)
		    {
			    $layout .= sprintf("<tr>\n<td>\n%s.%s</td>\n<td>\n<font color=\"grey\">\nUnknown</font>\n</td>\n", $domain, $ext);
			    $layout .= "<td>\nCould not contact server</td>\n</tr>\n";
			}
			else
			{
				$layout .= sprintf("\n<tr>\n<td>\n%s.%s</td>\n<td>\n<font color=\"red\">Taken\n</font>\n</td>\n", $domain, $ext);
			   $layout .= sprintf("<td>\n<a href=\"%s?domain=%s&ext=%s&option=whois\">check whois</a></td>\n</tr>\n", $PHP_SELF, $domain, $ext);
		   }
	    }
	    $layout .= "</table>\n</td>\n</tr>\n";
	    $ext = " all supported domains";
	    print_results($layout);
	}

/**	<------------------------------------functions--------------------------------> **/
function check_domain($domain,$ext)
{
    global $nomatch,$server;
    $output="";
    if(($sc = fsockopen($server,43))==false){return 2;}
    fputs($sc,"$domain.$ext\n");
    while(!feof($sc)){$output.=fgets($sc,128);}
    fclose($sc);
    //compare what has been returned by the server
    if (eregi($nomatch,$output)){
		return 0;
    }else{
        return 1;
    }
}

/*********		Function to return whois results		***********************************/
function whois($domain,$ext)
{   global $template,$server;
    if(($sc = fsockopen($server,43))==false){
        if(($sc = fsockopen($server,43))==false){
            //echo"There is a temporary service disruption Please again try later";
            $layout =2;
            print_results($layout);
            exit;
        }
    }
    if($ext=="com"||$ext=="net"){
        //
        fputs($sc, "$domain.$ext\n");
        while(!feof($sc)){
            $temp = fgets($sc,128);
            if(ereg("Whois Server:", $temp)) {
                $server = str_replace("Whois Server: ", "", $temp);
                $server = trim($server);
            }
        }
        fclose($sc);
        if(($sc = fsockopen($server,43))==false){
            //echo"There is a temporary service disruption Please try later";
            $layout =2;
            print_results($layout);
            exit;
        }
    }

    $output="";
    fputs($sc,"$domain.$ext\n");
    while(!feof($sc)){$output.=fgets($sc,128);}
    fclose($sc);
    //print
	print_whois($output);
    

}
/*******		function to check referer	************************************************/
function check_referer () {
	global $REFERERS, $HTTP_REFERER;
	if ($HTTP_REFERER != "")
		while (list($val, $ref) = each($REFERERS))
		if (preg_match("/^http:\/\/$ref/", $HTTP_REFERER))
		return;
		$layout = "<tr>\n<td>\n<font color=\"red\">\nAccess denied to: $HTTP_REFERER</font>\n<br>\nPlease dont link to this script <a href=\"http://www.topdog-software.com/scripts.php\">download</a> a copy
        and set it up on your site.<br>\n This is due to bandwidth usage ... leeching and Data mining</td>\n</tr>\n";
      print_results($layout);
      exit;
}
/*******		Function to print the results into your template	************************/
function print_results($layout)
{
    global $template,$registerlink,$domain,$ext,$server;
    if(!is_file($template)){
        print"The template file into which to print the results either does not exist or is
        not writeable<br>
        please correct this if you are the webmaster of this site<br>
        The script can not continue exiting......";
        exit;
    }
    $template = file ($template);
    $numtlines = count ($template);	//Number of lines in the template
    $line = 0;
    while (! stristr ($template[$line], "<!--DOMAIN RESULTS-->") && $line < $numtlines) {
	echo $template[$line];
	$line++;
    }
    if($layout=="0"){
        $line++;
			print   "\n<!-----------------\n";
			print	"\tPOWERED BY\n\n";
			print	"\tTOPDOG WHOIS & DOMAIN CHECK SCRIPT\n";
			print   "\t&copy; KISSA ANDREW COLIN\n";
			print	"\tkissandrew@yahoo.com\n";
			print	"\twww.topdog-software.com\n";
			print	"\n------------------->\n";
        	print   "<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>";
        	print   "<tr><td><b>Domain query Results for \"$domain.$ext\"</b></td></tr>";
        	print   "<tr><td><hr></td></tr>";
        	print   "<tr><td>The domain is available <a href=\"$registerlink?domain=$domain.$ext\">register</a> it now</td></tr>";
        	print   "</table>";
    }
    elseif($layout=="1"){
        $line++;
			print   "\n<!-----------------\n";
			print	"\tPOWERED BY\n\n";
			print	"\tTOPDOG WHOIS & DOMAIN CHECK SCRIPT\n";
			print   "\t&copy; KISSA ANDREW COLIN\n";
			print	"\tkissandrew@yahoo.com\n";
			print	"\twww.topdog-software.com\n";
			print	"\n------------------->\n";
        	print   "<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>\n";
        	print 	"<tr>\n<td>\n<b>\nDomain query Results for \"$domain.$ext\"</b>\n<br>\n</td>\n</tr>\n";
        	print   "<tr>\n<td>\n<hr>\n</td>\n</tr>\n";
        	print   "<tr>\n<td>\n<b>\nThe domain is already taken <a href=\"$PHP_SELF?domain=$domain&ext=$ext&option=whois\">Check</a> the whois information<br></td></tr>";
        	print   "<tr>\n<td>\nCheck another domain name <a href=\"javascript:history.back()\">here</a></td></tr>";
        	print   "</table>\n";
    }
     elseif($layout=="2"){
        $line++;
        print   "\n<!-----------------\n";
		  print	"\tPOWERED BY\n\n";
		  print	"\tTOPDOG WHOIS & DOMAIN CHECK SCRIPT\n";
		  print   "\t&copy; KISSA ANDREW COLIN\n";
		  print	"\tkissandrew@yahoo.com\n";
		  print	"\twww.topdog-software.com\n";
		  print	"\n------------------->\n";
        print   "<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>\n";
        print 	"<tr>\n<td>\n<b>\nDomain query Results for \"$domain.$ext\"</b>\n<br>\n</td>\n</tr>\n";
        print   "<tr>\n<td>\n<hr>\n</td>\n</tr>\n";
        print   "<tr>\n<td>\n<b>Could not contact the whois server $server</b>\n<br>\n</td>\n</tr>\n";
        print   "<tr>\n<td>\nCheck another domain name <a href=\"javascript:history.back()\">here</a>\n</td>\n</tr>\n";
        print   "</table>\n";
    }
    else{
    	  $line++;
        print   "<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>\n";
        print 	"<tr>\n<td>\n<b>Domain query Results for \"$domain.$ext\"</b>\n<br>\n</td>\n</tr>\n";
        print   "<tr>\n<td>\n<hr>\n</td>\n</tr>\n";
        print 	$layout;
        print   "<tr>\n<td>\nCheck another domain name <a href=\"javascript:history.back()\">here</a>\n</td>\n</tr>\n";
        print   "</table>\n";
    }
    print "<br>\n<br>\n";
    print "<center>\n<font class=font1csm>\nsearch powered by <a href=\"http://www.topdog-software.com/scripts.php\">topdog whois scripts</a>\n</font>\n</center>\n";
    while ($line < $numtlines) {
	 echo $template[$line];
	 $line++;
   }
}

/*******		Function to print whois results	*****************************************/
function print_whois($output){
	global $template,$domain,$ext;
	if(!is_file($template)){
        print"The template file into which to print the results either does not exist
        or is not writable<br>
        please correct this if you are the webmaster of this site<br>
        The script can not continue exiting......";
        exit;
    }
    $template = file ($template);
    $numtlines = count ($template);
    $line = 0;
    while (! stristr ($template[$line], "<!--DOMAIN RESULTS-->") && $line < $numtlines) {
	echo $template[$line];
	$line++;
    }
    $line++;
	 print   "\n<!-----------------\n";
	 print	"\tPOWERED BY\n\n";
	 print	"\tTOPDOG WHOIS & DOMAIN CHECK SCRIPT\n";
	 print   "\t&copy; KISSA ANDREW COLIN\n";
	 print	"\tkissandrew@yahoo.com\n";
	 print	"\twww.topdog-software.com\n";
	 print	"\n------------------->\n";
    print   "<table width=\"100%\" border=\"0\" cellPadding=2 class=font1l>\n";
    print   "<tr>\n<td>\n<b>\nDomain whois query information for \"$domain.$ext\"</b>\n</td>\n</tr>\n";
    print   "<tr>\n<td>\n<hr>\n</td>\n</tr>\n";
    print   "<tr>\n<td>\n";
    $output= explode("\n",$output);
    foreach ($output as $value){
            print "$value<br>\n";
    }
    print "</td>\n</tr>\n</table>\n";
    print "<br>";
    print "<center>\n<font class=font1csm>\nsearch powered by <a href=\"http://www.topdog-software.com/scripts.php\">topdog whois scripts</a>\n</font>\n</center>\n";
    while ($line < $numtlines) {
	echo $template[$line];
	$line++;
   }

}
/******	This checks the name for invaild characters	*******************************/
function namecheck($domain)
{
    if($domain==""){$layout = "<tr>\n<td>\n<font color=\"red\">\nYou must enter a domain to be checked</font>\n<br>\n";
 	 print_results($layout);exit;}
    if(strlen($domain)< 3){$layout = "<tr>\n<td>\n<font color=\"red\">\nThe domain name $domain is too short</font>\n</td>\n</tr>\n"; print_results($layout);exit;}
    if(strlen($domain)>57){$layout = "<tr>\n<td>\n<font color=\"red\">\nThe domain name $domain is too long</font>\n</td>\n</tr>\n"; print_results($layout);exit;}
    if(@ereg("^-|-$",$domain)){$layout = "<tr>\n<td>\n<font color=\"red\">\nDomains cannot begin or end with a hyphen</font>\n</td>\n</tr>\n"; print_results($layout);exit;}
    if(!ereg("([a-z]|[A-Z]|[0-9]|-){".strlen($domain)."}",$domain))
    {$layout = "<tr>\n<td>\n<font color=\"red\">\nDomain names cannot contain special characters</font>\n</td>\n</tr>\n"; print_results($layout);exit;}

}
/*******	Function to check co.za whois via socket connection	*********************/
function cozacheck($domain){
		$errno = 0;
		$errostr = "";
		$timeout = 30;
		$fp = fsockopen("co.za",80,$errno,$errstr,$timeout);
		if($fp){
			socket_set_timeout($fp,$timeout);
			$url = "GET /cgi-bin/whois.sh?Domain=$domain HTTP/1.0\r\n Host: co.za\r\n";
			$url .= "Connection: Keep-Alive\r\n User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)\r\n";
			$url .= "Referer: http://co.za/whois.shtml\r\n Accept: text/plain, text/html\r\n\r\n";
			fputs($fp,$url);
			$output = "";
			while(!feof($fp)){
				$output .= fgets($fp,128);	
			}
			fclose($fp);
			$temp_code = strip_tags($output); 
			if(eregi("Match: One",$temp_code)){
				//echo "The name is taken";
				return 1;
			}else{
				//echo "The name is available";
				return 0;
			}
		}else{
			$layout = "<tr>\n<td>\nThe script could not connect to the co.za whois server<br>";
			$layout .= "<b>DEBUG INFO:</b><br><br>";
			$layout .= "Error No: $errno<br>Error Description:<br>$errstr</td>\n</tr>\n";
			print_results($layout);
			exit;
		}

	}
/********	Function to check co.za whois via curl		***************************/
	function cozacurlcheck($domain){
		$ch = curl_init();
		$url = "http://co.za/cgi-bin/whois.sh?Domain=";
		$url .= $domain;
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_FAILONERROR, 1);
		curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)");
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
		curl_setopt($ch, CURLOPT_TIMEOUT, 4);
		curl_setopt($ch, CURLOPT_REFERER, "http://co.za/whois.shtml"); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $data = curl_exec($ch);
		if(curl_error($ch) == ""){
			curl_close($ch); 
			$temp_code = strip_tags($data);
			if(eregi("Match: One",$temp_code)){
				//echo "The name is taken";
				return 1;
			}else{
				//echo "The name is available";
				return 0;
			}
		}else{
			curl_close($ch);
			$layout = "<tr>\n<td>\nAn Error Occured in connecting to the whois server</td>\n</tr>\n";
			print_results($layout);
			exit;
		}
	}
/**********		function to return whois record via socket	***********************/
	function cozawhois($domain){
		$errno = 0;
		$errostr = "";
		$timeout = 30;
		$fp = fsockopen("co.za",80,$errno,$errstr,$timeout);
		if($fp){
			socket_set_timeout($fp,$timeout);
			$url = "GET /cgi-bin/whois.sh?Domain=$domain HTTP/1.0\r\n Host: co.za\r\n";
			$url .= "Connection: Keep-Alive\r\n User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)\r\n";
			$url .= "Referer: http://co.za/whois.shtml\r\n Accept: text/plain, text/html\r\n\r\n";
			fputs($fp,$url);
			$output = "";
			while(!feof($fp)){
				$output .= fgets($fp,128);	
			}
			fclose($fp);
			$temp_code = strip_tags($output);
			$startp = strpos($temp_code,"The CO.ZA simple whois server");
			$dis = substr($temp_code,$startp);
			print_whois($dis);
		}else{
			$layout = "<tr>\n<td>\nThe script could not connect to the co.za whois server<br>";
			$layout.= "<b>DEBUG INFO:</b><br><br>";
			$layout.= "Error No: $errno<br>Error Description:<br>$errstr</td>\n</tr>\n";
			print_results($layout);
			exit;
		}
	}
/**********		function to return whois record via curl		**********************/
	function cozacurlwhois($domain){
		$ch = curl_init();
		$url = "http://co.za/cgi-bin/whois.sh?Domain=";
		$url .= $domain;
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_FAILONERROR, 1);
		curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0; .NET CLR 1.0.3705)");
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 0);
		curl_setopt($ch, CURLOPT_TIMEOUT, 4);
		curl_setopt($ch, CURLOPT_REFERER, "http://co.za/whois.shtml"); 
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        $data = curl_exec($ch);
		if(curl_error($ch) == ""){
			curl_close($ch); 
			$temp_code = strip_tags($data);
			$startp = strpos($temp_code,"The CO.ZA simple whois server");
			$dis = substr($temp_code,$startp);
			print_whois($dis);
		}else{
			curl_close($ch);
			$layout = "<tr>\n<td>\nAn Error Occured in connecting to the whois 		server</td>\n</tr>\n";
			print_results($layout);
			exit;
		}

	}
/***<--------------------------------end functions------------------------------------>***/
