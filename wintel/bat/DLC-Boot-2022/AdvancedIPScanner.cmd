@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\AdvancedIPScanner\AdvancedIPScanner.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\AdvancedIPScanner" -y files\AdvancedIPScanner.7z
start "" /D"%temp%\DLC1Temp\AdvancedIPScanner" "AdvancedIPScanner.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\AdvancedIPScanner" "AdvancedIPScanner.exe"