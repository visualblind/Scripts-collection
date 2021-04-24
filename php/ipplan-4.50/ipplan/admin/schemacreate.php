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

// when the database layout changes, bump up this value.
define("SCHEMA", 19);

require_once("../ipplanlib.php");
//require_once('../adodb/adodb-errorhandler.inc.php');
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../auth.php");

// check for latest variable added to config.php file, if not there
// user did not upgrade properly
if (!defined("REQUESTENABLED")) die("Your config.php file is inconsistent - you cannot use your old config.php file during upgrade");

$auth = new BasicAuthenticator(ADMINREALM, REALMERROR);

$auth->addUser(ADMINUSER, ADMINPASSWD);

// And now perform the authentication
$auth->authenticate();

// adodb always maps the driver to mysql no matter what you select
if (DBF_TYPE=='mysql') {
   $taboptarray = array('mysql' => 'TYPE=MYISAM');
}
else if (DBF_TYPE=='maxsql') {
   $taboptarray = array('mysql' => 'TYPE=INNODB');
}
else {
   $taboptarray = array('mysql' => 'TYPE=MYISAM',
                        'oci8po' => 'tablespace users');
}

$tables['area']=array(
   array('areaaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('descrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('areaindex',  'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull')
);
$indexes['area']=array(
   array('area_customer', 'customer,descrip', array('UNIQUE')),
   array('area_areaaddr', 'areaaddr,customer', array('UNIQUE'))
);

$tables['auditlog']=array(
   array('userid', 'C', '40', 'DEFAULT' => ''),
   array('action', 'C', '254', 'DEFAULT' => '', 'NotNull'),
   array('dt', 'T', 'DEFTIMESTAMP', 'NotNull'),
);
$indexes['auditlog']=array(
   array('auditlog_dt', 'dt')
);

$tables['base']=array(
   array('baseaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('subnetsize', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('descrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('baseindex',  'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('admingrp', 'C', '40', 'DEFAULT' => '', 'NotNull'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull'),
   array('lastmod', 'T', 'DEFTIMESTAMP', 'NotNull'),
   array('userid', 'C', '40', 'DEFAULT' => ''),
   // baseopt is a binary encoded field - bit 0 defines if the subnet is DHCP if set
   array('baseopt', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0),
   array('swipmod', 'T', 'Null')
);
$indexes['base']=array(
   array('base_baseaddr', 'baseaddr,customer', array('UNIQUE')),
   array('base_customer', 'customer'),
   array('base_admingrp', 'admingrp')
);

$tables['baseadd']=array(
   array('baseindex', 'I8', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('info', 'X', 'DEFAULT' => ''),
   array('infobin', 'B', 'DEFAULT' => '', 'Null'),
   array('infobinfn', 'C', '255', 'DEFAULT' => '', 'Null')
);

$tables['custinfo']=array(
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('org', 'C', '100', 'DEFAULT' => ''),
   array('street', 'C', '255', 'DEFAULT' => ''),
   array('city', 'C', '80', 'DEFAULT' => ''),
   array('state', 'C', '2', 'DEFAULT' => ''),
   array('zipcode', 'C', '10', 'DEFAULT' => ''),
   array('cntry', 'C', '2', 'DEFAULT' => ''),
   array('maint', 'C', '80', 'DEFAULT' => ''),
   array('nichandl', 'C', '80', 'DEFAULT' => ''),
   array('lname', 'C', '80', 'DEFAULT' => ''),
   array('fname', 'C', '80', 'DEFAULT' => ''),
   array('mname', 'C', '80', 'DEFAULT' => ''),
   array('torg', 'C', '100', 'DEFAULT' => ''),
   array('tstreet', 'C', '255', 'DEFAULT' => ''),
   array('tcity', 'C', '80', 'DEFAULT' => ''),
   array('tstate', 'C', '2', 'DEFAULT' => ''),
   array('tzipcode', 'C', '10', 'DEFAULT' => ''),
   array('tcntry', 'C', '2', 'DEFAULT' => ''),
   array('phne', 'C', '20', 'DEFAULT' => ''),
   array('mbox', 'C', '100', 'DEFAULT' => '')
);

$tables['custadd']=array(
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('info', 'X', 'DEFAULT' => ''),
   array('infobinfn', 'C', '255', 'DEFAULT' => '', 'Null')
);

$tables['customer']=array(
   array('custdescrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('admingrp', 'C', '40', 'DEFAULT' => '', 'NotNull')
);
$indexes['customer']=array(
   array('customer_custdescrip', 'custdescrip', array('UNIQUE')),
   array('customer_admingrp', 'admingrp')
);

$tables['grp']=array(
   array('grpdescrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('grp', 'C', '40', 'DEFAULT' => '', 'NotNull', 'PRIMARY'),
   array('createcust', 'C', '1', 'DEFAULT' => 'N', 'NotNull'),
   array('resaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0),
   array('grpopt', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull')
);
$indexes['grp']=array(
   array('grp_grpdescrip', 'grpdescrip', array('UNIQUE'))
);

// order of columns for PRIMARY KEY is important!!
$tables['ipaddr']=array(
   array('ipaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('userinf', 'C', '80', 'DEFAULT' => ''),
   array('location', 'C', '80', 'DEFAULT' => ''),
   array('telno', 'C', '15', 'DEFAULT' => ''),
   array('descrip', 'C', '80', 'DEFAULT' => ''),
   array('hname', 'C', '100', 'DEFAULT' => ''),
   array('macaddr', 'C', '12', 'DEFAULT' => ''),
   array('baseindex', 'I8', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('lastmod', 'T', 'DEFTIMESTAMP', 'NotNull'),
   array('lastpol', 'T'),
   array('userid', 'C', '40', 'DEFAULT' => '')
);
$indexes['ipaddr']=array(
   array('ipaddr_baseindex', 'baseindex')
);

// order of columns for PRIMARY KEY is important!!
$tables['ipaddradd']=array(
   array('ipaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('baseindex', 'I8', 'DEFAULT' => 0, 'NotNull', 'PRIMARY'),
   array('info', 'X', 'DEFAULT' => ''),
   array('infobin', 'B', 'DEFAULT' => '', 'Null'),
   array('infobinfn', 'C', '255', 'DEFAULT' => '', 'Null')
);
$indexes['ipaddradd']=array(
   array('ipaddradd_baseindex', 'baseindex')
);

$tables['requestip']=array(
   array('requestindex', 'I4', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull'),
   array('requestdesc', 'C', '80', 'DEFAULT' => ''),
   array('userinf', 'C', '80', 'DEFAULT' => ''),
   array('location', 'C', '80', 'DEFAULT' => ''),
   array('telno', 'C', '15', 'DEFAULT' => ''),
   array('descrip', 'C', '80', 'DEFAULT' => ''),
   array('hname', 'C', '100', 'DEFAULT' => ''),
   array('macaddr', 'C', '12', 'DEFAULT' => ''),
   array('lastmod', 'T', 'DEFTIMESTAMP', 'NotNull'),
   array('info', 'X', 'DEFAULT' => '')
);
$indexes['requestip']=array(
   array('requestip_desc', 'customer, requestdesc', array('UNIQUE'))
);

$tables['range']=array(
   array('rangeaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('rangesize', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('descrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('rangeindex',  'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('areaindex',  'I8', 'DEFAULT' => 0, 'NotNull'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull')
);
$indexes['range']=array(
//   array('range_rangeaddr', 'rangeaddr,customer', array('UNIQUE')),
   array('range_rangeaddr', 'rangeaddr,customer'),
   array('range_customer', 'customer,descrip', array('UNIQUE')),
   array('range_areaindex', 'areaindex')
);

$tables['revdns']=array(
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull'),
   array('hname', 'C', '100', 'DEFAULT' => '', 'NotNull'),
   array('ipaddr', 'C', '15', 'DEFAULT' => '', 'NotNull'),
   array('horder', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'TINYINT UNSIGNED':'I1', 'DEFAULT' => 0, 'NotNull')
);
$indexes['revdns']=array(
   array('revdns_customer', 'customer')
);

if (DBF_TYPE=="mssql" or DBF_TYPE=="ado_mssql" or DBF_TYPE=="odbc_mssql" or 
    DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') {
   $tables['version']=array(
      array('version', 'I4', 'DEFAULT' => 0, 'NotNull')
   );
}
else {
   $tables['schema']=array(
      array('version', 'I4', 'DEFAULT' => 0, 'NotNull')
   );
}

$tables['users']=array(
   array('userid', 'C', '40', 'DEFAULT' => '', 'NotNull', 'PRIMARY'),
   array('userdescrip', 'C', '80', 'DEFAULT' => '', 'NotNull'),
   array('password', 'C', '40', 'DEFAULT' => '', 'NotNull')
);

$tables['usergrp']=array(
   array('userid', 'C', '40', 'DEFAULT' => '', 'NotNull'),
   array('grp', 'C', '40', 'DEFAULT' => '', 'NotNull')
);
$indexes['usergrp']=array(
   array('usergrp_userid', 'userid,grp', array('UNIQUE')),
   array('usergrp_grp', 'grp')
);

$tables['bounds']=array(
   array('boundsaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('boundssize', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('grp', 'C', '40', 'DEFAULT' => '', 'NotNull')
);
$indexes['bounds']=array(
   array('bounds_grp', 'grp'),
   array('bounds_boundsaddr', 'boundsaddr')
);

$tables['fwdzone']=array(
   array('data_id', 'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('domain', 'C', '254', 'DEFAULT' => '', 'NotNull'),
   array('lastmod', 'T', 'DEFAULT' => '', 'Null'),
   array('engineer', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('error_message', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('responsiblemail', 'C', '64', 'DEFAULT' => '', 'Null'),
   array('serialdate', 'C', '8', 'DEFAULT' => '', 'NotNull'),
   array('serialnum', 'I4', 'DEFAULT' => 0),
   array('ttl', 'I4', 'DEFAULT' => 0),
   array('refresh', 'I4', 'DEFAULT' => 0),
   array('retry', 'I4', 'DEFAULT' => 0),
   array('expire', 'I4', 'DEFAULT' => 0),
   array('minimum', 'I4', 'DEFAULT' => 0),
   array('userid', 'C', '40', 'DEFAULT' => ''),
   array('slaveonly', 'C', '1', 'DEFAULT' => 'N', 'NotNull'),
   array('zonefilepath1', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('zonefilepath2', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull'),
   array('admingrp', 'C', '40', 'DEFAULT' => '', 'Null')
);
$indexes['fwdzone']=array(
   array('fwdzone_customer', 'customer'),
   array('fwdzone_domain', 'domain')
);

$tables['fwdzonerec']=array(
   array('recidx', 'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('data_id', 'I8', 'DEFAULT' => 0, 'NotNull'),
   array('lastmod', 'T', 'DEFAULT' => '', 'Null'),
   array('host', 'C', '254', 'DEFAULT' => '', 'NotNull'),
   array('recordtype', 'C', '5', 'DEFAULT' => '', 'NotNull'),
   array('ip_hostname', 'C', '254', 'DEFAULT' => '', 'NotNull'),
   array('error_message', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('sortorder', 'I4', 'DEFAULT' => 0, 'NotNull'),
   array('userid', 'C', '40', 'DEFAULT' => '', 'NotNull'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull')
);
$indexes['fwdzonerec']=array(
   array('fwdzonerec_data_id', 'data_id'),
   array('fwdzonerec_sortorder', 'sortorder'),
   array('fwdzonerec_customer', 'customer')
);

$tables['fwddns']=array(
   array('id', 'I8', 'DEFAULT' => 0, 'NotNull'),
   array('hname', 'C', '100', 'DEFAULT' => '', 'NotNull'),
   array('horder', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'TINYINT UNSIGNED':'I1', 'DEFAULT' => 0, 'NotNull')
);
$indexes['fwddns']=array(
   array('fwddns_id', 'id')
);

$tables['zones']=array(
   array('id', 'I8', 'AUTOINCREMENT', 'NotNull', 'PRIMARY'),
   array('zoneip', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('zonesize', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0, 'NotNull'),
   array('zone', 'C', '254', 'DEFAULT' => '', 'NotNull'),
   array('lastmod', 'T', 'DEFAULT' => '', 'Null'),
   array('serialdate', 'C', '8', 'DEFAULT' => '', 'NotNull'),
   array('serialnum', 'I4', 'DEFAULT' => 0),
   array('ttl', 'I4', 'DEFAULT' => 0),
   array('refresh', 'I4', 'DEFAULT' => 0),
   array('retry', 'I4', 'DEFAULT' => 0),
   array('expire', 'I4', 'DEFAULT' => 0),
   array('minimum', 'I4', 'DEFAULT' => 0),
   array('userid', 'C', '40', 'DEFAULT' => ''),
   array('slaveonly', 'C', '1', 'DEFAULT' => 'N', 'NotNull'),
   array('zonefilepath1', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('zonefilepath2', 'C', '254', 'DEFAULT' => '', 'Null'),
   array('responsiblemail', 'C', '64', 'DEFAULT' => '', 'Null'),
   array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0, 'NotNull')
);
$indexes['zones']=array(
   array('zones_customer', 'customer'),
   array('zones_zoneip', 'zoneip')
);

$tables['zonedns']=array(
   array('id', 'I8', 'DEFAULT' => 0, 'NotNull'),
   array('hname', 'C', '100', 'DEFAULT' => '', 'NotNull'),
   array('horder', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'TINYINT UNSIGNED':'I1', 'DEFAULT' => 0, 'NotNull')
);
$indexes['zonedns']=array(
   array('zonedns_id', 'id')
);





// checks to see if user is using latest schema
function CreateSchema($display) {

   global $taboptarray, $tables, $indexes;

   $ds = &ADONewConnection(DBF_TYPE);
   if (!$ds) {
      echo "Invalid database driver selected<p>";
      echo "<b>".$ds->ErrorMsg()."</b>";
      exit;
   }
   $ds->debug = DBF_DEBUG;
   if(!$ds->Connect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME)) {
      echo "Failed to connect to database<p>";
      echo "<b>".$ds->ErrorMsg()."</b>";
      exit;
   }
   $ADODB_FETCH_MODE = ADODB_FETCH_ASSOC;

   // loop through tables and indexes arrays to create SQL
   foreach($tables as $tblname => $fldarray) {
      DoSQL ($ds, $display, $tblname, $fldarray);
   }

   if (DBF_TYPE=="mssql" or DBF_TYPE=="ado_mssql" or DBF_TYPE=="odbc_mssql" or
       DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') {
      $sqlarray = array('INSERT INTO version (version) VALUES ('.SCHEMA.')');
   }  
   else {
      $sqlarray = array('INSERT INTO schema (version) VALUES ('.SCHEMA.')');
   }
   if (DBF_TYPE!="mysql") {
      $sqlarray[] = 'COMMIT';
   }
   foreach($sqlarray as $value) {
      if (!$display) {
         if (!$ds->Execute($value)) {
            PrintSQL($value);
            echo "Failed to execute above statement against database<p>";
            echo "<b>".$ds->ErrorMsg()."</b>";
            exit;
         }
      } else {
         PrintSQL($value);
      }
   }
}

// create the SQL
function DoSQL ($ds, $display, $tblname, $fldarray) {

    global $taboptarray, $tables, $indexes;

    // Then create a data dictionary object, using this connection
    $dict = NewDataDictionary($ds);

    $sqlarray = $dict->CreateTableSQL($tblname, $fldarray, $taboptarray);
    if (!$display) {
        if ($dict->ExecuteSQLArray($sqlarray, FALSE)!=2) {
            PrintSQL($sqlarray[0]);
            echo "Failed to execute above statement against database<p>";
            echo "<b>".$ds->ErrorMsg()."</b>";
            exit;
        }
    } else {
        PrintSQL($sqlarray[0]);
    }
    if (@isset($indexes[$tblname])) {
        foreach($indexes[$tblname] as $idxarray) {
            // options field in array may not be set
            if (isset($idxarray[2])) {
                $sqlarray = $dict->CreateIndexSQL($idxarray[0], $tblname, $idxarray[1], $idxarray[2]);
            }
            else {
                $sqlarray = $dict->CreateIndexSQL($idxarray[0], $tblname, $idxarray[1]);
            }
            if (!$display) {
                if ($dict->ExecuteSQLArray($sqlarray, FALSE)!=2) {
                    PrintSQL($sqlarray[0]);
                    echo "Failed to execute above statement against database<p>";
                    echo "<b>".$ds->ErrorMsg()."</b>";
                    exit;
                }
            } else {
                PrintSQL($sqlarray[0]);
            }
        }
    }
}

function UpdateSchema($display) {

   global $taboptarray, $tables, $indexes;

   $ds = &ADONewConnection(DBF_TYPE);
   if (!$ds) {
      echo "Invalid database driver selected<p>";
      echo "<b>".$ds->ErrorMsg()."</b>";
      exit;
   }
   $ds->debug = DBF_DEBUG;
   if(!$ds->Connect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME)) {
      echo "Failed to connect to database<p>";
      echo "<b>".$ds->ErrorMsg()."</b>";
      exit;
   }
   $ds->SetFetchMode(ADODB_FETCH_ASSOC);

   // check mysql version
   if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
      $result=&$ds->Execute("SELECT version() AS version");
      $row = $result->FetchRow();
      $version=$row["version"];

      if ($version < "3.23.15") {
         die("You need mysql version 3.23.15 or later");
      }
   }

   // get schema version
   // schema is reserved word in mssql and mysql 5
   if (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') {
       // version upgrade before schema 18 using table called 'schema'
       if (in_array("schema", $ds->MetaTables())) {
           $result=&$ds->Execute("SELECT version
                   FROM `schema`");
       }
       else {
           $result=&$ds->Execute("SELECT version
                   FROM version");
       }
   }
   else if (DBF_TYPE=="mssql" or DBF_TYPE=="ado_mssql" or DBF_TYPE=="odbc_mssql") {
      $result=&$ds->Execute("SELECT version
                             FROM version");
   }
   else {
      $result=&$ds->Execute("SELECT version
                             FROM schema");
   }
   // could not read version number - probably hit upgrade button
   // for new install
   if (!$result) {
       die("<p>Could not determine IPplan version number - probably a database permission problem, the wrong database was selected or this is actually a new installation and not an upgrade!");
   }

   // could return error if schema table does not exist!
   $row = $result->FetchRow();
   $version=$row["version"];

   // schema version did not change
   if ($version == SCHEMA) {
      return;
   }
   else if (SCHEMA < $version) {
      echo "You are trying to downgrade IPplan - impossible";
      exit;
   }

   // Then create a data dictionary object, using this connection
   // this is crap - $dict should be passed to DoSQL too?
   $dict = NewDataDictionary($ds);

   switch ($version) {
     case 0:
       if (DBF_TYPE=="mssql" or DBF_TYPE=="ado_mssql" or DBF_TYPE=="odbc_mssql") {
          DoSQL ($ds, $display, "version", $tables["version"]);
       } 
       else {
          DoSQL ($ds, $display, "schema", $tables["schema"]);
       }

     case 1:
       DoSQL ($ds, $display, "custinfo", $tables["custinfo"]);
       DoSQL ($ds, $display, "revdns", $tables["revdns"]);

       // should be NOT NULL, but this fails on broken databases like PGSQL
       $sqlarray = $dict->AddColumnSQL("grp", 
           array(array('createcust', 'C', '1', 'DEFAULT' => 'N')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 2:
       $sqlarray = $dict->AlterColumnSQL("base", 
           array(array('customer', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0)));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

       // should be NOT NULL, but this fails on broken databases like PGSQL
       $sqlarray = $dict->AddColumnSQL("base", 
          array(array('lastmod', 'T', 'DEFTIMESTAMP'),
          array('userid', 'C', '40', 'DEFAULT' => '')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

       // should be NOT NULL, but this fails on broken databases like PGSQL
       $sqlarray = $dict->AddColumnSQL("base", 
          array(array('lastmod', 'T', 'DEFTIMESTAMP'),
          array('userid', 'C', '40', 'DEFAULT' => ''),
          array('swipmod', 'T')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 3:
       DoSQL ($ds, $display, "bounds", $tables["bounds"]);

     case 4:
       // cannot rename columns so create new column, copy data, delete old
       $sqlarray = $dict->AddColumnSQL("ipaddr", 
          array(array('userinf', 'C', '80', 'DEFAULT' => '')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

       $sqlarray = $dict->DropColumnSQL("ipaddr", array('user'));
       $sqlarray[] = "ALTER TABLE `user` RENAME `users`";
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 5:
       $sqlarray = $dict->AddColumnSQL("grp", 
           array(array('grpopt', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0)));
       $sqlarray[] = 'UPDATE grp SET grpopt=1';

       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 6:
       DoSQL ($ds, $display, "ipaddradd", $tables["ipaddradd"]);

     case 7:
       // don't add column if we did no 6
       if ($version>=7) {
           $sqlarray = $dict->AddColumnSQL("ipaddradd",
                   array(array('infobinfn', 'C', '255', 'DEFAULT' => '')));

           foreach($sqlarray as $value) {
               if (!$display) {
                   if (!$ds->Execute($value)) {
                       PrintSQL($value);
                       echo "Failed to execute above statement against database<p>";
                       echo "<b>".$ds->ErrorMsg()."</b>";
                       exit;
                   }
               } else {
                   PrintSQL($value);
               }
           }
       }

     case 8:
       DoSQL ($ds, $display, "fwdzone", $tables["fwdzone"]);
       DoSQL ($ds, $display, "fwdzonerec", $tables["fwdzonerec"]);
       DoSQL ($ds, $display, "fwddns", $tables["fwddns"]);
       DoSQL ($ds, $display, "zones", $tables["zones"]);
       DoSQL ($ds, $display, "zonedns", $tables["zonedns"]);


     case 9:
       // should be NOT NULL, but this fails on broken databases like PGSQL
       $sqlarray = $dict->AddColumnSQL("ipaddr", 
          array(array('hname', 'C', '100', 'DEFAULT' => '')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 10:
       // don't add column if we did no 6
       if ($version>=9) {
           // should be NOT NULL, but this fails on broken databases like PGSQL
           $sqlarray = $dict->AddColumnSQL("fwdzone", 
                   array(array('lastmod', 'T', 'DEFAULT' => '', 'Null')));
           $sqlarrayt = $dict->DropColumnSQL("fwdzone", 
                   array('mod'));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->AddColumnSQL("fwdzonerec", 
                   array(array('lastmod', 'T', 'DEFAULT' => '', 'Null')));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->DropColumnSQL("fwdzonerec", 
                   array('mod'));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->AddColumnSQL("zones", 
                   array(array('lastmod', 'T', 'DEFAULT' => '', 'Null')));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->DropColumnSQL("zones", 
                   array('mod'));
           $sqlarray[] = $sqlarrayt[0];

           foreach($sqlarray as $value) {
               if (!$display) {
                   if (!$ds->Execute($value)) {
                       PrintSQL($value);
                       echo "Failed to execute above statement against database<p>";
                       echo "<b>".$ds->ErrorMsg()."</b>";
                       exit;
                   }
               } else {
                   PrintSQL($value);
               }
           }
       }

     case 11:
       // should be NOT NULL, but this fails on broken databases like PGSQL
       $sqlarray = $dict->AddColumnSQL("auditlog", 
                    array(array('userid', 'C', '40', 'DEFAULT' => '')));
       // postgres cannot change a column definition - not my problem!!!
       if (DBF_TYPE=="postgres7") {
           if ($display) {
               $sqlarray[] = "# Postgres cannot change a column definition - I suggest using a database that can";
               $sqlarray[] = "# I WILL NOW DROP AND ADD THE COLUMN AGAIN - THIS WILL CAUSE DATA TO BE LOST IN THE AUDITLOG";
               $sqlarray[] = "# I CANNOT WRITE THE SQL FOR YOU AS IT DOES NOT EXIST - SORRY!";
           }
           $sqlarrayt = $dict->DropColumnSQL("auditlog", 
                   array('action'));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->AddColumnSQL("auditlog", 
                    array(array('action', 'C', '254', 'DEFAULT' => '')));
           $sqlarray[] = $sqlarrayt[0];
       }
       else {
           $sqlarrayt = $dict->AlterColumnSQL("auditlog", 
                   array(array('action', 'C', '254')));
           $sqlarray[] = $sqlarrayt[0];
       }
       if ($version>=9) {
           $sqlarrayt = $dict->AddColumnSQL("fwdzone", 
                   array(array('userid', 'C', '40', 'DEFAULT' => '')));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->AddColumnSQL("fwdzonerec", 
                   array(array('userid', 'C', '40', 'DEFAULT' => '')));
           $sqlarray[] = $sqlarrayt[0];
           $sqlarrayt = $dict->AddColumnSQL("zones", 
                   array(array('userid', 'C', '40', 'DEFAULT' => '')));
           $sqlarray[] = $sqlarrayt[0];
       }
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 12:
       // don't add column if we did no 6
       if ($version>=9) {
           // should be NOT NULL, but this fails on broken databases like PGSQL
           $sqlarray = $dict->AddColumnSQL("fwdzone", 
                   array(array('slaveonly', 'C', '1', 'DEFAULT' => 'N')));
           $sqlarrayt = $dict->AddColumnSQL("zones", 
                   array(array('slaveonly', 'C', '1', 'DEFAULT' => 'N')));
           $sqlarray[] = $sqlarrayt[0];

           foreach($sqlarray as $value) {
               if (!$display) {
                   if (!$ds->Execute($value)) {
                       PrintSQL($value);
                       echo "Failed to execute above statement against database<p>";
                       echo "<b>".$ds->ErrorMsg()."</b>";
                       exit;
                   }
               } else {
                   PrintSQL($value);
               }
           }
       }

     case 13:
       $sqlarray = $dict->AddColumnSQL("ipaddr", 
           array(array('lastpol', 'T')));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 14:
       DoSQL ($ds, $display, "baseadd", $tables["baseadd"]);
       DoSQL ($ds, $display, "custadd", $tables["custadd"]);

     case 15:
       $sqlarrayt = $dict->AddColumnSQL("ipaddr", 
           array(array('macaddr', 'C', '12', 'DEFAULT' => '')));
       $sqlarray[] = $sqlarrayt[0];
       $sqlarrayt = $dict->AddColumnSQL("base", 
           array(array('baseopt', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'INT UNSIGNED':'I8', 'DEFAULT' => 0)));
       $sqlarray[] = $sqlarrayt[0];
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }
     case 16:
       DoSQL ($ds, $display, "requestip", $tables["requestip"]);

     case 17:
       $sqlarray = $dict->AddColumnSQL("grp", 
           array(array('resaddr', (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') ? 'SMALLINT UNSIGNED':'I4', 'DEFAULT' => 0)));
       foreach($sqlarray as $value) {
          if (!$display) {
             if (!$ds->Execute($value)) {
                PrintSQL($value);
                echo "Failed to execute above statement against database<p>";
                echo "<b>".$ds->ErrorMsg()."</b>";
                exit;
             }
          } else {
             PrintSQL($value);
          }
       }

     case 18:
       // change table name from schema to version for mysql 5 compat
       if (DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') {
           $sqlarray = array("RENAME TABLE `schema` TO `version`");
           foreach($sqlarray as $value) {
               if (!$display) {
                   if (!$ds->Execute($value)) {
                       PrintSQL($value);
                       echo "Failed to execute above statement against database<p>";
                       echo "<b>".$ds->ErrorMsg()."</b>";
                       exit;
                   }
               } else {
                   PrintSQL($value);
               }
           }

       }


       // end switch
   }

   if (DBF_TYPE=="mssql" or DBF_TYPE=="ado_mssql" or DBF_TYPE=="odbc_mssql" or
       DBF_TYPE=='mysql' or DBF_TYPE=='maxsql') {
      $sqlarray = array('UPDATE version SET version='.SCHEMA);
   }  
   else {
      $sqlarray = array('UPDATE schema SET version='.SCHEMA);
   }
   if (DBF_TYPE!="mysql") {
      $sqlarray[] = 'COMMIT';
   }
   foreach($sqlarray as $value) {
      if (!$display) {
         if (!$ds->Execute($value)) {
            PrintSQL($value);
            echo "Failed to execute above statement against database<p>";
            echo "<b>".$ds->ErrorMsg()."</b>";
            exit;
         }
      } else {
         PrintSQL($value);
      }
   }
}

function PrintSQL($sqlarray) {

    echo '<pre>';
    echo $sqlarray;
    if (DBF_TYPE=='sybase' or 
        DBF_TYPE=='ado_mssql' or 
        DBF_TYPE=='odbc_mssql' or 
        DBF_TYPE=='mssql') {
        echo "\nGO\n\n";
    }
    else if (DBF_TYPE=='oci8po') {
        echo "\n/\n\n";
    }
    else {
        echo ";\n\n";
    }
//    echo '\n';
    echo '</pre>';

}

//******************************************************************************
// MAIN starts here
//******************************************************************************

// check php version
if (phpversion() < "4.1.0") {
   die("You need php version 4.1.0 or later");
}
// check for regex support
if(!extension_loaded("pcre")) {
   die("You need PERL regular expressions compiled into php (--with-pcre-regex=DIR) - installation cannot continue!");
}

// send output to file for import to database
if ($display==2) {
   // force file download due to bad mime type
   header("Content-Type: bad/type");
   header("Content-Disposition: attachment; filename=schema.sql");
   // capture output for later saving to file - kludge!
   ob_start();
}

/*
// queries return 2M - dump!
echo ini_get("post_max_size");
if (MAXUPLOADSIZE > ini_get("upload_max_filesize")) {
   echo "<p>MAXUPLOADSIZE in config file is larger than the php.ini file<br>";
   echo "file uploads may fail<br>";
}
*/
if (ini_get("safe_mode")) {
   echo "<p>\n\n#php is running in safe mode<br>\n";
   echo "#calls to external programs (nmap, ping, traceroute etc) will not work<br>\n";
   echo "#unless the safe_mode_exec_dir php.ini config option allows execution of these files<br>\n";
}
if(!extension_loaded("xml")) {
   echo "<p>\n\n#xml support not compiled into php<br>\n";
   echo "#some SWIP functions will not work<br>\n";
}
if(!extension_loaded("snmp")) {
   echo "<p>\n\n#snmp support not compiled into php<br>\n";
   echo "#importing from routing tables and direct query of device will not work<br>\n";
}
if(!extension_loaded("gettext")) {
   echo "<p>\n\n#gettext support not compiled into php<br>\n";
   echo "#multilingual support will not work<br>\n";
}
if(extension_loaded("zlib")) {
   echo "<p>\n\n#zlib support compiled into php<br>\n";
   echo "#output to webrowser will be compressed for quicker loading of pages if web browser supports compression<br>\n";
}
else {
   echo "<p>\n\n#zlib support not compiled into php<br>\n";
   echo "#output to webrowser will not be compressed - large pages will load slower<br>\n";
}
$tmp=get_cfg_var("file_uploads");
if (empty($tmp)) {
   echo "<p>\n\n#File uploads may have been disabled in the php.ini configuration file<br>\n";
}
if (!is_writeable(UPLOADDIRECTORY) or !is_readable(UPLOADDIRECTORY)) {
   echo "<p>\n\n#File uploads to ip records may not work - unable to create file in ".UPLOADDIRECTORY." - check permissions<br>\n";
}
if (!is_writeable(DNSEXPORTPATH)) {
   echo "<p>\n\n#DNS zone file exports do not work - unable to create file in ".DNSEXPORTPATH." - check permissions<br>\n";
}
// cannot use is_executable() function here - only for php > 5.x
if (NMAP != "") {
    if (!NmapScan("127.0.0.1/32")) {
       echo "<p>\n\n#Could not execute NMAP as defined by path ".NMAP." - check path<br>\n";
    }
}

echo "\n";

// check some database drivers (not all are checked and may still give errors)
// only check on unix systems - not sure if this works on windows?
if (strncmp(PHP_OS,'WIN',3) != 0) {
   switch (DBF_TYPE) {
     case "mysql":
     case "mysqlt":
     case "maxsql":
        if(!extension_loaded("mysql")) {
           echo "<p>mysql driver not compiled into php - cannot complete install<br>";
           echo "this is a php issue and has nothing to do with IPplan<br>";
           exit;
        }
        break;
     case "mssql":
        if(!extension_loaded("mssql")) {
           echo "<p>mssql driver not compiled into php - cannot complete install<br>";
           echo "this is a php issue and has nothing to do with IPplan<br>";
           exit;
        }
        break;
     case "oci8po":
        if(!extension_loaded("oci8")){
           echo "<p>oci8 driver not compiled into php - cannot complete install<br>";
           echo "this is a php issue and has nothing to do with IPplan<br>";
           exit;
        }
        break;
     case "postgres7":
        if(!extension_loaded("pgsql")) {
           echo "<p>pgsql driver not compiled into php - cannot complete install<br>";
           echo "this is a php issue and has nothing to do with IPplan<br>";
           exit;
        }
        break;
   }
}

// vars from install.php:
// display:
// 0 to execute sql, 1 to only display sql on screen
// new:
// 0 for upgrade, 1 for new install

if ($new) {
   CreateSchema($display);

   if ($display) {
      echo "<b>#The above commands need to be executed by the administrator to create the database schema for IPplan</b>\n";
   }
   else {
      echo "<b>The database schema was created - you can now create users and groups</b>";
   }
}
else {
    if (DBF_TYPE=="postgres7") {
//        echo "# YOU ARE USING POSTGRESS - YOU BETTER READ THE UPGRADE DOC AND THE ONSCREEN COMMENTS CAREFULLY AS UPGRADES DO NOT WORK TOO WELL USING POSTGRESS. YOU ARE BEING FORCED TO ISSUE THE SQL COMMANDS MANUALLY.\n";
 //       $display=1;
    }
   UpdateSchema($display);
   if ($display) {
      echo "<b>#The above commands need to be executed by the administrator to update the database schema for IPplan to v4.50. There may be no commands required.</b>\n";
   }
   else {
      echo "<b>The database schema was updated</b>";
   }
}

// take captured output, strip html and output as file
if ($display==2) {
   $buffer=strip_tags(ob_get_contents());
   ob_end_clean();
   echo "# You may need to remove the comment lines - lines that start with #\n\n";
   echo $buffer;
}
elseif ($display==1) {
   echo '<p>';
   echo '<form NAME="THISFORM" METHOD="post" ACTION="'.$_SERVER["PHP_SELF"].'?display=2&new='.$new.'">';
   echo '<input TYPE="SUBMIT" VALUE="Download as file">';
}
?>
