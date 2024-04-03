@echo off
pushd "%~dp0"

if exist X:\I386\explorer.exe goto runminiwin
if exist X:\bootmgr goto runminiwin

if exist "%temp%\DLC1Temp\CrystalDiskMark\CrystalDiskMark.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\CrystalDiskMark" -y files\CrystalDiskMark.7z
start "" /D"%temp%\DLC1Temp\CrystalDiskMark" "CrystalDiskMark.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\CrystalDiskMark" "CrystalDiskMark.exe"
exit


:runminiwin
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit