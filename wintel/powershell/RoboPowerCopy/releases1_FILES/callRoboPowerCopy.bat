@ECHO OFF
set cmd= 
:Loop
IF "%~1"=="" GOTO Continue

set cmd=%cmd% '%~1' 

SHIFT
GOTO Loop
:Continue

echo %cmd%
powershell.exe -command "&'.\roboPowerCopy.ps1' %cmd%"
pause