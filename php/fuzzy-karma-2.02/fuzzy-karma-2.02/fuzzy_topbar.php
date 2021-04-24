<?php
/* This is the header file
*/
include_once("etc/conf.php");
class fuzzy_topbar
{
    function fuzzy_topbar()
    {
            $this->run();
    } // end constructor
    
    function run()
    {
        echo '
    <table class="topbar" bgcolor="#003366" width="100%" border="0" background="'.IMAGES.'fuzzy-title.gif">
        <tr>
            <td colspan="3">
                <br />
				<img src="'.IMAGES.'logo.gif" width="250" style="vertical-align: middle;">
		<br />
            </td>
        </tr>
    </table>
    <table class="topbar" bgcolor="#003366" width="100%" border="0">
        <tr>
            <td width="200" nowrap>
                <span style="color: #ffffff; font-size: 11px; font-weight: bold; font-style: italic;">Review Packets</span>
            </td>
			<td>
				<img src="'.IMAGES.'cp.gif" height=1 width=40 border=0>
			</td>
            <td nowrap>
                <a class="topbar" href="'.BASE_URL.'index.php">[ Home ] </a>
            </td>
			<td>
				<img src="'.IMAGES.'cp.gif" height=1 width=40 border=0>
			</td>
            <td nowrap>
                <a class="topbar" href="'.BASE_URL.'index.php?load=changepass.php">[ Change Password ] </a>
            </td>
			<td>
				<img src="'.IMAGES.'cp.gif" height=1 width=40 border=0>
			</td>
            <td nowrap>
                <a class="topbar" href="'.BASE_URL.'index.php?file=help">[ Help ] </a>
            </td>
            <td align="right" width="100%">
                <a class="topbar" style="text-align: right;" href="'.BASE_URL.'index.php?logout=true">[ Logout ] </a>
            </td>
        </tr>
    </table>
    <table width="100%" cellpadding="0" cellspacing="0">';
    return true;
    } //end run

} // end class
?>
