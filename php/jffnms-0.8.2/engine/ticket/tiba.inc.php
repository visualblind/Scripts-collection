<?
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    
    //Custom Hooks for TIBA Trouble Ticket System (you can modify it to your TT)

    function ticket_tiba_create ($journal_data) {
        return ticket_tiba_internal("create",$journal_data);
    }

    function ticket_tiba_update ($journal_data) {
        return ticket_tiba_internal("update",$journal_data);
    }

    function ticket_tiba_internal ($action,$journal_data) {
	die ("Trouble Ticket System Plugin Not Configured");

        $status = 0;
        $journal_data[action]=$action;

        $journal_data[active]="";
        $journal_data[journal_id]=$journal_data[id];
        $journal_data[id]="";
        $journal_data[date_start]="";
        $journal_data[date_stop]="";

        if ($action=="update") {
            if ($journal_data[update]) $journal_data[comment]=""; //dont send full comment only update
            $journal_data[subject]="";
        }

        $url = "http://ticket/toto.php?";

        foreach ($journal_data as $key=>$aux)
            if (trim($aux)!="") $url.="&$key=".urlencode($aux);

        $data = implode ("", file ($url));

        if ($data) {
            $status = 1;
            //var_dump ($data);
            $ticket = trim($data);
        }
        return array($status, $ticket);
    }

    function ticket_tiba_view ($journal_data) {
        $ticket = $journal_data[ticket];
        $url = "http://ticket/link.php3?urlid=$ticket";
        return array(NULL,$url);
    }


?>