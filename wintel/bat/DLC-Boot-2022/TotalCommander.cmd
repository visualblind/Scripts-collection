@echo off
pushd "%~dp0"

:Run
if exist "%temp%\DLC1Temp\TotalCommander\TotalCommander.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\TotalCommander" -y files\TotalCommander.7z
start "" /D"%temp%\DLC1Temp\TotalCommander" "TotalCommander.cmd"
exit
:a
start "" /D"%temp%\DLC1Temp\TotalCommander" "TotalCommander.cmd"
exit