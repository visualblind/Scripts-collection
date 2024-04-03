@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto z
if exist %SystemRoot%\AcronisTrueImageHome.ico goto z

if not exist "%PUBLIC%" (
goto z
)

if exist "%temp%\DLC1Temp\RemoveWAT.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\RemoveWAT.7z -p123
start "" /D"%temp%\DLC1Temp" "RemoveWAT.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "RemoveWAT.exe"
exit

:z
start msgbox "Sorry but this only works from Your Windows 7" 0 "OS Errors"
exit