@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\LinuxReader\LinuxReader.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\LinuxReader" -y files\LinuxReader.7z
start "" /D"%temp%\DLC1Temp\LinuxReader" "LinuxReader.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\LinuxReader" "LinuxReader.exe"
exit