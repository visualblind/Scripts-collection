<?php

// IPplan v4.50
// Aug 24, 2001
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//

// NOTE: DO NOT REMOVE ANY LINES FROM THIS FILE

// define some global variables for database connections
// currently mysql and postgres7 are valid database types.
// maxsql should be used for mysql with transactions (innodb)
// oci8po is valid for oracle 9i (older versions of oracle
// are not supported). sybase, ado_mssql and mssql may work too.
// odbc_mssql should work for windows systems using IIS and mssql
// look in the adodb/drivers directory for additional drivers.

// the database user and password is NOT the same user and password
// used to access IPplan as a regular user.
define("DBF_TYPE", "maxsql");
define("DBF_HOST", "localhost");
define("DBF_USER", "ipplan");
define("DBF_NAME", "ipplan");
define("DBF_PASSWORD", "ipplan99");
// enable if using transaction safe tables. should be TRUE for all 
// databases except when using mysql with MyISAM tables
define("DBF_TRANSACTIONS", TRUE);
// use persistent database connections - not recommended for mysql
define("DBF_PERSISTENT", FALSE);
// turn on database debugging
define("DBF_DEBUG", FALSE);
// turn on intense php debugging - not the same as DBF_DEBUG
// for most debugging, turn on both!
define("DEBUG", FALSE);
// fix possible adodb issues with Oracle - this is the default,
// but oci8po driver appears to ignore setting?
define ("ADODB_ASSOC_CASE", 0);

// define some global variables for authentication
define("REALM", "IPplan authentication");
define("REALMERROR", "You need to enter a valid user-id and password");

// define global admin user and passwd. This is NOT the same user
// and password that the databases use.
define("ADMINUSER", "admin");
define("ADMINPASSWD", "admin");
define("ADMINREALM", "IPplan admin authentication");

// allow anonymous read access to information? If TRUE, anybody
// can view information, but authentication is required for all
// changes. Depending on your security policy, setting this to
// TRUE can be dangerous
define("ANONYMOUS", FALSE);

// setting to true logs all changes to the AuditLog
define("AUDIT", TRUE);

//---------------------START OF MISC SECTION-----------------

// field separator for import functions
define("FIELDS_TERMINATED_BY", "\t");
//define("FIELDS_TERMINATED_BY", ";");

// maximum number of lines per table - this must be a power of 2!
// eq 64, 128, 256, 512, 1024 etc
// don't make this too large else you will get URI too large errors
define("MAXTABLESIZE", 128);

// maximum number of bytes allowed to upload via import functions,
// info fields and attached files
// don't make this too large - consider the disk space as the info
// is stored in your database
// WARNING: this setting will be ignored if it is bigger than specified
// in the php.ini file
// 524288 is the default for Apache - you will get "Document contains
// no data" errors if the Apache limit is exceeded as Apache just
// kills the connection when the upload size is exceeded
define("MAXUPLOADSIZE", 524288);

// repository for files uploaded. this directory should not be
// under the web tree and should be readable and writable by the
// web server - usually user apache and group apache
// see either httpd.conf User directive or ps -ef to see which user
// apache runs under, then set mode 700 on directory and change owner
// to this user
define("UPLOADDIRECTORY", "/var/spool/ipplanuploads");

// default country code ("" for none)
define("DEFAULTCOUNTRY", "US");

// default state code ("" for none)
define("DEFAULTSTATE", "FL");

// path to nmap scanner (http://www.insecure.org) - leave blank 
// to turn off scanning or if scanner is not available. this will
// not work if php is running in safemode. probing and scanning may 
// also be against policy for your site!
//define("NMAP", "");
define("NMAP", "/usr/bin/nmap");

// helpdesk email address
define("HELPDESKEMAIL", "helpdesk@mydomain.com");

// email SMTP server/relay - either an ip address or domain name
define("EMAILSERVER", "localhost");

// enable or disable the request system
define("REQUESTENABLED", TRUE);

// list of customers/AS to display for which people can request IP addresses
// "" for all customers, or comma seperated list of customer index numbers
// obtain a list of index numbers on the admin->maintenance pages
define("REQUESTCUST", "");

// when ranges or aggregates are created, should we test for overlaps within customer?
// RANGETEST=0 - no overlaps allowed at all
// RANGETEST=1 - overlaps within areas allowed
// RANGETEST=2 - any type of overlap allowed

// upgraded versions of IPplan before 4.47 will require a database ALTER TABLE
// to remove UNIQUE index on range field. New installations to not require the ALTER TABLE:
// DROP INDEX rangeaddr ON range;
// ALTER TABLE range ADD  INDEX range_rangeaddr  (rangeaddr, customer);
define("RANGETEST", 0);
//-------------------------START OF REGISTRAR---------------------------

// enable and disable SWIP/resgistrar functionality (only useful if 
// dealing with ARIN or any other registrar directly)
// valid entries are TRUE or FALSE
define("REGENABLED", TRUE);

// default registry (ARIN/RIPE) - this definition must be uppercase
define("REGISTRY", "RIPE");

