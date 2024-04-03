@echo off
pushd "%~dp0"
if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64
start msgbox "Sorry but this only works from Windows 64Bit" 0 "OS Errors"
exit

:x64
if exist "%temp%\DLC1Temp\ActiveBCDEditor\ActiveBCDEditor.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActiveBCDEditor" -y files\ActiveBCDEditor.7z
start "" /D"%temp%\DLC1Temp\ActiveBCDEditor" "ActiveBCDEditor.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\ActiveBCDEditor" "ActiveBCDEditor.exe"
exit