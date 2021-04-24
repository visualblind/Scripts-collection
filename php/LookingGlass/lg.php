<?php

  include "version.php";
  include "header.php";

  if ( $_POST["func"] AND $_POST["target"] ) {
    include "functions.php";
    // Take action
    $target=preg_split("/[\s,;]/",$_POST["target"]);
    $target=$target[0];
    echo $version["fullname"]." function: <code>".$_POST["func"].
         "</code> for target: <code>".$target."</code> via: <code>".
         $_POST["ipv"]."</code> (if applicable)<br>\n";

    if ( is_ipv4($target) ) {
      $ip=$target;
      $host=get_host($ip);
      $_POST["ipv"]="ipv4";
    } elseif ( is_ipv6($target) ) {
      $ip=$target;
      $host=get_host($ip);
      $_POST["ipv"]="ipv6";
    } elseif ( is_url($target) ) {
      if ( $_POST["ipv"] == ipv4 ) {
        $ip=get_ipv4($target);
      } else {
        $ip=get_ipv6($target);
      }
      $host=get_host($ip);
    }

    echo "Target hostname: <code>";
    if ( $host ) 
      echo $host;
    else
      echo "reverse resolving failed";
    echo "</code>; Target IPno: <code>";
    if ( $ip )
      echo $ip;
    else
      echo "resolving failed";
    echo "</code><br>\n";

    $com="";
    switch ( $_POST["func"] ) {
    case "tcptraceroute":
      if ( $ip )
        $com="/usr/bin/tcptraceroute";
      break;
    case "traceroute":
      if ( $ip ) 
        if ( $_POST["ipv"] == "ipv4" )
          $com="/usr/sbin/traceroute -w 2";
        else
          $com="/usr/sbin/traceroute6 -w 2";
      break;
    case "tracepath":
      if ( $ip ) 
        if ( $_POST["ipv"] == "ipv4" )
          $com="/usr/sbin/tracepath";
        else
          $com="/usr/sbin/tracepath6";
      break;
    case "ping":
      if ( $ip )
        if ( $_POST["ipv"] == "ipv4" )
          $com="/bin/ping -c10 -W2";
        else
          $com="/bin/ping6 -c10 -W2";
      break;
    case "whois":
      $com="/usr/bin/whois";
      break;
    case "dnsa":
      if ( $_POST["ipv"] == "ipv4" )
        $com="/usr/bin/host -Q -t A";
      else
        $com="/usr/bin/host -Q -t AAAA";
      break;
    case "dnsmx":
      $com="/usr/bin/host -Q -t MX";
      break;
    case "dnsns":
      $com="/usr/bin/host -Q -t NS";
      break;
    case "dnsany":
      $com="/usr/bin/host -Q -t ANY";
      break;
    }

    if ( ( $_POST["ipv"] == "ipv4" ) AND
         is_rfc1918($ip) ) {
      echo "<hr><div class=\"info\">Sorry, can't do, ".$ip." RFC1918 (private) space.</div>\n";
    } elseif ( ! $com ) {
      echo "<hr><div class=\"info\">Sorry, can't do, somehow the input is insufficient.</div>\n";
    } else {
      // Log command for security, remove if you're not interested
      error_log($version["fullname"]."; [".$_POST["func"]."] [".
        $target."]; Time: ".date ("D d M Y H:i:s T")."; Remote_Host: ".
        $_SERVER["REMOTE_HOST"]."; Remote_Addr: ".$_SERVER["REMOTE_ADDR"].
        "; Http_User_agent: ".$_SERVER["HTTP_USER_AGENT"]." Command: ".$com." ".
        $target,0);
      $com=escapeshellcmd($com);
      echo "System command: <code>$com ".$target."</code><hr>\n";
      echo "<pre>\n";
      system("$com ".$target." 2>&1");
      echo "</pre>\n";
    }

    echo "<div align=\"right\"><a href=\"javascript:history.back()\">repeat</a> <a href=\".\">reload</a></div>\n";
  
  } else {
    // print form
    include "form.php";
  }

  include "footer.php";
?>