// your network maintainer id used when sending SWIP/registrar updates
define("MAINTAINERID", "DefaultID");

// e-mail address to send swip/registrar entries to
define("REGEMAIL", "swip@registrar.net");

// your SWIP/registrar admins e-mail address
define("REGADMINEMAIL", "myemail@mydomain.com");

// if you are with RIPE and LIR, you'll need your "reg-id"
define("REGID", "xx.yyyy");

// if you are with RIPE and LIR, you'll need your password
define("REGPASS", "LIR-PASS");

// whois server
define("WHOISSERVER", "whois.internic.net");
//-------------------------START OF DNS---------------------------------

// enable and disable DNS - valid entries are TRUE or FALSE
define("DNSENABLED", TRUE);

// DNS SOA information in seconds
define("DNSTTL", "21600");        // 6h
define("DNSREFRESH", "86400");    // 1d
define("DNSRETRY", "3600");       // 1h
define("DNSEXPIRE", "604800");    // 1w
define("DNSMINTTL", "21600");     // 6h

define("DNSSERVER1", "ns1.example.com");
define("DNSSERVER2", "ns2.example.com");
define("DNSSERVER3", "ns3.example.com");
define("DNSSERVER4", "ns4.example.com");

// export path where zone files in XML format will be output ready for
// transformation into zone file for various DNS servers
// NOTE: make sure that the webserver can write into this directory
//   this will usually be the user under which Apache runs. If the 
// permissions are not correct, the files will be created in the
// system temp directory, usually /tmp
define("DNSEXPORTPATH", "/tmp/dns/");

// dnsslaveonly is the default setting for when creating new zones. If your
// dns server only serves as a slave for most of your zones, it's helpful
// to set this to "yes". This constant determines whether or not the
// check box for dnsslaveonly will be set on the domain creation form.
// Valid values for this constant are "Y" and "N"
define("DNSSLAVEONLY", "N");

// automatically create A forward zone records for matching zones when
// updating IP address records - only supported on MySQL and Postgress
define("DNSAUTOCREATE", FALSE);
//-------------------------START OF DHCP EXTENSION----------------------

// export path where DHCP files in XML format will be output ready for
// transformation into DHCP file for various DHCP servers
define("DHCPEXPORTPATH", "/tmp/dhcp/");

// This string identifies ip addresses that belong in the DHCP pool
define("DHCPRESERVED", "Reserved - DHCP pool");

//-------------------------START OF LANGUAGES---------------------------

// which languages are supported by ipplan - see TRANSLATIONS to 
// translate ipplan into your own language. NOTE: English must always
// be in the list and first
$iso_codes = array (
    'en_EN'=>'English',
    'bg_BG'=>'Bulgarian',
    'fr_FR'=>'French - Auto Translation',
    'de_DE'=>'German - Auto Translation',
    'it_IT'=>'Italian - Auto Translation',
    'no_NO'=>'Norwegian - Auto Translation',
    'pt_PT'=>'Portuguese - Auto Translation',
    'es_ES'=>'Spanish - Auto Translation');

// should language choices be displayed?
define("LANGCHOICE", TRUE);
//-------------------------START THEME CHOOSER-------------------------

// Each line defines an available theme and gives it a name.

$config_themes = array (
    "Classic" => "default.css",
    "Pastel"  => "pastel.css");


//-------------------------START OF AUTHENTICATION----------------------

// settings to alter methods of authentication - either using ipplans
// own internal authentication or your own external authentication
// NOTE: don't mess with these settings if you are not sure what you
// are doing

// associative array index which contains current authenticated user
// from $_SERVER. This should be set to REMOTE_USER if using external
// authentication
define("AUTH_VAR", "PHP_AUTH_USER");

// type of authentication, either internal or external
// having issues with external authentication? search for var_dump in
// auth.php and follow the instructions above the var_dump line
define("AUTH_INTERNAL", TRUE);

// show logout button - this is not secure, so turned off by default
// best method to logoff is to close all browser instances
// useful for testing
define("AUTH_LOGOUT", FALSE);

// default read-only SNMP community string - used for reading routing
// tables and probing devices
define("SNMP_COMMUNITY", "public");

//-------------------------START OF MENU EXTENSION----------------------

// private menu extensions to the ipplan menu system
define("MENU_PRIV", FALSE);
define("MENU_EXTENSION", 
".|My site menu
..|First menu item|http://www.example.com
..|Second menu item|http://www2.example.com
"
);

// URL under which IPplan is installed. May be required for servers
// using virual hosts for which IPplan cannot figure out the URL
// This parameter should be in a directory format.
// if IPplan is at URL http://myhost.com/ipplan, then this setting
// should be /ipplan
// NOTE: no http, no hostname, no trailing /
define("BASE_URL", "");

//---------------------START OF AUDIT TRIGGER EXTENSION-----------------

// turn on external user trigger function - see user_trigger() function
// in ipplanlib.php
// for this to work, audit log (AUDIT config option) must be true
define("EXT_FUNCTION", FALSE);

?>
