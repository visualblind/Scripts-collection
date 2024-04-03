@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\BootICE.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\BootICEx86.7z
start "" /D"%temp%\DLC1Temp" "BootICE.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "BootICE.exe"
exit