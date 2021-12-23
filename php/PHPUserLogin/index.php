<?php
###########################################################
/*
Simple Login Script
Copyright (C) StivaSoft ltd. All rights Reserved.


This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see http://www.gnu.org/licenses/gpl-3.0.html.

For further information visit:
http://www.phpjabbers.com/
info@phpjabbers.com

Version:  2.0
Released: 2020-06-09
*/
###########################################################

session_name('LoginForm');
@session_start();

error_reporting(0);
include("config.php");

?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Login Form</title>
    <meta name="description" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
    <link href="//netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.min.css" rel="stylesheet" id="bootstrap-css">
    <link rel="stylesheet" href="css/main.css">
    <script src="//netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js"></script>

    <script src="//cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.19.2/jquery.validate.min.js"></script>
    <script src="js/main.js"></script>
    <style class="cp-pen-styles">
    </style>
</head>
<body>

<div class="wrapper">
    <div class="container">
        <h1>Welcome</h1>
        <?php
        // check if user is logged
        $error = '';
        if (isset($_POST['is_login'])) {
            $sql = "SELECT * FROM " . $SETTINGS["USERS"] . " WHERE `email` = '" . $mysqli->real_escape_string($_POST['email']) . "' AND `password` = '" . $mysqli->real_escape_string($_POST['password']) . "'";
            if ($result = $mysqli->query($sql)) {

                $user = $result->fetch_assoc();
                $result->free();
                if (!empty($user)) {
                    $_SESSION['user_info'] = $user;
                    $sql = " UPDATE " . $SETTINGS["USERS"] . " SET last_login = NOW() WHERE id=" . $user['id'];
                    if (!$mysqli->query($sql)) {
                        printf("Error: %s\n", $mysqli->sqlstate);
                        exit;
                    }
                } else {
                    $error = 'Wrong email or password.';
                }
            } else {
                printf("Error: %s\n", $mysqli->sqlstate);
                exit;
            }
        }

        // action when logout is pressed
        if (isset($_GET['ac']) && $_GET['ac'] == 'logout') {
            $_SESSION['user_info'] = null;
            unset($_SESSION['user_info']);
        }
        if ($error !==''){
            ?><div class="alert alert-danger">
                <strong>Error</strong> <?php echo $error; ?>
            </div>
            <?php
        }
        ?>
        <?php
        // logged in info
        if (isset($_SESSION['user_info']) && is_array($_SESSION['user_info'])) { ?>

            <form id="login-form" class="login-form" name="form1">

                <div id="form-content">
                    <div class="welcome">
                        <?php echo $_SESSION['user_info']['name'] ?>, you are logged in.
                        <br/><br/>
                        <?php echo $_SESSION['user_info']['content'] ?>
                        <br/><br/>
                        <a href="index.php?ac=logout" style="color:#3ec038">Logout</a>
                    </div>
                </div>

            </form>

        <?php } else {
            //login form
            ?>
            <form id="login-form" class="login-form" name="form1" method="post" action="index.php">
                <input type="hidden" name="is_login" value="1">
                <input id="email" name="email" class="required" type="email" placeholder="Email">
                <input id="password" name="password" class="required" type="password" placeholder="Password">
                <div class="row"><button type="submit" id="login-button">Login</button></div>

            </form>
        <?php } ?>
    </div>

    <ul class="bg-bubbles">
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
        <li></li>
    </ul>
</div>
</body>
</html>