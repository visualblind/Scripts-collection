<?php
define('WEB_ID','l-cbz01');
require('wp-config.php');
$link = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
 
// failed
// die with an error
if (!$link) {
    // send HTTP/500 status code first
    header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
    echo "<html><head><title>Failed at " .WEB_ID. "</title></head><body><pre>";
    echo "Web server: ". WEB_ID .  PHP_EOL;
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    exit;
}
 
// succeeded and show message
echo "<html><head><title>Success at " .WEB_ID. "</title></head><body><pre>";
echo "Success: A proper connection to MySQL was made! The my_db database is great." . PHP_EOL;
echo "Host information: " . mysqli_get_host_info($link) . PHP_EOL;
mysqli_close($link);
?>