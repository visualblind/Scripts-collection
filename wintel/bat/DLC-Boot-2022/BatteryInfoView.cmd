@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\BatteryInfoView\BatteryInfoView.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\BatteryInfoView" -y files\BatteryInfoView.7z
start "" /D"%temp%\DLC1Temp\BatteryInfoView" "BatteryInfoView.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\BatteryInfoView" "BatteryInfoView.exe"