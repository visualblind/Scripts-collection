@echo off
pushd "%~dp0"

if exist "X:\I386\explorer.exe" goto z
if exist "X:\bootmgr" goto z

if not exist "%PUBLIC%" (
goto z
)

if exist "D:\MSActBackUp\MSActBackUp.exe" goto a
7z.exe x -o"D:\MSActBackUp" -y files\MSActBackUp.7z
start "" /D"D:\MSActBackUp" "MSActBackUp.exe"
start msgbox "Your Backup save location D:\MSActBackUp" 0 "Caution"
exit
:a
start "" /D"D:\MSActBackUp" "MSActBackUp.exe"
start msgbox "Your Backup save location D:\MSActBackUp" 0 "Caution"
exit

:z
start msgbox "Sorry but this only works from Your Windows 7/8/10" 0 "OS Errors"
exit