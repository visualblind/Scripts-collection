<?php
include_once("etc/conf.php");
class fuzzy_footer
{
    function fuzzy_footer()
    {
            $this->run();
    } // end constructor
    
    function run()
    {
        echo '
</body>
</html>
';
    return true;
    } //end run
 
} // end class
?>


