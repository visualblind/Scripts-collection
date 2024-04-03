@echo off
pushd "%~dp0"
if exist "X:\I386\explorer.exe" goto z

if exist "%temp%\DLC1Temp\AdminPasswordResetter\AdminPasswordResetter.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\AdminPasswordResetter" -y files\AdminPasswordResetter.7z
start "" /D"%temp%\DLC1Temp\AdminPasswordResetter" "AdminPasswordResetter.exe"

exit
:a
start "" /D"%temp%\DLC1Temp\AdminPasswordResetter" "AdminPasswordResetter.exe"
exit

:z
start msgbox "Sorry but this only works from Your Windows or Mini Windows 10" 0 "OS Errors"
exit