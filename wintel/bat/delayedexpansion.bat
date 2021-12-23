@echo off


REM Example 1
 SetLocal EnableDelayedExpansion
 for  %%a in ("C:\Test\*.txt") do (
     set FileName=%%~a
     echo Filename is: !FileName!
 )
 endlocal


REM Example 2
SetLocal EnableDelayedExpansion
for /f "usebackq delims=: tokens=2" %%a in (`ipconfig ^| findstr IPv4 ^| findstr /r /c:"192.168.40.*"`) do (
    Set "MyIP=%%a"
    Set "MyIP=!MyIP!"
    set "MyIP=!MyIP: =!" 
)
echo MyIP="!MyIP!"
pause