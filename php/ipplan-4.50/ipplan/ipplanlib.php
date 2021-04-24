<?php

// IPplan v4.50
// Aug 24, 2001
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//

define("DEFAULTROUTE", "0.0.0.0");
define("ALLNETS", "255.255.255.255");


/*********** start of global code which runs for each script *********/

// compress output of all pages - could break things!
// breaks if there is space after last php close tag in script!
// must flush with ob_flush if sending from system() call
// required php 4.0.4, but ipplan requires 4.1.0
ob_start("ob_gzhandler");

// hack to make sure systems with register_globals off work
// very ugly, but it works. cannot be in function else variables
// must be declared global. will be called for each script as 
// this lib is always executed.
$types_to_register = array('_GET','_POST','_COOKIE','_SESSION','_SERVER');
foreach ($types_to_register as $type) {
    $arr = @${ $type }; 
    // get rid of magic_quotes else get multiple quotes on each submit
    if (($type=="_GET" or $type=="_POST") and get_magic_quotes_gpc())  {
        $arr=stripslashes_deep($arr);
        // print_r(array_keys($arr));
    }
    if (@count($arr) > 0) {
        extract($arr, EXTR_OVERWRITE);
    }
}

// set the error reporting level for IPplan
error_reporting(E_ALL ^ E_NOTICE);
//error_reporting(E_ALL);
// set to the user defined error handler
set_error_handler("myErrorHandler");
// turn off those pesky quotes
set_magic_quotes_runtime(0);

/*********** end of global code which runs for each script *********/


// baseaddr is an int, not an ip address
// Test base address to see if it is on valid subnet boundary
function TestBaseAddr($baseaddr, $subnetsize) {

    $newsize = $subnetsize-1;
    return ($baseaddr & $newsize);

}

// scan a single host to see if it is up
function ScanHost($host, $timeout=2) {

   // try port 80, if we connect OK, else if error 111, also OK
   $fp = @fsockopen($host, 80, $errno, $errstr, $timeout);
   if (!$fp) {
     // linux likes code 111, solaris likes 146
     if ($errno == 111 or $errno == 146) // connection refused
        return 1;
     else
        return 0;
   } else {
     return 1;
     fclose ($fp);
   }
}

// scan ip-range
// expects a range of addresses to scan in nmap range notation
function NmapScan ($range) {

    $NMAP = NMAP;
    $command = "$NMAP -sP -q -n -oG - ".escapeshellarg($range);
    exec($command, $resarr, $retval);

#echo $command;
    // error due to safe mode?
    if ($retval) {
        return FALSE;
    }
    else {
        $ret=array();
        foreach ($resarr as $line) {
            if(preg_match ("/^Host: ([\d\.]*) \(\).*Status: Up$/", $line, $m)) {
                $ret[$m[1]] = 1;
            }
        }
        return $ret;
    }
}

// creates a range of addresses to scan in nmap format given start and end
// ip addresses - something like 10.10.1.64-127
function NmapRange($nmapstart, $nmapend) {

    #echo $nmapstart." ".$nmapend;
    list($so1, $so2, $so3, $so4) = explode(".", $nmapstart);
    list($eo1, $eo2, $eo3, $eo4) = explode(".", $nmapend);

    $res="";
    $res=sprintf("%s.%s.%s.%s",
        $so1==$eo1 ? $so1 : $so1."-".$eo1,
        $so2==$eo2 ? $so2 : $so2."-".$eo2,
        $so3==$eo3 ? $so3 : $so3."-".$eo3,
        $so4==$eo4 ? $so4 : $so4."-".$eo4);

    return $res;

}

// test for ip addresses between 1.0.0.0 and 255.255.255.255
function testIP($a, $allowzero=FALSE) {
    $t = explode(".", $a);

    if (sizeof($t) != 4)
       return 1;

    for ($i = 0; $i < 4; $i++) {
        // first octet may not be 0
        if ($t[0] == 0 && $allowzero == FALSE)
           return 1;
        if ($t[$i] < 0 or $t[$i] > 255)
           return 1;
        if (!is_numeric($t[$i]))
           return 1;
    };
    return 0;
}

// fill subnet - add 0 or 255 as required
// options - 1 for 0, 2 for 255
function completeIP($a, $opt) {

    $t = explode(".", $a);
    for ($i = 4; $i > sizeof($t); $i--) {
        if ($opt == 1)
           $a = $a.".0";
        else
           $a = $a.".255";
    }

    return $a;
}

