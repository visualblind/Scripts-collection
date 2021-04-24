#!/bin/bash
# Sample script to demonstrate the creation of an HTML report using shell scripting
# Web directory
WEB_DIR=$1
REPORT_FILE=$WEB_DIR/filesystem_report.html
# A little CSS and table layout to make the report look a little nicer
echo "<HTML>
<HEAD>
<style>
.titulo{font-size: 1em; color: white; background:#0863CE; padding: 0.1em 0.2em;}
table
{
border-collapse:collapse;
}
table, td, th
{
border:1px solid black;
}
</style>
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8' />
</HEAD>
<BODY>" > $REPORT_FILE
# View hostname and insert it at the top of the html body
HOST=$(hostname -f)
echo "Filesystem usage for host <strong>$HOST</strong><br>
Last updated: <strong>$(date)</strong><br><br>
<table border='1'>
<tr><th class='titulo'>Filesystem</td>
<th class='titulo'>Size</td>
<th class='titulo'>Use %</td>
</tr>" >> $REPORT_FILE
# Read the output of df -h line by line
while read line; do
echo "<tr><td align='center'>" >> $REPORT_FILE
echo $line | awk '{print $1}' >> $REPORT_FILE
echo "</td><td align='center'>" >> $REPORT_FILE
echo $line | awk '{print $2}' >> $REPORT_FILE
echo "</td><td align='center'>" >> $REPORT_FILE
echo $line | awk '{print $5}' >> $REPORT_FILE
echo "</td></tr>" >> $REPORT_FILE
done < <(df -hT | grep -vi filesystem)
echo "</table></BODY></HTML>" >> $REPORT_FILE
