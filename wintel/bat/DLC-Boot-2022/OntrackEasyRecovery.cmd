@echo off
pushd "%~dp0"
if exist "X:\Windows\SysWOW64\wdscore.dll" goto x64

if exist "%temp%\DLC1Temp\OntrackEasyRecovery\OntrackEasyRecovery.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\OntrackEasyRecovery" -y files\OntrackEasyRecovery.7z
start "" /D"%temp%\DLC1Temp" "OntrackEasyRecovery\OntrackEasyRecovery.exe"
exit
:a
start "" /D"%temp%\DLC1Temp" "OntrackEasyRecovery\OntrackEasyRecovery.exe"
exit

:x64
if exist "%temp%\DLC1Temp\OntrackEasyRecovery\OntrackEasyRecovery.cmd" goto b
7z.exe x -o"%temp%\DLC1Temp\OntrackEasyRecovery" -y files\OntrackEasyRecovery.7z
start "" /D"%temp%\DLC1Temp" "OntrackEasyRecovery\OntrackEasyRecovery.cmd"
exit
:b
start "" /D"%temp%\DLC1Temp" "OntrackEasyRecovery\OntrackEasyRecovery.cmd"
exit