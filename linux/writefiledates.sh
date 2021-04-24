find -maxdepth 10 -type d -exec stat -c "%n %y" {} /web/var/www/website/dir > ~/xmlorders.txt;

/web/var/www/website/dir

find /web/var/www/website/dir -maxdepth 10 -type d -printf "%p %TY-%Tm-%Td %TH:%TM:%TS %Tz\n" > ~/xmlorders.txt

