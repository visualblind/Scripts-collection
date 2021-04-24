<?php
include_once("etc/conf.php");
class fuzzy_main
{
    function fuzzy_main($db, $load)
    {            
        $this->run($db, $load);
    } // end constructor
    
    function run($db, $load)
    {
        if ($load == "default")
        {
            echo '
            <td valign="top" width="70%">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td colspan="2">
                            <span>*** Fuzzy Database Statistics ***</span>
                        </td>
                    </tr>
					<tr>
						<td colspan=2><img src="'.IMAGES.'cp.gif" height=10 width=1 border=0></td>
					</tr>
                    <tr>
                        <td>
                            <span>Protocol</span>
                        </td>
                        <td>
                            <span>Analyzed Packets</span>
                        </td>
                    </tr>
                    ';
            $select = "SELECT * FROM fuzzy_packets ORDER BY protocol_name;";
            $result = $db->query($select);
            while ($row = mysql_fetch_row($result))
            {   
                $select = "SELECT COUNT(*) FROM ".$row[1].";";
                $count_result = $db->query($select);
                $protocol_count = mysql_fetch_row($count_result);
                $protocol_name = $row[0];
                echo '
                    <tr>
                        <td>
                            <span>'.$protocol_name.'</span>
                        </td>
						<td>
                            <span><a href="#" onClick="location.href=\''.BASE_URL.'index.php?load='.$row[3].'\'">'.$protocol_count[0].'</a></span>
                        </td>
                    </tr>
                    ';
            }
                $select = "SELECT COUNT(*) FROM fuzzy_temp;";
                $temp_result = $db->query($select);
                $temp_count = mysql_fetch_row($temp_result);
            echo '
					<tr>
						<td colspan=2><img src="'.IMAGES.'cp.gif" height=10 width=1 border=0></td>
					</tr>
                    <tr>
                        <td>
                            <span>Packets Not Yet Analyzed: <img src="'.IMAGES.'cp.gif" height=2 width=10 border=0></span>
                        </td>
                        <td>
                            <span>'.$temp_count[0].'</span>
                        </td>
                    </tr>
				';
				$select = "SELECT COUNT(*) FROM event;";
			$temp_result = $db->query($select);
			$temp_count = mysql_fetch_row($temp_result);
			echo '
				<tr>
				<td>
				<span>Packets in the Queue:</span>
				</td>
				<td>
				<span>'.$temp_count[0].'</span>
				</td>
				</tr>
				';
            echo '
                </table>
            </td>
            ';
                
        }
		elseif($load == "changepass.php")
		{
			include_once("changepass.php");
			$toString = new changepass();
		}//end elseif
        else {
            echo '<td valign="top" width="70%">';
            echo ($load);
            echo '</td>';
        }
    return true;
    } //end run
 
} // end class
?>

