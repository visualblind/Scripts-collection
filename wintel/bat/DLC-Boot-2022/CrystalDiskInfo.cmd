@echo off
pushd "%~dp0"

if exist "%temp%\DLC1Temp\CrystalDiskInfo\CrystalDiskInfo.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CrystalDiskInfo" -y files\CrystalDiskInfo.7z
start "" /D"%temp%\DLC1Temp\CrystalDiskInfo" "CrystalDiskInfo.exe"
exit

:a
start "" /D"%temp%\DLC1Temp\CrystalDiskInfo" "CrystalDiskInfo.exe"
exit