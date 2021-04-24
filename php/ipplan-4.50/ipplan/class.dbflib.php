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
// workaround for funky behaviour of nested includes with older
// versions of php
require_once(dirname(__FILE__)."/config.php");

define("DBF_API_VER", "1");

// generic errors
//$myError[1]    = my_("Could not connect to database");
//$myError[2]    = my_("Incorrect parameters");
//$myError[3]    = my_("Incorrect API version");
//$myError[50]   = my_("Invalid IP address!");
// specific errors for DisplayBase
//$myError[100]  = 

class IPplanDbf {

    var $ds;
    // default search expression type
    var $expr="RLIKE";
    // default size search - larger than
    var $size=0;
    // default dhcp search - 1 to search for DHCP subnets only
    var $dhcp=0;

// open a database connection
    function IPplanDbf() {

        // create a connection id
        $this->ds = &ADONewConnection(DBF_TYPE);
        $this->ds->debug = DBF_DEBUG;
        if (DBF_PERSISTENT) {
            if ($this->ds->
                PConnect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME)) {
                $this->ds->SetFetchMode(ADODB_FETCH_ASSOC);
                return $this->ds;
            }
        }
        else {
            if ($this->ds->
                Connect(DBF_HOST, DBF_USER, DBF_PASSWORD, DBF_NAME) != false) {
                $this->ds->SetFetchMode(ADODB_FETCH_ASSOC);
                return $this->ds;
            }
        }
        // kill connection info if error - probably bogus database name
        unset($this->ds);
        return false;
    }

// start of transaction for transaction aware tables
    function DbfTransactionStart() {

        if (DBF_TRANSACTIONS)
            $this->ds->BeginTrans();

    }

// end of transaction for transaction aware tables
    function DbfTransactionEnd() {

        if (DBF_TRANSACTIONS)
            $this->ds->CommitTrans();

    }

// rollback of transaction for transaction aware tables
    function DbfTransactionRollback() {

        if (DBF_TRANSACTIONS)
            $this->ds->RollBackTrans();

    }

// add a new ipaddress entry in the ipaddr table if it does not already exist
// Else it just updates existing record
    function DeleteIP($ipaddr, $baseindex) {

        // lock the row for update - at the same time get current row
        if($row=$this->GetIPDetails($baseindex, $ipaddr)) {
            // log the entire row to the auditlog for history - field
            // is too small!

            $this->ds->RowLock("ipaddr", "baseindex=$baseindex AND ipaddr=$ipaddr");
        }

        $row["event"]=132;
        $row["user"]=$_SERVER[AUTH_VAR];
        $row["action"]="delete ip details";
        $row["baseindex"]=$baseindex;
        $row["ip"]=inet_ntoa($ipaddr);

        $this->ds->Execute("DELETE FROM ipaddr
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr") and
        $this->ds->Execute("DELETE FROM ipaddradd
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr") and
        $this->AuditLog($row);

    }

// add a new ipaddress entry in the ipaddr table if it does not already exist
// Else it just updates existing record
    function AddIP($ipaddr, $baseindex, $user, $location, $telno, $macaddr, $descrip, $hname, $info) {

        $userid = $_SERVER[AUTH_VAR];

        // add main data to ipaddr table emulate mysql replace
        // (try update, if fails due to non-existant record, them
        // insert) to ipaddr table
        // change to SELECT, test, then UPDATE or INSERT to prevent key errors
        // RE 30/3/2005 - should use FOR UPDATE on SELECT, but don't know compat?
        // did away with using Affected_Rows as this returns 0 if no rec to update

        // THIS GETS DONE TWICE!!! ONCE FOR AUDITLOG AND AGAIN HERE!
        if($this->ds->GetRow("SELECT ipaddr
                FROM ipaddr
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr")) {   // should have FOR UPDATE here!
        $result = &$this->ds->Execute("UPDATE ipaddr
                SET userinf=".$this->ds->qstr($user).",
                location=".$this->ds->qstr($location).",
                telno=".$this->ds->qstr($telno).",
                macaddr=".$this->ds->qstr($macaddr).",
                descrip=".$this->ds->qstr($descrip).",
                hname=".$this->ds->qstr($hname).",
                lastmod=".$this->ds->DBTimeStamp(time()).",
                userid=".$this->ds->qstr($userid)."
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr");
        }
        else {
            $result = &$this->ds->Execute("INSERT INTO ipaddr
                    (userinf, location, telno, macaddr, descrip, hname,
                     baseindex, ipaddr, lastmod, userid)
                    VALUES
                    (".$this->ds->qstr($user).",
                     ".$this->ds->qstr($location).",
                     ".$this->ds->qstr($telno).",
                     ".$this->ds->qstr($macaddr).",
                     ".$this->ds->qstr($descrip).",
                     ".$this->ds->qstr($hname).",
                     $baseindex, 
                     $ipaddr,
                     ".$this->ds->DBTimeStamp(time()).",
                     ".$this->ds->qstr($userid).")");
        }

        // always try to update record - record could not exist, which
        // is OK, but always add record if info is not blank

        // AddIP could be called from import functions or create subnet
        // to add DNS or nmap records - do not add record if info is empty - waste?
        // add serialized info from userdefined template
        // to ipaddradd table
        if($this->ds->GetRow("SELECT ipaddr
                FROM ipaddradd
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr")) {   // should have FOR UPDATE here!
            $result = &$this->ds->Execute("UPDATE ipaddradd
                    SET info=".$this->ds->qstr($info)."
                    WHERE baseindex=$baseindex AND
                    ipaddr=$ipaddr");
        // this generates a "duplicate key" error if no update
        // should be OK under normal circumstances, but generates error under
        // debug mode turned on
        }
        else {
            if (!empty($info)) {
                $result = &$this->ds->Execute("INSERT INTO ipaddradd
                        (info, baseindex, ipaddr)
                        VALUES
                        (".$this->ds->qstr($info).",
                         $baseindex,
                         $ipaddr)");
            }
        }
    }

// update an existing IP record - only updates relevant field
    function UpdateIP($ipaddr, $baseindex, $field, $value) {

        $userid = $_SERVER[AUTH_VAR];

        $result = &$this->ds->Execute("UPDATE ipaddr
                           SET $field=".$this->ds->qstr($value).",
                              lastmod=".$this->ds->DBTimeStamp(time()).",
                              userid=".$this->ds->qstr($userid)."
                           WHERE baseindex=$baseindex AND ipaddr=$ipaddr");

        // record does not exist, error
        return $this->ds->Affected_Rows();
    }

// modify a single ip address or range
// supply baseindex as arg
// assumes info is valid!!!
    function ModifyIP($ipaddr, $baseindex, $user, $location,
                      $telno, $macaddr, $descrip, $hname, $info) {

        if (is_array($ipaddr)) {
            // dont use REPLACE here as maybe only one field
            // must be updated causing others to be cleared!!!
            foreach($ipaddr as $value) {

                // lock the row for update - at the same time get current row
                if($row=$this->GetIPDetails($baseindex, $value)) {
                    // log the entire row to the auditlog for history - field
                    // is too small!
                    // probably better to rather just insert into a duplicate
                    // ipaddr table, or to have a trigger event do something
                    $row["event"]=130;
                    $row["user"]=$_SERVER[AUTH_VAR];
                    $row["action"]="log old row contents";
                    $row["baseindex"]=$baseindex;
                    $row["ip"]=inet_ntoa($value);
                    $this->AuditLog($row);

                    $this->ds->RowLock("ipaddr", "baseindex=$baseindex AND ipaddr=$value");
                }

                if ($user) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "userinf", $user))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                if ($location) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "location",
                                $location))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                if ($descrip) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "descrip",
                                $descrip))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                if ($telno) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "telno", $telno))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                if ($macaddr) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "macaddr", $macaddr))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                // special case - called from DNS scripts to update hostname field
                if ($hname) {
                    if (!$this->
                            UpdateIP($value, $baseindex, "hname", $hname))
                        $this->AddIP($value, $baseindex, $user,
                                $location, $telno, $macaddr, $descrip, $hname, $info);
                }
                // this does not generate a trigger if multiple recs are updated!!!
                $this->
                    AuditLog(sprintf
                            (my_
                             ("User %s modified ip details %s index %u"),
                             $_SERVER[AUTH_VAR],
                             inet_ntoa($value), $baseindex));
            }
        }
        else {
            // lock the row for update - at the same time get current row
            if($row=$this->GetIPDetails($baseindex, $ipaddr)) {
                // log the entire row to the auditlog for history - field
                // is too small!
                // probably better to rather just insert into a duplicate
                // ipaddr table, or to have a trigger event do something
                $row["event"]=130;
                $row["user"]=$_SERVER[AUTH_VAR];
                $row["action"]="log old row contents";
                $row["baseindex"]=$baseindex;
                $row["ip"]=inet_ntoa($ipaddr);
                $this->AuditLog($row);
                    
                $this->ds->RowLock("ipaddr", "baseindex=$baseindex AND ipaddr=$ipaddr");
            }
            $this->AddIP($ipaddr, $baseindex, $user, $location, $telno, $macaddr,
                         $descrip, $hname, $info);
            $this->AuditLog(array("event"=>131, "action"=>"modify ip details", "ip"=>inet_ntoa($ipaddr),
                    "user"=>$_SERVER[AUTH_VAR], "ipaddr"=>$ipaddr, "baseindex"=>$baseindex,
                    "userinf"=>$user, "location"=>$location, "telno"=>$telno, "macaddr"=>$macaddr, 
                    "descrip"=>$descrip, "hname"=>$hname));
        }
    }

