@echo off
pushd "%~dp0"

if "%COMPUTERNAME:~0,6%"=="MiniXP" goto z
if exist %SystemRoot%\AcronisTrueImageHome.ico goto z


if exist "%temp%\DLC1Temp\RevoUninstaller\RevoUPPort.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\RevoUninstaller" -y files\RevoUninstaller.7z
start "" /D"%temp%\DLC1Temp\RevoUninstaller" "RevoUPPort.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\RevoUninstaller" "RevoUPPort.exe"
exit


:z
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit