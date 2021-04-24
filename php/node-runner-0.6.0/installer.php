<?
## This script serves as an installer for Node Runner 0.6.0.
## To run this script, use it as a parameter to your PHP interpreter
## from the command line. (e.g. /usr/bin/php -q installer).

// Turn off PHP's Safe Mode and adjust max_execution_time (Windows Hack)
$safe_mode_off = ini_set("safe_mode", "0");
$max_time = ini_set("max_execution_time", "9999");

// Turn off error reporting (it's built-in to this script).
error_reporting(E_ALL ^ E_NOTICE ^ E_WARNING);


// COMMON FUNCTIONS

function dir_contents($dir) {
  // Returns array of file names from $dir
  $i=0;
  if ($use_dir = @opendir($dir)) {
    while (($file = readdir($use_dir)) != false) {
      if (($file != ".") && ($file != "..")) {
        $files_array[$i] = "$file";
        $i++;
      }
    }
    closedir($use_dir);
  }
  return $files_array;
}

function copyr($source, $dest) {
  // Copies contents of directory recursively
  // Simple copy for a file
  if (is_file($source)) {      
      return copy($source, $dest);      
  }

  // Make destination directory  
  if (!is_dir($dest)) {
      $success = mkdir($dest, 0755);      
      if (!$success) { return false; }
  }
 
  // Loop through the folder
  $use_dir = @opendir($source);
  while (($entry = readdir($use_dir)) != false) {
      // Skip pointers
      if ($entry == '.' || $entry == '..') {
          continue;
      }

      if ((ereg("/", $dest)) &&  (substr($dest, -1) != '/')) {
        $dest .= '/';
	$source .= '/';
      } else if ((ereg("\\\\", $dest)) &&  (substr($dest, -1) != "\\")) {
        $dest .= "\\";
	$source .= "\\";
      }

      // Deep copy directories
      if ($dest !== $source.$entry) {
          copyr($source.$entry, $dest.$entry);
      }
  }
 
  // Clean up
  closedir($use_dir);
  return true;
}

// End COMMON FUNCTIONS


// Set $glbl_hash
$glbl_hash = md5(mktime());



echo "\n\n\n#################################################\n";
echo " Welcome to the Node Runner installation script.\n";
echo "#################################################\n\n";


// STEP 1: Determine NEW INSTALL or UPGRADE.

do {

  $stdin = fopen('php://stdin', 'r');
  echo "Is this a NEW INSTALL or an UPGRADE (N/U)? ";
  $install_type = fgets($stdin,4);
  $install_type = ltrim(rtrim(strtoupper($install_type)));
  fclose($stdin);

  if ($install_type == 'N') {
    $install_type = 'NEW INSTALL';
  } else if ($install_type == 'U') {
    $install_type = 'UPGRADE';
  } else {
    unset($install_type);
  }

} while (!$install_type);

// End STEP 1










// STEP 2: Prompt for location of HTML
echo "\n\nWhere would you like to store your HTML files for Node Runner?\n";
echo "(ex. /var/www/node-runner/)  Enter location or type NONE to skip.\n\n";

do {
  unset($perm_errors);

  do {
    $stdin = fopen('php://stdin', 'r');
    echo "Location: ";
    $dest_loc_html = fgets($stdin,250);
    $dest_loc_html = ltrim(rtrim($dest_loc_html));
    if ((ereg("/", $dest_loc_html)) && (substr($dest_loc_html, -1) != '/')) {
      $dest_loc_html .= '/';
    } else if ((ereg("\\\\", $dest_loc_html)) &&  (substr($dest_loc_html, -1) != "\\")) {
      $dest_loc_html .= "\\";
    }
    fclose($stdin);
    
    if (($dest_loc_html == ".") || ($dest_loc_html == "..") || (ereg("\./", $dest_loc_html)) || (ereg("\.\\\\", $dest_loc_html))) {
      echo "\nERROR: Please use absolute path for location, not relative.\n\n";
      unset($dest_loc_html);      
    }

    if (strtoupper($dest_loc_html) == 'NONE') {
      $dest_loc_html = 'NONE';
    }

  } while (!$dest_loc_html);

  
  echo "\n\n";

  if ($dest_loc_html != 'NONE') {
    // Check to see if destination exists.
    if (is_dir($dest_loc_html)) {
      // Destination directory exists, so check it for files.
      $existing_files = dir_contents($dest_loc_html);
      if (!empty($existing_files)) {
        // Destination directory already contains files, so prompt for permission to remove them.

        do {
          $stdin = fopen('php://stdin', 'r');
          echo "This directory already exists, overwrite it? [Y/N] ";
          $remove_them = fgets($stdin,4);
          $remove_them = ltrim(rtrim(strtoupper($remove_them)));
          fclose($stdin);
          if ($remove_them == 'Y') {
            // Attempt to remove all files from this directory.
            echo "Destination files will be overwritten.\n\n";
            $failure = 0;
            foreach($existing_files as $file) {
              $success = unlink($dest_loc_html.$file);
              if (!$success) { $failure++; }
            }
            if ($failure) {
              echo "ERROR: Could not remove old files.  Check permissions.\n";
              echo "This may cause problems copying the new HTML files over.\n\n";
            }
          } else if ($remove_them == 'N') {
            // Do NOT attempt to remove files from this directory.
            echo "Destination files will not be overwritten.\n\n";
          } else {
            unset($remove_them);
          }
        } while (!$remove_them);
    
      } else {
        // Destination directory exists, but contains no files.
        // We shouldn't need to do anything here - this is just a placeholder.
      }
    

    } else {
      // Destination directory does not exist, so attempt to create it.
      $create_dir = mkdir($dest_loc_html, 0755);
      if (!$create_dir) {
        echo "ERROR: Unable to create destination directory.  Make sure you have permission\nto create the $dest_loc_html directory.  Please try again.\n\n";
        $perm_errors = 1;
	continue;
      }

    }
  }

  unset($existing_files);

} while ($perm_errors);
// End STEP 2







