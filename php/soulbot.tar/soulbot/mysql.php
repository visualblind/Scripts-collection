<?
// including this file automatically connects you to the database.

function DatabaseConnect() {
        if (!($mylink = mysql_pconnect(MYSQLHOST, MYSQLUSER, MYSQLPASS)))
        {
		print  "Unable to connect to MYSQL_HOST as MYSQL_USER. (bad connect string or host down)<br>";
		echo mysql_error();
                exit;
        }//fi
        @mysql_select_db(MYSQLDATABASE);
        if (mysql_error()>0){
                echo "Unable to connect to MYSQL_DB on MYSQL_HOST as MYSQL_USER. (most likely bad user/pass or database name)<br>";
                echo mysql_error();
        }//
}// end function

DatabaseConnect();
?>
