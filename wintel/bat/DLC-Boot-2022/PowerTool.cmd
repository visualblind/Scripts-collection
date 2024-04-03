@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64Bit

:32bit
if exist "%temp%\DLC1Temp\PowerTool\PowerTool.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\PowerTool" -y files\PowerToolx86.7z
start "" /D"%temp%\DLC1Temp\PowerTool" "PowerTool.exe"
exit
:a32
start "" /D"%temp%\DLC1Temp\PowerTool" "PowerTool.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\PowerTool\PowerTool.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\PowerTool" -y files\PowerToolx64.7z
start "" /D"%temp%\DLC1Temp\PowerTool" "PowerTool.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\PowerTool" "PowerTool.exe"