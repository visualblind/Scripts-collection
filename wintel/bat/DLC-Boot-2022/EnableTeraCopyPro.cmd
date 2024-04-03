@echo off
pushd "%~dp0"

if exist "X:\I386\explorer.exe" goto z
if exist "X:\bootmgr" goto exit

start msgbox "Sorry but this only works from Mini Windows XP or Mini Windows 10" 0 "OS Errors"
exit

:z
7z.exe x -o"%temp%\DLC1Temp" -y files\TeraDisableEnable.7z
CHDIR /D "%temp%\DLC1Temp"
REG IMPORT TeraEnable.reg
exit

:exit
exit