@echo off
pushd "%~dp0"
if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit
if exist "%temp%\DLC1Temp\BootNext.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\BootNext.7z
start "" /D"%temp%\DLC1Temp" "BootNext.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "BootNext.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\BootNext.exe" goto a64bit
7z.exe x -o"%temp%\DLC1Temp" -y files\BootNext.7z
start "" /D"%temp%\DLC1Temp" "RunBootNext.cmd"
exit
:a64bit
start "" /D"%temp%\DLC1Temp" "RunBootNext.cmd"
exit