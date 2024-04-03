@echo off
pushd "%~dp0"

:x86
if exist "%temp%\DLC1Temp\OODiskRecovery\OODiskRecovery.exe" goto a86
7z.exe x -o"%temp%\DLC1Temp\OODiskRecovery" -y files\OODiskRecovery.7z
start "" /D"%temp%\DLC1Temp\OODiskRecovery" "OODiskRecovery.exe"
exit
:a86
start "" /D"%temp%\DLC1Temp\OODiskRecovery" "OODiskRecovery.exe"
exit