// STEP 3: Copy HTML files from tarball source locations to destination directory chosen above.

if ($dest_loc_html != 'NONE') {

  $html_dir = chdir('html');
  if (!$html_dir) {
    echo "Cannot change to 'html' directory.  Where did it go?\n\n";
    echo "Setup cannot continue.  Exiting.\n\n";
    exit();
  }

  $cwd = getcwd();
  if (ereg("/", $cwd)) {
    $cwd .= '/';  
  } else if (ereg("\\\\", $cwd)) {
    $cwd .= "\\";
  }
  $html_files = dir_contents($cwd);
  $failure = 0;
  foreach ($html_files as $file) {
    $html_filecopy = copyr($cwd.$file, $dest_loc_html.$file);
    if (!$html_filecopy) { $failure++; }
  }

  if ($failure) {
    echo "One or more files were not copied correctly.  You may need to\nmanually re-copy the contents of the 'html' directory\nto the $dest_loc_html directory.\n\n";
  }

}

// End STEP 3











// STEP 4: Prompt for destination location for rest of tarball source files

echo "\nWhere would you like to store the rest of the files (non-HTML) for Node Runner?\n";
echo "(Default: /usr/local/node-runner/)  Enter location or leave blank for default.\n\n";

do {
  unset($perm_errors);

  do {
    $stdin = fopen('php://stdin', 'r');
    echo "Location [/usr/local/node-runner/]: ";
    $dest_loc_rest = fgets($stdin,250);
    $dest_loc_rest = ltrim(rtrim($dest_loc_rest));

    if (!$dest_loc_rest) {
      $dest_loc_rest = '/usr/local/node-runner/';
    }

    if (ereg("/", $dest_loc_rest)) {
      if  (substr($dest_loc_rest, -1) != '/') {
        $dest_loc_rest .= '/';
      }
      $path_to_include = $dest_loc_rest.'include/';
      $nr_inc_file = $dest_loc_rest.'etc/nr.inc';
      $etc_directory = $dest_loc_rest.'etc/';
      $sql_directory = $dest_loc_rest.'sql/';
      $node_start_file = $dest_loc_rest.'node.start';
      if ($dest_loc_html) { $connect_php_file = $dest_loc_html.'connect.php'; }
    } else if (ereg("\\\\", $dest_loc_rest)) {
      if  (substr($dest_loc_rest, -1) != "\\") {
        $dest_loc_rest .= "\\";
      }
      $path_to_include = $dest_loc_rest."include\\";
      $path_to_include = str_replace("\\", "\\\\", $path_to_include);
      $nr_inc_file = $dest_loc_rest."etc\\nr.inc";
      $etc_directory = $dest_loc_rest.'etc\\';
      $etc_directory = str_replace("\\", "\\\\", $etc_directory);
      $sql_directory = $dest_loc_rest.'sql\\';
      $node_start_file = $dest_loc_rest.'node.start';
      if ($dest_loc_html) { $connect_php_file = $dest_loc_html.'connect.php'; }
    }
    fclose($stdin);
  
    if (($dest_loc_rest == ".") || ($dest_loc_rest == "..") || (ereg("\./", $dest_loc_rest)) || (ereg("\.\\\\", $dest_loc_rest))) {
      echo "\nERROR: Please use absolute path for location, not relative.\n\n";
      unset($dest_loc_rest);
    }
  } while (!$dest_loc_rest);

  echo "\n\n";

  // Check to see if destination exists.
  if (is_dir($dest_loc_rest)) {
      // Destination directory exists, so check it for files.
      $existing_files = dir_contents($dest_loc_rest);
      if (!empty($existing_files)) {
        // Destination directory already contains files, so prompt for permission to remove them.

        do {
          $stdin = fopen('php://stdin', 'r');
          echo "This directory already exists, overwrite it? [Y/N] ";
          $remove_them = fgets($stdin,4);
          $remove_them = ltrim(rtrim(strtoupper($remove_them)));
          fclose($stdin);
          if ($remove_them == 'Y') {
            // Attempt to remove all files from this directory.
            echo "Destination files will be overwritten.\n\n";
            $failure = 0;
            foreach($existing_files as $file) {
              $success = unlink($dest_loc_rest.$file);
              if (!$success) { $failure++; }
            }
            if ($failure) {
              echo "ERROR: Could not remove old files.  Check permissions.\n";
              echo "This may cause problems copying the new HTML files over.\n\n";
            }
          } else if ($remove_them == 'N') {
            // Do NOT attempt to remove files from this directory.
            echo "Destination files will not be overwritten.\n\n";
          } else {
            unset($remove_them);
          }
        } while (!$remove_them);
    
      } else {
        // Destination directory exists, but contains no files.
        // We shouldn't need to do anything here - this is just a placeholder.
      }
    

  } else {
     // Destination directory does not exist, so attempt to create it.
     $create_dir = mkdir($dest_loc_rest, 0755);
     if (!$create_dir) {
       echo "Unable to create destination directory.  Make sure you have permission\nto create the $dest_loc_rest directory.  Please try again.\n\n";
       $perm_errors = 1;     
     }

  }

} while ($perm_errors);