// php function ip2long is broken!!! (mod_php4.0.4p1)
function inet_aton($a) {
    $inet = 0.0;
    $t = explode(".", $a);
    for ($i = 0; $i < 4; $i++) {
        $inet *= 256.0;
        $inet += $t[$i];
    };
    return $inet;
}

// php function ip2long is broken!!! (mod_php4.0.4p1)
function inet_aton3($a) {
    $inet = 0.0;
    $t = explode(".", $a);
    for ($i = 1; $i < 4; $i++) {
        $inet *= 256.0;
        $inet += $t[$i];
    };
    return $inet;
}

// php function long2ip is broken!!! (mod_php4.0.4p1)
function inet_ntoa($n) {
    $t=array(0,0,0,0);
    $msk = 16777216.0;
    $n += 0.0;
    if ($n < 1)
        return('0.0.0.0');
    for ($i = 0; $i < 4; $i++) {
        $k = (int) ($n / $msk);
        $n -= $msk * $k;
        $t[$i]= $k;
        $msk /=256.0;
    };
    $a=join('.', $t);
    return($a);
}

// returns the number of bits in the mask cisco style
function inet_bits($n) {

    if ($n == 1)
       return 32;
    else
       return 32-strlen(decbin($n-1));
}

// display various blocks of subnet
// if $fldindex is set use this as column in dfb to skip
function DisplayBlock($w, $row, $totcnt, $anchor, $fldindex="") {

       $cnt=intval($totcnt/MAXTABLESIZE);
       $vars=$_SERVER["PHP_SELF"]."?block=".$cnt.$anchor;
       if ($totcnt % MAXTABLESIZE == 0) {
          insert($w,anchor($vars, $fldindex ? $row[$fldindex] : inet_ntoa($row["baseaddr"])));
       }
       if ($totcnt % MAXTABLESIZE == MAXTABLESIZE-1) {
          insert($w,text(" - "));
          insert($w,anchor($vars, $fldindex ? $row[$fldindex] : inet_ntoa($row["baseaddr"])));
          insert($w,textbr());
       }
       
       return $vars;
}

// displays customer drop down box - requires a working form
// $submit parameter allows drop down to just be displayed, normal
// behaviour will be to submit to self
function myCustomerDropDown($ds, $f1, $cust, $grps, $submit=TRUE) {

   // need to see cookie!
   global $ipplanCustomer, $displayall;

   $custset=0;

   $cust=floor($cust);   // dont trust $cust as it could 
                         // come from form post
   $ipplanCustomer=floor($ipplanCustomer);

   // display customer drop down list, nothing to display, just exit
   if (!$result=$ds->GetCustomerGrp(0))
       return 0;

   // do this here else will do extra queries for every customer
   $adminuser=$ds->TestGrpsAdmin($grps);

   insert($f1,textbrbr(my_("Customer/autonomous system")));
   $lst=array();
   while($row=$result->FetchRow()) {
      // ugly kludge with global variable!
      // remove all from list if global searching is not available
      if (!$displayall and strtolower($row["custdescrip"])=="all")
         continue;

      // strip out customers user may not see due to not being member
      // of customers admin group. $grps array could be empty if anonymous
      // access is allowed!
      if(!$adminuser) {
         if(!empty($grps)) {
            if(!in_array($row["admingrp"], $grps))
               continue;
         }
      }

      $col=$row["customer"];
      // make customer first customer in database
      if (!$cust) {
         $cust=$col;
         $custset=1;    // remember that customer was blank
      }
      // only make customer same as cookie if customer actually
      // still exists in database, else will cause loop!
      if ($custset) {
         if ($col == $ipplanCustomer)
            $cust=$ipplanCustomer;
      }
      $lst["$col"]=$row["custdescrip"];
   }

   if ($submit)
      insert($f1,selectbox($lst,
                        array("name"=>"cust", "onChange"=>"submit()"),
                        $cust));
   else
      insert($f1,selectbox($lst,
                        array("name"=>"cust"),
                        $cust));

   return $cust;

}

