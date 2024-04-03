<?
/*
	new config file for slsk 
*/
set_time_limit(0);

$debugstart = 1;
define('DEBUG', TRUE);
$serverhost = '38.115.131.131';
$serverport = 2240;

define("RETRY", 15); # num times to attempt to connect to network
define("RETRYINT", 10); # num secs between retry

// most likely leave the following alone
define("BWINC", 1024); // amount to pull from wire in chunks.

define('PEERPORT', 2235); # port we will listen on for peer connects in SETWAITPORT

define("MYSQLHOST", "localhost");
define("MYSQLUSER", "root");
define("MYSQLPASS", "");
define("MYSQLDATABASE", "soul_soul"); // if you change this, change in the examples as well.

// current user
    $rname = rand(1000,9999); // you can change this if you want..
    define('SLSK_USER',    'soul'.$rname);
    define('SLSK_PASS',    $rname);


#### NO CHANGES BELOW UNLESS YOU KNOW WHAT YOU ARE DOING 
// current version
    define('SLSK_VERSION',     152);//149
    define('AUTO_JOIN',    'test');
    define('SLSK_INFO',    'http://www.slsknet.org/slskinfo2');

// user status codes
define('STATUS_UNKNOWN',    -1);
define('STATUS_OFFLINE',     0);
define('STATUS_AWAY',        1);
define('STATUS_ONLINE',      2);

// protocol types in packets.
define('TYPE_BYTE',          1); # byte	(1 byte)
define('TYPE_INT',           2); # integer (4 bytes)
define('TYPE_STRING',        4); # string (string_length + 4 bytes)
define('TYPE_ENUM',          8); # array of possible from above.

// these are codes sent from the server
$SERVERCODES = array(
'LOGIN'				=> 1,
'SETWAITPORT'			=> 2,
'GETPEERADDRESS'		=> 3,
'ADDUSER'			=> 5,
'GETUSERSTATUS'			=> 7,
'SAYCHATROOM'			=> 13,
'JOINROOM'			=> 14,
'LEAVEROOM'			=> 15,
'USERJOINEDROOM'		=> 16,
'USERLEFTROOM'			=> 17,
'CONNECTTOPEER'			=> 18,
'MESSAGEUSER'			=> 22,
'MESSAGEACKED'			=> 23,
'FILESEARCH'			=> 26,
'SETSTATUS'			=> 28,
'SENDSPEED'			=> 34,
'SHAREDFOLDERSFILES'		=> 35,
'GETUSERSTATS'			=> 36,
'QUEUEDDOWNLOADS'		=> 40,
'RELOGGED'			=> 41,
'PLACEINLINERESPONSE'		=> 60,
'ROOMADDED'			=> 62,
'ROOMREMOVED'			=> 63,
'ROOMLIST'			=> 64,
'EXACTFILESEARCH'		=> 65,
'ADMINMESSAGE'			=> 66,
'GLOBALUSERLIST'		=> 67,
'TUNNELEDMESSAGE'		=> 68,
'PRIVILEGEDUSERS'		=> 69,
'MSG83'				=> 83,
'MSG84'				=> 84,
'MSG85'				=> 85,
'PARENTINACTIVITYTIMEOUT'	=> 86,
'SEARCHINACTIVITYTIMEOUT'	=> 87,
'MINPARENTSINCACHE'		=> 88,
'MSG89'				=> 89,
'DISTRIBALIVEINTERVAL'		=> 90,
'ADDTOPRIVILEGED'		=> 91,
'CHECKPRIVILEGES'		=> 92,
'CANTCONNECTTOPEER'		=> 1001,
'HAVENOPARENT'			=> 71,
'SEARCHREQUEST'			=> 93,
'NETINFO'			=> 102,
'WISHLISTSEARCH'		=> 103,
'WISHLISTINTERVAL'		=> 104	    
);

// codes sent from or sent to a peer
$PEERCODES = array(
'GETSHAREDFILELIST' 		=> 4,
'SHAREDFILELIST' 		=> 5,
'FILESEARCHREQUEST' 		=> 8,
'FILESEARCHRESULT' 		=> 9,
'USERINFOREQUEST' 		=> 15,
'USERINFOREPLY' 		=> 16,
'FOLDERCONTENTSREQUEST' 	=> 36,
'FOLDERCONTENTSRESPONSE' 	=> 37,
'TRANSFERREQUEST' 		=> 40,
'TRANSFERRESPONSE' 		=> 41,
'PLACEHOLDUPLOAD' 		=> 42,
'QUEUEUPLOAD' 			=> 43,
'PLACEINQUEUE' 			=> 44,
'UPLOADFAILED' 			=> 46,
'QUEUEFAILED' 			=> 50,
'PLACEINQUEUEREQUEST' 		=> 51
);


#
#	PROTOCOL MAP
#
?>
