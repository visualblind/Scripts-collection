CD C:\_Admin
wevtutil.exe qe Security /q:*[System[EventID=4740]] /f:text > Lockout.txt
EXIT