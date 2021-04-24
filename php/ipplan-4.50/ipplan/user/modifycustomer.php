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

require_once("../ipplanlib.php");
require_once("../adodb/adodb.inc.php");
require_once("../class.dbflib.php");
require_once("../layout/class.layout");
require_once("../auth.php");
require_once("../class.templib.php");

$auth = new SQLAuthenticator(REALM, REALMERROR);

// And now perform the authentication
$grps=$auth->authenticate();

// set language
isset($_COOKIE["ipplanLanguage"]) && myLanguage($_COOKIE['ipplanLanguage']);

//setdefault("window",array("bgcolor"=>"white"));
//setdefault("table",array("cellpadding"=>"0"));
//setdefault("text",array("size"=>"2"));

// explicitly cast variables as security measure against SQL injection
list($cust, $custdescrip, $grp, $org, $street, $city, $state, $zipcode, $cntry, $hname, $ipaddr, $nichandl, $lname, $fname, $mname, $torg, $tstreet, $tcity, $tstate, $tzipcode, $tcntry, $phne, $mbox) = myRegister("I:cust S:custdescrip S:grp S:org S:street S:city S:state S:zipcode S:cntry A:hname A:ipaddr S:nichandl S:lname S:fname S:mname S:torg S:tstreet S:tcity S:tstate S:tzipcode S:tcntry S:phne S:mbox");
list($userfld) = myRegister("A:userfld");  // for template

$formerror="";

if ($cust == 0)
   $title=my_("Create a new customer/autonomous system");
else
   $title=my_("Modify a customer/autonomous system details");
newhtml($p);
$w=myheading($p, $title, true);

$ds=new IPplanDbf() or myError($w,$p, my_("Could not connect to database"));

