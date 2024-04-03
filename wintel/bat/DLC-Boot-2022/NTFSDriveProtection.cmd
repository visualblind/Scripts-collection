@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\NTFSDriveProtection\NTFSDriveProtection.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\NTFSDriveProtection" -y files\NTFSDriveProtection.7z
start "" /D"%temp%\DLC1Temp\NTFSDriveProtection" "NTFSDriveProtection.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\NTFSDriveProtection" "NTFSDriveProtection.exe"
exit