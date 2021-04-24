<?php

// PHP BasicAuthenticator Class Version 1.3 (24th March 2001)
//  
// Copyright David Wilkinson 2001. All Rights reserved.
// 
// This software may be used, modified and distributed freely
// providing this copyright notice remains intact at the head 
// of the file.
//
// This software is freeware. The author accepts no liability for
// any loss or damages whatsoever incurred directly or indirectly 
// from the use of this script. The author of this software makes 
// no claims as to its fitness for any purpose whatsoever. If you 
// wish to use this software you should first satisfy yourself that 
// it meets your requirements.
//
// URL:   http://www.cascade.org.uk/software/php/auth/
// Email: davidw@cascade.org.uk

// Modified 7/6/2001 RE
// Added so that authentication module returns groups that user belongs
// to once authenticated

// workaround for funky behaviour of nested includes with older
// versions of php
require_once(dirname(__FILE__)."/config.php");

class BasicAuthenticator
{
    var $realm = "<private>";
    var $message;
    var $authenticated = -1;
    var $users;

    // not normally required, only for SQL authentication
    var $grps = FALSE;
    
    function BasicAuthenticator($realm, $message = "Access Denied")
    {
        $this->realm = $realm;
        $this->message = $message;
    }
         
    
    function authenticate()
    {

        if ((isset($_COOKIE["ipplanNoAuth"]) and $_COOKIE["ipplanNoAuth"]=="yes") or 
            $this->isAuthenticated() == 0)
        {

            // delete logout cookie
            setcookie("ipplanNoAuth", "", time() - 3600, "/");
            Header("WWW-Authenticate: Basic realm=\"$this->realm\"");
            // adapt to broken servers - anything bigger than 1.0 uses 
            // new method
            if ($_SERVER["SERVER_PROTOCOL"]=="HTTP/1.0") {
               Header("HTTP/1.0 401 Unauthorized");    // http 1.0 method
            }
            else {
               Header("Status: 401 Unauthorized");     // http 1.1 method
            }
            echo $this->message;
            exit();
        }
        else
        {
            Header("HTTP/1.0 200 OK");
            return $this->grps;
        }
    }
    
    
    function addUser($user, $passwd)
    {
        $this->users["$user"] = $passwd;
    }
    
    
    function isAuthenticated()
    {
        // dummy server vars into new va called MY_SERVER_VARS
        // needed as vars might get updated if running on ISS
        $MY_SERVER_VARS = $_SERVER;

    	if ($this->authenticated < 0)
    	{
		// Check for encoded not plain text response
		// to fix php on Windows with ISAPI module
		// Contributed by Brian Epley
		if ( (!(isset($MY_SERVER_VARS["PHP_AUTH_USER"]))) &&
		      (!(isset($MY_SERVER_VARS["PHP_AUTH_PW"]))) &&
		      (isset($MY_SERVER_VARS['HTTP_AUTHORIZATION'])) )
		{
			list($MY_SERVER_VARS["PHP_AUTH_USER"],
				$MY_SERVER_VARS["PHP_AUTH_PW"]) =
				explode(':',
				base64_decode(substr($MY_SERVER_VARS['HTTP_AUTHORIZATION'], 6)));
		}

                // always use PHP_AUTH_USER for basic authentication
        	if(isset($MY_SERVER_VARS["PHP_AUTH_USER"])) 
        	{
            	$this->authenticated = $this->validate($MY_SERVER_VARS["PHP_AUTH_USER"], $MY_SERVER_VARS["PHP_AUTH_PW"]);
        	}
        	else
        	{
            	$this->authenticated = 0;
            }
        }
        
        return $this->authenticated;
    }
    
    
    function validate($user, $passwd)
    {
        if (strlen(trim($user)) > 0 && strlen(trim($passwd)) > 0)
        {
            // Both $user and $password are non-zero length
            if (isset($this->users["$user"]) && $this->users["$user"] == $passwd)
            {
                return 1;
            }
        }
        return 0;
    }
}

class SQLAuthenticator extends BasicAuthenticator
{

    // use different method here if using external authetication to take
    // into account that AUTH_VAR may be different
    function isAuthenticated()
    {
        // dummy server vars into new va called MY_SERVER_VARS
        // needed as vars might get updated if running on ISS
        $MY_SERVER_VARS = $_SERVER;
        // if you have auth issues, uncomment below var_dump line and look at screen output AFTER
        // you have authenticated. look for variables like REMOTE_USER, PHP_AUTH_USER or
        // some variable that contains the user-id that authenticated. This is the setting
        // that needs to be added in the config.php file for AUTH_VAR
        //var_dump($_SERVER);

        if ($this->authenticated < 0)
        {
                // Check for encoded not plain text response
                // to fix php on Windows with ISAPI module
                // Contributed by Brian Epley
                if ( (!(isset($MY_SERVER_VARS["PHP_AUTH_USER"]))) &&
                      (!(isset($MY_SERVER_VARS["PHP_AUTH_PW"]))) &&
                      (isset($MY_SERVER_VARS['HTTP_AUTHORIZATION'])) )
                {
                        list($MY_SERVER_VARS["PHP_AUTH_USER"],
                                $MY_SERVER_VARS["PHP_AUTH_PW"]) =
                                explode(':',
                                base64_decode(substr($MY_SERVER_VARS['HTTP_AUTHORIZATION'], 6)));
                }

                if(isset($MY_SERVER_VARS[AUTH_VAR]))
                {
                // PHP_AUTH_PW could be undefined if AUTH_INTERNAL = FALSE
                // this is OK as it is taken care of in the validate()
                // method
                $this->authenticated = $this->validate($MY_SERVER_VARS[AUTH_VAR], $MY_SERVER_VARS["PHP_AUTH_PW"]);
                }
                else
                {
                $this->authenticated = 0;
            }
        }

        return $this->authenticated;
    }


    function validate($user, $passwd)
    {


       $ds = &ADONewConnection(DBF_TYPE);    # create a connection
       if (DBF_PERSISTENT) {
          $ds->PConnect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME) or
              die("Could not connect to database");
       }
       else {
          $ds->Connect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME) or
              die("Could not connect to database");
       }

       $ds->SetFetchMode(ADODB_FETCH_ASSOC);

       // only check password for internal authentication
       if (AUTH_INTERNAL) {
          $passwd=crypt($passwd, 'xq');
          $result=$ds->Execute("SELECT usergrp.grp AS grp
                                FROM users, usergrp
                                WHERE users.userid=".$ds->qstr($user)." AND
                                   users.password=".$ds->qstr($passwd)." AND
                                   users.userid=usergrp.userid");
       }
       else {
          $result=$ds->Execute("SELECT usergrp.grp AS grp
                                FROM users, usergrp
                                WHERE users.userid=".$ds->qstr($user)." AND
                                   users.userid=usergrp.userid");
       }

       // found a user, updates grps
       // result should always be lowercase from database
       $i=0;
       if ($result) { 
          while ($row = $result->FetchRow()) {
             $grp[$i++]=$row["grp"];
          }
          if (empty($grp)) {
             $ret=0;
          }
          else {
             $this->grps=$grp;
             $ret=1;
          }

          $result->Close(); 
          $ds->Close();
       }
       // error
       else {
          $ret=0;
       }

       return $ret;
   }
}

?>
