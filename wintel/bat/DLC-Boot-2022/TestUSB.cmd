@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\TestUSB.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\TestUSB.7z
start "" /D"%temp%\DLC1Temp" "TestUSB.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "TestUSB.exe"