// End STEP 4













// STEP 5: Copy all other files from tarball source locations to destination directory chosen above.

if ($dest_loc_html != 'NONE') {
  $back_one_dir = chdir('..');
  if (!$back_one_dir) {
    echo "Cannot find the rest of the source files.  Where did they go?\n\n";
    echo "Setup cannot continue.  Exiting.\n\n";
    exit();
  }
}

$cwd = getcwd();
  if (ereg("/", $cwd)) {
    $cwd .= '/';  
  } else if (ereg("\\\\", $cwd)) {
    $cwd .= "\\";
  }
$rest_of_files = dir_contents($cwd);
$failure = 0;
foreach ($rest_of_files as $file) {
  if ($file == 'html') { continue; }
  $rest_of_filecopy = copyr($cwd.$file, $dest_loc_rest.$file);
  if (!$rest_of_filecopy) { $failure++; }
}

// Remove the installer.php file from $dest_loc_rest
$rm_installer = unlink($dest_loc_rest."installer.php");

if ($failure) {
  echo "One or more files were not copied correctly.  You may need to\nmanually re-copy the contents of the $cwd directory\nto the $dest_loc_rest directory.\n\n";
}

// End STEP 5










// STEP 6: Prompt for all variables in nr.inc file.

$stdin = fopen('php://stdin', 'r');
echo "\n\nIt is now time to define the general settings for Node Runner.\nAnswer the following questions or leave blank for default settings.\nFor Yes/No questions, the default value will be presented in uppercase.\n\nPress Enter to continue...";
$anykey = fgets($stdin,4);

do {
  unset($perm_errors);
  if (!is_writable($nr_inc_file)) {
    echo "ERROR: Could not open nr.inc for writing.\n\n";
    $stdin = fopen('php://stdin', 'r');
    echo "Do you wish to skip this part? [y/N] ";
    $skip_config = fgets($stdin,4);
    $skip_config = ltrim(rtrim(strtolower($skip_config)));
    fclose($stdin);
  
    if (strtoupper($skip_config) == 'Y') {
      echo "\n\nYou have opted to skip configuration of general settings.  Before using\n";
      echo "Node Runner, you must now manually configure the options in the nr.inc file.\n\n";
    } else {
      $stdin = fopen('php://stdin', 'r');
      echo "\n\nPlease correct the permissions on the nr.inc file and press Enter to continue...";    
      $anykey = fgets($stdin,4);
      $perm_errors = 1;    
    }
  }
} while ($perm_errors);

