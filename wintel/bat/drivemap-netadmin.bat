@echo off
net use K: /delete
net use J: /delete
if %OS% == Windows_NT goto ntlogin

:ntlogin
net use i: /delete
net use i: \\server1\apps /PERSISTENT:NO
net use j: \\server1\departments /PERSISTENT:NO
net use L: \\server1\data /PERSISTENT:NO
net use Y: \\server1\admin /PERSISTENT:NO
goto end

:End
exit