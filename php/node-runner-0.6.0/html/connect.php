<?php

$etcdir = "../etc"; // Change accordingly, full path is recommended.

require_once($etcdir.'nr.inc');
switch (strtolower($dbtype)) {
    case ("mysql"):
      require_once($etcdir.'mysql.inc');
      break;
    /* //not implemented yet
    case ("postgresql"):
      require_once($etcdir.'postgresql.inc');
      break;
    */ //not implemented yet
}

db_connect();
session_start();
?>