// displays area drop down box - requires a working form
// does not matter if areaindex is out of range, will pick "No range"
function myAreaDropDown($ds, $f1, $cust, $areaindex, $displayall=FALSE) {

   $cust=floor($cust);   // dont trust $cust as it could 
                         // come from form post
   $areaindex=floor($areaindex);

   if ($displayall) {
        // display all - only used on createrange
        $result=$ds->GetArea($cust, 0);
   }
   else {
        // display only those areas that have ranges - all other cases
        $result=$ds->GetArea($cust, -1);
   }


   // don't bother if there are no records, will always display "No area"
   insert($f1,textbrbr(my_("Area (optional)")));
   $lst=array();
   $lst["0"]=my_("No area selected");
   while($result and $row = $result->FetchRow()) {
      $col=$row["areaindex"];
      $lst["$col"]=inet_ntoa($row["areaaddr"])." - ".$row["descrip"];
   }

   insert($f1,selectbox($lst,
                     array("name"=>"areaindex","onChange"=>"submit()"),
                     $areaindex));

   return $areaindex;

}

// displays range drop down box - requires a working form
function myRangeDropDown($ds, $f2, $cust, $areaindex) {

   $cust=floor($cust);   // dont trust $cust as it could 
                         // come from form post
   $areaindex=floor($areaindex);

   // display range drop down list
   if ($areaindex)
      $result=$ds->GetRangeInArea($cust, $areaindex);
   else
      $result=$ds->GetRange($cust, 0);

   // don't bother if there are no records, will always display "No range"
   insert($f2,textbrbr(my_("Range (optional)")));
   $lst=array();
   $lst["0"]=my_("No range selected");
   while($row = $result->FetchRow()) {
      $col=$row["rangeindex"];
      $lst["$col"]=inet_ntoa($row["rangeaddr"])."/".inet_ntoa(inet_aton(ALLNETS)-$row["rangesize"]+1).
                   "/".inet_bits($row["rangesize"])." - ".$row["descrip"];
   }

   insert($f2,selectbox($lst,
                     array("name"=>"rangeindex")));

}

// displays error messages and terminates the programs execution
// should only be used for terminal errors that cannot recover (database etc)
// will also ignore previous output generated for the HTML page
// takes optional terminate parameter - if FALSE, script does not terminate
// used for displaying non-fatal form errors
// $message is can be a number of errors seperated by \n
function myError($w, $p, $message, $terminate=TRUE) {

    // Changed by Stephen, 12/24/2004
    // $w now equals the DIV container for the class.
    // $p now equals the pointer to the HTML container.  

    // display error message
    if (!empty($message)) {
        $message=nl2br(htmlspecialchars($message));
        insert($w,span($message, array("class"=>"textError")));
    }

    if ($terminate) {
        printhtml($p);
        exit;
    }
}



// wrapper around gettext function to check if gettext is available first
// gettext is used to internationalize a program
// see http://www.gnu.org/software/gettext
//     http://zez.org/article/articleview/42/
//     http://www.php-er.com/chapters/Gettext_Functions.html
function my_($message) {

   return extension_loaded("gettext") ? gettext($message) : $message;

}

// set the language to use
// cookie is in form <2 letter country code>;<path to ipplan root>
function myLanguage($langcookie) {

   if(extension_loaded("gettext")) {
      // split language and path from cookie
      list($lang,$path) = explode(":", $langcookie, 2);

      // Set language environment variable
      // not required anymore
      //putenv("LANG=$lang");
      setlocale(LC_ALL, $lang);
                                                                                
      // Specify location of translation tables 
      bindtextdomain ("messages", $path."/locale"); 

      // Choose domain 
      textdomain ("messages");
   }
}

// returns the directory tree base URL for menu construction
// if constant BASE_URL is defined, use that instead
function base_url() {

    $BASE_URL = BASE_URL;

    if (empty($BASE_URL)) {
        // dirname strips trailing slash!
        $tmp = dirname($_SERVER["PHP_SELF"]);
        // installed in root of a virtual server? then return empty path
        if ($tmp == "/") return "";
        //$tmp = dirname($_SERVER["SCRIPT_NAME"]);
        $tmp = eregi_replace("/user$","",$tmp);
        $tmp = eregi_replace("/admin$","",$tmp);

        return $tmp;
    }
    else {
        return $BASE_URL;
    }

}

