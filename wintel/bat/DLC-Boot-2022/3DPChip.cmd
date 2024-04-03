@echo off
pushd "%~dp0"

if exist "X:\I386\explorer.exe" goto z
if exist "X:\bootmgr" goto z

if exist "%temp%\DLC1Temp\3DPChip.exe" goto a
7z.exe x -o"%temp%\DLC1Temp" -y files\3DPChip.7z -p123
start "" /D"%temp%\DLC1Temp" "3DPChip.exe"
exit

:a
start "" /D"%temp%\DLC1Temp" "3DPChip.exe"
exit

:z
start msgbox "Sorry but this only works from Your Windows" 0 "OS Errors"
exit