<?php
include_once("etc/conf.php");
class fuzzy_rightbar
{
    function fuzzy_rightbar()
    {
            $this->run();
    } // end constructor
    
    function run()
    {
        echo '
            <td valign="top" width="15%">
                <table align="right">
                    <tr>
			<td>
				
			</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr valign="bottom">
            <td class="leftbar">
                <br />
            </td>
            <td valign="bottom">
                <img src="'.IMAGES.'bottomcurve.gif" align="top">
            </td>
        </tr>

    </table>
';
    return true;
    } //end run
 
} // end class
?>

