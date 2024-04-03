@echo off
pushd "%~dp0"
if not exist "%PUBLIC%" (
goto z
)

if exist "%temp%\DLC1Temp\Framework35Offline\Framework35Offline.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\Framework35Offline" -y files\Framework35Offline.7z
start "" /D"%temp%\DLC1Temp\Framework35Offline" "Framework35Offline.cmd"
exit
:a
start "" /D"%temp%\DLC1Temp\Framework35Offline" "Framework35Offline.cmd"
exit

:z
start msgbox "Sorry but this only works on Windows 8/10" 0 "OS Errors"
exit