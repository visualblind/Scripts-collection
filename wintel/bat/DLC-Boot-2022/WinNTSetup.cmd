@echo off
pushd "%~dp0"

if exist %SystemRoot%\SysWOW64\wdscore.dll goto x64

if exist "%temp%\DLC1Temp\WinNTSetupx86\WinNTSetup.exe" goto a
7z.exe x -o"%temp%\DLC1Temp\WinNTSetupx86" -y files\WinNTSetupx86.7z
rem 7z.exe x -o"%temp%\DLC1Temp\WinNTSetupx86\Tools\x86" -y files\BootICEx86.7z
start "" /D"%temp%\DLC1Temp\WinNTSetupx86" "WinNTSetup.exe"
exit
:a
start "" /D"%temp%\DLC1Temp\WinNTSetupx86" "WinNTSetup.exe"
exit

:x64
if exist "%temp%\DLC1Temp\WinNTSetupx64\WinNTSetup.exe" goto a64
7z.exe x -o"%temp%\DLC1Temp\WinNTSetupx64" -y files\WinNTSetupx64.7z
rem 7z.exe x -o"%temp%\DLC1Temp\WinNTSetupx64\Tools\x64" -y files\BootICEx64.7z
start "" /D"%temp%\DLC1Temp\WinNTSetupx64" "WinNTSetup.exe"
exit
:a64
start "" /D"%temp%\DLC1Temp\WinNTSetupx64" "WinNTSetup.exe"
exit