@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwin
if exist X:\bootmgr goto runminiwin

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\TotalUninstall\App\Tu\Tu.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\TotalUninstall" -y files\TotalUninstall.7z
start "" /D"%temp%\DLC1Temp\TotalUninstall\App\Tu" "Tu.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\TotalUninstall\App\Tu" "Tu.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\TotalUninstall\App\Tu64\Tu.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\TotalUninstall" -y files\TotalUninstall.7z
start "" /D"%temp%\DLC1Temp\TotalUninstall\App\Tu64" "Tu.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\TotalUninstall\App\Tu64" "Tu.exe"
exit

:runminiwin
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit