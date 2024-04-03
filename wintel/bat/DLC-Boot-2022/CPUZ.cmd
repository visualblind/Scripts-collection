@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\CPUZ\CPUZ.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CPUZ" -y files\CPUZ.7z
start "" /D"%temp%\DLC1Temp\CPUZ" "CPUZ.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\CPUZ" "CPUZ.exe"