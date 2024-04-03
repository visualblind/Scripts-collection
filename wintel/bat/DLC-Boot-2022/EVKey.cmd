@echo off
pushd "%~dp0"
if "%COMPUTERNAME:~0,6%"=="MiniXP" goto runminiwin
if exist %SystemRoot%\AcronisTrueImageHome.ico goto runminiwin

start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 7/8/10/11" 0 "OS Errors"
exit

:runminiwin
if exist "X:\Windows\SysWOW64\wdscore.dll" goto x64

:x86
if exist "%temp%\DLC1Temp\EVKey\EVKey32.exe" goto ax86
7z.exe x -o"%temp%\DLC1Temp\EVKey" -y files\EVKey.7z
start "" /D"%temp%\DLC1Temp\EVKey" "EVKey32.exe"
exit

:ax86
start "" /D"%temp%\DLC1Temp\EVKey" "EVKey32.exe"
exit

:x64
if exist "%temp%\DLC1Temp\EVKey\EVKey64.exe" goto ax64
7z.exe x -o"%temp%\DLC1Temp\EVKey" -y files\EVKey.7z
start "" /D"%temp%\DLC1Temp\EVKey" "EVKey64.exe"
exit

:ax64
start "" /D"%temp%\DLC1Temp\EVKey" "EVKey64.exe"
exit