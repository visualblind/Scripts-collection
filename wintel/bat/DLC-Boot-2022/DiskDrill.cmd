@echo off
pushd "%~dp0"
if exist "%temp%\DLC1Temp\DiskDrill\DiskDrill.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\DiskDrill" -y files\DiskDrill.7z
start "" /D"%temp%\DLC1Temp\DiskDrill" "DiskDrill.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\DiskDrill" "DiskDrill.exe"
exit