@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\BurnAware\SmartRipper.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\BurnAware" -y files\SmartRipper.7z
start "" /D"%temp%\DLC1Temp\BurnAware" "SmartRipper.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\BurnAware" "SmartRipper.exe"