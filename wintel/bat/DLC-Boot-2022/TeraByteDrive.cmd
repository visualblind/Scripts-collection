@echo off
pushd "%~dp0"

if exist "X:\Windows\SysWOW64\wdscore.dll" goto x64

:x86
if exist "%temp%\DLC1Temp\TeraByteDrive\TeraByteDrive.exe" goto a32
7z.exe x -o"%temp%\DLC1Temp\TeraByteDrive" -y files\TeraByteDrive.7z
start "" /B /D"%temp%\DLC1Temp\TeraByteDrive" "TeraByteDrive.exe"
exit

:a32
start "" /B /D"%temp%\DLC1Temp\TeraByteDrive" "TeraByteDrive.exe"
exit

:x64
if exist "%temp%\DLC1Temp\TeraByteDrive\TeraByteDrivex64.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\TeraByteDrive" -y files\TeraByteDrive.7z
start "" /B /D"%temp%\DLC1Temp\TeraByteDrive" "TeraByteDrivex64.exe"
exit

:a64
start "" /B /D"%temp%\DLC1Temp\TeraByteDrive" "TeraByteDrivex64.exe"
exit