// returns the base path under which IPplan is installed
function base_dir() {

    // dirname strips trailing slash!
    $tmp = dirname(__FILE__);
    //$tmp = dirname($_SERVER["SCRIPT_FILENAME"]);
    $tmp = eregi_replace("/user$","",$tmp);
    $tmp = eregi_replace("/admin$","",$tmp);

    return $tmp;

}

// returns a complete URI for use with Location: header. Returns relative URI
// if complete URI cannot be worked out
function location_uri($relative_url) {

    // running Apache or something or server that has HTTP_HOST set?
    if (isset($_SERVER['HTTP_HOST'])) {
        return "http" . (isset($_SERVER["HTTPS"]) && $_SERVER["HTTPS"]=='on'?"s":"")
            ."://".$_SERVER['HTTP_HOST'].dirname($_SERVER['PHP_SELF'])."/".$relative_url;
    }
    // no, we will hope for best with a relative URI - this is against HTTP specs, but too bad
    else {
        return $relative_url;
    }
}

// draw title block
function myheading($q, $title, $displaymenu=true) {

    // Generate the correct prefix for URLs in menu.

    $BASE_URL = base_url();
    $BASE_DIR = base_dir();

    $myDirPath = $BASE_DIR . '/menus/';
    $myWwwPath = $BASE_URL . '/menus/';

    // these files should probably not be here
    require_once $myDirPath . 'lib/PHPLIB.php';
    require_once $myDirPath . 'lib/layersmenu-common.inc.php';
    require_once $myDirPath . 'lib/layersmenu.inc.php';
    require_once $BASE_DIR  . '/menudefs.php';
    eval("\$ADMIN_MENU = \"$ADMIN_MENU\";");

    // create the html page HEAD section
    insert($q, $header=wheader("IPPlan - $title"));
    insert($q, $w=container("div",array("class"=>"matte")));

    insert($header, generic("meta",array("http-equiv"=>"Content-Type","content"=>"text/html; charset=UTF-8")));
    if ($displaymenu) {
        insert($header, generic("link",array("rel"=>"stylesheet","href"=>"$myWwwPath"."layersmenu-gtk2.css")));
        //    insert($header, generic("link",array("rel"=>"stylesheet","href"=>"$myWwwPath"."layersmenu-demo.css")));
    }


    // Added theme support.
    $themecookie=isset($_COOKIE["ipplanTheme"]) ? $_COOKIE["ipplanTheme"] : "";
    global $config_themes;  // obtained from config.php file which is global
    if (!empty($themecookie) and $config_themes[$themecookie] <> "") {
        insert($header, generic("link",array("rel"=>"stylesheet","href"=>"$BASE_URL"."/themes/$config_themes[$themecookie]")));
    }
    else {
        insert($header, generic("link",array("rel"=>"stylesheet","href"=>"$BASE_URL"."/themes/default.css")));
    }

    if ($displaymenu) {
        insert($w, script("",array("language"=>"JavaScript","type"=>"text/javascript","src"=> $myWwwPath."libjs/layersmenu-browser_detection.js")));
        insert($w, script("",array("language"=>"JavaScript","type"=>"text/javascript","src"=> $myWwwPath . 'libjs/layersmenu-library.js')));
        insert($w, script("",array("language"=>"JavaScript","type"=>"text/javascript","src"=> $myWwwPath . 'libjs/layersmenu.js')));

        $mid= new LayersMenu(6, 7, 2, 1);
        $mid->setDirroot ($BASE_DIR.'/menus/');
        $mid->setLibjsdir($BASE_DIR.'/menus/libjs/');
        $mid->setImgdir  ($BASE_DIR.'/menus/menuimages/');
        $mid->setImgwww  ($BASE_URL.'/menus/menuimages/');
        $mid->setIcondir ($BASE_DIR.'/menus/menuicons/');
        $mid->setIconwww ($BASE_URL.'/menus/menuicons/');
        $mid->setTpldir  ($BASE_DIR.'/menus/templates/');
        $mid->SetMenuStructureString($ADMIN_MENU);
        $mid->setIconsize(16, 16);
        $mid->parseStructureForMenu('hormenu1');
        $mid->newHorizontalMenu('hormenu1');
    }

    // draw header box
    insert($w,$con=container("div",array("class"=>"headerbox",
                    "align"=>"center")));
    insert($con, heading(1, my_("IPPlan - IP Address Management and Tracking")));
    insert($con, block("<br>"));
    insert($con, heading(3, $title));

    if ($displaymenu) {
        // draw menu box here
        insert($w,$con=container("div",array("class"=>"menubox")));
        insert($con,$t =table(array("cols"=>"2","width"=>"100%")));
        insert($t, $c1=cell());
        insert($t, $c2=cell(array("align"=>"right")));

        insert($c1,block($mid->getHeader()));
        insert($c1,block($mid->getMenu('hormenu1')));
        insert($c1,block($mid->getFooter()));

        // find a place to display logged in user
        insert ($c2,$uc=container("div",array("class"=>"userbox")));
        if (isset($_SERVER[AUTH_VAR])) {
            insert($uc,block(sprintf(my_("Logged in as %s"), $_SERVER[AUTH_VAR])));
        }
    }

    insert($w,$con=container("div",array("class"=>"normalbox")));
    insert($w,$con1=container("div",array("class"=>"footerbox")));
    insert($con1,block("IPPlan v4.50"));
    return $con;

}

