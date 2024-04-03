@echo off
pushd "%~dp0"
:MAIN
if exist X:\I386\explorer.exe goto runminiwin
if exist X:\bootmgr goto runminiwin
start msgbox "Sorry but this only works from Mini Windows" 0 "OS Errors"
exit

:runminiwin
if exist "%temp%\DLC1Temp\BkavRansomwareScan.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\BkavRansomwareScan.7z
start "" /D"%temp%\DLC1Temp" "BkavRansomwareScan.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "BkavRansomwareScan.exe"