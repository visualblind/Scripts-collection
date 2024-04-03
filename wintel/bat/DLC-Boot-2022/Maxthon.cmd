@echo off
pushd "%~dp0"
:MAIN
if exist X:\I386\explorer.exe goto runminiwin
if exist X:\bootmgr goto runminiwin

if exist "%temp%\DLC1Temp\Maxthon\Maxthon.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\Maxthon" -y files\Maxthon.7z
start "" /D"%temp%\DLC1Temp\Maxthon" "Maxthon.exe"
exit

:runminiwin
rem if exist %SystemRoot%\SysWOW64\wdscore.dll goto minix64

if exist "%temp%\DLC1Temp\Maxthon\Maxthon.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\Maxthon" -y files\Maxthon.7z
start "" /D"%temp%\DLC1Temp\Maxthon" "Maxthon.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\Maxthon" "Maxthon.exe"
exit

:minix64
start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 10 32Bit" 0 "OS Errors"
exit