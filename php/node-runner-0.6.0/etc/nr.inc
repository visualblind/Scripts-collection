<?
# Standard configuration file for Node Runner
# Should be stored somewhere safe

$nr_ver = "0.6.0";     # Node Runner version number
$dbtype = "mysql";     # database type (Currently only supports MySQL)
$dbhost = "localhost"; # database host
$db = "";              # database name
$dbuser = "";          # database username
$dbpass = "";          # database password
$sender = "";          # Email address to receive alerts from
$detailed_email = 0;   # Send detailed information with email alerts (0 = NO)
$delay = 15;           # Minutes to wait between each "down" notification
$max_alerts = 0;       # Maximum number of alerts sent while "down" (0 = unlimited)
                       # This is in addition to initial notification.
$max_attempts = 2;     # Max query attempts before declaring status as "down"
$qtime = 2;            # Time between queries (Should coincide with cron -
                       # i.e. if node.start is run every 2 minutes, value
                       # should be set to 2.
$allow_refused = 0;    # Allow port error 111 'Connection Refused' to be regarded
                       # as a positive response (UP) by the node.  You may encounter
                       # this with various routers on the telnet port.
$debug = 0;            # Set to 1 for script output (see README)
$firstmail = 0;        # Number of minutes a node must be "DOWN" before
                       # NR sends first mail notice.
                       # (0 = Send notice immediately)
$secure_monitor = 0;   # Only admins can start the Network Dashboard marquee (0 = NO)
$show_recent = 1;      # Display list of recent failures on Network Dashboard (0 = NO)
$monitor_polling = 0;  # Allow 'Click to poll manually' on Network Dashboard (0 = NO)
$truncate_at = 22;     # Truncate node names to this length on status monitor (0 = No truncation)
$status_stats = 1;     # Display Node Statistics Snapshot on Network Dashboard (0 = NO)
$dash_refrate = 30;    # Set refresh rate (in seconds) for Network Dashboard
$allow_rss = 1;        # Allow RSS feed for NR Project News on main page of web interface.

$glbl_hash = "Rx1Uo12n6N";  # CHANGE THIS to ensure the security of your web interface.

$path_to_include = "/path/to/include/";    # This should point to the NR include directory.
                                           # (Remember the trailing slash.)
$nr_url = "http://localhost/node-runner/"; # This should point to the url where the NR html
				           # files were placed. (Remember trailing slash.)

# DO NOT MODIFY BELOW THIS POINT!

// Set globals for includes
GLOBAL $nr_ver,
       $dbtype,
       $dbhost,
       $db,
       $dbuser,
       $dbpass,
       $detailed_email,
       $sender,
       $delay,
       $max_alerts,
       $max_attempts,
       $qtime,
       $debug,
       $allow_refused,
       $firstmail,
       $secure_monitor,
       $show_recent,
       $monitor_polling,
       $allow_rss,
       $glbl_hash,
	   $path_to_include,
	   $nr_url;
?>
