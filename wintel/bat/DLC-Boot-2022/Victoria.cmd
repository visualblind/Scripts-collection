@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\Victoria\Victoria.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\Victoria" -y files\Victoria.7z
start "" /D"%temp%\DLC1Temp\Victoria" "Victoria.cmd"
exit

:a
start "" /D"%temp%\DLC1Temp\Victoria" "Victoria.cmd"
exit