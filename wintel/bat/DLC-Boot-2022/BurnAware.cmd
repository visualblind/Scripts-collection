@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\BurnAware\BurnAware.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\BurnAware" -y files\BurnAware.7z
start "" /D"%temp%\DLC1Temp\BurnAware" "BurnAware.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\BurnAware" "BurnAware.exe"