// draw a search box with associated search type if required
class mySearch {

    // w - the layout display container to draw this in
    // vars - the hidden vars to maintain in this subform for submission - array, probably get or post
    // search - the search string
    // frmvar - the form variable to use
    var $w, $vars, $search, $frmvar;

    var $expr="";           // the last expression used - for form resubmit
    var $expr_disp=FALSE;   // do we require an expression drop down?
    var $method="get";
    var $legend;

    function mySearch(&$w, $vars, $search, $frmvar) {
        $this->w=$w;
        $this->vars=$vars;
        $this->search=$search;
        $this->frmvar=$frmvar;
        $this->legend=my_("Refine Search");
    }

    function Search() {

        unset($this->vars[$this->frmvar]);
        unset($this->vars["block"]);
        unset($this->vars["expr"]);
        //    $url=my_http_build_query($vars);

        // start form
        insert($this->w, $f = form(array("name"=>"SEARCH",
                        "method"=>$this->method,
                        "action"=>$_SERVER["PHP_SELF"])));

        insert($f, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text($this->legend));
        if ($this->expr_disp) {
            $lst=array("START"=>my_("Starts with"),
                    "END"=>my_("Ends with"),
                    "LIKE"=>my_("Contains"),
                    "NLIKE"=>my_("Does not contain"),
                    "EXACT"=>my_("Equal to"));
            if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql" or DBF_TYPE=="postgres7") {
                $lst["RLIKE"]=my_("Regex contains");
            }
            // only supported by mysql
            if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
                $lst["NRLIKE"]=my_("Does not regex contain");
            }
            insert($con,selectbox($lst, array("name"=>"expr"), $this->expr));
        }

        insert($con,input_text(array("name"=>$this->frmvar,
                        "value"=>$this->search,
                        "size"=>"20",
                        "maxlength"=>"80")));

        foreach ($this->vars as $key=>$value) {
            insert($con,hidden(array("name"=>"$key",
                            "value"=>"$value")));
        }

        insert($con,submit(array("value"=>my_("Submit"))));
        insert($con,block(" <a href='#' onclick='SEARCH.".$this->frmvar.".value=\"\"; SEARCH.submit();'>Reset Search</a>"));


    }
}

// select field to focus on in html form
// form and field variables must be static text variables
function myFocus($w, $form, $field) {

    insert($w, script("document.$form.$field.focus();",
                array("language"=>"JavaScript", "type"=>"text/javascript")));
}

