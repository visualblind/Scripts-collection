@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\KMSTools.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\KMSTools.7z -p123
start "" /D"%temp%\DLC1Temp" "KMSTools.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "KMSTools.exe"