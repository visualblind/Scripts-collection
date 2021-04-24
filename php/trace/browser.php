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
echo "\n";


echo "<table border=0 cellspacing=0 cellpadding=2>\n";
echo "<tr><td valign=top>\n";

# show all places of one sites

if ($op == "view"){

echo "<a href=browser.php>Site-index</a><br><br>\n";

$site = $_GET['site'];

# get name of site we want to see
$quernaam = "select naam from site where sid='$site'";
$resultnaam = mysql_query($quernaam);
$rown = mysql_fetch_object($resultnaam);
echo "<h2>".$rown->naam."</H2>\n";

echo "Fill in what you want to see with numbers. if you have 3 things, you can fill in 1-2-3 or 2-3-1 etc... <br>the way you fill sets the order !<br><br>";

echo "<table>\n";
echo "<form action=browser.php?op=show&site=$site method=post>\n";
//echo "<input type=hidden name=site value=$site>";

# get all places where we tracerouted the site

$queryvan = "select van.plaats,vanxsiteid,vanxsite.datum from vanxsite ";
$queryvan .= " left join van on vanxsite.van_id=van.vid";
$queryvan .= " left join site on vanxsite.site_id=site.sid where vanxsite.site_id='$site'";
$resultvan = mysql_query($queryvan);
$nr = mysql_num_rows($resultvan);
while ($rowv = mysql_fetch_object($resultvan)){

    echo "\t<tr>\n\t\t<td>\n\t\t\t";
    echo $rowv->plaats." (".$rowv->datum.")\n\t\t</td>\n";
    echo "\n\t\t<td>\n\t\t\t";
    echo "&nbsp;&nbsp;<input type=text size=5 name=\"".$rowv->vanxsiteid."\"> - &nbsp;&nbsp; <a href=browser.php?op=del&id=".$rowv->vanxsiteid."&site=$site>Delete this traceroute </a>";
    echo "</td>";
}
echo "\t<tr>\n\t\t<td colspan=2>\n\t\t\t<input type=submit value=\"Show\">\n\t\t</td>\n\t</tr>\n";
echo "</form>\n";
echo "</table>\n ";
}

# question: first ask if you really really want to delete it :)

elseif ($op == "del") {

$id = $_GET['id'];
$site = $_GET['site'];

echo "<h2>Are you sure to remove this traceroute ??</h2>";
echo "<h3><a href=browser.php?op=delete&id=$id&site=$site>Very sure</a><h3>";
echo "<h3><a href=javascript:history.back()>No, go back</a></h3>";

}

# after ok, delete from info and from crosstable

elseif($op == "delete"){

$id = $_GET['id'];
$site = $_GET['site'];

$query = "select * from info where vxsid='$id'";
$result = mysql_query($query);
    while ($row = mysql_fetch_object($result)){
    
        $query1 = "delete from info where id='".$row->id."'";
        //echo $query1."<br>";
        $result1 = mysql_query($query1);
    
    }

$delxquery = "delete from vanxsite where vanxsiteid='$id'";
$resultx = mysql_query($delxquery);

echo "<meta http-equiv=\"refresh\" content=\"0; url=browser.php?op=view&site=$site\">";
echo "<a href=browser.php?op=view&site=$site>Click here if you are not forwarded automatically</a>";

}

# view all inputted places

elseif ($op == "show"){

$site = $_GET['site'];
$errej = array();
$quernaam = "select naam from site where sid='$site'";
$resultnaam = mysql_query($quernaam);
$rown = mysql_fetch_object($resultnaam);
echo "<h2>".stripslashes($rown->naam)."</H2>\n";


echo "<table border=1 cellspacing=0 cellpadding=4>";
echo "<tr>";

while(list($key, $val)=each($HTTP_POST_VARS)) 
{ 
//echo "$key:$val"; 
    if ($val)
        $errej[$val] = $key;
}

for ($i=1;$i<=count($errej);$i++){

$qiery = "select van.vid,van.plaats from van left join vanxsite on van.vid=vanxsite.van_id where vanxsite.vanxsiteid='".$errej[$i]."'";
$result = mysql_query($qiery);
$rowid = mysql_fetch_object($result);

echo "<td valign=".$valign.">";
echo "<table>";
echo "<tr><td align=center colspan=6><center><b>".$rowid->plaats."</b></td></tr>";
echo "<tr>";

$idvan = $rowid->vid;
$query = "select * from info left join vanxsite on info.vxsid=vanxsite.vanxsiteid where vanxsiteid=".$errej[$i]." order by ID ASC";
$result = mysql_query($query);

echo "<td bgcolor=#DDDDDD><font size=-2>nr</font></td>";
echo "<td bgcolor=#DDDDDD><font size=-2>Hostname</font></td>";
echo "<td bgcolor=#DDDDDD><font size=-2>Loss</font></td>";
echo "<td bgcolor=#DDDDDD><font size=-2>Best</font></td>";
echo "<td bgcolor=#DDDDDD><font size=-2>Avg</font></td>";
echo "<td bgcolor=#DDDDDD><font size=-2>Worst</font></td>";
echo "</tr>";
while ($row = mysql_fetch_object($result)){
echo "<tr>";
    $test = substr($row->text,0,1);
        if ($test == "|") {
            $test = substr_replace($row->text,"",0,1);
        }
        else{
            $test = $row->text;
        }
        
        $used = explode("|",$test);
        $counter = $used;
        $b = count($counter);
        $used3 = $used;
        $used1 = array_splice($used,0,3);
        if ($b == "9")
        $used2 = array_splice($used3,6,3);
        if ($b == "8")
        $used2 = array_splice($used3,5,3);

        for ($u=0;$u<count($used1);$u++){
            echo "<td><font size=-2>$used1[$u]</font></td>";
        }
        
        for ($u=0;$u<count($used2);$u++){
            echo "<td><font size=-2>$used2[$u]</a></td>";
        }

echo "</tr>";
    }
echo "</Table></td>";
}
echo "</tr></table>";

}

else {

echo "<a href=index.php>index</a><br><br>";

echo "<table><tr><td>\n";

$query = "select naam,sid from site";
$result = mysql_query($query);
print mysql_error();
    while ($row = mysql_fetch_object($result)){
        print mysql_error();
        $queryvan = "select van.plaats,vanxsiteid,vanxsite.datum from vanxsite ";
	$queryvan .= " left join van on vanxsite.van_id=van.vid";
	$queryvan .= " left join site on vanxsite.site_id=site.sid where vanxsite.site_id='$row->sid'";
	$resultvan = mysql_query($queryvan);
	$nr = mysql_num_rows($resultvan);
        echo "<li><a href=browser.php?op=view&site=".$row->sid.">".stripslashes($row->naam)."</a> ($nr)";
}

echo "</td></tr></table>\n";

}

echo "</td></tr>\n</table>";

echo "\n\n";
include "footer.inc.php";
?>
