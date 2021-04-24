<?php
include_once("etc/conf.php");
class fuzzy_bottombar
{
    function fuzzy_bottombar()
    {
            $this->run();
    } // end constructor
    
    function run()
    {
        echo '
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td colspan="3">
                <table width="100%" border="0" bgcolor="#003366">
                    <tr>
                        <td style=" text-align: right;">
                            <span style="color: #ffffff; font-size: 11px; font-weight: bold; font-style: italic;">'.BANNER.'</span>
                        </td>
                    </tr> 
                </table>
            </td>
        </tr>
    </table>
';
    return true;
    } //end run
 
} // end class
?>

