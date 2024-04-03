@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\DaossoftWindowsPassword\DaossoftWindowsPassword.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\DaossoftWindowsPassword" -y files\DaossoftWindowsPassword.7z
start "" /D"%temp%\DLC1Temp\DaossoftWindowsPassword" "DaossoftWindowsPassword.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\DaossoftWindowsPassword" "DaossoftWindowsPassword.exe"