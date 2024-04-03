@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\MilfordSoftDataRecovery\MilfordSoftDataRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\MilfordSoftDataRecovery" -y files\MilfordSoftDataRecovery.7z
start "" /D"%temp%\DLC1Temp\MilfordSoftDataRecovery" "MilfordSoftDataRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\MilfordSoftDataRecovery" "MilfordSoftDataRecovery.exe"
exit