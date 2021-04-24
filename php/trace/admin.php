<?

$version_info = explode('.', phpversion());
if ($version_info[0] < 4 || ($version_info[0] > 3 && $version_info[1] < 1)) {
    $_POST = $HTTP_POST_VARS;
    $_GET = $HTTP_GET_VARS;
    $_COOKIE = $HTTP_COOKIE_VARS;
}

if (!isset($_GET['op']))
  $op = '';
else
  $op = $_GET['op'];

include "header.inc.php";
echo "<a href=index.php>Index</a>";
// get old traceplaces from database
function from(){

$query = "select vid,plaats from van";
$result = mysql_query($query);

while ($row = mysql_fetch_object($result)){

    echo "<option value=".$row->vid.">".stripslashes($row->plaats);

}
}

// get already traced sites from database
function site(){

$query = "select sid,naam from site";
$result = mysql_query($query);

while ($row = mysql_fetch_object($result)){

    echo "<option value=\"".$row->sid."\">".stripslashes($row->naam);

}
}


?>


<h2>Traceroute : Admin</h2>

<?
// adding info in database !
if ($op == "add") {

$text = $_POST['text'];
$siteold = $_POST['siteold'];
$sitenew = $_POST['sitenew'];
$vanold = $_POST['vanold'];
$vannew = $_POST['vannew'];

    if ($text == "")
        echo "no text !<br><a href=javascript:history.back()>Back</a>";
            elseif (($siteold == "Selecteer") AND ($sitenew == ""))
                echo "NO site chosen/filled in !<br><a href=javascript:history.back()>Back</a>";
                    elseif($vanold == "Selecteer" AND $vannew == "")
                        echo "NO trace chosen/filled in !<br><a href=javascript:history.back()>Back</a>";
    else {


        if ($vanold != "Selecteer"){
            $vanid = $vanold;
        }
        if ($vanold == "Selecteer") {
            $queryvan = "insert into van values('','$vannew')";
            $resultvan = mysql_query($queryvan);
            $vanid = mysql_insert_id();
        }
        if ($siteold != "Selecteer") {
            $siteid = $siteold;
        }
        if ($siteold == "Selecteer") {
            $querysite = "insert into site values ('','$sitenew')";
            $resultsite = mysql_query($querysite);
            $siteid = mysql_insert_id();
        }

	   // insert into crosstable
	   $datum = date("Y-m-d H:i:s");
	   $queryx = "insert into vanxsite values('','$vanid','$siteid','$datum')";
	   $resultx = mysql_query($queryx);
	   $xid = mysql_insert_id();
       // write tempdata to datafile
       $fp = fopen ("data.txt", "w");
       $text = trim($text);
       fwrite($fp,"$text");
       fclose($fp);


       // open the file
       $fp = fopen ("data.txt", "r");
       $i = 0;
       while (!feof($fp)) {
           $contents = fgets ($fp, 1000);
           $lijn = str_replace(" ","|",$contents);
           $lijn = str_replace("|||||","|",$lijn);
           $lijn = str_replace("|||||","|",$lijn);
           $lijn = str_replace("||||","|",$lijn);
           $lijn = str_replace("||||","|",$lijn);
           $lijn = str_replace("|||","|",$lijn);
           $lijn = str_replace("||","|",$lijn);
             $query = "insert into info values ('','$xid','$vanid','$siteid','".trim($lijn)."')";
               //echo $query."<br>";
               $result = mysql_query($query);
               print mysql_error();
               $i++;
        }
        fclose ($fp);

      echo "<br>";
     echo "<h2>Data in database</h2><br>";
     echo "<a href=admin.php>Back to admin</a><br>";
     echo "<a href=browser.php>Browse data</a>";

    }
}

// form for inserting the info
else { ?>

Add new traceroute
<form method=post action=admin.php?op=add>
<table>
<tr><td><textarea name=text cols=150 rows=30></textarea></td></tr>
<tr><td>Site : <select name=siteold><option>Selecteer <? site(); ?> </select> -&nbsp; <input type=text name=sitenew size=30> - Either choose from select box or fill in new site</td></tr>
<tr><td>Traced from : <select name=vanold><option>Selecteer <? from(); ?> </select> -&nbsp; <input type=text name=vannew size=30>  - Either choose from select box or fill in new traceroute-server/place</td></tr>
<tr><td><input type=submit value="Add data"></td></tr>
</table>
</form>

<?

}

include "footer.inc.php";
?>
