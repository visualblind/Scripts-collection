@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminiwin
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runminiwin

if exist "%temp%\DLC1Temp\UltraSurf\UltraSurf.cmd" goto runready
:run
7z.exe x -o"%temp%\DLC1Temp\UltraSurf" -y files\UltraSurf.7z
start "" /D"%temp%\DLC1Temp\UltraSurf" "UltraSurf.cmd"
exit
:runready
start "" /D"%temp%\DLC1Temp\UltraSurf" "UltraSurf.cmd"
exit

:runminiwin
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit