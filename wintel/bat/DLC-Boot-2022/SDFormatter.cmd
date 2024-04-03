@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\SDFormatter\SDFormatter.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\SDFormatter" -y files\SDFormatter.7z
start "" /D"%temp%\DLC1Temp\SDFormatter" "SDFormatter.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\SDFormatter" "SDFormatter.exe"
exit