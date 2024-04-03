@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwinxp

rem if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64

if exist "%temp%\DLC1Temp\CentBrowser\CentBrowser.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CentBrowser" -y files\CentBrowser.7z
start "" /D"%temp%\DLC1Temp\CentBrowser" "CentBrowser.exe"
exit

:x64
if exist "%temp%\DLC1Temp\CentBrowser\CentBrowser.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CentBrowser" -y files\CentBrowser.7z
start "" /D"%temp%\DLC1Temp\CentBrowser" "CentBrowser.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\CentBrowser" "CentBrowser.exe"
exit


:runminiwinxp
start msgbox "Sorry but this only works from Mini Windows 10 or Your Windows" 0 "OS Errors"
exit