if ($_POST) {
    
    $custdescrip=trim($custdescrip);

    if (strlen($custdescrip) < 2) {
        $formerror .= my_("The customer description must be longer")."\n";
    }
    if ($cntry == "US" and !preg_match("/[0-9]{5}/",
                $zipcode)) {
        $formerror .= my_("Invalid zipcode")."\n";
    }
    if ($tcntry == "US" and !preg_match("/[0-9]{5}/",
                $tzipcode)) {
        $formerror .= my_("Invalid contact zipcode")."\n";
    }
    if ($mbox and !preg_match("/^[^ \t@|()<>,]+@[^ \t@()<>,]+\\.[^ \t()<>,.]+$/",         $mbox)) {
        $formerror .= my_("Invalid E-mail address")."\n";
    }
    for ($i = 1; $i < 11; $i++) {
        if ($hname[$i] and
                !preg_match("/[^ \t@()<>,]+\\.[^ \t()<>,.]+$/", $hname[$i])) {
            $formerror .= sprintf(my_("Invalid hostname %u"), $i)."\n";
        }
        if ($ipaddr[$i] and testIP($ipaddr[$i])) {
            $formerror .= sprintf(my_("Invalid IP address %u"), $i)."\n";
        }
        if (($hname[$i] and !$ipaddr[$i]) or (!$hname[$i] and $ipaddr[$i])) {
            $formerror .= sprintf(my_("Invalid hostname/IP address combination %u"), $i)."\n";
        }
    }

    // use base template (for additional subnet information)
    $template=NULL;
    if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/custtemplate.xml")) {
        $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/custtemplate.xml");
    }

    $info="";
    if (is_object($template) and $template->is_error() == FALSE) {
        // PROBLEM HERE: if template create suddenly returns error (template file
        // permissions, xml error etc), then each submit thereafter will erase
        // previous contents - this is not good
        $template->Merge($userfld);
        if($err=$template->Verify($w)) {
            $formerror .= my_("Additional information error")."\n";
        }

        if ($template->is_blank() == FALSE) {
            $info=$template->encode();
        }
    }

    if (!$formerror) {
        if (!$ds->TestCustomerCreate($_SERVER[AUTH_VAR])) {
            myError($w,$p, my_("You may not create customers as you are not a member a group that can create customers"));
        }

        $ds->DbfTransactionStart();

        // new record?
        if ($cust == 0) {
            $result=&$ds->ds->Execute("INSERT INTO customer
                    (custdescrip, admingrp)
                    VALUES
                    (".$ds->ds->qstr($custdescrip).",
                     ".$ds->ds->qstr($grp).")");

            // did not fail due to key error?
            if ($result) {
                if (DBF_TYPE=="mysql" or DBF_TYPE=="maxsql") {
                    $cust=$ds->ds->Insert_ID();
                }
                else {
                    // emulate getting the last insert_id
                    $result=&$ds->ds->Execute("SELECT customer 
                            FROM customer
                            WHERE custdescrip=".$ds->ds->qstr($custdescrip));
                    $temprow = $result->FetchRow();
                    $cust=$temprow["customer"];
                }

                $ds->AuditLog(array("event"=>180, "action"=>"create customer", 
                            "user"=>$_SERVER[AUTH_VAR], "cust"=>$cust, "descrip"=>$custdescrip));
                $ds->DbfTransactionEnd();
            }
        }
        else {

            // always need to test - customer could have been deleted
            // result used later
            $result=$ds->GetCustomerInfo($cust);
            // should only be one row here
            if (!$row = $result->FetchRow()) {
                myError($w,$p, my_("Customer cannot be found!"));
            }

            $result=&$ds->ds->Execute("UPDATE customer
                    SET custdescrip=".$ds->ds->qstr($custdescrip).",
                    admingrp=".$ds->ds->qstr($grp)."
                    WHERE customer=$cust");

            // did not fail due to key error?
            if ($result) {
                $ds->AuditLog(array("event"=>181, "action"=>"modify customer", 
                            "user"=>$_SERVER[AUTH_VAR], "cust"=>$cust, "descrip"=>$custdescrip));
                $ds->DbfTransactionEnd();
            }
        }

        // transaction could be rolled back if insert below fails - must
        // start new transaction here
        $ds->DbfTransactionStart();
        if ($result) {

            // must emulate replace here as custinfo record may
            // not exist
            $result=&$ds->ds->Execute("DELETE FROM custinfo
                    WHERE customer=$cust");
            $result=&$ds->ds->Execute("INSERT INTO custinfo
                    (customer, maint, org, street, city, state, zipcode,
                     cntry, nichandl, lname, fname, mname, torg,
                     tstreet, tcity, tstate, tzipcode, tcntry,
                     phne, mbox)
                    VALUES
                    ($cust,
                     ".$ds->ds->qstr("").",
                     ".$ds->ds->qstr($org).",
                     ".$ds->ds->qstr($street).",
                     ".$ds->ds->qstr($city).",
                     ".$ds->ds->qstr($state).",
                     ".$ds->ds->qstr($zipcode).",
                     ".$ds->ds->qstr($cntry).",
                     ".$ds->ds->qstr($nichandl).",
                     ".$ds->ds->qstr($lname).",
                     ".$ds->ds->qstr($fname).",
                     ".$ds->ds->qstr($mname).",
                     ".$ds->ds->qstr($torg).",
                     ".$ds->ds->qstr($tstreet).",
                     ".$ds->ds->qstr($tcity).",
                     ".$ds->ds->qstr($tstate).",
                     ".$ds->ds->qstr($tzipcode).",
                     ".$ds->ds->qstr($tcntry).",
                     ".$ds->ds->qstr($phne).",
                     ".$ds->ds->qstr($mbox).")");

            // delete all the DNS records first to preserve correct order
            $result=&$ds->ds->Execute("DELETE FROM revdns
                    WHERE customer=$cust");

            // add reverse DNS into revdns table
            for ($i = 1; $i < 11; $i++) {
                if ($hname[$i] and $ipaddr[$i]) {
                    $hnametemp=$hname[$i];
                    $ipaddrtemp=$ipaddr[$i];

                    // add DNS records
                    $result=&$ds->ds->Execute("INSERT INTO revdns
                            (customer, hname, ipaddr, horder)
                            VALUES
                            ($cust,
                             ".$ds->ds->qstr($hnametemp).",
                             ".$ds->ds->qstr($ipaddrtemp).",
                             $i)");
                }
            }

            if($ds->ds->GetRow("SELECT customer
                        FROM custadd
                        WHERE customer=$cust")) {   // should have FOR UPDATE here!
                $result = &$ds->ds->Execute("UPDATE custadd
                        SET info=".$ds->ds->qstr($info)."
                        WHERE customer=$cust");
            // this generates a "duplicate key" error if no update
            // should be OK under normal circumstances, but generates error under
            // debug mode turned on
        }
            else {
                if (!empty($info)) {
                    $result = &$ds->ds->Execute("INSERT INTO custadd
                            (info, customer)
                            VALUES
                            (".$ds->ds->qstr($info).", $cust)");
                }
            }

            $ds->DbfTransactionEnd();
            insert($w,text(my_("Customer/autonomous system details modified")));
        }
        else {
            $formerror .= my_("Customer/autonomous system details could not be modified - possibly a duplicate description")."\n";
        }
    }
}

if (!$_POST || $formerror) {
    myError($w,$p, $formerror, FALSE);

    if ($_GET) {
        // always need to test - customer could have been deleted
        // result used later
        $result1=$ds->GetCustomerInfo($cust);
        // should only be one row here
        if (!$row1 = $result1->FetchRow()) {
            myError($w,$p, my_("Customer cannot be found!"));
        }
    }

    // display opening text
    insert($w,heading(3, "$title."));

    $result=$ds->GetGrps();

    $lst=array();
    while($row = $result->FetchRow()) {
        $col=$row["grp"];
        $lst["$col"]=$row["grpdescrip"];
    }
    if (empty($lst)) {
        myError($w,$p, my_("You first need to create some groups!"));
    }

    // start form
    insert($w, $f = form(array("name"=>"ENTRY",
                    "method"=>"post",
                    "action"=>$_SERVER["PHP_SELF"])));

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend, text(my_("Required information")));

    insert($con,textbr(my_("Customer/autonomous system description:")));

    insert($con,hidden(array("name"=>"cust",
                    "value"=>"$cust")));
    myFocus($p, "ENTRY", "custdescrip");
    insert($con,input_text(array("name"=>"custdescrip",
                    "value"=>"$custdescrip",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("Customer/autonomous system admin group:")));
    insert($con,textbr(my_("WARNING: If you choose a group that you do not have access to, you will not be able to see or access the data")));

    insert($con,selectbox($lst,
                array("name"=>"grp"),
                $grp));

    insert($f,submit(array("value"=>my_("Submit"))));
    insert($f,freset(array("value"=>my_("Clear"))));

    if ($_GET) {
        $result2=$ds->GetCustomerDNSInfo($cust);

        $org=$row1["org"];
        $street=$row1["street"];
        $city=$row1["city"];
        $state=$row1["state"];
        $zipcode=$row1["zipcode"];
        $cntry=$row1["cntry"];

        $nichandl=$row1["nichandl"];
        $lname=$row1["lname"];
        $fname=$row1["fname"];
        $mname=$row1["mname"];
        $torg=$row1["torg"];
        $tstreet=$row1["tstreet"];
        $tcity=$row1["tcity"];
        $tstate=$row1["tstate"];
        $tzipcode=$row1["tzipcode"];
        $tcntry=$row1["tcntry"];
        $phne=$row1["phne"];
        $mbox=$row1["mbox"];

        $i=1;
        while($row2 = $result2->FetchRow()) {
            $hname[$i]=$row2["hname"];
            $ipaddr[$i]=$row2["ipaddr"];
            $i++;
        }
    }

    $countrycodes=array(
            ""=>"None",
            "AD"=>"AD   Andorra",
            "AE"=>"AE   United Arab Emirates",
            "AF"=>"AF   Afghanistan",
            "AG"=>"AG   Antigua and Barbuda",
            "AI"=>"AI   Anguilla",
            "AL"=>"AL   Albania",
            "AM"=>"AM   Armenia",
            "AN"=>"AN   Netherlands Antilles",
            "AO"=>"AO   Angola",
            "AQ"=>"AQ   Antarctica",
            "AR"=>"AR   Argentina",
            "AS"=>"AS   American Samoa",
            "AT"=>"AT   Austria",
            "AU"=>"AU   Australia",
            "AW"=>"AW   Aruba",
            "AZ"=>"AZ   Azerbaijan",
            "BA"=>"BA   Bosnia and Herzegovina",
            "BB"=>"BB   Barbados",
            "BD"=>"BD   Bangladesh",
            "BE"=>"BE   Belgium",
            "BF"=>"BF   Burkina Faso",
            "BG"=>"BG   Bulgaria",
            "BH"=>"BH   Bahrain",
            "BI"=>"BI   Burundi",
            "BJ"=>"BJ   Benin",
            "BM"=>"BM   Bermuda",
            "BN"=>"BN   Brunei Darussalam",
            "BO"=>"BO   Bolivia",
            "BR"=>"BR   Brazil",
            "BS"=>"BS   Bahamas",
            "BT"=>"BT   Bhutan",
            "BV"=>"BV   Bouvet Island",
            "BW"=>"BW   Botswana",
            "BY"=>"BY   Belarus",
            "BZ"=>"BZ   Belize",
            "CA"=>"CA   Canada",
            "CC"=>"CC   Cocos (Keeling) Islands",
            "CF"=>"CF   Central African Republic",
            "CG"=>"CG   Congo",
            "CH"=>"CH   Switzerland",
            "CI"=>"CI   Cote D'Ivoire (Ivory Coast)",
            "CK"=>"CK   Cook Islands",
            "CL"=>"CL   Chile",
            "CM"=>"CM   Cameroon",
            "CN"=>"CN   China",
            "CO"=>"CO   Colombia",
            "CR"=>"CR   Costa Rica",
            "CS"=>"CS   Czechoslovakia (former)",
            "CU"=>"CU   Cuba",
            "CV"=>"CV   Cape Verde",
            "CX"=>"CX   Christmas Island",
            "CY"=>"CY   Cyprus",
            "CZ"=>"CZ   Czech Republic",
            "DE"=>"DE   Germany",
            "DJ"=>"DJ   Djibouti",
            "DK"=>"DK   Denmark",
            "DM"=>"DM   Dominica",
            "DO"=>"DO   Dominican Republic",
            "DZ"=>"DZ   Algeria",
            "EC"=>"EC   Ecuador",
            "EE"=>"EE   Estonia",
            "EG"=>"EG   Egypt",
            "EH"=>"EH   Western Sahara",
            "ER"=>"ER   Eritrea",
            "ES"=>"ES   Spain",
            "ET"=>"ET   Ethiopia",
            "FI"=>"FI   Finland",
            "FJ"=>"FJ   Fiji",
            "FK"=>"FK   Falkland Islands (Malvinas)",
            "FM"=>"FM   Micronesia",
            "FO"=>"FO   Faroe Islands",
            "FR"=>"FR   France",
            "FX"=>"FX   France, Metropolitan",
            "GA"=>"GA   Gabon",
            "GB"=>"GB   Great Britain (UK)",
            "GD"=>"GD   Grenada",
            "GE"=>"GE   Georgia",
            "GF"=>"GF   French Guiana",
            "GH"=>"GH   Ghana",
            "GI"=>"GI   Gibraltar",
            "GL"=>"GL   Greenland",
            "GM"=>"GM   Gambia",
            "GN"=>"GN   Guinea",
            "GP"=>"GP   Guadeloupe",
            "GQ"=>"GQ   Equatorial Guinea",
            "GR"=>"GR   Greece",
            "GS"=>"GS   S. Georgia and S. Sandwich Isls.",
            "GT"=>"GT   Guatemala",
            "GU"=>"GU   Guam",
            "GW"=>"GW   Guinea-Bissau",
            "GY"=>"GY   Guyana",
            "HK"=>"HK   Hong Kong",
            "HM"=>"HM   Heard and McDonald Islands",
            "HN"=>"HN   Honduras",
            "HR"=>"HR   Croatia (Hrvatska)",
            "HT"=>"HT   Haiti",
            "HU"=>"HU   Hungary",
            "ID"=>"ID   Indonesia",
            "IE"=>"IE   Ireland",
            "IL"=>"IL   Israel",
            "IN"=>"IN   India",
            "IO"=>"IO   British Indian Ocean Territory",
            "IQ"=>"IQ   Iraq",
            "IR"=>"IR   Iran",
            "IS"=>"IS   Iceland",
            "IT"=>"IT   Italy",
            "JM"=>"JM   Jamaica",
            "JO"=>"JO   Jordan",
            "JP"=>"JP   Japan",
            "KE"=>"KE   Kenya",
            "KG"=>"KG   Kyrgyzstan",
            "KH"=>"KH   Cambodia",
            "KI"=>"KI   Kiribati",
            "KM"=>"KM   Comoros",
            "KN"=>"KN   Saint Kitts and Nevis",
            "KP"=>"KP   Korea (North)",
            "KR"=>"KR   Korea (South)",
            "KW"=>"KW   Kuwait",
            "KY"=>"KY   Cayman Islands",
            "KZ"=>"KZ   Kazakhstan",
            "LA"=>"LA   Laos",
            "LB"=>"LB   Lebanon",
            "LC"=>"LC   Saint Lucia",
            "LI"=>"LI   Liechtenstein",
            "LK"=>"LK   Sri Lanka",
            "LR"=>"LR   Liberia",
            "LS"=>"LS   Lesotho",
            "LT"=>"LT   Lithuania",
            "LU"=>"LU   Luxembourg",
            "LV"=>"LV   Latvia",
            "LY"=>"LY   Libya",
            "MA"=>"MA   Morocco",
            "MC"=>"MC   Monaco",
            "MD"=>"MD   Moldova",
            "MG"=>"MG   Madagascar",
            "MH"=>"MH   Marshall Islands",
            "MK"=>"MK   Macedonia",
            "ML"=>"ML   Mali",
            "MM"=>"MM   Myanmar",
            "MN"=>"MN   Mongolia",
            "MO"=>"MO   Macau",
            "MP"=>"MP   Northern Mariana Islands",
            "MQ"=>"MQ   Martinique",
            "MR"=>"MR   Mauritania",
            "MS"=>"MS   Montserrat",
            "MT"=>"MT   Malta",
            "MU"=>"MU   Mauritius",
            "MV"=>"MV   Maldives",
            "MW"=>"MW   Malawi",
            "MX"=>"MX   Mexico",
            "MY"=>"MY   Malaysia",
            "MZ"=>"MZ   Mozambique",
            "NA"=>"NA   Namibia",
            "NC"=>"NC   New Caledonia",
            "NE"=>"NE   Niger",
            "NF"=>"NF   Norfolk Island",
            "NG"=>"NG   Nigeria",
            "NI"=>"NI   Nicaragua",
            "NL"=>"NL   Netherlands",
            "NO"=>"NO   Norway",
            "NP"=>"NP   Nepal",
            "NR"=>"NR   Nauru",
            "NT"=>"NT   Neutral Zone",
            "NU"=>"NU   Niue",
            "NZ"=>"NZ   New Zealand (Aotearoa)",
            "OM"=>"OM   Oman",
            "PA"=>"PA   Panama",
            "PE"=>"PE   Peru",
            "PF"=>"PF   French Polynesia",
            "PG"=>"PG   Papua New Guinea",
            "PH"=>"PH   Philippines",
            "PK"=>"PK   Pakistan",
            "PL"=>"PL   Poland",
            "PM"=>"PM   St. Pierre and Miquelon",
            "PN"=>"PN   Pitcairn",
            "PR"=>"PR   Puerto Rico",
            "PT"=>"PT   Portugal",
            "PW"=>"PW   Palau",
            "PY"=>"PY   Paraguay",
            "QA"=>"QA   Qatar",
            "RE"=>"RE   Reunion",
            "RO"=>"RO   Romania",
            "RU"=>"RU   Russian Federation",
            "RW"=>"RW   Rwanda",
            "SA"=>"SA   Saudi Arabia",
            "SB"=>"SB   Solomon Islands",
            "SC"=>"SC   Seychelles",
            "SD"=>"SD   Sudan",
            "SE"=>"SE   Sweden",
            "SG"=>"SG   Singapore",
            "SH"=>"SH   St. Helena",
            "SI"=>"SI   Slovenia",
            "SJ"=>"SJ   Svalbard and Jan Mayen Islands",
            "SK"=>"SK   Slovak Republic",
            "SL"=>"SL   Sierra Leone",
            "SM"=>"SM   San Marino",
            "SN"=>"SN   Senegal",
            "SO"=>"SO   Somalia",
            "SR"=>"SR   Suriname",
            "ST"=>"ST   Sao Tome and Principe",
            "SU"=>"SU   USSR (former)",
            "SV"=>"SV   El Salvador",
            "SY"=>"SY   Syria",
            "SZ"=>"SZ   Swaziland",
            "TC"=>"TC   Turks and Caicos Islands",
            "TD"=>"TD   Chad",
            "TF"=>"TF   French Southern Territories",
            "TG"=>"TG   Togo",
            "TH"=>"TH   Thailand",
            "TJ"=>"TJ   Tajikistan",
            "TK"=>"TK   Tokelau",
            "TM"=>"TM   Turkmenistan",
            "TN"=>"TN   Tunisia",
            "TO"=>"TO   Tonga",
            "TP"=>"TP   East Timor",
            "TR"=>"TR   Turkey",
            "TT"=>"TT   Trinidad and Tobago",
            "TV"=>"TV   Tuvalu",
            "TW"=>"TW   Taiwan",
            "TZ"=>"TZ   Tanzania",
            "UA"=>"UA   Ukraine",
            "UG"=>"UG   Uganda",
            "UK"=>"UK   United Kingdom",
            "UM"=>"UM   US Minor Outlying Islands",
            "US"=>"US   United States",
            "UY"=>"UY   Uruguay",
            "UZ"=>"UZ   Uzbekistan",
            "VA"=>"VA   Vatican City State (Holy See)",
            "VC"=>"VC   Saint Vincent and the Grenadines",
            "VE"=>"VE   Venezuela",
            "VG"=>"VG   Virgin Islands (British)",
            "VI"=>"VI   Virgin Islands (U.S.)",
            "VN"=>"VN   Viet Nam",
            "VU"=>"VU   Vanuatu",
            "WF"=>"WF   Wallis and Futuna Islands",
            "WS"=>"WS   Samoa",
            "YE"=>"YE   Yemen",
            "YT"=>"YT   Mayotte",
            "YU"=>"YU   Yugoslavia",
            "ZA"=>"ZA   South Africa",
            "ZM"=>"ZM   Zambia",
            "ZR"=>"ZR   Zaire",
            "ZW"=>"ZW   Zimbabwe");

    $statecodes=array(
            ""=>"None",
            "AL"=>"AL	Alabama",
            "AK"=>"AK	Alaska",
            "AZ"=>"AZ	Arizona",
            "AR"=>"AR	Arkansas",
            "CA"=>"CA	California",
            "CO"=>"CO	Colorado",
            "CT"=>"CT	Connecticut",
            "DE"=>"DE	Delaware",
            "DC"=>"DC	District of Columbia",
            "FL"=>"FL	Florida",
            "GA"=>"GA	Georgia",
            "HI"=>"HI	Hawaii",
            "ID"=>"ID	Idaho",
            "IL"=>"IL	Illinois",
            "IN"=>"IN	Indiana",
            "IA"=>"IA	Iowa",
            "KS"=>"KS	Kansas",
            "KY"=>"KY	Kentucky",
            "LA"=>"LA	Louisiana",
            "ME"=>"ME	Maine",
            "MD"=>"MD	Maryland",
            "MA"=>"MA	Massachusetts",
            "MI"=>"MI	Michigan",
            "MN"=>"MN	Minnesota",
            "MS"=>"MS	Mississippi",
            "MO"=>"MO	Missouri",
            "MT"=>"MT	Montana",
            "NE"=>"NE	Nebraska",
            "NV"=>"NV	Nevada",
            "NH"=>"NH	New Hampshire",
            "NJ"=>"NJ	New Jersey",
            "NM"=>"NM	New Mexico",
            "NY"=>"NY	New York",
            "NC"=>"NC	North Carolina",
            "ND"=>"ND	North Dakota",
            "OH"=>"OH	Ohio",
            "OK"=>"OK	Oklahoma",
            "OR"=>"OR	Oregon",
            "PA"=>"PA	Pennsylvania",
            "PR"=>"PR	Puerto Rico",
            "RI"=>"RI	Rhode Island",
            "SC"=>"SC	South Carolina",
            "SD"=>"SD	South Dakota",
            "TN"=>"TN	Tennessee",
            "TX"=>"TX	Texas",
            "UT"=>"UT	Utah",
            "VT"=>"VT	Vermont",
            "VA"=>"VA	Virginia",
            "WA"=>"WA	Washington (state)",
            "WV"=>"WV	West Virginia",
            "WI"=>"WI	Wisconsin",
            "WY"=>"WY	Wyoming");

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend,text(my_("Customer information (optional)")));

    insert($con,textbr(my_("Organization:")));
    insert($con,input_text(array("name"=>"org",
                    "value"=>"$org",
                    "size"=>"100",
                    "maxlength"=>"100")));

    insert($con,textbrbr(my_("Street:")));
    insert($con,input_text(array("name"=>"street",
                    "value"=>"$street",
                    "size"=>"80",
                    "maxlength"=>"255")));

    insert($con,textbrbr(my_("City:")));
    insert($con,input_text(array("name"=>"city",
                    "value"=>"$city",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("State:")));
    insert($con,selectbox($statecodes,
                array("name"=>"state"), $state));

    insert($con,textbrbr(my_("Zipcode:")));
    insert($con,input_text(array("name"=>"zipcode",
                    "value"=>"$zipcode",
                    "size"=>"10",
                    "maxlength"=>"10")));

    insert($con,textbrbr(my_("Country:")));
    insert($con,selectbox($countrycodes,
                array("name"=>"cntry"), $cntry));

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend,text(my_("Reverse DNS information (optional)")));


    // space for 10 reverse entries
    for ($i=1; $i < 11; $i++) {
        insert($con,textbrbr(sprintf(my_("Hostname %u:"), $i)));
        insert($con,input_text(array("name"=>"hname[".$i."]",
                        "value"=>isset($hname[$i]) ? $hname[$i] : "",
                        "size"=>"80",
                        "maxlength"=>"80")));

        insert($con,textbrbr(sprintf(my_("IP address %u:"), $i)));
        insert($con,input_text(array("name"=>"ipaddr[".$i."]",
                        "value"=>isset($ipaddr[$i]) ? $ipaddr[$i] : "",
                        "size"=>"15",
                        "maxlength"=>"15")));
    }

    insert($f, $con=container("fieldset",array("class"=>"fieldset")));
    insert($con, $legend=container("legend",array("class"=>"legend")));
    insert($legend,text(my_("Technical contact information (optional)")));

    insert($con,textbr(my_("Nickname/handle:")));
    insert($con,input_text(array("name"=>"nichandl",
                    "value"=>"$nichandl",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("Last name/surname:")));
    insert($con,input_text(array("name"=>"lname",
                    "value"=>"$lname",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("First name:")));
    insert($con,input_text(array("name"=>"fname",
                    "value"=>"$fname",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("Middle name:")));
    insert($con,input_text(array("name"=>"mname",
                    "value"=>"$mname",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("Organization:")));
    insert($con,input_text(array("name"=>"torg",
                    "value"=>"$torg",
                    "size"=>"100",
                    "maxlength"=>"100")));

    insert($con,textbrbr(my_("Street:")));
    insert($con,input_text(array("name"=>"tstreet",
                    "value"=>"$tstreet",
                    "size"=>"80",
                    "maxlength"=>"255")));

    insert($con,textbrbr(my_("City:")));
    insert($con,input_text(array("name"=>"tcity",
                    "value"=>"$tcity",
                    "size"=>"80",
                    "maxlength"=>"80")));

    insert($con,textbrbr(my_("State:")));
    insert($con,selectbox($statecodes,
                array("name"=>"tstate"),
                $tstate));

    insert($con,textbrbr(my_("Zipcode:")));
    insert($con,input_text(array("name"=>"tzipcode",
                    "value"=>"$tzipcode",
                    "size"=>"10",
                    "maxlength"=>"10")));

    insert($con,textbrbr(my_("Country:")));
    insert($con,selectbox($countrycodes,
                array("name"=>"tcntry"),
                $tcntry));

    insert($con,textbrbr(my_("Telephone number:")));
    insert($con,input_text(array("name"=>"phne",
                    "value"=>"$phne",
                    "size"=>"20",
                    "maxlength"=>"20")));

    insert($con,textbrbr(my_("E-mail address:")));
    insert($con,input_text(array("name"=>"mbox",
                    "value"=>"$mbox",
                    "size"=>"100",
                    "maxlength"=>"100")));

    $result=&$ds->ds->Execute("SELECT info
            FROM custadd
            WHERE customer=$cust");

    $rowadd = $result->FetchRow();
    $dbfinfo=$rowadd["info"];

    // use base template (for additional subnet information)
    $template=NULL;
    if (is_readable(dirname($_SERVER['SCRIPT_FILENAME'])."/custtemplate.xml")) {
        $template=new IPplanIPTemplate(dirname($_SERVER['SCRIPT_FILENAME'])."/custtemplate.xml");
    }

    if (is_object($template) and $template->is_error() == FALSE) {
        insert($f, $con=container("fieldset",array("class"=>"fieldset")));
        insert($con, $legend=container("legend",array("class"=>"legend")));
        insert($legend, text(my_("Additional information")));

        $template->Merge($template->decode($dbfinfo));
        $template->DisplayTemplate($con);
    }

    insert($f,submit(array("value"=>my_("Submit"))));
    insert($f,freset(array("value"=>my_("Clear"))));
}

printhtml($p);

?>