if (strtoupper($skip_config) != 'Y') {

echo "\n\n";



echo "Since you are running Node Runner on this machine, it will serve as\n";
echo "the highest level node in your network monitoring heirarchy.  For example,\n";
echo "if Node Runner could not contact the machine on which it is running, it\n";
echo "wouldn't try to contact other machines, because it would assume that it\n";
echo "lost it's network connection or the NIC was bad.  That said, you need to\n";
echo "pick a TCP port which is open on this machine (localhost) that will be\n";
echo "available to query at any time.  The default is 80, assuming that you will\n";
echo "be serving the Node Runner web interface from this machine as well.\n\n";
do {

  unset($connection_valid);
  $stdin = fopen('php://stdin', 'r');
  echo "TCP Port: [80] ";
  $test_port = fgets($stdin,4);
  $test_port = intval(ltrim(rtrim(strtolower($test_port))));
  fclose($stdin);
  
  if (!$test_port) {
    $test_port = 80;
  }
  
  $socket = fsockopen("127.0.0.1", $test_port, $errno, $errstr, 5);
  if (!$socket) {
	echo "\n\nERROR: TCP port $test_port did not respond.  Please choose another port.\n\n";
  } else {
    $connection_valid = 1;
  	fclose($socket);
  }
  
} while (!$connection_valid);


echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Database Host [localhost]: ";
$dbhost = fgets($stdin,250);
$dbhost = ltrim(rtrim(strtolower($dbhost)));
fclose($stdin);

if (!$dbhost) {
  $dbhost = 'localhost';
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Database Name [node_runner]: ";
$db = fgets($stdin,250);
$db = ltrim(rtrim(strtolower($db)));
fclose($stdin);

if (!$db) {
  $db = 'node_runner';
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Database Username [nruser]: ";
$dbuser = fgets($stdin,250);
$dbuser = ltrim(rtrim(strtolower($dbuser)));
fclose($stdin);

if (!$dbuser) {
  $dbuser = 'nruser';
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Database Password [changeme]: ";
$dbpass = fgets($stdin,250);
$dbpass = ltrim(rtrim(strtolower($dbpass)));
fclose($stdin);

if (!$dbpass) {
  $dbpass = 'changeme';
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Sender address for email alerts [nr@$dbhost]: ";
$sender = fgets($stdin,250);
$sender = ltrim(rtrim(strtolower($sender)));
fclose($stdin);

if (!$sender) {
  $sender = "nr@$dbhost";
}

$sender = '"Node Runner" <'.$sender.'>';

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Send detailed status info with alerts? (y/N) ";
$detailed_email = fgets($stdin,4);
$detailed_email = ltrim(rtrim(strtolower($detailed_email)));
fclose($stdin);

if (strtoupper($detailed_email) == 'Y') {
  $detailed_email = "1";
} else {
  $detailed_email = "0";
}
  
echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Minutes to wait between each \"DOWN\" alert: [15] ";
$delay = fgets($stdin,6);
$delay = intval(ltrim(rtrim(strtolower($delay))));
fclose($stdin);

if (!$delay) {
  $delay = "15";
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Max number of \"DOWN\" alerts to send: [0 = unlimited] ";
$max_alerts = fgets($stdin,6);
$max_alerts = intval(ltrim(rtrim(strtolower($max_alerts))));
fclose($stdin);

if (!$max_alerts) {
  $max_alerts = "0";
}

echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Max query attempts before a node is declared as \"DOWN\": [2] ";
$max_attempts = fgets($stdin,4);
$max_attempts = intval(ltrim(rtrim(strtolower($max_attempts))));
fclose($stdin);

if (!$max_attempts) {
  $max_attempts = "2";
}

echo "\n\n";

do {
  unset($whoops);
  $stdin = fopen('php://stdin', 'r');
  echo "\nNode Runner's polling script (node.start) is intended to run as a\n";
  echo "cron job (scheduled task).  The script will run every few minutes, polling\n";
  echo "your network nodes with each iteration.  Please specify how many minutes\n";
  echo "apart this script should be scheduled.\n\n";
  echo "NOTE: Be sure to allow enough time between iterations.  For small networks,\n";
  echo "2 minutes is probably sufficient, where larger networks might require 3.\n\n";
  echo "Minutes between iterations: [2] ";
  $qtime = fgets($stdin,4);
  $qtime = intval(ltrim(rtrim(strtolower($qtime))));
  fclose($stdin);

  if (!$qtime) {
    $qtime = "2";
  }

  if (($qtime != 1) && ($qtime != 2) && ($qtime != 3) && ($qtime != 4) && ($qtime != 5)&& ($qtime != 6)
   && ($qtime != 10) && ($qtime != 12) && ($qtime != 15) && ($qtime != 20) && ($qtime != 30)) {
    echo "\n\nERROR: You have chosen to run the node.start script at an interval\n";
    echo "of $qtime minutes, which is not evenly divisible by 60 (minutes).  That\n";
    echo "means when you run your cron job, at some point during each hour, you\n";
    echo "will have a gap in polling which is greater than $qtime minutes.  If this\n";
    echo "doesn't make any sense to you, do some research on cron jobs and try to\n";
    echo "figure out how you would run a script every $qtime minutes.\n\n";
    $stdin = fopen('php://stdin', 'r');
	echo "Press Enter and try again...";
	$anykey = fgets($stdin,4);
	fclose($stdin);
    $whoops = 1;
    echo "\n\n";
  }
} while ($whoops);



echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "You may encounter 'Connection Refused' errors when polling certain types\n";
echo "of devices.  This is especially true when polling the telnet service on\n";
echo "certain routers, or the HTTP service on web servers that have crashed\n";
echo "(e.g. IIS 4+).  In the first case, the service should be regarded as\n";
echo "\"UP\", but in the second case, it would be \"DOWN\".  With these\n";
echo "considerations in mind, you may choose to ignore 'Connection Refused'\n";
echo "errors, in which case Node Runner will regard the node as \"UP\".\n";
echo "You can always change this setting at a later time.\n\n";
echo "Ignore 'Connection Refused' errors: [y/N] ";
$allow_refused = fgets($stdin,4);
$allow_refused = ltrim(rtrim(strtolower($allow_refused)));
fclose($stdin);

if (strtoupper($allow_refused) == 'Y') {
  $allow_refused = "1";
} else {
  $allow_refused = "0";
}
  
echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Enable debugging? [y/N] ";
$debug = fgets($stdin,4);
$debug = ltrim(rtrim(strtolower($debug)));
fclose($stdin);

if (strtoupper($debug) == 'Y') {
  $debug = "1";
} else {
  $debug = "0";
}
  
echo "\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Node Runner can be configured to wait a specified amount of time\n";
echo "before it sends its initial \"DOWN\" email notification.  You might\n";
echo "choose this option if you have slow or high-latency network lines\n";
echo "which can generate intermittent \"DOWN\" reports.\n\n";
echo "Minutes to wait before sending first notification: [0] ";
$firstmail = fgets($stdin,4);
$firstmail = intval(ltrim(rtrim(strtolower($firstmail))));
fclose($stdin);

if (!$firstmail) {
  $firstmail = "0";
}

echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Only allow admins to start the Network Dashboard marquee? [y/N] ";
$secure_monitor = fgets($stdin,4);
$secure_monitor = ltrim(rtrim(strtolower($secure_monitor)));
fclose($stdin);

if (strtoupper($secure_monitor) == 'Y') {
  $secure_monitor = "1";
} else {
  $secure_monitor = "0";
}
  
echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Display list of recent network failures on Network Dashboard? [Y/n] ";
$show_recent = fgets($stdin,4);
$show_recent = ltrim(rtrim(strtolower($show_recent)));
fclose($stdin);

if (strtoupper($show_recent) == 'N') {
  $show_recent = "0";
} else {
  $show_recent = "1";
}
  
echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Display 'Node Statistics Snapshot' on Network Dashboard? [Y/n] ";
$status_stats = fgets($stdin,4);
$status_stats = ltrim(rtrim(strtolower($status_stats)));
fclose($stdin);

if (strtoupper($status_stats) == 'N') {
  $status_stats = "0";
} else {
  $status_stats = "1";
}
  
echo "\n\n";


$stdin = fopen('php://stdin', 'r');
echo "The Network Dashboard displays a list of any nodes that are currently\n";
echo "down.  Below each node is a link to manually poll the node in cases\n";
echo "where you don't wish to wait for the next iteration of the polling\n";
echo "script.  If you are worried about click-happy users abusing the option\n";
echo "you may wish to disable the functionality.  (Default = disabled)\n\n";
echo "Allow 'Click to Poll Manually' option on Network Dashboard? [y/N] ";
$monitor_polling = fgets($stdin,4);
$monitor_polling = ltrim(rtrim(strtolower($monitor_polling)));
fclose($stdin);

if (strtoupper($monitor_polling) == 'Y') {
  $monitor_polling = "1";
} else {
  $monitor_polling = "0";
}
  
echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Really long node names can be truncated on the Network Dashboard to\n";
echo "prevent line wrapping and other unattractive side effects.  This\n";
echo "setting only affects the Network Dashboard display, names will not\n";
echo "be truncated in the database itself.\n\n";
echo "Maximum length of node names (in chars): [22] ";
$truncate_at = fgets($stdin,6);
$truncate_at = intval(ltrim(rtrim(strtolower($truncate_at))));
fclose($stdin);

if (!$truncate_at) {
  $truncate_at = "22";
}
  
echo "\n\n\n";


$stdin = fopen('php://stdin', 'r');
echo "Refresh rate (in seconds) for Network Dashboard: [30] ";
$dash_refrate = fgets($stdin,4);
$dash_refrate = intval(ltrim(rtrim(strtolower($dash_refrate))));
fclose($stdin);

if (!$dash_refrate) {
  $dash_refrate = "30";
}
  
echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Allow RSS feed for NR project news on main page of web interface? [Y/n] ";
$allow_rss = fgets($stdin,4);
$allow_rss = ltrim(rtrim(strtolower($allow_rss)));
fclose($stdin);

if (strtoupper($allow_rss) == 'N') {
  $allow_rss = "0";
} else {
  $allow_rss = "1";
}
  
echo "\n";


$stdin = fopen('php://stdin', 'r');
echo "Web Interface URL: [http://localhost/node-runner/] ";
$nr_url = fgets($stdin,250);
$nr_url = ltrim(rtrim(strtolower($nr_url)));
fclose($stdin);

if (($nr_url) && (substr($nr_url, -1) != '/')) {
  $nr_url .= '/';
} else if (!$nr_url) {
  $nr_url = 'http://localhost/node-runner/';
}

echo "\n";

} // end if (strtoupper($skip_config) != 'Y')

// End STEP 6








// STEP 7: Write collected setup info to nr.inc file.

if (strtoupper($skip_config) != 'Y') {

  $handle = fopen($nr_inc_file, "r");
  $contents = fread($handle, filesize($nr_inc_file));  
  fclose($handle);    

  $contents = str_replace("dbhost = \"localhost\"","dbhost = \"$dbhost\"",$contents);  
  $contents = str_replace("db = \"\"","db = \"$db\"",$contents);
  $contents = str_replace("dbuser = \"\"","dbuser = \"$dbuser\"",$contents);
  $contents = str_replace("dbpass = \"\"","dbpass = \"$dbpass\"",$contents);
  $contents = str_replace("sender = \"\"","sender = \"".addslashes($sender)."\"",$contents);
  $contents = str_replace("detailed_email = 0","detailed_email = $detailed_email",$contents);
  $contents = str_replace("delay = 15","delay = $delay",$contents);
  $contents = str_replace("max_alerts = 0","max_alerts = $max_alerts",$contents);
  $contents = str_replace("max_attempts = 2","max_attempts = $max_attempts",$contents);
  $contents = str_replace("qtime = 2","qtime = $qtime",$contents);
  $contents = str_replace("allow_refused = 0","allow_refused = $allow_refused",$contents);
  $contents = str_replace("debug = 0","debug = $debug",$contents);
  $contents = str_replace("firstmail = 0","firstmail = $firstmail",$contents);
  $contents = str_replace("secure_monitor = 0","secure_monitor = $secure_monitor",$contents);
  $contents = str_replace("show_recent = 1","show_recent = $show_recent",$contents);
  $contents = str_replace("monitor_polling = 0","monitor_polling = $monitor_polling",$contents);
  $contents = str_replace("truncate_at = 22","truncate_at = $truncate_at",$contents);
  $contents = str_replace("status_stats = 1","status_stats = $status_stats",$contents);
  $contents = str_replace("dash_refrate = 30","dash_refrate = $dash_refrate",$contents);
  $contents = str_replace("allow_rss = 1","allow_rss = $allow_rss",$contents);
  $contents = str_replace("glbl_hash = \"Rx1Uo12n6N\"","glbl_hash = \"$glbl_hash\"",$contents);
  $contents = str_replace("path_to_include = \"/path/to/include/\"","path_to_include = \"$path_to_include\"",$contents);
  $contents = str_replace("nr_url = \"http://localhost/node-runner/\"","nr_url = \"$nr_url\"",$contents);  
  
  $handle = fopen($nr_inc_file, "w");
  $output = fwrite($handle, $contents);
  fclose($handle); 

} // end if (strtoupper($skip_config) != 'Y')

// End STEP 7








// STEP 8: Verify existence of 'etc' directory and modify 'node.start' and 'connect.php' accordingly.

unset($skip_config);

$stdin = fopen('php://stdin', 'r');
echo "\n\nSetup will now attempt to set the location of the 'etc' directory\n";
echo "in your 'node.start' and 'connect.php' files.\n\nPress Enter to continue...";
$anykey = fgets($stdin,4);

if (!is_dir($etc_directory)) {
  // Note that the $etc_directory variable must be set at this point, or it would not have written the nr.inc file.
  echo "ERROR: For some reason, your 'etc' directory is missing.\n\n";
  echo "You will need to set a variable manually in your 'node.start'\n";
  echo "and the 'connect.php' files to make them work.  You might also\n";
  echo "make sure the general variables you defined were successfully\n";
  echo "written to the 'nr.inc' file.\n\n";
} else {
    
  do { // make sure the 'node.start' file exists and is writable
    unset($perm_errors);
    if (!is_writable($node_start_file)) {
      echo "ERROR: Could not open node.start for writing.\n\n";
      $stdin = fopen('php://stdin', 'r');
      echo "Do you wish to skip this part? [y/N] ";
      $skip_config = fgets($stdin,4);
      $skip_config = ltrim(rtrim(strtolower($skip_config)));
      fclose($stdin);
  
      if (strtoupper($skip_config) == 'Y') {
        echo "\n\nYou have opted to skip this step.  Before you attempt to execute the\n";
        echo "node.start script, you must now manually configure the '\$path_to_etc'\n";
	echo "variable within the file.\n\n";
      } else {
        $stdin = fopen('php://stdin', 'r');
        echo "\n\nPlease correct the permissions on the node.start file and press Enter to continue...";    
        $anykey = fgets($stdin,4);
        $perm_errors = 1;    
      }
    }
  } while ($perm_errors);
  
  do { // make sure the 'connect.php' file exists and is writable
    unset($perm_errors);
    if (!is_writable($connect_php_file)) {
      echo "ERROR: Could not open connect.php for writing.\n\n";
      $stdin = fopen('php://stdin', 'r');
      echo "Do you wish to skip this part? [y/N] ";
      $skip_config = fgets($stdin,4);
      $skip_config = ltrim(rtrim(strtolower($skip_config)));
      fclose($stdin);
  
      if (strtoupper($skip_config) == 'Y') {
        echo "\n\nYou have opted to skip this step.  Before you attempt to use the\n";
        echo "Node Runner web interface, you must now manually configure the\n";
        echo "'\$etcdir' variable within the 'connect.php' file.\n\n";
      } else {
        $stdin = fopen('php://stdin', 'r');
        echo "\n\nPlease correct the permissions on the node.start file and press Enter to continue...";    
        $anykey = fgets($stdin,4);
        $perm_errors = 1;    
      }
    }
  } while ($perm_errors);
  
  // At this point, we have verified that the node.start and connect.php files exist and are writable,
  // so we can now modify them.
  
  // First the node.start file
  unset($contents);
  $handle = fopen($node_start_file, "r");
  $contents = fread($handle, filesize($node_start_file));  
  fclose($handle);    

  $contents = str_replace("path_to_etc = \"etc/\"","path_to_etc = \"$etc_directory\"",$contents);  
  
  $handle = fopen($node_start_file, "w");
  $output = fwrite($handle, $contents);
  fclose($handle); 
  
  // Then the connect.php file
  unset($contents);
  $handle = fopen($connect_php_file, "r");
  $contents = fread($handle, filesize($connect_php_file));  
  fclose($handle);    

  $contents = str_replace("etcdir = \"../etc\"","etcdir = \"$etc_directory\"",$contents);  
  
  $handle = fopen($connect_php_file, "w");
  $output = fwrite($handle, $contents);
  fclose($handle); 
  
}

// End STEP 8











// STEP 9: Set up database tables

echo "\n\nTime to install or upgrade your database...";
do {
  $connect = mysql_connect($dbhost,$dbuser,$dbpass);
  if (!$connect) {
    $stdin = fopen('php://stdin', 'r');
    echo "\n\nERROR: Could not connect: ".mysql_error()."\n";
  	echo "Please grant the user \"$dbuser\" access to the database and\n";
  	echo "press Enter to continue...";
  	$anykey = fgets($stdin,4);
	fclose($stdin);
  }
} while (!$connect);

// Make sure all sql files are available
$sql_file_array = array($sql_directory.'nr-mysql-setup.php',
                        $sql_directory.'update-nr-to-v0.2.php',
						$sql_directory.'update-nr-to-v0.3.php',
						$sql_directory.'update-nr-to-v0.4.php',
						$sql_directory.'update-nr-to-v0.4.2.php',
						$sql_directory.'update-nr-to-v0.5.0.php',
						$sql_directory.'update-nr-to-v0.5.1.php',
						$sql_directory.'update-nr-to-v0.6.0.php');

for ($x=0; $x<sizeof($sql_file_array); $x++) {
  do {
    unset($file_missing);
    if (!is_file($sql_file_array[$x])) {
      $stdin = fopen('php://stdin', 'r');
      echo "\n\nERROR: Cannot find $sql_file_array[$x] file.\n";
      echo "This file is required by the Node Runner setup process.\n";
      echo "Please make sure the file exists in $sql_directory\n";
      echo "and press Enter to continue...";
  	  $anykey = fgets($stdin,4);
	  fclose($stdin);
	  $file_missing = 1;
    }
  } while ($file_missing) ;
}


if ($install_type == 'NEW INSTALL') {
  // install_type (from above) is NEW INSTALL
  
  $stdin = fopen('php://stdin', 'r');
  echo "\n\nHave you already created the database for Node Runner (per step 2 of\n";
  echo "the INSTALL file)? [y/N] ";
  $createit = fgets($stdin,4);
  $createit = ltrim(rtrim(strtoupper($createit)));
  fclose($stdin);
  if (!$createit) {
    $createit = 'N';
  }

  if ($createit == 'N') {
	echo "\n\nChecking database permissions...\n\n";
	$createdb = mysql_query("CREATE DATABASE $db;");
	if (!$createdb) {
	  $stdin = fopen('php://stdin', 'r');
	  echo "ERROR: Database could not be created.  You probably do not have permission\n";
	  echo "to create databases with the user account specified.  You will need\n";
	  echo "to manually create the \"$db\" database before setup can\n";
	  echo "continue.  Do that now, and press Enter when you're finished...";
	  $anykey = fgets($stdin,4);
	  fclose($stdin);
	}
  }
    
  do {
    unset($err_msg);
    echo "\n\nSetup will now attempt to populate the Node Runner database.\n";
    require_once($sql_directory.'nr-mysql-setup.php');
    if ($err_msg) {
	  echo "\n\nERROR: Database could not be populated.  MySQL said:\n\n".$err_msg."\n\n";
	  $stdin = fopen('php://stdin', 'r');
	  echo "Do you want to correct this error and try again? [Y/n] ";
	  $tryagain = fgets($stdin,4);
	  $tryagain = ltrim(rtrim(strtoupper($tryagain)));
	  fclose($stdin);

	  if (strtoupper($tryagain) == 'N') {
	    unset($err_msg);
	  } else {
	    $err_msg = 1;
	  }
	      
    } else {
      // database population worked, so move on.
	  unset($err_msg);
	  echo "\n\nDatabase populated successfully.\n\n";
    }
  } while ($err_msg);
     

  


  
} else {
  // install_type (from above) is UPGRADE

  echo "\n\nFrom which version will you be upgrading?\n\n";
  echo "A) 0.1\n";
  echo "B) 0.2\n";
  echo "C) 0.3\n";
  echo "D) 0.4.0 - 0.4.1\n";
  echo "E) 0.4.2 - 0.4.9\n";
  echo "F) 0.5.0\n";
  echo "G) 0.5.1 - 0.5.2\n";
  
  do {
    $stdin = fopen('php://stdin', 'r');
    echo "\nSelect a letter: ";
    $updateit = fgets($stdin,4);
    $updateit = ltrim(rtrim(strtoupper($updateit)));
    fclose($stdin);
    if (($updateit != 'A') &&
        ($updateit != 'B') &&
        ($updateit != 'C') &&
        ($updateit != 'D') &&
        ($updateit != 'E') &&
        ($updateit != 'F') &&
        ($updateit != 'G')) {
        unset($updateit);
    }
  } while (!$updateit);

  echo "\n\nSetup will now attempt to upgrade the Node Runner database.\n";
  unset($err_msg);

  // Begin really long switch statement for specific versions.
  switch($updateit) {
    case ($updateit == 'A'):
    require_once($sql_directory.'update-nr-to-v0.2.php');
    require_once($sql_directory.'update-nr-to-v0.3.php');
    require_once($sql_directory.'update-nr-to-v0.4.php');
    require_once($sql_directory.'update-nr-to-v0.4.2.php');
    require_once($sql_directory.'update-nr-to-v0.5.0.php');
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'B'):
    require_once($sql_directory.'update-nr-to-v0.3.php');
    require_once($sql_directory.'update-nr-to-v0.4.php');
    require_once($sql_directory.'update-nr-to-v0.4.2.php');
    require_once($sql_directory.'update-nr-to-v0.5.0.php');
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'C'):
    require_once($sql_directory.'update-nr-to-v0.4.php');
    require_once($sql_directory.'update-nr-to-v0.4.2.php');
    require_once($sql_directory.'update-nr-to-v0.5.0.php');
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'D'):
    require_once($sql_directory.'update-nr-to-v0.4.2.php');
    require_once($sql_directory.'update-nr-to-v0.5.0.php');
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'E'):
    require_once($sql_directory.'update-nr-to-v0.5.0.php');
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'F'):
    require_once($sql_directory.'update-nr-to-v0.5.1.php');
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
    case ($updateit == 'G'):
    require_once($sql_directory.'update-nr-to-v0.6.0.php');
    if ($err_msg) {
      echo "\n\nERROR: Database could not be upgraded.  MySQL said:\n\n".$err_msg."\n\n";
    } else {
      echo "\n\nDatabase upgraded successfully.\n\n";
    }
    break;
  } // End really long switch statement for specific versions.
  
}

