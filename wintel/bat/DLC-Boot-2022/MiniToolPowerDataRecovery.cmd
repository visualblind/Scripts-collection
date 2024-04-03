@echo off
pushd "%~dp0"

if exist "%windir%\SysWOW64\wdscore.dll" goto x64


:x86
if exist "%temp%\DLC1Temp\PowerData\MiniToolPowerDataRecovery.exe" goto a86
7z.exe x -o"%temp%\DLC1Temp\PowerData" -y files\MiniToolPowerDataRecoveryx86.7z
start "" /D"%temp%\DLC1Temp\PowerData" "MiniToolPowerDataRecovery.exe"
exit
:a86
start "" /D"%temp%\DLC1Temp\PowerData" "MiniToolPowerDataRecovery.exe"
exit

:x64
if exist "%temp%\DLC1Temp\PowerData\PowerDataRecovery.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\PowerData" -y files\MiniToolPowerDataRecoveryx64.7z
start "" /D"%temp%\DLC1Temp\PowerData" "PowerDataRecovery.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\PowerData" "PowerDataRecovery.exe"
exit