// IPplan error handler function
function myErrorHandler ($errno, $errstr, $errfile, $errline) {

    static $beenhere=FALSE;

    // ugly hack to filter out E_STRICT php5 messages - needs fixing 
    // error_reporting level appears to be ignored?
    if (phpversion() >= "5.0.0" and $errno==2048) {
        return;
    }

    if (DEBUG==FALSE) {
        // check what we actually want to report on, ignore rest
        if (!($errno & error_reporting())) return;
    }
    else {
        // for debugging - ignore pesky messages
        if (strstr($errstr, "var: Deprecated")) return;
        if (strstr($errfile, "layersmenu.inc.php")) return;
    }


    echo "<div class=errorbox>";
    if (!$beenhere) {
        echo "If you see this message, submit a detailed bug report on Sourceforge including ";
        echo "the message below, the database platform used and the steps to perform to recreate ";
        echo "the problem.<p>";
        echo "PHP ".PHP_VERSION." (".PHP_OS.")<br>\n";
        $beenhere=TRUE;
    }

    switch ($errno) {
        case E_USER_ERROR:
            echo "<b>FATAL</b> [$errno] $errstr<br>\n";
            echo "  Fatal error in line ".$errline." of file ".$errfile."<br>";
            echo "Aborting...<br>\n";
            echo "</div>";
            exit;
            break;
        case E_USER_WARNING:
            echo "<b>ERROR:</b> [$errno] $errstr Line: $errline File: $errfile<br>\n";
            break;
        case E_USER_NOTICE:
            echo "<b>WARNING:</b> [$errno] $errstr Line: $errline File: $errfile<br>\n";
            break;
        case E_NOTICE:
            echo "<b>NOTICE:</b> [$errno] $errstr Line: $errline File: $errfile<br>\n";
            break;
        case 2048:  // E_STRICT error type of php5 - undefined in php4
            echo "<b>STRICT:</b> [$errno] $errstr Line: $errline File: $errfile<br>\n";
            break;
        default:
            echo "<b>Unknown error type:</b> [$errno] $errstr Line: $errline File: $errfile<br>\n";
            break;
    }
    echo "</div>";

}

function color_flip_flop() {
    // Added by Stephen Blackstone
    // Simple Function to alternate the two pieces by color.

    $color1="oddrow";   // Define row color A.
    $color2="evenrow"; 	 // Define row color B.
    static $currentcolor;
    if ($currentcolor==$color1) { 
        $currentcolor=$color2; 
    }
    else {
        $currentcolor=$color1; 
    }

    return($currentcolor);

}

function stripslashes_deep($value) {
    $value = is_array($value) ?
        array_map('stripslashes_deep', $value) :
            stripslashes($value);

    return $value;
}

// emulates php 5 function to build urlencoded query string from array
function my_http_build_query($arr) {

    $str="";

    foreach ($arr as $key=>$value) {
        if (empty($str)) {
            $str .= $key."=".urlencode($value);
        }
        else {
            $str .= "&".$key."=".urlencode($value);
        }
    }

    return $str;

}

// start a user defined trigger on an ipplan database event
// $action is associative array with at least one index called "event"
// events must be unique, user_trigger function is in ipplanlib.php
// eg array("event"=>100)
// eg array("event"=>100, "cust"=>$cust)
// function called from AuditLog, empty currently, returns nothing
// only called if EXT_FUNCTION in config.php is TRUE
// error handling must be done internal to function

// see TRIGGERS file for list of event codes and variables passed
function user_trigger($action) {

/*
    switch ($action["event"]) {
        case 100:
            system("updatedns.pl ".$action["domain"]);
            break;
        case 200:
            system("deletezone.pl");
            break;
    }
    */

}

// expects a string formatted as follows:
// "code:variablename code:variablename ..."
// where code is A for array, S for string, I for integer
// returns an array of the sanitized variables
function myRegister($vars) {

    $newvars=array();
    $tokens = split(" ", $vars);

    foreach ($tokens as $value) {
        list($code, $variable) = split(":", $value);
        switch ($code) {
            case "A":
                $newvars[]=isset($_REQUEST["$variable"]) ? stripslashes_deep($_REQUEST["$variable"]) : array();
                continue;
            case "S":
                $newvars[]=isset($_REQUEST["$variable"]) ? stripslashes((string)$_REQUEST["$variable"]) : "";
                continue;
            case "B":  
                // use floor here to convert to float as int is just not big enough for ip addresses
                $newvars[]=isset($_REQUEST["$variable"]) ? floor($_REQUEST["$variable"]) : 0;
                continue;
            case "I":  
                $newvars[]=isset($_REQUEST["$variable"]) ? (int)$_REQUEST["$variable"] : 0;
                continue;
        }
    }

    return $newvars;

}

/*
// test code
$t1=""; $t2="";
foreach ($_REQUEST as $key=>$value) {
    $t1 .= "S:$key ";
    $t2 .= "$".$key.", ";
}

define_syslog_variables();
openlog("TextLog", LOG_PID, LOG_LOCAL0);
syslog(LOG_INFO, $t1);
syslog(LOG_INFO, $t2);
closelog();
*/

?>
