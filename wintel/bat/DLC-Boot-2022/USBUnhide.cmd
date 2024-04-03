@echo off
pushd "%~dp0"

:XP
if exist "%temp%\DLC1Temp\USBUnhide.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\USBUnhide.7z
start "" /D"%temp%\DLC1Temp" "USBUnhide.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "USBUnhide.exe"
exit