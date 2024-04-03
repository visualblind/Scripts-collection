@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\ActiveKillDisk\ActiveKillDisk.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActiveKillDisk\" -y files\ActiveKillDiskx86.7z
start "" /D"%temp%\DLC1Temp\ActiveKillDisk\" "ActiveKillDisk.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\ActiveKillDisk\ActiveKillDisk.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\ActiveKillDisk\" -y files\ActiveKillDiskx64.7z
start "" /D"%temp%\DLC1Temp\ActiveKillDisk\" "ActiveKillDisk.exe"
exit


:a
start "" /D"%temp%\DLC1Temp\ActiveKillDisk\" "ActiveKillDisk.exe"
exit

