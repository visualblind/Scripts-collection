@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\DiskgetorDataRecovery\DiskgetorDataRecovery.cmd" goto a
7z.exe x -o"%temp%\DLC1Temp\DiskgetorDataRecovery" -y files\DiskgetorDataRecovery.7z
start "" /D"%temp%\DLC1Temp\DiskgetorDataRecovery" "DiskgetorDataRecovery.cmd"
exit
:a
start "" /D"%temp%\DLC1Temp\DiskgetorDataRecovery" "DiskgetorDataRecovery.cmd"
exit