@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto z
if exist %SystemRoot%\AcronisTrueImageHome.ico goto z

start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 7" 0 "OS Errors"
exit

:z
if exist "%temp%\DLC1Temp\WindowsGate.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\WindowsGate.7z
start "" /D"%temp%\DLC1Temp" "WindowsGate.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "WindowsGate.exe"
exit