<html>

<head>
<title>Network Utils</title>
</head>

<body bgcolor="#FFFFFF" link="#0000FF" vlink="#800080" alink="#FF0000">

<?PHP
$error = True;
if ($HTTP_POST_VARS['B1'] == "Whois") {

    if ($HTTP_POST_VARS['T1'] == "") {
        $msg = "You didn't supply a domain name the previous page.";
    } else {
        $error = False;
        $reply = "";
        $fp = fsockopen ($HTTP_POST_VARS['D1'], "43", $errno, $errstr, 60);
        if (!$fp) {
            $reply = "$errstr ($errno)<br>\n";
        } else {
            fputs ($fp, $HTTP_POST_VARS['T1']."\r\n");
            while (!feof($fp)) {
                $tmp_reply = fgets ($fp,128);
                $tmp_reply = str_replace("\r", "", $tmp_reply);
                $tmp_reply = str_replace("\n", "<br>\n", $tmp_reply);
                $tmp_reply = str_replace("  ", "&nbsp;&nbsp;", $tmp_reply);
                if (substr($reply, 0, 1) == " ") {
                    $tmp_reply = substr_replace($tmp_reply, "&nbsp;", 0, 1);
                }
                $reply .= $tmp_reply;
            }
            fclose ($fp);
            $reply = "Whois server <strong>".$HTTP_POST_VARS['D1']. "</strong> responded with the following for <strong>".$HTTP_POST_VARS['T1']."</strong>: - <br><br>\n".$reply;
        }
    }
}

if ($HTTP_POST_VARS['B1'] == "IP Lookup") {
    if ($HTTP_POST_VARS['T1'] == "") {
        $msg = "You didn't supply a host name the previous page.";
    } else {
        $error = False;
        $reply = "The IP address for <strong>".$HTTP_POST_VARS['T1']."</strong> is: -<br><br>".gethostbyname($HTTP_POST_VARS['T1']);
    }
}

if ($HTTP_POST_VARS['B1'] == "Host Name Lookup") {
    if ($HTTP_POST_VARS['T1'] == "") {
        $msg = "You didn't supply an IP address the previous page.";
    } else {
        $error = False;
        $reply = "The host name for <strong>".$HTTP_POST_VARS['T1']."</strong> is: -<br><br>".gethostbyaddr($HTTP_POST_VARS['T1']);
    }
}

    if ($error) {
        echo "<p><font face='Arial' size='2'>".$msg."</font></p>\n";
        echo "<p><font face='Arial' size='2'>Click <A HREF=JavaScript:history.back()>here</a> to return to the previous page or click the Back button on your browser.</font></p>\n";
    } else {
	echo "<p><font face='Arial' size='2'>".$reply."</font></p>\n";
    }

?>

</body>
</html>