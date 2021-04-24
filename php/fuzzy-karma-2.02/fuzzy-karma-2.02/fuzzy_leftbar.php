<?php
include_once("etc/conf.php");
class fuzzy_leftbar
{
    function fuzzy_leftbar($db)
    {
            $this->run($db);
    } // end constructor
    
    function run($db)
    {
        $select = "SELECT * FROM fuzzy_packets ORDER BY protocol_name;";
        $result = $db->query($select);

        echo '
        <tr>
            <td valign="top" width="12%" class="leftbar">
                <table class="leftbar" cellpadding="0" cellspacing="1" height="100%">
                <!--<tr><br /></tr>-->';
        while ($row = mysql_fetch_row($result))
        {
            echo '
                    <tr class="leftmenu">
                        <td class="leftmenu_out" onMouseOver="this.className=\'leftmenu_over\'"
                            onMouseOut="this.className=\'leftmenu_out\'"
                            onClick="location.href=\''.BASE_URL.'index.php?load='.$row[3].'\'"
                        >
                            <span class="leftmenu">'.$row[0].'</span>
                        </td>
                    </tr>';
        }
 /*                  <tr class="leftmenu">
                        <td class="leftmenu_out" onMouseOver="this.className=\'leftmenu_over\'"
                            onMouseOut="this.className=\'leftmenu_out\'"
                        >
                            <span class="leftmenu">---View All---</span>
                        </td>
                    </tr> */
	echo '
                </table>
            </td>
            <td valign="top">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td valign="top" width="12" rowspan="2">
                            <table cellpadding="0" cellspacing="0">
                                <tr>
                                    <td valign="top">
                                        <img src="'.IMAGES.'topcurve.gif">
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
            ';
    return true;
    } //end run
 
} // end class
?>

