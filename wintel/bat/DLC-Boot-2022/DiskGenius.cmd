@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\DiskGenius\DiskGenius.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\DiskGenius" -y files\DiskGenius.7z
start "" /D"%temp%\DLC1Temp\DiskGenius" "DiskGenius.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\DiskGenius" "DiskGenius.exe"