$stdin = fopen('php://stdin', 'r');
echo "Press Enter to continue...";
$anykey = fgets($stdin,4);
fclose($stdin);
  
// End STEP 9










// STEP 10: Create line for user to copy to cron for node.start script.

echo "\n\nLastly, you need to schedule the node.start script to run at regular\n";
echo "intervals throughout the hour.  This setup script will NOT do that for\n";
echo "you, because it probably requires admin/root access.  However, to\n";
echo "schedule the script on your own, follow these instructions.\n\n";
echo "View instructions for:\n\n";
echo "1) Unix\n";
echo "2) Windows\n";
$stdin = fopen('php://stdin', 'r');
echo "\nWhich OS? [1] ";
$os_instructs = fgets($stdin,4);
$os_instructs = intval(ltrim(rtrim(strtoupper($os_instructs))));
fclose($stdin);

if (!$os_instructs) {
  $os_instructs = 1;
}

echo "\n\n";


if ($os_instructs == 1) {

  echo "For UNIX users, you need to add a cron job, using the 'crontab'\n";
  echo "application.  Just type 'crontab -e', and add the following line,\n";
  echo "which is being generated based on the answers you provided above:\n\n";

  // Another switch statement for pre-defined $qtime
  switch($qtime) {
    case ($qtime == '1'):
    $cron_string = "*";
    break;
    case ($qtime == '2'):
    $cron_string = "0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58";
    break;
    case ($qtime == '3'):
    $cron_string = "0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57";
    break;
    case ($qtime == '4'):
    $cron_string = "0,4,8,12,16,20,24,28,32,36,40,44,48,52,56";
    break;
    case ($qtime == '5'):
    $cron_string = "0,5,10,15,20,25,30,35,40,45,50,55";
    break;
    case ($qtime == '6'):
    $cron_string = "0,6,12,18,24,30,36,42,48,54";
    break;
    case ($qtime == '10'):
    $cron_string = "0,10,20,30,40,50";
    break;
    case ($qtime == '12'):
    $cron_string = "0,12,24,36,48";
    break;
    case ($qtime == '15'):
    $cron_string = "0,15,30,45";
    break;
  }
  
  echo "$cron_string * * * * /usr/bin/php -q $node_start_file >> /tmp/nr-debug.txt\n\n";
  
  echo "NOTE: Line may wrap on screen, but it should only be a single line.\n\n";

} else if ($os_instructs == 2) {

  echo "For Windows users, it is recommended that you create a batch script\n";
  echo "to call the PHP interpreter and the node.start script every $qtime\n";
  echo "minutes, similar to the following (lines should not wrap):\n\n\n";

  echo "@echo off\n\n";
  echo ":: Script to run Node Runner polling script every $qtime minutes.\n";
  echo ":: NOTE: This script requires sleep.exe (Batch File Wait) utility.\n\n";
  echo "cd \php\n";
  echo ":loop\n";
  echo "php -q $node_start_file >> %TEMP%\\nr-debug.txt\n";
  echo "sleep ".($qtime * 60)."\n";
  echo "goto loop\n\n";

  echo "\nNOTE: The sleep.exe utility is freely available in most versions of Windows\n";
  echo "Resource Kits.  Search on the microsoft.com website to download it.\n\n";

}

echo "NOTE FOR ANY OS: You may need to adjust the location of the PHP CLI\n";
echo "interpreter and the nr-debug.txt file.\n";

// End STEP 10


echo "\n\n\nThat's it!  Node Runner installation is complete.  It is recommended\n";
echo "that you remove this installer script (installer.php) now to prevent anyone\n";
echo "from tampering with your installation.\n\n";
echo "You can now login to the web interface with a default username of 'admin' and\n";
echo "default password of 'node-runner'.  Please change this password asap.\n\n";
echo "Please report any bugs using the SourceForge.net tracker, which is available\n";
echo "on the Node Runner website.  Thank you for using Open Source software.\n\n";



?>