// create a new subnet
// baseaddr is an int, not an ip address
// assumes info is valid!!!
// returns the last inserted baseindex, 0 on failure
    function CreateSubnet($baseaddr, $subnetsize, $descrip, $cust, $dhcp, $grp) {

        $userid = $_SERVER[AUTH_VAR];

        // no other options defined for baseopt, so always make 1 or 0
        $result = &$this->ds->Execute("INSERT INTO base
                              (baseaddr, subnetsize, descrip, admingrp,
                               baseopt, customer, userid, lastmod)
                           VALUES
                              ($baseaddr, $subnetsize,
                              ".$this->ds->qstr($descrip).",
                              ".$this->ds->qstr($grp).",
                               $dhcp,
                               $cust,
                              ".$this->ds->qstr($userid).",
                              ".$this->ds->DBTimeStamp(time()).")");

        if (DBF_TYPE == "mysql" or DBF_TYPE == "maxsql") {
            return $this->ds->Insert_ID();
        }
        else {
            // emulate getting the last insert_id
            $result = &$this->ds->Execute("SELECT baseindex 
                               FROM base
                               WHERE baseaddr=$baseaddr AND customer=$cust");
            $temprow = $result->FetchRow();
            return $temprow["baseindex"];
        }
    }

// check if user is part of customer admin group
    function TestCustomerGrp($baseindex, $userid) {

        // could use GetRow here
        $result = &$this->ds->Execute("SELECT customer.admingrp AS admingrp
                            FROM base, customer, usergrp
                            WHERE base.baseindex=$baseindex AND
                               base.customer=customer.customer AND
                               customer.admingrp=usergrp.grp AND
                               usergrp.userid=".$this->ds->qstr($userid));

        if ($row = $result->FetchRow()) {
            return $row["admingrp"];
        }
        else
            return 0;

    }

// check if user can create/modify customers
    function TestCustomerCreate($userid) {

        // could use GetRow here
        $result = &$this->ds->Execute("SELECT usergrp.grp
                            FROM usergrp, grp
                            WHERE usergrp.userid=".$this->ds->qstr($userid)." AND
                               usergrp.grp=grp.grp AND
                               grp.createcust=".$this->ds->qstr('Y'));

        if ($row = $result->FetchRow()) {
            return $row["grp"];
        }
        else
            return 0;

    }

// find the subnets admin group
    function GetBaseGrp($baseindex) {

        // could use GetRow here
        $result = &$this->ds->Execute("SELECT admingrp
                           FROM base
                           WHERE baseindex=$baseindex");

        if ($row = $result->FetchRow()) {
            return $row["admingrp"];
        }
        else
            return 0;

    }

// delete a subnet
// supply baseindex as arg
// assumes info is valid!!!
// no need for customer as baseindex makes delete unique!!!
    function DeleteSubnet($baseindex) {

        $result = &$this->ds->Execute("DELETE FROM base
                         WHERE baseindex=$baseindex") and 
        $result = &$this->ds->Execute("DELETE FROM ipaddr
                         WHERE baseindex=$baseindex") and
        $result = &$this->ds->Execute("DELETE FROM baseadd
                         WHERE baseindex=$baseindex");

        return $result;
    }

// takes groups array and generates SQL for where clause
    function grpSQL($grps) {

        $string = " IN (";
        foreach($grps as $value) {
            $string .= $this->ds->qstr($value).",";
        }
        return substr($string, 0, -1).")";
    }

// test if subnets overlap within a customer only
// no need to pass groups as validity of user to access this customer
// would have been determined already through user auth
    function GetDuplicateSubnet($baseaddr, $subnetsize, $cust) {

        // get baseaddr and subnetsize so that info is available for
        // importbase - we need to check for EXACT matches there
        return $this->ds->
            Execute("SELECT baseaddr, subnetsize, baseindex, descrip,
                            lastmod, userid, swipmod
                         FROM base
                         WHERE (($baseaddr BETWEEN baseaddr AND 
                            baseaddr + subnetsize - 1) OR
                            ($baseaddr < baseaddr AND 
                            $baseaddr+$subnetsize > 
                               baseaddr + subnetsize - 1)) AND
                            customer=$cust");
    }

// test if bounds overlap, ie. group can interact with subnet
// returns 1 if action allowed (create etc), zero if action not allowed
    function TestBounds($boundsaddr, $boundssize, $grp) {

        $result = &$this->ds->Execute("SELECT count(*) AS cnt
                         FROM bounds
                         WHERE grp=".$this->ds->qstr($grp));
        $row = $result->FetchRow();
        // no bounds, group can do anything
        if ($row["cnt"] == 0) {
            return 1;
        }

        $result = &$this->ds->Execute("SELECT boundsaddr
                               FROM bounds
                               WHERE (($boundsaddr BETWEEN boundsaddr AND 
                                  boundsaddr + boundssize - 1) AND
                                  ($boundsaddr+$boundssize-1 BETWEEN boundsaddr AND 
                                      boundsaddr + boundssize - 1)) AND
                                  grp=".$this->ds->qstr($grp));

        if ($result->FetchRow()) {
            return 1;
        }
        return 0;
    }

// test if subnets overlap between customers - looks at all customers
// need groups here as some users may not see all customers
    function GetDuplicateSubnetAll($baseaddr, $subnetsize, $grps = 0) {

        $sql = "";

        if (!empty($grps)) {
            if (!$this->TestGrpsAdmin($grps)) {
                // add groups to search in if required - no index here!!!
                $sql .= " AND customer.admingrp ".$this->grpSQL($grps);
            }
        }

        return $this->ds->
            Execute("SELECT base.baseaddr, base.subnetsize, base.baseindex,
                            base.descrip, customer.custdescrip, 
                            customer.customer, base.lastmod, base.userid, 
                            base.swipmod
                         FROM base, customer
                         WHERE (($baseaddr BETWEEN base.baseaddr AND 
                            base.baseaddr + base.subnetsize - 1) OR
                            ($baseaddr < base.baseaddr AND 
                            $baseaddr+$subnetsize > 
                               base.baseaddr + base.subnetsize - 1)) AND
                            base.customer = customer.customer
                            $sql");
    }

// find base address info from an area
// not all fields are used, but get them anyway so function is
// more generic
// if all customer, must filter on groups
    function GetBaseFromArea($areaindex, $descrip, $cust, $grps = 0) {

        $sql = "";

        if ($descrip) {
            $sql=$this->mySearchSql("base.descrip", $this->expr, $descrip);
        }
        // does user want to search on subnet size?
        if ($this->size > 0) {
            $sql.=" AND base.subnetsize > $this->size ";
        }

        // if duplicate ranges allowed we need to suppress them
        // take care of order here relative to other SQL
        if ($cust == 0) {
            if (!empty($grps)) {
                if (!$this->TestGrpsAdmin($grps)) {
                    // add groups to search in if required - no index here!!!
                    // add at begining of SQL due to GROUP by above!
                    $sql.= " AND customer.admingrp ".$this->grpSQL($grps);
                }
            }
            return $this->ds->
                Execute("SELECT DISTINCT base.baseindex, base.subnetsize, 
                              base.descrip, base.baseaddr, base.admingrp,
                              base.lastmod, base.userid, base.swipmod,
                              customer.custdescrip, customer.customer
                            FROM base, range, customer
                            WHERE range.areaindex=$areaindex 
                              AND base.baseaddr BETWEEN range.rangeaddr 
                              AND range.rangeaddr+range.rangesize-1 
                              AND base.customer=customer.customer
                              $sql
                            ORDER BY
                               base.baseaddr");
        }
        else {
            return $this->ds->
                Execute("SELECT DISTINCT base.baseindex, base.subnetsize, 
                              base.descrip, base.baseaddr, base.admingrp,
                              base.lastmod, base.userid, base.swipmod
                            FROM base, range
                            WHERE range.areaindex=$areaindex 
                              AND base.baseaddr BETWEEN range.rangeaddr 
                              AND range.rangeaddr+range.rangesize-1 
                              AND base.customer=$cust
                              AND range.customer=$cust
                              $sql
                            ORDER BY
                               base.baseaddr");
        }
    }

// find base address info
// not all fields are used, but get them anyway so function is
// more generic
    function GetBase($startnum, $endnum, $descrip, $cust, $grps = 0) {

        $sql = "";
        
        if ($descrip) {
            $sql=$this->mySearchSql("base.descrip", $this->expr, $descrip);
        }
        // does user want to search on subnet size?
        if ($this->size > 0) {
            $sql.=" AND base.subnetsize > $this->size ";
        }
        // NOTE: this should be & if there are additional bit masks
        if ($this->dhcp > 0) {
            $sql.=" AND base.baseopt > 0 ";
        }

        if ($cust == 0) {
            if (!empty($grps)) {
                if (!$this->TestGrpsAdmin($grps)) {
                    // add groups to search in if required - no index here!!!
                    $sql .= " AND customer.admingrp ".$this->grpSQL($grps);
                }
            }
            return $this->ds->
                Execute("SELECT base.baseindex, base.subnetsize, 
                              base.descrip, base.baseaddr, base.admingrp, 
                              base.lastmod, base.userid, base.swipmod,
                              customer.custdescrip, customer.customer
                            FROM base, customer
                            WHERE base.baseaddr BETWEEN $startnum AND $endnum 
                              AND base.customer=customer.customer
                              $sql
                            ORDER BY
                               base.baseaddr");
        }
        else {
            return $this->ds->
                Execute("SELECT base.baseindex, base.subnetsize, 
                              base.descrip, base.baseaddr, base.admingrp, 
                              base.lastmod, base.userid, base.swipmod
                            FROM base
                            WHERE base.baseaddr BETWEEN $startnum AND $endnum 
                              $sql
                              AND base.customer=$cust
                            ORDER BY
                               base.baseaddr");
        }
    }

// find base address info from a baseindex
// added customer as field - required as backlink in modifyipform - 13/3/2005
    function GetBaseFromIndex($baseindex) {

        return $this->ds->Execute("SELECT baseindex, subnetsize, 
                             descrip, baseaddr, swipmod, customer,
                             baseopt
                           FROM base
                           WHERE baseindex=$baseindex");
    }

// find base address info from a ip
    function GetBaseFromIP($ip, $cust) {

        // query looks odd, but record may not exist, but would still
        // like to know which baseaddr it should belong to
        return $this->ds->Execute("SELECT baseindex, subnetsize, 
                             descrip, baseaddr
                           FROM base
                           WHERE $ip BETWEEN baseaddr AND
                              baseaddr+subnetsize-1 AND
                              customer=$cust");
    }

// get all the ip records from a subnet based on a baseindex
// could return nothing as there are no records in database for
// entries where all fields are blank
    function GetSubnetDetails($baseindex, $sql="") {

        // no use converting ipaddr to quad as there may be holes in database
        // which needs to be calculated at runtime
        return $this->ds->Execute("SELECT userinf, location, telno, 
                             descrip, hname, ipaddr, lastmod, userid, lastpol
                           FROM ipaddr
                           WHERE baseindex=$baseindex $sql
                           ORDER BY
                              ipaddr");
    }

// get one ip record from a subnet based on a baseindex and ipaddr
// could return nothing as there are no records in database for
// entries where all fields are blank
    function GetIPDetails($baseindex, $ipaddr) {

        // no use converting ipaddr to quad as there may be holes in database
        // which needs to be calculated at runtime
        return $this->ds->GetRow("SELECT userinf, location, telno, 
                             descrip, hname, ipaddr, lastmod, userid
                           FROM ipaddr
                           WHERE baseindex=$baseindex AND ipaddr=$ipaddr");
    }

// update the poll date of the address - will add a record if required
    function UpdateIPPoll($baseindex, $ipaddr) {

        $result = $this->ds->Execute("UPDATE ipaddr
                SET lastpol=".$this->ds->DBTimeStamp(time())."
                WHERE baseindex=$baseindex AND
                ipaddr=$ipaddr");
        if ($this->ds->Affected_Rows() == 0) {
            $result = $this->ds->Execute("INSERT INTO ipaddr
                    (userinf, location, telno, descrip, hname,
                     baseindex, ipaddr, lastmod, lastpol, userid)
                    VALUES
                    (".$this->ds->qstr("").",
                     ".$this->ds->qstr("").",
                     ".$this->ds->qstr("").",
                     ".$this->ds->qstr("Unknown - added by IPplan poller").",
                     ".$this->ds->qstr("").",
                     $baseindex, 
                     $ipaddr,
                     ".$this->ds->DBTimeStamp(time()).",
                     ".$this->ds->DBTimeStamp(time()).",
                     ".$this->ds->qstr("POLLER").")");
        }

    }

// check if user has full rights to view everthing
    function TestGrpsAdmin($grps) {

        if (!empty($grps)) {
            $result = $this->GetGrpsInfo($grps);
            while ($row = $result->FetchRow()) {
                if ($row["grpopt"] & 1)
                    return TRUE;
            }
        }
        return FALSE;

    }

// get all the customer info
    function GetGrps() {

        return $this->ds->Execute("SELECT grpdescrip, grp
                            FROM grp
                            ORDER BY grpdescrip");
    }

// get all the info for groups user belongs to
// don't pass empty grps array as you will generate database error
    function GetGrpsInfo($grps) {

        $sql = $this->grpSQL($grps);

        return $this->ds->
            Execute("SELECT grpdescrip, grp, createcust, grpopt
                            FROM grp
                            WHERE grp $sql");
    }

// get all the customers
    function GetCustomer($sql="") {

        if (empty($sql)) {
            return $this->ds->Execute("SELECT custdescrip, customer, admingrp
                    FROM customer
                    ORDER BY custdescrip");
        }
        else {
            return $this->ds->Execute("SELECT custdescrip, customer, admingrp
                    FROM customer
                    WHERE $sql
                    ORDER BY custdescrip");
        }
    }

// get all the customer info
    function GetCustomerInfo($cust) {

        return $this->ds->Execute("SELECT *
                               FROM custinfo
                               WHERE customer=$cust");
    }

// get all the customer DNS info
    function GetCustomerDNSInfo($cust) {

        return $this->ds->Execute("SELECT hname, ipaddr
                               FROM revdns
                               WHERE customer=$cust
                               ORDER BY horder");
    }

// get customer description
    function GetCustomerDescrip($cust) {

        $row = $this->ds->GetRow("SELECT custdescrip
                            FROM customer
                            WHERE customer=$cust");

        return $row["custdescrip"];

    }

// get particular customer group info
// if cust = 0, get info for all customers
// autoincrement field cannot be 0, so database integrity retained
    function GetCustomerGrp($cust) {

        if ($cust == 0) {
            return $this->ds->
                Execute("SELECT custdescrip, customer, admingrp
                            FROM customer
                            ORDER BY custdescrip");
        }
        else {
            return $this->ds->
                Execute("SELECT custdescrip, customer, admingrp
                            FROM customer
                            WHERE customer=$cust");
        }
    }

// get all the range info
    function GetRangeInArea($cust, $areaindex) {

        return $this->ds->
            Execute("SELECT rangeaddr, rangesize, descrip, rangeindex
                            FROM range
                            WHERE areaindex=$areaindex
                            ORDER BY rangeaddr");
    }

// get all the range info
    function GetRange($cust, $rangeindex) {

        if (!$rangeindex) {
            return $this->ds->
                Execute("SELECT rangeaddr, rangesize, descrip, rangeindex
                               FROM range
                               WHERE customer=$cust
                               ORDER BY rangeaddr");
        }
        else {
            return $this->ds->
                Execute("SELECT rangeaddr, rangesize, descrip, rangeindex
                               FROM range
                               WHERE rangeindex=$rangeindex
                               ORDER BY rangeaddr");
        }
    }

// get all the area info
    function GetArea($cust, $areaindex) {

        // all areas for customer
        if ($areaindex==0) {
            return $this->ds->Execute("SELECT areaaddr, descrip, areaindex
                               FROM area
                               WHERE customer=$cust
                               ORDER BY areaaddr");
        }
        // only areas that have ranges defined
        else if ($areaindex==-1) {
            return $this->ds->Execute("SELECT area.areaaddr, area.descrip, area.areaindex
                               FROM area, range
                               WHERE area.customer=$cust AND 
                                range.areaindex=area.areaindex
                               ORDER BY area.areaaddr");
        }
        // get specific area
        else {
            return $this->ds->Execute("SELECT areaaddr, descrip, areaindex
                               FROM area
                               WHERE areaindex=$areaindex
                               ORDER BY areaaddr");
        }
    }

// get md5 checksum of records to change
// ip is an integer ip address or array of integer ip addresses
    function GetMD5($ip, $baseindex) {

        $sql="";
        if (is_array($ip)) {
            foreach($ip as $value) {
                $sql .= "$value,";
            }
        }
        else {
            $sql = "$ip,";
        }
        // chop extra , if array was passed
        $sql = substr($sql, 0, strlen($sql) - 1);

        // optimised for mysql
        if (DBF_TYPE == "mysql" or DBF_TYPE == "maxsql") {
            $result =
                &$this->ds->Execute("SELECT md5(sum(lastmod)) AS md5str
                             FROM ipaddr
                             WHERE ipaddr IN($sql) AND baseindex=$baseindex
                             GROUP BY lastmod");

            $row = $result->FetchRow();
            return $row["md5str"];
        }
        else {
            $result = &$this->ds->Execute("SELECT lastmod
                             FROM ipaddr
                             WHERE ipaddr IN($sql) AND baseindex=$baseindex");

            $md5str="";
            while ($row = $result->FetchRow()) {
                $md5str .= $row["lastmod"];
            }
            return md5($md5str);
        }
    }

// put some stuff in the audit log
// $message is either a string or 
// $message is associative array with at least one index called "event"
// if you do not want to send a trigger, use a string as parameter
// events must be unique, user_trigger function is in ipplanlib.php
// eg array("event"=>100)
// eg array("event"=>100, "action"=>"add zone", "domain"=>"example.com")
// see TRIGGERS file for more info
    function AuditLog($message) {

        if (AUDIT) {
            if (is_string($message)) {
                $this->ds->Execute("INSERT INTO auditlog
                        (action, userid, dt)
                        VALUES
                        (".$this->ds->qstr(substr($message,0,254)).",
                         ".$this->ds->qstr(isset($_SERVER[AUTH_VAR]) ? $_SERVER[AUTH_VAR] : "").",
                         ".$this->ds->DBTimeStamp(time()).")");
            }
            else if (is_array($message)) {
                // step through array
                $newmsg="";
                foreach ($message as $key=>$value) {
                    $newmsg .= "$key=$value, ";
                }
                $newmsg = substr($newmsg, 0, strlen($newmsg)-2);
                // message could be long, so wrap over multiple log lines
                $msgarr = explode("\n", wordwrap($newmsg, 250, "\n... "));

                foreach($msgarr as $value) {
                    $this->ds->Execute("INSERT INTO auditlog
                            (action, userid, dt)
                            VALUES
                            (".$this->ds->qstr(substr($value,0,254)).",
                             ".$this->ds->qstr($_SERVER[AUTH_VAR]).",
                             ".$this->ds->DBTimeStamp(time()).")");
                }

                // call external trigger function
                if (EXT_FUNCTION) {
                    user_trigger($message);
                }
            }

        }
    }

    // build an sql query for the search - $var contain field, type is expression,
    // search is what to search for
    // returns nothing if no search
    function mySearchSql($var, $expr, $search, $addand=TRUE) {

        $sql="";
        if (!empty($search)) {
            switch ($expr) {
                case "NLIKE":
                    $sql="$var NOT LIKE ".$this->ds->qstr("%$search%");
                    break;
                case "EXACT":
                    $sql="$var = ".$this->ds->qstr("$search");
                    break;
                case "RLIKE":
                // default is RLIKE, need to protect for DBF's without RLIKE
                    if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
                        $sql="$var RLIKE ".$this->ds->qstr("$search");
                        break;
                    }
                    if (DBF_TYPE=="postgres7") {
                         $sql="$var ~ ".$this->ds->qstr("$search");
                        break;
                    }
                case "NRLIKE":
                    if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
                        $sql="$var NOT RLIKE ".$this->ds->qstr("$search");
                        break;
                    }
                    if (DBF_TYPE=="postgres7") {
                        $sql="$var NOT ~ ".$this->ds->qstr("$search");
                        break;
                    }
                case "LIKE":
                    $sql="$var LIKE ".$this->ds->qstr("%$search%");
                    break;
                case "END":
                    $sql="$var LIKE ".$this->ds->qstr("%$search");
                    break;
                // default is START search
                default:
                    $sql="$var LIKE ".$this->ds->qstr("$search%");
            }
            // should there be an AND?
            if ($addand) {
                $sql = "AND ".$sql;
            }
        }

        return $sql;

    }

}

class Base extends IPplanDbf {

    // form variables
    var $cust;
    var $areaindex;
    var $rangeindex;
    var $ipaddr = "";
    var $searchin = 0;
    var $descrip = "";
    // local class variables
    var $grps;
    var $custdescrip = "";
    var $site = "";
    var $start;
    var $end;
    var $subnetsize = 0;   // used for searching over a range - called from findfree
    var $errstr = "";
    var $err = 0;

    function SetGrps($grps) {

        $this->grps = $grps;

    }

    function SetIPaddr($ipaddr) {

        $this->ipaddr = $ipaddr;

    }

    function SetSearchIn($searchin) {

        $this->searchin = $searchin;

    }

    function SetDescrip($descrip) {

        $this->descrip = $descrip;

    }

    // if size is set, SetIPaddr must be called
    function SetSubnetSize($subnetsize) {

        $this->subnetsize = $subnetsize;

    }

    function FetchBase($cust, $areaindex, $rangeindex) {

        // use local function variables as they may change
        $this->cust = $cust;
        $this->rangeindex = $rangeindex;
        $this->areaindex = $areaindex;

        // set start and end address according to range
        if ($this->rangeindex) {
            // should only return one row here!
            $result = $this->GetRange($this->cust, $this->rangeindex);
            $row = $result->FetchRow();

            $this->start = inet_ntoa($row["rangeaddr"]);
            $this->end =
                inet_ntoa($row["rangeaddr"] + $row["rangesize"] - 1);
            $this->site = " (".$row["descrip"].")";
        }
        else {
            if ($this->ipaddr) {
                if ($this->subnetsize) {
                    $this->start = $this->ipaddr;
                    $this->end = inet_ntoa(inet_aton($this->ipaddr)+$this->subnetsize-1);
                }
                else {
                    $this->start = completeIP($this->ipaddr, 1);
                    $this->end = completeIP($this->ipaddr, 2);
                }

                if (testIP($this->start) or testIP($this->end)) {
                    $this->err = 50;    // Invalid IP address!
                    $this->errstr = my_("Invalid IP address!");
                    return FALSE;
                }
            }
            else {
                $this->start = DEFAULTROUTE;
                $this->end = ALLNETS;
            }
        }

        $startnum = inet_aton($this->start);
        $endnum = inet_aton($this->end);

        // pager could have made cust = 0
        if ($this->cust == 0) {
            $this->custdescrip = "All";
        }
        else {
            $this->custdescrip = $this->GetCustomerDescrip($this->cust);
        }
        if (strtolower($this->custdescrip) == "all")
            $this->cust = 0;

        if ($this->areaindex and ! $this->rangeindex) {
            $result =
                $this->GetBaseFromArea($this->areaindex, $this->descrip,
                                       $this->cust, $this->grps);
        }
        else {

            // search in subnet - finds subnets with exact ip address match
            // useful for finding from where an attack comes if you have IP
            if ($this->searchin == 0) {
                $result =
                    $this->GetBase($startnum, $endnum, $this->descrip,
                                   $this->cust, $this->grps);
            }
            else {
                if ($this->cust == 0) {
                    $result =
                        $this->GetDuplicateSubnetAll($startnum, 1,
                                                     $this->grps);
                }
                else {
                    $result =
                        $this->GetDuplicateSubnet($startnum, 1,
                                                  $this->cust);
                }
            }
        }

        return $result;
    }
}

?>
