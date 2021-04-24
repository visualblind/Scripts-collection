<?	
/* This file is part of JFFNMS
 * Copyright (C) <2002-2005> Javier Szyszlican <javier@szysz.com>
 * This program is licensed under the GNU GPL, full terms in the LICENSE file
 */
    include ("../auth.php"); 
?>
<HTML>
<HEAD>
<style type="text/css">@import url(calendar/calendar-blue2.css);</style>
<script type="text/javascript" src="calendar/calendar_stripped.js"></script>
<script type="text/javascript" src="calendar/calendar-en.js"></script>
<script type="text/javascript" src="calendar/calendar-setup_stripped.js"></script>
<TITLE>Calendar</TITLE>
</HEAD>
<BODY leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<div id="calendar-container"></div>

<SCRIPT>
var select = opener.document.getElementById(opener.dateselect);

var raw_date = select.options[select.selectedIndex].value;
var textdate = raw_date.split('-');
var selected_date = new Date(textdate[0],textdate[1]-1,textdate[2]);

function pad(number,length, padding) {
    var str = '' + number;
    while (str.length < length)
	str = padding + str;
    return str;
}

function dateChanged(calendar) {
    // Beware that this function is called even if the end-user only
    // changed the month/year.  In order to determine if a date was
    // clicked you can use the dateClicked property of the calendar:

    if (calendar.dateClicked) {

	date = calendar.date.getFullYear() + "-" + pad(calendar.date.getMonth()+1, 2,'0') + "-" + pad(calendar.date.getDate(),2,'0');

	opener.SetDate(opener.dateselect, date);
	self.close();
    }
};

Calendar.setup(
    {
        date		: selected_date,
        flat         	: "calendar-container", // ID of the parent element
        flatCallback 	: dateChanged           // our callback function
    }
  );

</SCRIPT>
</BODY>
</HTML>
