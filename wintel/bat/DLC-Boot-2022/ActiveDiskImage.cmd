@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto 64bit

:32bit
if exist "%temp%\DLC1Temp\ActiveDiskImage\ActiveDiskImage.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\ActiveDiskImage\" -y files\ActiveDiskImagex86.7z
start "" /D"%temp%\DLC1Temp\ActiveDiskImage\" "ActiveDiskImage.exe"
exit

:a32
start "" /D"%temp%\DLC1Temp\ActiveDiskImage\" "ActiveDiskImage.exe"
exit

:64bit
if exist "%temp%\DLC1Temp\ActiveDiskImage\ActiveDiskImage.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\ActiveDiskImage\" -y files\ActiveDiskImagex64.7z
start "" /D"%temp%\DLC1Temp\ActiveDiskImage\" "ActiveDiskImage.exe"
exit


:a64
start "" /D"%temp%\DLC1Temp\ActiveDiskImage\" "ActiveDiskImage.exe"
exit
