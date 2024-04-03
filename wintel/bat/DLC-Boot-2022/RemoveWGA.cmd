@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto z
if exist %SystemRoot%\AcronisTrueImageHome.ico goto z

if exist "%PUBLIC%" (
goto z
)

if exist "%temp%\DLC1Temp\RemoveWGA1.2.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\RemoveWGA.7z -p123
start "" /D"%temp%\DLC1Temp" "RemoveWGA1.2.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "RemoveWGA1.2.exe"
exit

:z
start msgbox "Sorry but this only works from Your Windows XP" 0 "OS Errors"
exit